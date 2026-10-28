
extern scanf
extern printf
section .data
tamanho equ 4
msg: db "Digite a nota do aluno %d", 0xA,0x0
fmtFloat: db "%f", 0x0
section .bss
notas resd tamanho                       ; 10 notas float

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    mov ebx,0
    
    push ebx
    push msg
    call printf
    add esp, 8
    
    xor ebx, ebx                     ; contador = 0
    leitura_loop:
    cmp ebx, tamanho
    jge fim
    
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
    
    
    
    fim:
    xor eax, eax
    ret