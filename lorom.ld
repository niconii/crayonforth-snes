MEMORY {
    ZEROPAGE:   start = $000000, size =   $100;
    BSS:        start = $000200, size =  $1e00;
    BSS7E:      start = $7e2000, size =  $e000;
    BSS7F:      start = $7f0000, size = $10000;
    ROM0:       start = $808000, size =  $8000, fill = yes;
    ROM1:       start = $818000, size =  $8000, fill = yes;
    ROM2:       start = $828000, size =  $8000, fill = yes;
    ROM3:       start = $838000, size =  $8000, fill = yes;
    ROM4:       start = $848000, size =  $8000, fill = yes;
    ROM5:       start = $858000, size =  $8000, fill = yes;
    ROM6:       start = $868000, size =  $8000, fill = yes;
    ROM7:       start = $878000, size =  $8000, fill = yes;
}

SEGMENTS {
    FONT:       load = ROM0, type = ro, start = $808000;
    CODE:       load = ROM0, type = ro, start = $80b000;
    EXTINFO:    load = ROM0, type = ro, start = $80ffb0;
    HEADER:     load = ROM0, type = ro, start = $80ffc0, fillval = $20;
    ROMINFO:    load = ROM0, type = ro, start = $80ffd5;
    VECTORS:    load = ROM0, type = ro, start = $80ffe0;

    ROM1:       load = ROM1, type = ro, optional = yes;
    ROM2:       load = ROM2, type = ro, optional = yes;
    ROM3:       load = ROM3, type = ro, optional = yes;
    ROM4:       load = ROM4, type = ro, optional = yes;
    ROM5:       load = ROM5, type = ro, optional = yes;
    ROM6:       load = ROM6, type = ro, optional = yes;
    ROM7:       load = ROM7, type = ro, optional = yes;

    ZEROPAGE:   load = ZEROPAGE, type = zp, optional = yes;
    BSS:        load = BSS,   type = bss, define = yes, optional = yes;
    BSS7E:      load = BSS7E, type = bss, define = yes, optional = yes;
    BSS7F:      load = BSS7F, type = bss, define = yes, optional = yes;
}
