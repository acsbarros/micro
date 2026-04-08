extern printf
section .data ; valores inicilizados
fmtInt: db "%d",0xA,0x0




section .bss ; valores não inicializados
idade resb 1

section .text ; codigo fonte
    global main
main:
    mov ebp, esp; for correct debugging
    ; add, sub, mul, div (-,+,*,/)
    mov ebp, esp; for correct debugging    
     mov eax,0
     mov ebx,0   
    ; operação de divisão
    mov al, 11 ; dividendo
    mov bl,5 ; divisor
    div bl ; operacao  -> resultado ficou em AL e o resto ficou em AH    
    MOV EBX,EAX ; guarda o resultado temporariamente em ebx    
    mov ah,0
    movzx eax,al
    ;imprimir o resultado    
    push eax
    push fmtInt
    call printf
    add esp,8
        
    mov eax,EBX
    mov al,0
    movzx eax,ah
    
    push eax
    push fmtInt
    call printf
    add esp,8 
    

    mov byte[idade],43    
    
    mov eax,0
    mov al, byte[idade]
    
    xor eax,eax; return 0
    ret





