global _start

section .data
    positive db "To jest liczba calkowita", 10
    positive_len equ $-positive

    negative db "To nie jest liczba calkowita", 10
    negative_len equ $-negative

section .bss
    bufor resb 64
    liczba_bajtow resq 1

section .text
_start:
    call read_text

    ; Sprawdz, czy odczytano dane.
    cmp rax, 0
    jle koniec_nie

    ; Zachowaj liczbe odczytanych bajtow.
    mov [liczba_bajtow], rax

    mov rdi, bufor
    mov rsi, [liczba_bajtow]
    dec rsi
    call is_integer

    cmp rax, 1
    je koniec_tak
    jne koniec_nie

    jmp koniec

; === is_integer

; address -> rdi
; length - 1 -> rsi
; returns 1 or 0 -> rax
is_integer:
    mov rdx, 0 ; counter
    mov rax, 0
    mov rbp, 0
    mov rax, 1 ; default to oki
    jmp is_integer_loop
    ret

is_integer_loop:
    ; current thingy
    movzx rbx, byte [rdi + 1 * rdx]

    ; test for minus
    mov rcx, '-'
    cmp rbx, rcx
    je is_integer_set_minus_flag

    ; test for less than 0x30
    mov rcx, '0'
    cmp rbx, rcx
    jl is_integer_bad

    ; test for more than 0x30
    add rcx, 9
    cmp rbx, rcx
    jg is_integer_bad

    jmp is_integer_continue

is_integer_set_minus_flag:
; buffer[1] == '-' && len(buffer) == 1
    mov rbp, 0 ; check for length of the buffer
    cmp rdx, rbp
    jne is_integer_bad

    cmp rsi, 2
    jl is_integer_bad

    jmp is_integer_continue

is_integer_bad:
    mov rax, 0
    mov rcx, 0
    ret

is_integer_good:
    mov rax, 1
    mov rcx, 0
    ret

is_integer_continue:
    inc rdx
    cmp rdx, rsi
    je is_integer_good

    jmp is_integer_loop

;; ===

read_text:
    mov rax, 0              ; Numer wywolania read.
    mov rdi, 0              ; Standardowe wejscie.
    mov rsi, bufor          ; Adres bufora.
    mov rdx, 64             ; Rozmiar bufora.
    syscall
    ret

; buffer -> rdi
; length -> rsi
print_text:
    mov rdx, rsi
    mov rsi, rdi

    mov rax, 1
    mov rdi, 1

    syscall

    ret

koniec_tak:
    mov rdi, positive
    mov rsi, positive_len
    call print_text
    jmp koniec

koniec_nie:
    mov rdi, negative
    mov rsi, negative_len
    call print_text
    jmp koniec

koniec:
    ; Ustaw tutaj breakpoint, aby obejrzec bufor.
    mov rax, 60
    mov rdi, 0
    syscall
