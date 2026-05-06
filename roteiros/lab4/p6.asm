extern printf
extern scanf
section .data ; valores inicilizados
fmtInt: db "%d",0xA,0x0
msg: db "Digite o valor de x",0xA,0x0
msgSaida: db "Resultado",0xA,0x0

section .bss ; valores não inicializados
x resd 1
y resd 1
r1 resd 1
r2 resd 1
r3 resd 1

section .text ; codigo fonte
    global main
main:
    mov ebp, esp; for correct debugging
    ;printf(msg)
    push msg
    call printf
    add esp,4
    
    ;scanf("%d",&x)
    push x
    push fmtInt
    call scanf
    add esp,8      
   
    ; primeira parte R1 
    mov eax,dword[x]
    mov ebx,dword[x]
    mul ebx    
    
   mov ebx,2
   mul ebx  
   mov dword[r1],eax  
   ; segunda parte R2
   mov eax,dword[x]
   mov ebx,5
   mul ebx
   mov dword[r2],eax  
   
   ; terceira parte R3
   mov eax,dword[r1]
   mov ebx,dword[r2]
   sub eax,ebx
   add eax,4
   mov dword[r3],eax 
   
    ; quarta parte
    mov  eax,dword[r3]
    mov ebx, 3
    div ebx  
    
    
    ;printf("%d",x)
    push eax
    push fmtInt
    call printf
    add esp,8
    
    xor eax,eax; return 0
    ret





