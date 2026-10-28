extern printf
extern scanf
section .data
qtdidades equ 3
fmtInt: db "%d", 0x0              ; %d para ler int
msg: db "Digite a idade da pessoa %d: ", 0xA,0x0
fmtIntSaida: db "Idade da pessoa %d: %d", 0xA, 0x0

section .bss
idades resd qtdidades                       ; 10 idades
s resd 1 ; soma
m resd 1 ; media
section .text
global main
main:
    mov ebp, esp
    
    xor ebx, ebx                     ; contador = 0
    
    leitura_loop:
    cmp ebx, qtdidades
    jge mostrar_notas
    
    ; Mensagem
    push ebx
    push msg
    call printf
    add esp, 8
    
    ; Lê a idade
    lea eax, [idades + ebx*4]         ; endereço da idade
    push eax
    push fmtInt
    call scanf
    add esp, 8
    
    inc ebx
    jmp leitura_loop   

    
    mostrar_notas:
    xor ebx, ebx    
    saida_loop:
    cmp ebx, qtdidades
    jge media
    
    push dword[idades + ebx*4]
    push ebx    
    push fmtIntSaida
    call printf
    add esp, 12                     
    
    inc ebx
    jmp saida_loop
    
    media:
    xor ebx, ebx 
    mov dword[s],0   
    mov dword[m],0
    calmedia:
    cmp ebx, qtdidades
    jge fim
    
    mov eax,dword[s]
    add eax,dword[idades + ebx*4]
    mov dword[s],eax   
    inc ebx
    jmp calmedia
    
    
    fim:  
    mov eax,dword[s] 
    mov ebx,qtdidades
    div ebx
    mov dword[m],eax
    push dword[s] 
    push fmtInt
    call printf
    add esp, 8   
    
    push dword[m] 
    push fmtInt
    call printf
    add esp, 8    
          
    xor eax, eax
    ret