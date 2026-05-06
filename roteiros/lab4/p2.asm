extern scanf
extern printf

section .data
printString: db "%d",0x0d,0x00
printDiv: db "divisao",0x0d,0x00

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here   
    ; 26/5 ->26 dividendo(ax) e o 5 é o divisor(BL,CL,DL)  (quociente em AH e Resto em AL)
    mov eax,0
    mov ebx,0
    
    mov ax,10
    mov bl,2
    div bl  
    MOV EBX,EAX     
     ;exibe resultado da divisão (QUOCIENTE)
    mov ah,0
    movzx eax,al    
    push eax
    push printString
    call printf
    add esp,8  
    
      ;exibe RESTO da divisão
    mov eax,EBX
    mov al,0
    movzx eax,ah   
    push eax
    push printString
    call printf
    add esp,8  
    
       
    
    
    
    
    xor eax, eax
    ret
