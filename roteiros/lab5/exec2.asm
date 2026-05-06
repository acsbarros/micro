extern printf
extern scanf
section .data ; valores inicilizados
fmtInt: db "%d",0x0
msg: db "Digite o valor de x",0xA,0x0
msgSaida: db "Fatorial: ",0x0
fmtIntSaida: db "%d",0xA,0x0
section .bss ; valores não inicializados
x resd 1
fat resd 1
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
    cmp ecx,0
    jle prima

    .for:
    push ecx

    mov eax,dword[soma]
    add eax,ecx
    mov dword[soma],eax


    pop ecx
    loop .for

    ; printf("Fatorial")
prima:    push msgSaida
    call printf
    add esp,4

    ;printf("%d",x)
    push dword[soma]
    push fmtInt
    call printf
    add esp,8

    xor eax,eax; return 0
    ret





