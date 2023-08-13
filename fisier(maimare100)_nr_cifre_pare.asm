bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll    
import printf msvcrt.dll    
import fopen msvcrt.dll    
import fclose msvcrt.dll    
import fread msvcrt.dll    

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "input.txt", 0 ; der name des files den wir lesen werden 
    accesMode db "r", 0        ; acces mode
    fileDescriptor dd -1       ; variable um den file descriptor zu behalten
    readCharacters dd 0        ; anzahl der gelesenen charaktern
    len equ 100     
    buffer times (len + 1) db 0; string das dem text behalt
    format db "%s", 0
    format2 db "Es sind %d gerade Ziffern", 0 ; format fur dem autput auf dem bildschirm

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0 ;counter fur geraden Zifern
        mov edx, 0
        
        push dword accesMode
        push dword fileName
        call [fopen]
        add esp, 4*2 ; Wir befreien die Parametern auf dem Stack, 4*2 da es zwei doublewords sind
        ;Wir offnen den file
        
        cmp eax, 0
        je end
        ;Wenn der File nicht gefunden wurde beendet der Programm
        
        mov [fileDescriptor], eax
        ;Wir sparen den file descriptor des files
        
        whileReadFromFile:
            ;In diesem while lesen wir die charaktern aus dem File
            ;Wir brauchen einen while da den File mehr als 100 Charaktern enthalten kann
        
            push dword [fileDescriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4 ; Wir befreien die Parametern auf dem Stack, 4*4 da es vier doublewords sind
            ;Wir lesen zwischen 0 und 100 Charaktern aus dem File
        
            cmp eax, 0
            je end
            ;Wenn wir nichts aus dem File mehr lesen konnen, dann beenden wir dem while
            
            ;push dword buffer
            ;push dword format
            ;call [printf]
            ;add esp, 4*2
            
            mov [readCharacters], eax
            ;Wir sparen den Anzahl der gelesenen Charaktern aus dem File
            
            mov eax, 0
            mov edx, 0
            
                mov esi, 0
                ;Wir benutzen esi um den vektor buffer durchzulaufen
                ;Buffer enthalt die gelesenen Charaktern
            
                while:
                    ;Diesem While bestimmt wie viele geraden Ziffern sich im buffer befinden
                    
                    mov edx, 0
                    mov dl, [buffer + esi]
            
                    ;Wir prufen ob den aktuellen char in dem vektor eine Ziffer ist
                    cmp dl, '0'
                    jb nichtZiffer
            
                    cmp dl, '9'
                    jg nichtZiffer
                    
                    ;Wenn der Charakter eine Ziffer ist mussen wir prufen ob es auch gerade ist
                    mov al, dl
                    sub al, '0'
                    
                    ;Wir prufen ob diese Ziffer gerade oder ungerade ist
                    test al, 1
                    jnz nichtGerade ; Wenn der Resultat 0 ist, dann ist diese Ziffer gerade
                    
                    inc ebx 
                    ;Die Ziffer ist gerade, also wir mussen den counter inkrementieren
                    
                    nichtGerade:
                    nichtZiffer:
            
                    inc esi
                    cmp esi, [readCharacters]
                    je whileReadFromFile
            
                jmp while
        
        jmp whileReadFromFile
        
    end:
    
        push dword ebx
        push dword format2
        call [printf]
        add esp, 4*2 ; Wir befreien die Parametern auf dem Stack, 4*2 da es zwei doublewords sind
        ;Wir zeigen auf dem Bildschirm den Anzahl von geraden Ziffern in dem File
        
        push dword [fileDescriptor]
        call [fclose]
        add esp, 4 ; Wir befreien die Parametern auf dem Stack, 4 da es ein doublewords is
        ;Wir schliesen dem File am ende des Programms
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
