.proc vblank
    phb
    phd
    rep #$30
    pha
    phx
    phy

    ; Call current vblank routine
    pea return_point - 1    ; Push return point address - 1
    pei (VBlankPtr)         ; Push address of current vblank routine - 1
    rts                     ; "Return" to vblank routine
return_point:               ; Vblank routine will return here

    ply
    plx
    pla
    pld
    plb
    rti
.endproc
