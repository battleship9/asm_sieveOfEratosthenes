BITS 64
GLOBAL _start

section .data
n: equ 100
printFormat: equ 10

section .bss
largestPrime: resq 1
tmp: resq 1

section .text
_start:

; gets the current highest available address in the data section
mov rax, 45
int 80h

; not primes list
lea r11, [rax + 8]

; increases aviable memory
lea rbx, [rax + n*8]
mov rax, 45
int 80h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find primes

    ; constant
    ; will be used to set bool values
    mov rbx, 1

    ; 0 and 1 aren't primes
    mov [r11 + 0], bl
    mov [r11 + 8], bl

    ; i = 2
    mov rcx, 2

loop1:
    ; if notPrimes[i] skips
    mov al, [r11 + rcx*8]
    cmp al, 1
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
    ; if notPrimes[i] skips
    mov al, [r11 + rcx*8]
    cmp al, 1
    je skip2

    mov [largestPrime], rcx
    mov rcx, 0

skip2:
    ; i--
    dec rcx
    ; i>=0
    cmp rcx, 0
    jge loop3

%include "print.asm"

end:
    mov rax, 1
    int 80h