extern printf
section .data ; valores inicilizados
fmtInt: db "%d",0xA,0x0

section .bss ; valores não inicializados

section .text ; codigo fonte
    global main

main:
    mov ebp, esp; for correct debugging
    
    ;mov eax,128; decimal
    ;mov eax,0x80 ; hex
    ;mov eax,0b00000000000000000000000010000000 ; bin (32 bits)
    ;mov eax,200o
    
    ;MOVZX - Zero Extension (trata como unsigned)
    ;MOVSX - Sign Extension (trata como signed)
    
    ;mov al,10000000
    ;MOVSX eax,al
     mov eax,0
     mov ebx,0   
    ; operação de divisão
    mov al, 11 ; dividendo
    mov bl,5 ; divisor
    div bl ; operacao  -> resultado ficou em AL e o resto ficou em AH
    
    MOV EBX,EAX ; guarda o resultado temporariamente em ebx
    
    mov ah,0
    movzx eax,al
    
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
    
    
    xor eax,eax; return 0
    ret





