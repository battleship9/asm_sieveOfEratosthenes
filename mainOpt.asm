bits 64
global _start

section .data
n: equ 100000000
printFormat: equ 10000000

section .bss
largestPrime: resq 1
tmp: resq 1

section .text
_start:

; gets the current highest available address in the data section
mov rax, 45
int 80h

; not primes list
mov r11, rax
add r11, 8

; increases aviable memory
add rax, n*8
mov rbx, rax
mov rax, 45
int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; finding primes

    ; constant
    ; will be used to set bool values
    mov rbx, 1

    ; 0 and 1 aren't primes
    mov [r11 + 0], bl
    mov [r11 + 8], bl

    ; i = 2
    mov rcx, 2

loop1:
    ; clears rax
    xor rax, rax

    ; if notPrimes[i] skip
    mov al, [r11 + rcx*8]
    cmp rax, 1
    je skip1

    ; j = i*i
    mov rax, rcx
    mul rcx
    mov rdx, rax

loop2:
    ; notPrimes[j] = 1
    mov [r11 + rdx*8], bl

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

    ; if notPrimes[i] skip
    mov al, [r11 + rcx*8]
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