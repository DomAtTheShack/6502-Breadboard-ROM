from emu6502 import My6502System, DebugGUI

if __name__ == "__main__":
    system = My6502System(gui=None)     # create system with no gui yet
    gui = DebugGUI(system)              # create gui with system
    system.gui = gui                    # link gui back to system
    system.memory.gui_callback = gui.log if hasattr(gui, 'log') else None

    system.load_binary("./bin/darwin.bin")
    system.run()
    gui.mainloop()
