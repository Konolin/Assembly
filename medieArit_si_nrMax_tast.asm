bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fclose, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
     n dd 0
     message1 db "Folge: ", 0
     message2 db "Aritmestische Mittel: %d; ", 0
     message3 db "Maximalwert: %d", 0
     format db "%d", 0
     file_name db "zahlen.txt", 0
     acces_mode db "w", 0
     file_descriptor dd -1
     s resb 12

; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        push dword message1
        call [printf]
        add esp, 4
        
        mov esi, 0
                
        Schleife:
            push dword n
            push dword format
            call [scanf]
            add esp, 4*2
            
            mov ebx, [n]
            
            cmp ebx, 0
            je Ende
            
            mov dword [s+esi], ebx
            inc esi

            jmp Schleife
            
        Ende:
        
        mov ecx, esi
        mov esi, 0
        mov eax, 0
        mov ebx, 0
        mov dl, 0
        
        Repeta:
            add al, [s+esi]
            
            cmp [s+esi], dl
            jg Max
            jmp continua
            
            Max:
                mov dl, [s+esi]
                
            continua:                 
                inc esi
                inc bl
            
        loop Repeta
            
        cbw
        idiv bl
        cbw
        cwde
        
        mov bl, dl
        
        push eax
        push dword message2
        call [printf]
        add esp, 4
        
        mov al, bl
        cbw
        cwd
        mov ebx, eax
        
        push eax
        push dword message3
        call [printf]
        add esp, 4*2
                
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        cmp eax, 0
        je final
        
        push dword message2
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        push ebx
        push dword message3
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        final:

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
