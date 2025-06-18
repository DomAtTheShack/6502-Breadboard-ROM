import tkinter as tk
from tkinter.scrolledtext import ScrolledText
import threading
import sys
import termios
import tty
from py65.devices.mpu6502 import MPU
import time

class MyMemory:
    def __init__(self, gui_callback=None):
        self.ram = [0] * 0x10000
        self.rx_buffer = []
        self.output_buffer = []
        self.gui_callback = gui_callback
        self.serial_char_time = 1 / 1920
        self.last_rx_time = 0
        self.last_tx_time = 0
        self._start_input_thread()

    def _start_input_thread(self):
        import termios, tty, sys
        def read_keys():
            old_settings = termios.tcgetattr(sys.stdin)
            tty.setcbreak(sys.stdin.fileno())
            try:
                while True:
                    c = sys.stdin.read(1)
                    now = time.perf_counter()
                    wait = self.serial_char_time - (now - self.last_rx_time)
                    if wait > 0:
                        time.sleep(wait)
                    self.last_rx_time = time.perf_counter()

                    if c == '\n':
                        self.rx_buffer.append(0x0D)  # or 0x0A depending on your protocol

                    else:
                        self.rx_buffer.append(ord(c))
            finally:
                termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)

        threading.Thread(target=read_keys, daemon=True).start()

    def __getitem__(self, addr):
        if addr == 0x4001:
            return 0x08 if self.rx_buffer else 0x00
        elif addr == 0x4000:
            now = time.perf_counter()
            wait = self.serial_char_time - (now - self.last_rx_time)
            if wait > 0:
                time.sleep(wait)
            self.last_rx_time = time.perf_counter()
            return self.rx_buffer.pop(0) if self.rx_buffer else 0x00
        return self.ram[addr]

    def __setitem__(self, addr, val):
        if addr == 0x4000:
            now = time.perf_counter()
            wait = self.serial_char_time - (now - self.last_tx_time)
            if wait > 0:
                time.sleep(wait)
            self.last_tx_time = time.perf_counter()

            # Save output for GUI console
            self.output_buffer.append(val)

            # Print to terminal with correct newline handling
            if val == 0x0A or val == 0x0D:
                print("\r\n", end='', flush=True)
            elif 32 <= val <= 126:
                print(chr(val), end='', flush=True)
            else:
                print(f"[{val:02X}]", end='', flush=True)

        else:
            self.ram[addr] = val


