extern printf
extern scanf
section .data ; valores inicilizados
fmtInt: db "%d",0x0
msg: db "Digite o valor de x",0xA,0x0
msgSaida: db "Fatorial: ",0x0
msgMenor: db "Menor: ",0x0
msgMaior: db "Maior: ",0x0
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

    ;printf(fmtInt)
    push dword[x]
    push fmtInt
    call printf
    add esp,8
    
    mov eax,800
    cmp dword[x],eax
    jg maior
    push msgMenor
    call printf
    add esp,4 
    xor eax, eax
    ret
    
maior: 
    push msgMaior
    call printf
    add esp,4
    ret




