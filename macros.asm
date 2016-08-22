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

.macro color arg
    lda #<arg
    sta CGDATA
    lda #>arg
    sta CGDATA
.endmacro

.macro font0 bg, fg
    color bg
    color fg
    color bg
    color fg
.endmacro

.macro font1 bg, fg
    color bg
    color bg
    color fg
    color fg
.endmacro