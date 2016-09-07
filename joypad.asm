; joy ( -- )
; Update joypads
.proc joy
    pha
    phx

    sep #$20
        lda #%00000001
        :
            bit HVBJOY
        bne :-
    rep #$20

    ldy JOY1L
    tya
    eor Joy1Cur
    sty Joy1Cur
    and Joy1Cur
    sta Joy1Prs

    ldy JOY2L
    tya
    eor Joy2Cur
    sty Joy2Cur
    and Joy2Cur
    sta Joy2Prs

    plx
    pla
    rts
.endproc
