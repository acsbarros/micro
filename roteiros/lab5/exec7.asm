extern printf
extern scanf
section .data
nnotas equ 3
fmtFloat: db "%f", 0x0              ; %f para ler float
msg: db "Digite a nota do aluno %d: ", 0x0
fmtFloatSaida: db "Nota do aluno %d: %.2f", 0xA, 0x0

section .bss
notas resd nnotas                       ; 10 notas float

section .text
global main
main:
    mov ebp, esp
    
    xor ebx, ebx                     ; contador = 0
    
    leitura_loop:
    cmp ebx, nnotas
    jge mostrar_notas
    
    ; Mensagem
    push ebx
    push msg
    call printf
    add esp, 8
    
    ; Lê a nota (float)
    lea eax, [notas + ebx*4]         ; endereço da nota
    push eax
    push fmtFloat
    call scanf
    add esp, 8
    
    inc ebx
    jmp leitura_loop
    
    mostrar_notas:
    xor ebx, ebx
    
    saida_loop:
    cmp ebx, nnotas
    jge fim
    
    ; O printf espera double (8 bytes), mas temos float (4 bytes)
    ; Por isso precisamos converter
    fld dword [notas + ebx*4]        ; carrega float na FPU
    sub esp, 8                       ; reserva espaço para double
    fstp qword [esp]                 ; converte e coloca double na pilha
    
    push ebx                         ; número do aluno
    push fmtFloatSaida
    call printf
    add esp, 16                      ; 2 parâmetros + 8 bytes do double = 16
    
    inc ebx
    jmp saida_loop
    
    fim:
    xor eax, eax
    ret