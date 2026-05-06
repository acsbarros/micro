extern printf
section .data
nome: db "carlos",0xa,0x0
msg: db "exit",0xa,0x0
section .text
global main
main:
    ;write your code here
    
    mov ebx,3
    mov eax,0
    
    .repita: 
    cmp eax,ebx
    jge exit
    push eax
    ; repete o que vc quiser aqui dentro
    push nome
    call printf
    add esp,4
        
    pop eax
    inc eax
    jmp .repita
    
exit: 
    xor eax, eax
    ret