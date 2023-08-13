bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 125
    b db 2
    c dw 15
    d db 200
    e dq 80

; our code starts here
segment code use32 class=code
    start:
        mov al, [b]
        cbw             ; vorzeichenbehaftete Umwandlung von al zu ax
        cwd             ; vorzeichenbehaftete Umwandlung von ax zu dx:ax
        ; dx:ax = b
        idiv word [c]   ; vorzeichenbehaftete Division dx:axdurch c
        ; ax=b/c
        ; der Quotient ist in ax (der Rest ist in dx, aber wirgehen nur mit der Quotient weiter)
        
        
        mov bx, ax      ; wir speichern b/c in bx, damit wir ax zum Multiplizieren von d mit 2 verwenden können
        mov al, 2
        imul byte [d]   ; ax=d*2
        
        
        sub bx, ax      ; bx=b/c-d*2
        ; wir wandeln das Wort bx in doubleword um, damit wir es mit dem doubleword a addieren können
        mov ax, bx
        cwd             ; vorzeichenbehaftete Umwandlung von ax zu dx:ax
        ;dx:ax=b/c-d*2
        
        
        mov bx, word [a]
        mov cx, word [a+2]  ; cx:bx = a
        
        
        add ax, bx
        adc dx, cx      ; das Ergebnis von a + b / c - d * 2 ist in dx:ax
        
        
        push dx
        push ax
        pop eax         ; eax = a + b / c - d * 2
        cdq             ; edx:eax = a + b / c - d * 2
        
        
        sub eax, dword [e]
        sbb edx, dword [e+4] ; edx:eax = a + b / c - d * 2- e
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
