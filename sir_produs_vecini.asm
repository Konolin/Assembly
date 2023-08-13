bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data

    S db 1,2,3,4
    len equ $-S
    D times len-1 dw 0

segment code use32 class=code
    start:
        
        mov ecx, len-1
        mov esi, 0
        jecxz Ende
        Do:
            mov al,[S+esi]      ; al = S[esi]
            mov bl,[S+(esi+1)]  ; bl = S[esi+1]
            mul bl              ; ax = al * bl
            mov [D+esi],ax      ; D[esi] = ax
        loop Do
        Ende:
        
        push    dword 0
        call    [exit]