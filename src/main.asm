.proc main
    ; Set up data stack
    ldx #$0180

    ; Set up 64x28 console
    jsr c64init

    ; Print banner
    jsr banner

main_loop:
    lda Joy1Prs

    bit #BUTTON_B
    beq :+
        dpush #'B'
        jsr emit
    :

    bit #BUTTON_Y
    beq :+
        dpush #'Y'
        jsr emit
    :

    bit #BUTTON_SELECT
    beq :+
        dpush #' '
        jsr emit
    :

    bit #BUTTON_START
    beq :+
        jsr cr
    :

    bit #BUTTON_A
    beq :+
        dpush #'A'
        jsr emit
    :

    bit #BUTTON_X
    beq :+
        dpush #'X'
        jsr emit
    :

    bit #BUTTON_L
    beq :+
        dpush #'L'
        jsr emit
    :

    bit #BUTTON_R
    beq :+
        dpush #'R'
        jsr emit
    :
    
    wai
    bra main_loop
.endproc
