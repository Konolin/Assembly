bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s1 db 1, 3, 5, 7
    s2 db 2, 6, 9, 4
    l equ $-s1
    d times l times 2 db 0

; our code starts here
segment code use32 class=code
    start:
        mov ecx, l ; wir setzen die Länge l in ECX, um dieSchleife zu machen
        mov esi, 0 ; Index fur die durchquerung von s1, s2
        mov edi, 0 ; Index fur die durchquerung von d
        
        jecxz Sfarsit ; springt zu Sfarsit wenn ecx = 0
        Repeta:
            ; man nimmt den Wert von s1 und s2, der sich auf den Index esi befindet
            mov al, [s1+esi]
            mov bl, [s2+esi]
            inc esi
            
            ; die Werte von al und bl werden in d verschoben auf die Positionen d+edi und d+edi+1
            mov [d+edi], al
            inc edi
            mov [d+edi], bl
            inc edi
            loop Repeta
        Sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
