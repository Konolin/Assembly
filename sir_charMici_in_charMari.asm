bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'b', 'c', 'm','n'     ; man deklariert die Zeichenfolge von Bytes
    l equ $-s                       ; man berechnet die Länge der Zeichenfolge in l 
    d times l db 0                  ; man reserviert l Bytes für den Zielfolge und initialisiere ihn

; our code starts here
segment code use32 class=code
    start:
        mov ecx, l      ; wir setzen die Länge l in ECX, um die Schleife zu machen
        mov esi, 0 
        jecxz Sfarsit
        
        Repeta:
            mov al, [s+esi]
            mov bl, 'a'-'A' ; um den entsprechenden Großbuchstaben zu erhalten, subtrahieren wir den ASCII-CODE von 'a'-'A' vom Kleinbuchstaben die in AL gespeichert sind
            
            sub al, bl 
            mov[d+esi], al
            
            inc esi
            loop Repeta
            
        Sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
