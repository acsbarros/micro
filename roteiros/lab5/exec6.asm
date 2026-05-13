extern printf
extern scanf

section .data
fmtDouble: db "%lf", 0x0            ; %lf para ler double
msg: db "Digite a nota do aluno %d: ", 0x0
fmtDoubleSaida: db "Nota do aluno %d: %.2f", 0xA, 0x0

section .bss
notas resq 3                       ; 3 notas double (cada 8 bytes)

section .text
global main
main:
    mov ebp, esp
    
    xor ebx, ebx                     ; contador = 0
    
    leitura_loop:
    cmp ebx, 3
    jge mostrar_notas
    
    ; Mensagem
    push ebx
    push msg
    call printf
    add esp, 8
    
    ; Lê a nota (double = 8 bytes)
    lea eax, [notas + ebx*8]         ; endereço da nota
    push eax
    push fmtDouble
    call scanf
    add esp, 8
    
    inc ebx
    jmp leitura_loop
    
    mostrar_notas:
    xor ebx, ebx
    
    saida_loop:
    cmp ebx, 3
    jge fim
    
    ; Para double, empilha parte alta e parte baixa
    push dword [notas + ebx*8 + 4]   ; parte alta
    push dword [notas + ebx*8]       ; parte baixa
    push ebx                         ; número do aluno
    push fmtDoubleSaida
    call printf
    add esp, 16                      ; 4 parâmetros de 4 bytes = 16
    
    inc ebx
    jmp saida_loop
    
    fim:
    xor eax, eax
    ret