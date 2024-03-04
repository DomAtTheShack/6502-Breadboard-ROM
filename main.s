; These three routines are provided by run6502 for simple I/O
;   sim_putchar will print the character in the accumulator to standard output
;   sim_getchar will populate the accumulator with one character from standard input
;   sim_exit will terminate the simulator
.import sim_putchar, sim_getchar, sim_exit

.segment "CODE"
.org $8000
reset:  ldx #$41    ; Letter A
@next:  txa
        jsr sim_putchar
        inx
        cpx #$5b
        bne @next
        lda #$0a    ; Newline
        jsr sim_putchar
        jmp sim_exit
.org $fffc
.word $8000
.word $0000


