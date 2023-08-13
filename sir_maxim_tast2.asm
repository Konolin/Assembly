bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, gets, printf, fopen,fclose, fprintf           
import exit msvcrt.dll    
import gets msvcrt.dll    
import printf msvcrt.dll    
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll

global s
global maximum
global file_descriptor
global file_name
global access_mode
global Print_maximum
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s times 100 db 0
    maximum dd 0
    Print_nummer db "Nummer: %d", 0Ah, 0
    Print_maximum db "Maximum: %x", 0Ah, 0
    zahlenfolge_zeigen db "Zahlenfolge = %s", 0Ah,0
    file_name db "max.txt", 0 ; filename to be read
    access_mode db "a", 0 ; file access mode: "a" => append text at the end of the file
    file_descriptor dd -1 ; variable to hold the file descriptor
; our code starts here

 segment code use32 class=code
    start:
        mov esi, 0
        
        ; Schreiben einer Zahlenfolge 
        
        push dword s
        call [gets]
        add esp, 4*1
        
        push dword s
        push dword zahlenfolge_zeigen
        call [printf]
        add esp,4*2
        
        ; Zb Zahlenfolge= 12 13 14 15  
        mov eax, 0
        mov esi, 0
        mov ecx,[maximum]
        mov eax, 0
        mov esi, 0
        mov ecx,[maximum]
        
       Zahl_schreiben:
       
            ; im bl speichern wir das Wert,das sich an der Stelle esi in s befindet(Wert= ein einziges Character)
            ; Zb [s+0]=> '1', nicht 12
            
            mov ebx, 0
            mov bl, [s + esi]
            
            ; Wir prufen ob wir zur ende der Folge sind
            ; Zb sind wir zu dem Charakter der nach 15 folgt => gehen wir zur "ende_zahl_schreiben" label
            ; BEMERKUNG!!!! Die Zahl '15' wird mit max nicht vergleicht
            ; Wir werden die Zahl 15 in "ende_zahl_schreiben" printen
            
            
            cmp bl, 0
            je ende_zahl_schreiben
            
            
            ; Befindet sich [s+esi] nicht zwischen '0' und '9' => Sonderzeichen 
            ; gehen wir zur keine_ziffer label
            
            
            cmp bl, '0'
            jl keine_ziffer
            cmp bl, '9'
            jg keine_ziffer
            
            
            
            ; Wir haben eine Ziffer gefunden
            ; Wir mussen unsere Zahl aufbauen
            ; Zahl wird in eax gebaut : eax = eax * 10 + [s+esi]
            ; ZB:
                    ; Fur '14'
                    ; 1. ebx => 1  eax=0
                    ;    eax=0*10+ebx =1
                    ; 2. ebx => 4  eax=1
                    ;    eax=1*10+ebx =10+4=14
                    
            ; eax wird immer zu 0 initialisiert
            ; wir gehen zu dem nachsten Charakter
           
                    
            ist_ziffer:
                sub bl, '0' ;  'ziffer'-'0'=>ziffer
                mov edx, 10
                mul edx; edx:eax = eax * 10 (eigentlich eax = eax*10)
                add eax, ebx
                
                inc esi
                jmp Zahl_schreiben
                
            ; Wir arbeiten jetzt mit [s+esi] ein Sonderzeichen
            ; Erstens mussen wir prufen ob eax!=0(eax enthalt eine Zahl) ist
            ; Falls ja: 1. eax > maximum => maximum = eax
            ;           2. esi++
            ;           3. => Nachsten Charakter
            ;Falls eax=0: 1.inc++
            ;             2.  => Nachsten Charakter
            
                
            keine_ziffer:
                cmp eax, 0
                je ist_kein_nummer
                
                ist_nummer:
                    mov ecx, [maximum]
                    cmp eax, ecx
                    jle nicht_grosser
                    
                    grosser:
                        mov [maximum], eax
                    
                    nicht_grosser:
                
                    
                    mov eax, 0
                        
                    inc esi
                    jmp Zahl_schreiben
            
                ist_kein_nummer:
                    inc esi
                    jmp Zahl_schreiben
                    
        ; Ende der Folge
        ; Prufen ob eax eine Nummer enthalt
        ; wenn ja prufen ob eax>maximum
        ; maximum in der Datei max.txt speichern
        ende_zahl_schreiben:
            cmp eax, 0
            je Keine_Nummer
            mov ecx, [maximum]
            cmp eax, ecx
            jle nichtgrosser
                    
            Grosser:
                mov [maximum], eax
                    
            nichtgrosser:

            
            Keine_Nummer:

            
            push dword access_mode
            push dword file_name
            call [fopen]
            add esp, 4*2 ; clean-up the stack
            mov [file_descriptor], eax ; store the file descriptor returned by fopen
            
            ; check if fopen() has successfully created the file
            
            cmp eax, 0
            je final
            
            ; append the text to file using fprintf()
            ; fprintf(file_descriptor, text)
            
            push dword [maximum]
            push dword Print_maximum
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*3
            
            ; call fclose() to close the file
            ; fclose(file_descriptor)
            
            push dword [file_descriptor]
            call [fclose]
            add esp, 4*2
    final:
        
        push    dword 0
        call    [exit]


