macro print8x8(sx, sy, str) {
                lda.b #(32*{sy} + {sx})
                sta io.VMADDL
                stz io.VMADDH

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
                lda.b #(32*{sy} + {sx})
                sta io.VMADDL
                stz io.VMADDH

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

                lda.b #(32*({sy}+1) + {sx})
                sta io.VMADDL
                stz io.VMADDH

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