class DebugGUI(tk.Tk):
    def __init__(self, system):
        super().__init__()
        self.system = system
        self.running = False
        self.instructions_since_mem_update = 0   # <--- Add this line
        self.memory_update_interval = 100  # or whatever number of instructions before updating memory viewer

        self.title("6502 Emulator Debugger")
        self.geometry("900x600")

        # --- Controls frame ---
        ctrl_frame = tk.Frame(self)
        ctrl_frame.pack(fill=tk.X, padx=5, pady=5)

        self.run_button = tk.Button(ctrl_frame, text="Run", command=self.toggle_run)
        self.run_button.pack(side=tk.LEFT, padx=5)

        self.step_button = tk.Button(ctrl_frame, text="Step", command=self.step_once)
        self.step_button.pack(side=tk.LEFT, padx=5)

        self.reset_button = tk.Button(ctrl_frame, text="Reset", command=self.reset_cpu)
        self.reset_button.pack(side=tk.LEFT, padx=5)

        tk.Label(ctrl_frame, text="Send Input (ASCII or Hex):").pack(side=tk.LEFT, padx=5)

        self.input_entry = tk.Entry(ctrl_frame, width=30)
        self.input_entry.pack(side=tk.LEFT, padx=5)
        self.input_entry.bind("<Return>", self.send_input)

        # --- Output console ---
        self.output_console = ScrolledText(self, height=15, state=tk.DISABLED, font=("Courier", 10))
        self.output_console.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # --- Registers display ---
        self.regs_label = tk.Label(self, text="", font=("Courier", 12), justify=tk.LEFT)
        self.regs_label.pack(anchor=tk.W, padx=5)

        # --- Memory Viewer ---
        mem_frame = tk.Frame(self)
        mem_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        mem_label = tk.Label(mem_frame, text="Memory Viewer (Full 64 KiB):")
        mem_label.pack(anchor=tk.W)

        self.memory_viewer = ScrolledText(mem_frame, height=20, width=80, font=("Courier", 10))
        self.memory_viewer.pack(fill=tk.BOTH, expand=True)
        self.memory_viewer.config(state=tk.DISABLED)


        self.mem_text = ScrolledText(mem_frame, height=10, font=("Courier", 10))
        self.mem_text.pack(fill=tk.BOTH, expand=True)
        self.mem_text.config(state=tk.DISABLED)

        # Refresh memory viewer every second
        self.after(1000, self.update_memory_viewer)

        # Start periodic UI updates
        self.after(100, self.update_ui)

    def reset_cpu(self):
        # Reset PC to reset vector in memory (0xFFFC and 0xFFFD)
        lo = self.system.memory[0xFFFC]
        hi = self.system.memory[0xFFFD]
        self.system.cpu.pc = lo | (hi << 8)
        self.log(f"CPU Reset: PC set to {self.system.cpu.pc:04X}")

    def toggle_run(self):
        if self.running:
            self.running = False
            self.run_button.config(text="Run")
        else:
            self.running = True
            self.run_button.config(text="Stop")
            threading.Thread(target=self.run_loop, daemon=True).start()


    def run_loop(self):
        while self.running:
            for _ in range(500):  # run some instructions
                self.system.cpu.step()
                self.instructions_since_mem_update += 1

                if self.instructions_since_mem_update >= self.memory_update_interval:
                    # Schedule memory view update on main thread
                    self.after(0, self.update_memory_viewer)
                    self.instructions_since_mem_update = 0

            self.after(0, self.update_registers)
            time.sleep(0.05)

    def step_once(self):
        if not self.running:
            self.system.cpu.step()
            self.update_registers()

    def send_input(self, event=None):
        text = self.input_entry.get().strip()
        self.input_entry.delete(0, tk.END)
        # Try to parse hex (space separated) or ASCII input
        bytes_to_send = []
        if all(c in "0123456789abcdefABCDEF " for c in text):
            try:
                for part in text.split():
                    if part:
                        bytes_to_send.append(int(part, 16))
            except ValueError:
                bytes_to_send = [ord(c) for c in text]
        else:
            bytes_to_send = [ord(c) for c in text]

        for b in bytes_to_send:
            self.system.memory.rx_buffer.append(b)

    def update_ui(self):
        self.update_registers()
        self.update_output_console()
        self.after(100, self.update_ui)

    def update_registers(self):
        cpu = self.system.cpu
        regs = (
            f"PC: {cpu.pc:04X}  A: {cpu.a:02X}  X: {cpu.x:02X}  Y: {cpu.y:02X}  "
            f"SP: {cpu.sp:02X}  STATUS: {cpu.p:02X}"
        )
        self.regs_label.config(text=regs)

    def update_output_console(self):
        mem = self.system.memory
        if hasattr(mem, 'output_buffer') and mem.output_buffer:
            self.output_console.config(state=tk.NORMAL)
            for val in mem.output_buffer:
                ascii_char = chr(val) if 32 <= val <= 126 else '.'
                self.output_console.insert(tk.END, f"{val:02X} '{ascii_char}'\n")
            mem.output_buffer.clear()
            self.output_console.see(tk.END)
            self.output_console.config(state=tk.DISABLED)

    def update_memory_viewer(self):
        # Save current scroll position
        current_view = self.memory_viewer.yview()

        self.memory_viewer.config(state=tk.NORMAL)
        self.memory_viewer.delete(1.0, tk.END)

        mem = self.system.memory
        for i in range(0x0000, 0x10000, 16):
            bytes_str = ' '.join(f"{mem[i + j]:02X}" for j in range(16))
            self.memory_viewer.insert(tk.END, f"{i:04X}: {bytes_str}\n")

        self.memory_viewer.config(state=tk.DISABLED)

        # Restore previous scroll position
        self.memory_viewer.yview_moveto(current_view[0])

    def log(self, msg):
        self.output_console.config(state=tk.NORMAL)
        self.output_console.insert(tk.END, msg + "\n")
        self.output_console.see(tk.END)
        self.output_console.config(state=tk.DISABLED)

class My6502System:
    def __init__(self, gui):
        self.gui = gui
        if gui is not None:
            callback = gui.log
        else:
            callback = None
        self.memory = MyMemory(gui_callback=callback)
        self.cpu = MPU(memory=self.memory)


    def load_binary(self, filename, address=0x8000):
        with open(filename, "rb") as f:
            data = f.read()
        for i, b in enumerate(data):
            self.memory[address + i] = b
        lo = self.memory[0xFFFC]
        hi = self.memory[0xFFFD]
        self.cpu.pc = lo | (hi << 8)

    def run(self):
        def step_loop():
            cycles_per_second = 1_000_000
            instructions_per_batch = 500
            cycles = 0
            last_time = time.perf_counter()

            while self.gui.running:
                for _ in range(instructions_per_batch):
                    self.cpu.step()
                    cycles += self.cpu.excycles

                self.gui.update_registers(self.cpu)

                now = time.perf_counter()
                elapsed = now - last_time
                target_time = cycles / cycles_per_second

                if elapsed < target_time:
                    time.sleep(target_time - elapsed)

                # Reset counters each batch
                last_time = time.perf_counter()
                cycles = 0

        threading.Thread(target=step_loop, daemon=True).start()


# --- Entry Point ---

if __name__ == "__main__":
    gui = DebugGUI()
    system = My6502System(gui)
    system.load_binary("./BASIC/tmp/eater.bin")  # adjust path if needed
    system.run()
    gui.run()
