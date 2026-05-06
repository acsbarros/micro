extern scanf
extern printf

section .data
intInt: db "%d",0xA,0x0

section .bss
x resd 1
m resd 1
r1 resd 1
r2 resd 1
r3 resd 1
r4 resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ;write your code here
    ;scanf("%d",&x)
    push x
    push intInt
    call scanf
    add esp,8
    
    mov eax,dword[x]
    mov ebx,dword[x]
    mul ebx    
    mov ebx,2
    mul ebx    
    ; guardar 2x²  em r1
    mov dword[r1],eax 
    mov eax,dword[x]
    mov ebx,3
    mul ebx    
    mov ebx,2
    div ebx 
    ; guardar o valor de (3x)/2 em r2  
    mov dword[r2],eax
    mov eax,dword[r1]
    sub eax,dword[r2]
    add eax,5    
    
    ; printf("%d",eax)
    push eax
    push intInt
    call printf
    add esp,8   
    
    
    xor eax, eax
    ret