extern scanf
extern printf
section .data
    valor db 0x80      ; byte com valor 128 ou -128

section .text
    global main

main:

    
    mov ebp, esp; for correct debugging
    mov eax,0 
    mov eax,0x80 ; hex
    mov eax,128 ; decimal
    mov eax,0b000000000000000000000010000000 ; bin
    mov eax,200o ; octal
    
    ; Carrega o byte
    mov al, [valor]    ; AL = 0x80
    
    ; MOVZX - Zero Extension (trata como unsigned)
    movzx ecx, al      ; ECX = 0x00000080 (128 decimal)
    
    ; MOVSX - Sign Extension (trata como signed)
    movsx edx, al      ; EDX = 0xFFFFFF80 (-128 decimal)
    
    ; Agora ECX e EDX têm valores diferentes!
    
    ; Exemplo de uso prático:
    ; Se você está processando uma string (caracteres ASCII)
    mov al, 'A'        ; AL = 0x41 (65 decimal)
    movzx eax, al      ; EAX = 65 - correto para caractere
    
    ; Se você está processando um número signed pequeno
    mov al, -1         ; AL = 0xFF (11111111)
    movzx eax, al      ; EAX = 255 (ERRADO! perdeu o sinal)
    movsx eax, al      ; EAX = -1 (CORRETO! mantém o sinal)
    
    xor eax, eax
    ret
