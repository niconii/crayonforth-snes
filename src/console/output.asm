; cr ( -- )
; Advance to the start of the next line
.proc cr
    dpush ScFlags
    ora #F_LINEDONE
    dpop ScFlags
    wai
    rts
.endproc

; refresh ( -- )
; Refresh the screen
.proc refresh
    dpush ScFlags
    ora #F_REFRESH
    dpop ScFlags
    rts
.endproc

; emit ( ch -- )
; Emit a character to the screen
.proc emit
    sep #$20
        xba
        lda TAttrib
        xba
    rep #$20
    dpush CursorX
    and #$00ff
    dpop y
    cpy ScreenW
    bcs :+
        dpop {LineBuf,y}
        bra end
    :
        jsr cr
        dpop LineBuf
    end:
    inc CursorX
    inc CursorX
    jsr refresh
    rts
.endproc

; .s ( ptr len -- )
; Print a string
.proc _s
    tay
    lda #0
    :
        phy

        sep #$20
            lda ($00,x)
        rep #$20
        dpush t
        jsr emit
        inc $00,x

        ply
        dey
    bne :-
    lda $02,x
    inx
    inx
    inx
    inx
    rts
.endproc

; clearline ( -- )
; Clears line buffer
.proc clearline
    pha

    sep #$20
        ; Zero-fill line buffer with DMA
        ldy #LineBuf
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
        ldy ScreenW         ; len=ScreenW
        sty DAS7L
        lda #%10000000      ; initiate DMA
        sta MDMAEN
    rep #$20

    pla
    rts
.endproc

; banner ( -- )
; Prints the title/copyright banner
.proc banner
    phb
    pea ^banner1 << 8
    plb
    plb

    dpush #.loword(banner1)
    dpush #BANNER1_LEN
    jsr _s
    jsr cr

    dpush #.loword(banner2)
    dpush #BANNER2_LEN
    jsr _s
    jsr cr

    jsr cr

    plb
    rts
.endproc
