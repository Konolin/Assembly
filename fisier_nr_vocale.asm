bits 32

global start
extern exit, printf, fopen, fclose, fread
import exit msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll

segment data use32 class=data
    file_name db "datei.txt", 0 ; zu lesen Dateiname
    acces_mode db "r", 0 ; r - öffnet eine Datei zum Einlesen
    file_descriptor dd -1 ; Variable zur Aufnahme des Dateiskriptors
    len equ 100 ; maximale Anzahl der zu lesenden Zeichen
    text times (len + 1) db 0 ; String für den Text, der aus der Datei gelesen wird
    format db "We've read %d vowels from file.", 0
    
segment code use32 class=code
    start:     
        push dword acces_mode
        push dword file_name
        call [fopen] ; fopen() gibt einen Dateideskriptor im EAX oder 0 im Fehlerfall zurück
        add esp, 4 * 2 ; den Stapel bereinigen
        
        mov [file_descriptor], eax ; den von fopen zurückgegebenen Dateideskriptor speichern
        
        cmp eax, 0 ; Überprüfung, ob fopen() die Datei erfolgreich erstellt hat
        je final
        
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread] ; nach dem Aufruf von fread() enthält EAX die Anzahl der gelesenen Zeichen
        add esp, 4 * 4 ; den Stapel bereinigen
        
        mov esi, 0
        mov ecx, eax ; wir setzen Anzahl der gelesenen Zeichen in ECX, um die Schleife zu machen
        mov ebx, 0

        ; alle Zeichen werden anhand des ASCII-Codes auf Vokalzeichen geprüft
        vowel_verification:
            jecxz vowel_verification_end
            mov al, [text + esi]
            inc esi
            cmp al, 97
            je vowel_counter
            cmp al, 101
            je vowel_counter
            cmp al, 105
            je vowel_counter
            cmp al, 111
            je vowel_counter
            cmp al, 117
            je vowel_counter
            loop vowel_verification
            jmp vowel_verification_end
        
        vowel_counter:
            inc ebx ; die Anzahl der Vokalen word in ebx gespeichert
            loop vowel_verification
        
        vowel_verification_end:
        
            ; die Anzahl der gelesenen Vokale und den Text anzeigen
            push dword text
            push dword ebx
            push dword format
            call [printf]
            add esp, 4 * 3 ; den Stapel bereinigen
            
            push dword [file_descriptor]
            call [fclose] ; Aufruf von fclose() zum Schließen der Datei
            add esp, 4 ; den Stapel bereinigen
        
        final:
    
        push    dword 0 
        call    [exit]