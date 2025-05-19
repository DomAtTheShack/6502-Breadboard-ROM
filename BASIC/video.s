.segment "CODE"
.ifdef DARWIN

CLRMON:
    lda #$0C
    jsr MONCOUT
    rts
.endif