extern printf
extern scanf

section .data ; valores inicilizados
fmtInt: db "%d",0x0
msg: db "Digite a idade",0xA,0x0
fmtIntSaida: db "%d",0xA,0x0

section .bss
idades resd 4
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    
    mov ecx,4  
    .for:
    push ecx     
    ; scanf("%d",&idades)
    ; scanf recebe endereço: Use lea para carregar o endereço   
    lea eax, [idades+(ecx-1)*4]    
    push eax
    push fmtInt
    call scanf
    add esp,8
    pop ecx
    loop .for     
        
    mov ecx,4  
    .repita:
    push ecx       
    push dword[idades+(ecx-1)*4]
    push fmtIntSaida
    call printf
    add esp,8

    pop ecx
    loop .repita
    
    
    xor eax, eax
    ret