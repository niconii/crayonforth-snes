macro seek(offset) {
    origin (({offset} & $7f0000) >> 1) | ({offset} & $007fff)
    base {offset}
}

macro seekf(offset) {
    if pc() >= {offset} {
        error "Memory overlap at {offset}"
    }
    seek({offset})
}

macro print8x8(sx, sy, str) {
                ldx.w #(32*{sy} + {sx})
                stx io.VMADDL

                ldx.w #({str} & $00ffff)
            -
                lda $00,x
                cmp #$ff
                beq +
                sta io.VMDATAL
                stz io.VMDATAH
                inx
                jmp -
            +
}

macro print8x16(sx, sy, str) {
                ldx.w #(32*{sy} + {sx})
                stx io.VMADDL

                ldx.w #({str} & $00ffff)
            -
                lda $00,x
                cmp #$ff
                beq +
                ora #$40
                sta io.VMDATAL
                stz io.VMDATAH
                inx
                jmp -
            +

                ldx.w #(32*({sy}+1) + {sx})
                stx io.VMADDL

                ldx.w #({str} & $00ffff)
            -
                lda $00,x
                cmp #$ff
                beq +
                ora #$80
                sta io.VMDATAL
                stz io.VMDATAH
                inx
                jmp -
            +
}
