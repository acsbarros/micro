extern printf
extern scanf
section .data ; valores inicilizados
fmtInt: db "%d",0x0
msg: db "Digite o valor de x",0xA,0x0
msgSaida: db "Resultado",0x0

section .bss ; valores não inicializados
x resd 1
y resd 1

section .text ; codigo fonte
    global main:
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
    

    ;printf("%d",x)
prima:    push dword[x]
    push fmtInt
    call printf
    add esp,8

exit:    xor eax,eax; return 0
    ret





