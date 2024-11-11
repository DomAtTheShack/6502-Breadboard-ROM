PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
INTFR = $600D
INTER = $600E
PCR = $600c

value = $0200
mod10 = $0202
message = $0204

E  = %10000000
RW = %01000000
RSW = %00100000
T = $00

counter = $00 ; 2 Bytes

  .org $8000

reset:
  cli

  lda #%11111111 ; Set all pins on port B to output
  sta DDRB

  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA

  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  sta PORTB
  jsr flickEnable

  lda #%00001110 ; Display on; cursor on; blink off
  sta PORTB
  jsr flickEnable


  lda #%00000110 ; Increment and shift cursor; don't shift display
  sta PORTB
  jsr flickEnable

  lda #%00000001
  jsr lcd_instruction

  lda #%10000010
  sta INTER

  lda #00
  sta PCR

  lda #0
  sta counter
  sta counter + 1

loop:
  lda #%00000010
  jsr lcd_instruction

  lda #0
  sta message

  lda counter
  sta value
  lda counter + 1
  sta value + 1

  divide:
  lda #0
  sta mod10
  sta mod10 + 1
  clc

  ldx #16

  divloop:
  rol value
  rol value + 1
  rol mod10
  rol mod10 + 1

  sec
  lda mod10
  sbc #10
  tay
  lda mod10 + 1
  sbc #0
  bcc ignore_result
  sty mod10
  sta mod10 + 1

ignore_result:
  dex
  bne divloop
  rol value
  rol value + 1

  lda mod10
  clc
  adc #"0"
  jsr push_char

  lda value
  ora value + 1
  bne divide

  ldx #0

print:
  lda message,x
  beq loop
  jsr writeChar
  inx
  jmp print

push_char:
  pha
  ldy #0

char_loop:
  lda message,y
  tax
  pla
  sta message,y
  iny
  txa
  pha
  bne char_loop
  pla
  sta message,y
  rts

writeChar:  ; 1 Param (Valid ASCII Char in Acumulator Register)
  sta PORTB
  lda #RSW         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RSW | E)   ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear allc c bits
  sta PORTA
  rts

lcd_wait:
  pha
  lda #%00000000  ; Port B is input
  sta DDRB
lcdbusy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne lcdbusy

  lda #RW
  sta PORTA
  lda #%11111111  ; Port B is output
  sta DDRB
  pla
  rts

lcd_instruction:
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

flickEnable: ; No Prameters nessisary
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

flickRW:   ; No Parametes nessisary
  lda RSW         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RSW | E)   ; Set E bit and Register Select bit to send instruction
  sta PORTA
  lda #0         ; Clear all bits
  sta PORTA
  rts


nmib:
  rti

irq:
  pha
  txa
  pha
  inc counter
  bne exit_irq
  inc counter + 1
exit_irq:
  ;delay
  ldx #$FF
  delay:
  dex
  bne delay
  bit PORTA
  pla
  tax
  pla
  rti

  .org $9000
hello:
  .byte 'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!', 0


  .org $fffa
  .word nmib
  .word reset
  .word irq
