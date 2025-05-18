        .org $8000

; Constants
BUFFER_START = $0200      ; Starting address of the buffer
BUFFER_SIZE  = 128        ; Maximum buffer size
ENTER_CHAR   = $0D        ; ASCII code for Carriage Return (Enter key)

; Zero Page Variables
buffer_index  = $00      ; Index for storing characters in the buffer
temp_char     = $01      ; Temporary storage for the received character

        .org $8000

; Program Start
reset:
        jsr acia_init     ; Initialize ACIA
        jsr lcd_init      ; Initialize LCD

        lda #0
        sta buffer_index  ; Reset buffer index

main_loop:
        jsr char_rx       ; Receive character (result in A)
        sta temp_char     ; Store received character temporarily

        lda temp_char
        cmp #ENTER_CHAR
        beq print_buffer  ; If Enter is pressed, proceed to print buffer

        jsr char_tx       ; Echo character back

        ; Store character in buffer
        ldx buffer_index
        lda temp_char
        sta BUFFER_START,x
        inx
        cpx #BUFFER_SIZE
        bcc store_index
        ldx #0            ; Reset index if buffer is full
store_index:
        stx buffer_index
        jmp main_loop

print_buffer:
        ldx #0
print_loop:
        cpx buffer_index
        beq done_printing
        lda BUFFER_START,x
        jsr print_char
        inx
        jmp print_loop

done_printing:
        jmp done_printing         ; Infinite loop (adjust address as needed)

          .include "serial.s"
  .include "lcd.s"

  .org $fffc
  .word reset        ; Set reset vector
  .word $0000        ; Reserved memory location
