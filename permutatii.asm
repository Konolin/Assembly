bits 32
global start

extern exit, printf, scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll

segment data use32 class=data
    n dd 0                       ; hier wird der Zahl von der Tast gespeichert
    message db "n=", 0
    format10 db "%u", 0          ; vorzeichenlose decimal Format
    format16 db "%x, ", 0        ; vorzeichenlose hexadecimal Format
    formatnr db "~%u~", 0
    

segment code use32 class=code
    start:
        ; Gegeben ist eine vorzeichenlose Zahl a auf 32 Bit. 
        ; Geben Sie die hexadezimale Darstellung von a aus, aber auch die
        ; Ergebnisse der kreisförmigen Permutationen seiner Hex-Ziffern.
    
        
        ; Druckt 'n='
        push dword message      ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*1            ; freit 1 Parameter auf der Stack
        
        
        ; Liest n
        push dword n            ; die Adresse wird auf den Stack gelegt
        push dword format10     ; die Adresse wird auf den Stack gelegt
        call [scanf]            ; ruft die Funktion
        add esp, 4*2            ; freit 2 Parameter auf der Stack
        
        
        ; Druckt n
        push dword [n]          ; die Adresse wird auf den Stack gelegt
        push dword format16     ; die Adresse wird auf den Stack gelegt
        call [printf]           ; ruft die Funktion
        add esp, 4*2            ; freit 2 Parameter auf der Stack
        
        
        ; Rechnet der Anzahl der Ziffern
        mov ecx, 0              ; Anzahl Ziffern
        mov eax, [n]            ; eax = n
        nr_cifre:
            shr eax, 4          ; jede 4 bits sind ein Ziffer in n
            inc ecx             ; shr loscht je ein Ziffer (wie n = n div 10)
            cmp eax, 0          
            jne nr_cifre        ; wenn eax = 0 dann ist die Schleife fertig
        
        
        ; Drucken der Permutationen
        mov esi, ecx            ; esi wird fur die Schleife benutzt (Anzahl der Wiederholungen)
        mov edi, ecx            ; edi haltet der Anzahl der Ziffern fest
        dec esi                 ; 'esi - 1' um die erste Permutation nucht zwei mal zu drucken
        perm:
            dec esi
            mov ebx, 0
            mov edx, 0
            mov eax, [n]
            mov ecx, edi
          
            ror eax, 4          ; man rotiert alle bits um 4 nach rechts (4 bit = 1 Hex-Ziffer)
           
            mov ebx, 1111_0000_0000_0000_0000_0000_0000_0000b       
            and ebx, eax        ; in ebx haltet die 4 bits die am linkestens sind fest 
                                ;(die Hex-Ziffer die von rechts nach links gebracht wurde) 
            
            mov edx, 0000_1111_1111_1111_1111_1111_1111_1111b
            and eax, edx        ; in eax haltet man nur die anderen bits fest
            
            mov edx, 0          ; ecx = 8 - Anzahl der Ziffern
            mov edx, ecx 
            mov ecx, 8
            sub ecx, edx
            
            shift:              ; man bringt ebx, 4*ecx bits nach rechts
                dec ecx         ; zB   1011_0000_0000_0000_0000_0000_0000_0000
                shr ebx, 4      ; wird 0000_0000_0000_0000_0000_1011_0000_0000 
                cmp ecx, 0      ;                  hier wird eax sein~~~~~~~~~
                jg shift

            or eax, ebx
            mov [n], eax        ; n nimmt den neuen Wert
            
            ; Man druckt n
            push dword [n]          ; die Adresse wird auf den Stack gelegt
            push dword format16     ; die Adresse wird auf den Stack gelegt
            call [printf]           ; ruft die Funktion
            add esp, 4*2            ; freit 2 Parameter auf der Stack
       
            cmp esi, 0
            jg perm             ; perm wird esi mal wiederholt
        
        
    
        ; exit(0)
        push    dword 0
        call    [exit]
