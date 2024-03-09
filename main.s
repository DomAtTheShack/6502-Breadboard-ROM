PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E  = %10000000
RW = %01000000
RSW = %00100000
T = $00

  .org $8000

reset:
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


  lda #"H"
  jsr writeChar

  lda #"e"
  jsr writeChar

  lda #"l"
  jsr writeChar

  lda #"l"
  jsr writeChar

  lda #"o"
  jsr writeChar

  jmp loop

writeChar:  ; 1 Param (Valid ASCII Char in Acumulator Register)
  sta PORTB
  lda #RSW         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RSW | E)   ; Set E bit to send instruction
  sta PORTA
  lda #RSW         ; Clear E bits
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

loop:
  jmp loop

  .org $fffc
  .word reset
  .word $0000
