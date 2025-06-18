.segment "CODE"
.ifdef DARWIN

CLRMON:
    lda #$0C
    jsr MONCOUT
    lda #$01
    sta OK_FLAG
    rts

; ----------------------------------------------------------------------------
; CURPOS:  read “expr,expr” → CURX, CURY (each 0–255)
; ----------------------------------------------------------------------------
CURPOS:
    lda #$0E
    jsr MONCOUT

    jsr     GETBYT      ; parse first byte → X
    txa                 ; bring into A
    jsr MONCOUT         ; Then print out

    lda #$0F
    jsr MONCOUT

    jsr     CHKCOM      ; eat the comma

    jsr     GETBYT      ; parse second byte → X
    txa
    jsr MONCOUT

    lda #$01
    sta OK_FLAG
    rts


; ----------------------------------------------------------------------------
; CURBLINK:  Makes cursor blink
; ----------------------------------------------------------------------------
CURBLINK:
    lda #$03
    jsr MONCOUT
    rts

; ----------------------------------------------------------------------------
; CURSOLID:  Makes cursor solid
; ----------------------------------------------------------------------------
CURSOLID:
    lda #$04
    jsr MONCOUT
    rts

; ----------------------------------------------------------------------------
; GR:  Sets video into bitmap graphics mode
; ----------------------------------------------------------------------------
GR:
    lda #$01
    sta OK_FLAG
    sta GRMODE
    lda #$02
    jsr MONCOUT
    lda #$00
    jsr MONCOUT
    jmp CLRMON

; ----------------------------------------------------------------------------
; TEXT:  Sets video into normal text mode
; ----------------------------------------------------------------------------
TEXT:
    lda #$01
    sta OK_FLAG
    lda #$00
    sta GRMODE
    lda #$02
    jsr MONCOUT
    lda #$5F
    jsr MONCOUT
    jsr CLRMON
    jmp RESTART


; ----------------------------------------------------------------------------
; CURSET:  CURSET 0x24 sets the cursor char
; ----------------------------------------------------------------------------
CURSET:
    lda #$02
    jsr MONCOUT
    jsr GETBYT
    txa
    jsr MONCOUT
    rts


.endif
