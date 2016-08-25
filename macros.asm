.macro dpush arg
    dex
    dex
    sta $00,x
    
    .ifblank arg
    .elseif (.xmatch ({arg}, t))
    .elseif (.xmatch ({arg}, y))
        tya
    .elseif (.xmatch ({arg}, r))
        pla
    .else
        lda arg
    .endif
.endmacro

.macro dpop arg
    .ifblank arg
    .elseif (.xmatch ({arg}, y))
        tay
    .elseif (.xmatch ({arg}, r))
        pha
    .else
        sta arg
    .endif

    lda $00,x
    inx
    inx
.endmacro
