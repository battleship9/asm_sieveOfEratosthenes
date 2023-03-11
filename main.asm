bits 64
global _start

section .data
n: equ 100000000
printFormat: equ 10000000
notPrimes: times n db 0

section .bss
largestPrime: resq 1
tmp: resq 1

section .text
_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find primes

    ; 0 and 1 aren't primes
    mov rax, 1
    mov [notPrimes + 0], al
    mov [notPrimes + 1], al

    ; i = 2
    mov rcx, 2

loop1:
    xor rax, rax

    mov r10, rcx
    add r10, notPrimes

    ; if notPrimes[i] skips
    mov al, [r10]
    cmp rax, 1
    je skip1

    ; j = i*i
    mov rax, rcx
    mul rcx
    mov rdx, rax

loop2:
    mov r10, rdx
    add r10, notPrimes

    ; notPrimes[j] = 1
    mov rax, 1
    mov [r10], al

    ; j+=i
    add rdx, rcx
    ; j<n
    cmp rdx, n
    jl loop2

skip1:
    ; i++
    inc rcx
    ; i*i<=n
    mov rax, rcx
    mul rcx
    cmp rax, n
    jle loop1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; get the largest prime

    ; i = n-1
    mov rcx, n-1

loop3:
    xor rax, rax

    ; if notPrimes[i] skips
    mov al, [notPrimes + rcx]
    cmp rax, 1
    je skip2

    mov [largestPrime], rcx
    mov rcx, 0

skip2:
    ; i--
    dec rcx
    ; i>=0
    cmp rcx, 0
    jge loop3

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

end:
    mov rax, 1
    int 80h