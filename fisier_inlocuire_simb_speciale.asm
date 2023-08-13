bits 32

global start
extern exit, fopen, fprintf, fclose
import exit msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll 

segment data use32 class=data
    file_name db "ana.txt", 0       ; name der Datei
    access_mode db "a", 0           ; a(Append) - Druckt den text am Ende der Datei
    file_descriptor dd -1           ; Variable fur den file descriptor
    text db "Ana, are 12 M$x pere...", 0   ; Anfangstext

segment code use32 class=code
    start:
        ; fopen() erstellt/ofnet eine Datei
        ; fopen() gibt den file_descriptor in EAX oder 0 wenn ein Error stattgefunden hat
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2                ; freit den Stack
        mov [file_descriptor], eax  ; speichert den file_descriptor der von fopen gegeben wurde
        cmp eax, 0                  ; uberpruft ob fopen() die Datei erfolglich erstellt hat (eax != 0)
        je final
        
        mov esi, text               ; Pointer zur Text
        mov edi, text               ; Destinationpointer
        mov ecx, -1                 ; Initialisierung der Schleife
        
        replace_loop:
            inc ecx                 ; ecx++
            mov al, [esi+ecx]       ; ein Element von dem Text wird in al gebracht
            
            ; man uberpruft ob al eine kleine Buckstabe ist
            cmp al, 'a'             
            jb not_lower
            cmp al, 'z'
            ja not_lower
            jmp not_special
        
        
        ; man uberpruft ob al eine grosse Buckstabe ist        
        not_lower:
            cmp al, 'A'            
            jb not_upper
            cmp al, 'Z'
            ja not_upper
            jmp not_special
            
        
        ; man uberpruft ob al eine Ziffer ist
        not_upper:
            cmp al, '0'
            jb special
            cmp al, '9'
            ja special
            jmp not_special
        
        
        special:
            ; man uberpruft ob al kein Leerstelle ist
            cmp al, ' '
            je not_special
            mov [edi+ecx], byte 'X'
        
        
        ; Kleinbuchstaben, Großbuchstaben, Ziffern
        not_special:
            cmp al, 0               ; uberpruft of der String nicht am Ende ist
            jne replace_loop        ; beginnt wieder am replace_loop
            jmp write_file          ; Ende der Schleife, geht zum Schreiben des Textes in der Datei
        
        
        
        write_file:
            mov [edi+ecx], byte ''  ; ohne das, wird ein X am Ende der Datei gedruckt
        
            ; schreibt den Text in der Datei mit fprintf()
            push dword text
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4*2
            ; call fclose() to close the file
            push dword [file_descriptor]
            call [fclose]
            add esp, 4

        
        
        final:
    
        ; exit(0)
        push    dword 0 
        call    [exit]
