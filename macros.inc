macro seek(variable offset) {
    origin ((offset & $7f0000) >> 1) | (offset & $007fff)
    base offset
}

macro pad_to(variable offset) {
    seek(offset)
    db 0
}

macro start() {
    seek($000000)
}

macro end() {
    check_free((pc() & $ff0000) + $010000)
}

macro check_free(variable offset) {
    if pc() < offset {
        print_hex6(pc())
        print "..."
        print_hex6(offset - 1)
        print " free\n"
    } else if pc() > offset {
        print "Overlap at "
        print_hex6(offset)
        print "\n"
        error "Memory overlap"
    }
}

macro seekf(variable offset) {
    check_free(offset)
    seek(offset)
}

macro bank(variable n) {
    check_free(n << 16)
    seek((n << 16) | $008000)
}

macro print_hex6(variable n) {
    print "$"
    print_hex1((n & $f00000) >> 20)
    print_hex1((n & $0f0000) >> 16)
    print_hex1((n & $00f000) >> 12)
    print_hex1((n & $000f00) >>  8)
    print_hex1((n & $0000f0) >>  4)
    print_hex1((n & $00000f) >>  0)
}

macro print_hex1(variable n) {
    if n >= 10 {
        putchar(97 - 10 + n)
    } else {
        putchar(48 + n)
    }
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
