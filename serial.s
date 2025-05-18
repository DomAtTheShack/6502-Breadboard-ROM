ACIA_DATA = $4000
ACIA_STATUS = $4001
ACIA_CMD = $4002
ACIA_CTRL = $4003

  .org $a000

char_rx:
rx_wait:
  lda ACIA_STATUS
  and #$08        ; check rx buffer
  beq rx_wait

  lda ACIA_DATA
  rts

char_tx:
  pha
  lda #$0A
  sta ACIA_DATA
tx_wait:
  lda ACIA_STATUS
  and #$10          ; Check tx buffer
  beq tx_wait
  pla
  rts

acia_init:
  lda #0
  sta ACIA_STATUS

  lda #%00011111
  sta ACIA_CTRL ; N-8-1 19200 baud

  lda #%00011011
  sta ACIA_CMD ; no parity, echo, no interrupts
  rts
