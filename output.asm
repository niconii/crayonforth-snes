; cr ( -- )
; Advance to the start of the next line
.proc cr
    dpush Flags
    ora #F_LINEDONE
    dpop Flags
    wai
    rts
.endproc

; refresh ( -- )
; Refresh the screen
.proc refresh
    dpush Flags
    ora #F_REFRESH
    dpop Flags
    rts
.endproc

; emit ( ch -- )
; Emit a character to the screen
.proc emit
    sep #$20
        xba
        lda TextColor
        xba
    rep #$20
    dpush CursorX
    and #$00ff
    dpop y
    cpy LineLen
    bcs :+
        dpop {LineBuffer,y}
        bra end
    :
        jsr cr
        dpop LineBuffer
    end:
    inc CursorX
    inc CursorX
    jsr refresh
    rts
.endproc

; clearline ( -- )
; Clears line buffer
.proc clearline
    pha

    sep #$20
        ; Zero-fill line buffer with DMA
        ldy #LineBuffer
        sty WMADDL
        stz WMADDH
        lda #%00001000      ; a->b astep=+0 unit=[0]
        sta DMAP7
        lda #<WMDATA        ; b=WMDATA
        sta BBAD7
        ldy #.loword(zerobyte) ; a=zerobyte
        sty A1T7L
        lda #^zerobyte
        sta A1B7
        ldy LineLen         ; len=LineLen
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN
    rep #$20

    pla
    rts
.endproc