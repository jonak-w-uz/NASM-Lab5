global _start

section .bss
    bufor resb 64
    liczba_bajtow resq 1

section .text
_start:
    ; Wczytaj maksymalnie 64 bajty ze standardowego wejscia.
    mov rax, 0              ; Numer wywolania read.
    mov rdi, 0              ; Standardowe wejscie.
    mov rsi, bufor          ; Adres bufora.
    mov rdx, 64             ; Rozmiar bufora.
    syscall

    ; Sprawdz, czy odczytano dane.
    cmp rax, 0
    jle koniec

    ; Zachowaj liczbe odczytanych bajtow.
    mov [liczba_bajtow], rax

    mov rdi, bufor
    mov rsi, qword [liczba_bajtow]
    call print_text
    jmp koniec

print_text:
    mov rdx, rsi
    mov rsi, rdi

    mov rax, 1
    mov rdi, 0

    syscall

    ret
koniec:
    ; Ustaw tutaj breakpoint, aby obejrzec bufor.
    mov rax, 60
    mov rdi, 0
    syscall
