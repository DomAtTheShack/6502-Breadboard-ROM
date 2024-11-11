charCount = $00
charQueue = $01

ptr = $fe

  .org $8000

reset:
  cli
loop:
  ldx $4001
  cpx #$00
  beq nops
  cpx #$0d
  beq readCmd
  cpy #23
  beq nops
  stx $5001
  ldy charCount
  stx charQueue, y
  inc charCount
nops:
  nop
  nop
  jmp loop

readCmd:
  ldx #0
  ldy charCount
  stx charQueue, y
  inc charCount
  jsr printNewLine
  ldx #0
next_cmd:
  ; Load command pointer from cmd_table
  cpx #6
  beq printError
  LDA cmd_table, X   ; Load low byte of command pointer
  STA ptr            ; Store to temporary pointer location
  inc ptr
  INX
  LDA cmd_table, X   ; Load high byte of command pointer
  STA ptr + 1        ; Store high byte
  INX

  LDY #0             ; Reset Y index to start comparing from the beginning
  CMP_loop:
    LDA (ptr), Y     ; Load a byte from the command
    beq match_found  ; If null terminator is reached, command matches
    CMP charQueue, Y ; Compare with user input character at Y index
    BNE next_cmd     ; If not equal, go to next command
    INY              ; Move to the next character
    JMP CMP_loop     ; Repeat comparison

match_found:
  iny
  lda #0
  cmp charQueue, y
  bne loop
  dex
  lda cmd_method_table, x
  sta ptr + 1
  dex
  lda cmd_method_table, x
  sta ptr
  jsr clearUserIn
  ; Code to handle a successful match (e.g., execute command)
  JMP (ptr) ; Jump to command handling code

handle_command:
  jsr printNewLine


printError:
  jsr clearUserIn
  lda error
  sta charCount
  lda table_end - 2
  sta ptr
  lda table_end - 1
  sta ptr + 1
  jsr printString
  jsr printNewLine
  jmp loop

clearUserIn:
  pha
  lda #0
  sta charCount
  pla
  rts

printString:
  ldy #0
printStringLoop:
  lda (ptr), y
  sta $5001
  iny
  cpy charCount
  bne printStringLoop
  jsr printNewLine
  lda #0
  sta charCount
  jmp loop

printNewLine:
  pha
  lda #$0d
  sta $5001
  pla
  rts

loadCmdToPtr:
  ldy #0
  lda cmd_table, x
  sta ptr
  inx
  lda cmd_table, x
  sta ptr + 1

 ; Load the length of the command into charCount
  lda (ptr), y      ; Load the first byte at the address in ptr (length byte)
  inc ptr
  sta charCount      ; Store the length in charCount
  rts

help:
  ldx #$00
  jsr loadCmdToPtr
  jmp printString

run:
  ldx #$04
  jsr loadCmdToPtr
  jmp printString

stop:
  ldx #$02
  jsr loadCmdToPtr
  jmp printString

  .org $f000

cmd_method_table:
  .word help
  .word stop
  .word run

cmd_method_end:

cmd_table:
  .word cmd1  ; Pointer to command 1
  .word cmd2  ; Pointer to command 2
  .word cmd3  ; Pointer to command 3
  .word error + 1


table_end:     ; Marks the end of the table

cmd1:
  .byte 4,'H', 'E', 'L', 'P', 0  ; Command "HELP", null-terminated
cmd2:
  .byte 4,'S', 'T', 'O', 'P', 0  ; Command "STOP", null-terminated
cmd3:
  .byte 3,'R', 'U', 'N', 0       ; Command "RUN", null-terminated
error:
  .byte 14,'S','y','n','t','a','x',' ','E','r','r','o','r', $0d  ; Syntax Error

  .org $fffa
  .word $0000
  .word reset
  .word $0000
