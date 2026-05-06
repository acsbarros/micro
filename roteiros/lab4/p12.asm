extern printf
extern scanf

section .data ; valores inicilizados
fmtInt: db "%d",0xA,0x0
msg: db "Digite a idade",0xA,0x0
fmtIntSaida: db "%d",0xA,0x0

section .bss
idades resd 3
x resd 1
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    
     mov ecx,3
     mov esi,0
    .for: 
           
    push [idades+esi]
    push fmtInt
    call scanf    
    add esp,8
    mov ecx,[esp]
    inc esi
    cmp esi,3
    jl .for
    
    
    mov ecx,3    
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