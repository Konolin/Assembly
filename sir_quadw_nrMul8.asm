bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dq  123110110abcb0h, 1116adcb5a051ad2h, 4120ca11d730cbb0
    len equ ($-sir)/8       ; die Länge des Strings (in Quadwords)
    opt db 8                ; Variable zum Testen der Teilbarkeit durch 8
    zece dd 10              ; Variable zur Bestimmung der Ziffern zur Basis 10 einer Zahl durch aufeinanderfolgende Divisionen durch 10 
    suma dd  0              ; Variable, die zum Halten der Summe der Ziffern verwendet wird

; our code starts here
segment code use32 class=code
    start:
        mov esi, sir    ; in eds:esi speichern wir die Adresse des Strings "sir"
        cld             ; parsen die Folge von links nach rechts (DF=0).
        mov ecx, len    ; wir werden die Elemente der Folge in einer Schleife mit len Iterationen parsen.
        mov ebx, 0      ; in ebx werden wir die Zahl der Vielfachen von 8 halten.
        
        
        repeta:
            lodsd           ; in eax haben wir das niedrige Doppelwort(am wenigsten signifikant) des aktuellen Quadwords aus der Folge
            lodsd           ; in eax haben wir das hochwertige Doppelwortdes aktuellen Quadwords aus der Folge
            shr eax, 16
            mov ah, 0       ; wir interessieren uns für das niederwertige Byte (am wenigsten signifikant) dieses Wortes(AL)
            
            div byte[opt]   ; prüfe ob al durch 8 teilbar ist
            cmp ah, 0       ; wenn der Rest 0 ist, setze die Schleife "repeta" fort. Sonst erhöhen wie die Anzahl der Vielfachen von 8 von EBX.
            jnz nonmultiplu
            inc ebx
            
            nonmultiplu:
        loop repeta         ;wenn es mehr Elemente gibt (ecx>0),setze die Schleife fort.
        
        
        ; Als nächstes erhalten wir die Ziffern der Zahl EBX (zur Basis 10) durch aufeinanderfolgende Divisionen durch 10 und berechnen dann die Summe dieser Ziffern
        mov eax, ebx 
        mov edx, 0
        transf:
            div dword[zece]         ; dividiere die Zahl durch 10, um die letzte Ziffer zu erhalten. Diese Ziffer wird in EDX sein
            add dword[suma], edx    ; addiere die Ziffer zur Summe.
            cmp eax, 0
            jz sfarsit      ; Wenn der Quotient (von al) 0 ist, bedeutet dies, dass wir alle Ziffern erhalten haben und die Schleife "transf" verlassen können
                            ;sonst bereite den Quotienten für eine neue Iteration vor 
            mov edx, 0
            jmp transf              ;setzt die Schleife fort, um eine neue Ziffer zu erhalten.
        sfarsit:        ;Ende des Programms
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
