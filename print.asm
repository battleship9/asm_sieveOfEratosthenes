;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print the largest prime

    mov rcx, printFormat

    ; loads the largest prime
    mov rax, [largestPrime]

loop4:
    xor rdx, rdx

    ; divides by print format
    div rcx
    ; makes it humanly readable
    add rax, '0'
    ; copies to output
    mov [tmp], rax

    push rdx
    push rcx

    ; writes the output
    mov rax, 4
    mov rbx, 1
    mov rcx, tmp
    mov rdx, 8
    int 80h

    pop rcx

    xor rdx, rdx

    ; divides print format by 10
    mov rax, rcx
    mov rbx, 10
    div rbx
    mov rcx, rax

    pop rdx

    ; loads the remainder
    mov rax, rdx

    ; loops if print format is greater than 1
    cmp rcx, 1
    jg loop4

    ; prints the ones place
    add rax, '0'
    mov [tmp], rax

    mov rax, 4
    mov rbx, 1
    mov rcx, tmp
    mov rdx, 8
    int 80h