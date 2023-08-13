bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 1, 5, 3, 8, 2, 9
    l equ $-s
    d1 times l db 0
    d2 times l db 0
    zwei db 2

    
segment code use32 class=code
    start:
        mov ecx,l   ; l in ecx fur die Schleife
        mov esi, 0  ; esi als index fur s
        mov ebx, 0  ; ebx als Zähler/index für d2
        mov edi, 0  ; edi als Zähler/index für d1
        
        bucla:
            mov al,[s+esi]  ; S[esi]
            clc             ; curatam carry-ul, weil wir die carry-flag fur die gerade und ungerade Zahlen nutzen
            shr al,1        ; shift right mit 1, weil wir die Zahl in al in der basis 2 durch 2 teilen
            jc ungerade     ; wenn die CF=1, die Zahl ist ungerade,sonst ist es gerade
            jmp gerade
            
            gerade:
                mov bl, [s+esi]
                mov [d1+edi], bl
                inc edi
                
            ungerade:
                mov bl, [s+esi]
                mov [d2+ebx], bl
                inc ebx
                
            inc esi
        loop bucla
        
        push    dword 0
        call    [exit]