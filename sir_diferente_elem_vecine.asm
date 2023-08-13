bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s db 1, 2, 4, 6, 10, 20, 25     ; Declaration der Reihe
    len equ $-s                     ; Lange der Folge s
    d times len-1 db 0              ; Deklaration der Folge (l-1 Elemente)
    
segment code use32 class=code
    start:
        mov ecx, len-1          ; wir setzen die Länge l-1 in ECX, Anz Wiederholungen
        mov esi,0               ; wir setzen 0 in esi, der Index
        
        jecxz Sfarsit
        Repeta:
        
            mov al, [s+esi]      ; im al dem S[i]
            mov bl, [s+(esi+1)]  ; im bl dem S[i+1]
            sub bl, al           ; bl = S[i+1]-S[i]
            
            mov [d+esi], bl      ; D[i] = bl
            
            inc esi             
            
        loop Repeta     ;so lange ecx !=0
        Sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program