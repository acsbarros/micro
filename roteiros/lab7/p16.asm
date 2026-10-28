extern printf
extern scanf

section .data
qtdidades equ 6
fmtInt: db "%d",0xa,0x0

section .bss
idades resd 6
s resd 1
section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    ;lea eax,[idades]
    mov ebx,0
    loop_atr_direta:
    cmp ebx,qtdidades
    jge imprima    
    mov dword[idades+ebx*4],ebx
    inc ebx
    jmp loop_atr_direta
    
    imprima: 
    mov ebx,0
    loop_ver_direta:
    cmp ebx,qtdidades
    jge soma    
    push dword[idades+ebx*4]
    push fmtInt
    call printf
    add esp,8
   
    inc ebx
    jmp loop_ver_direta
    
    
    
    
    soma: 
    mov ebx,0
    mov dword[s],0
    loop_soma:
    cmp ebx,qtdidades
    jge fim    
    mov eax,dword[idades+ebx*4]
    add eax,dword[s]
    mov dword[s],eax 
          
    inc ebx
    jmp loop_soma
    
    
    fim: 
    push dword[s]
    push fmtInt
    call printf
    add esp,8
    
    mov eax,dword[s]
    mov ebx,qtdidades
    div ebx
    
    push eax
    push fmtInt
    call printf
    add esp,8
    
    
    xor eax, eax    
    ret