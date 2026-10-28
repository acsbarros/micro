extern printf
extern scanf
section .data ; valores inicilizados
fmtInt: db "%d",0x0
msg: db "Digite o valor de x",0xA,0x0
msgSaida: db "Somatorio: ",0x0
fmtIntSaida: db "%d",0xA,0x0
signal: dd -1
; s = 1-2+3-4+5-6...
section .bss ; valores não inicializados
x resd 1
soma resd 1

section .text ; codigo fonte
    global main:
    mov ebp, esp; for correct debugging
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
    
    
    mov ecx,dword[x]    
    mov dword[soma],0
    
    .for:
    push ecx    
    
    mov eax,-1
    mov ebx,dword[signal]
    imul ebx
    mov dword[signal],eax
    mov ebx,ecx
    imul ebx
    
    
    add eax,dword[soma]
    mov dword[soma],eax
             
    
    pop ecx
    loop .for

   
prima:    push msgSaida
          call printf
          add esp,4
          push dword[soma]
          push fmtInt
          call printf
          add esp,8

    xor eax,eax; return 0
    ret





