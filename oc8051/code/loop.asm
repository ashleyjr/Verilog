main:   mov R0, #16
        mov A, #127
        movx @R0, A
        mov R0, #0
        mov R1, #1
        mov R2, #2
        mov R3, #3
        mov R4, #4
        mov R5, #5
        mov R6, #6
        mov R7, #7
        mov dptr, #main
        jmp @A+DPTR 
