.ifdef DARWIN

T1CL = $6004
T1CH = $6005
ACR  = $600B

BEEP:
    lda $50
    sta T1CL
    lda #$10
    sta T1CH

    lda #$c0
    sta ACR
    rts

.endif
