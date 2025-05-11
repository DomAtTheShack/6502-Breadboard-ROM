
  .org $8000

reset:
  jsr acia_init
  jsr lcd_init

main:
  jsr char_rx
  pha
  jsr print_char
  pla
  jsr char_tx
  jmp main

  .include "serial.s"
  .include "lcd.s"

  .org $fffc
  .word reset
  .word $0000

