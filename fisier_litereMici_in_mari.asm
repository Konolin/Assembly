bits 32

global start
extern exit, fopen, fclose, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll

segment data use32 class=data
    file_name db "Ergebniss L4.txt", 0
    access_mode db "w", 0
    file_descriptor dd -1
    text db "The number 1 person in the world, besides ME, is +- Mihai Viteazu!!! Math is awesome 2^5=32 #mathrules", 0
    
segment code use32 class=code
    start:
        mov ecx, text
        call toUpper
        call file_print
        
    toUpper:            ;Function um die Kleinbuchstaben in Grossbuchstaben zu umwandeln
        mov al, [ecx]   ;al = eine buchstabe, ecx ist ein index fur unser text
        cmp al, 0X0     ;prufen ob al den null terminating zeichen ist
        je file_print
        cmp al, 'a'     ;prufen ob al(die Buchstabe) zwischen a und z ist
        jb next
        cmp al, 'z'
        ja next
        sub al, 0X20    ;wir wandeln die Kleinbuchstaben in Grossbuchstaben um
        mov [ecx], al   ;wir speichern die neue buchstabe zuruck zum text
        
    next:
        inc ecx         ;inc die index
        jmp toUpper
        
        
    file_print:
        push dword access_mode      ;wir benutzen w mode, weil wir ein neuen Datei erstellen, und im ihn schrieben, wollen
        push dword file_name        ;wir namen unser datei
        call [fopen]                ; wir erstellen unser datei und es offnen
        add esp, 4*2                ;loschen den stack
        mov [file_descriptor], eax  ;speichern die file descriptor die wir bekommen haben
        cmp eax, 0                  ;wir prufen, dass die Datei erstellt wurde
        je final
        push dword text             ;wir speichern unser text im Stack
        push dword [file_descriptor];wir speichern unser Datei adresse im Stack
        call [fprintf]              ;wir schreiben unser text in der Datei
        add esp, 4*2                ;loschen stack
        push dword [file_descriptor];wir speichern unser Datei adresse im Stack
        call [fclose]               ;wir schliessen unser Datei
        add esp, 4                  ;loschen Stack
        final :
        
        push    dword 0
        call    [exit]
