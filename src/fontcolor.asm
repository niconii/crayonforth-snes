; _color ( c -- ) blanking only
.proc _color
    sep #$20
        sta CGDATA
        xba
        sta CGDATA
    rep #$20
    dpop
    rts
.endproc

; _font0s ( bg fg a -- bg fg a ) blanking only
.proc _font0s
    sep #$20
        sta CGADD
    rep #$20
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    rts
.endproc

; _font0 ( bg fg n -- ) blanking only
.proc _font0
    asl a
    asl a
    jsr _font0s
    clc
    adc #$20
    jsr _font0s
    clc
    adc #$20
    jsr _font0s
    clc
    adc #$20
    jsr _font0s

    ldy $04,x
    txa
    clc
    adc #6
    tax
    tya
    rts
.endproc

; _font1s ( bg fg a -- bg fg a ) blanking only
.proc _font1s
    sep #$20
        sta CGADD
    rep #$20
    dpush {$04,x}
    jsr _color
    dpush {$04,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    dpush {$02,x}
    jsr _color
    rts
.endproc

; _font1 ( bg fg n -- ) blanking only
.proc _font1
    asl
    asl
    jsr _font1s
    clc
    adc #$20
    jsr _font1s
    clc
    adc #$20
    jsr _font1s
    clc
    adc #$20
    jsr _font1s

    ldy $04,x
    txa
    clc
    adc #6
    tax
    tya
    rts
.endproc
