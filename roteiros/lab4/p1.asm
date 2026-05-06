extern printf ; printf("Digite o valor de a");
extern scanf ; scanf("%d",&a)
section .data
msg: db "Digite o valor de a",0xA,0x0
intFmt: db "%d",0xA,0x0
section .bss
a resd 1
section .text
global main
main:
    mov ebp, esp; for correct debugging
    mov eax,0
    mov ebx,0
    mov ax,2
    mov bx,1    
    add ax,bx    
    
    push msg
    call printf
    add esp,4    
    push a
    push intFmt
    call scanf
    add esp,8
    
    push dword[a]
    push intFmt
    call printf    
    add esp,8
    
    mov eax,dword[a]
    
    
    
    
    
xor eax,eax ; esta linha corresponde ao return 0 é a mesma coisa que mov eax zero
ret





