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
    dpush CursorX
    and #$00ff
    dpop y
    cpy #(2*32)
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
