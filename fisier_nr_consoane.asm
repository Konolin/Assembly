
bits 32 

global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf
import exit msvcrt.dll  
import fopen msvcrt.dll  
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    konsoane db 'bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ',0

    lenstring equ $-konsoane
    
    nume_fisier db "x.txt", 0  ; Name der Datei
    mod_acces db "r", 0          ; Wie offnen wir die Datei
                                 ; r - fur lesen 
    len equ 700                ; Max von Chars gelesen                            
    text times (len+1) db 0      ; String wo die Datei gelesen wird
    descriptor_fis dd -1         ; Deskriptor der Datei
    format db '%s', 0  ;format string
    formatd db '%d ',0 ;format decimal Zahl

; our code starts here
segment code use32 class=code
    start:
        ; eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces     
        push dword nume_fisier
        call [fopen] ; wir stellen mod_acces und nume_fisier auf dem Stack, von rechts nach links eax=fopen('tema.txt','r') r-Read
        add esp, 4*2 ;freien der Parameter vom Stack

        cmp eax,0 
        je final ;hier probieren wir ob fopen funktioniert hat (eax!=0)
        
        mov [descriptor_fis], eax ;wir stellen in descriptor der Register eax,der eigentlich der descriptor enthalt
        
        ; eax = fread(text, 1, len, descriptor_fis)
        push dword [descriptor_fis] ;zeigt welchen File man offnen soll
        push dword len ;welche Lange aus dem File man lesen soll
        push dword 1 ;Nummer von Elemente
        push dword text ;hier werden wir die Chars stellen
        call [fread] ;wir stellen Parameter auf dem Stack von rechts nach links, sodass eax=fread(buffer,1,len,descriptor)
        add esp,4*4 ;freien der Parameter vom Stack; 4 per Doubleword
        ; eax=Anzahl von Char in File 
        
              
 
        mov ebx,0 ;anzahl konstanten wird hier gespeichert
        mov edi,0 ;wir benutzen das, um den file zu durchqueren
        mov edx,0 ;wir benutzen das, um den string zu durchqueren
        mov ecx,eax ;wir stellen in ecx die Anzahl Chars die in eax ist
        
        mov eax, 0 
        jecxz sfarsit ;wenn ecx=0, dann enden wir die Schleife
        loop_start:

            mov al,[text+edi] ;al wird Elemente aus dem File
            mov esi,0 ;esi wird mit 0 inizialisiert damit wir den String Konsonanten durchqueren
     
            while.:
             
                cmp esi,lenstring ;hier Testen wir ob wir alle Konsonanten durchgequert haben
                ja endwhile ;wenn esi grosser als lange des Strings ist, dann kommen wir heraus
                
                mov dl,[konsoane+esi] ; dl wird die Elemente aus den String
                cmp al,dl ;compare von char aus datei mit alle Konsonanten aus dem String
                jne not_consoana

                inc ebx ;Anzahl von Konsonanten
                
                not_consoana: ;wenn al un dl gleich sind, dann inkrementieren wir die Anzahl(ebx)
            
                inc esi ; wir gehen weiter im String
                jmp while.
                
                
        
        endwhile:
        inc edi ;wir gehen weiter im file
       
        loop loop_start
        sfarsit:
        
        
        ; fclose(descriptor_fis)
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4 ;schliesen des Files mit der descriptor=descriptor_fis
        
        ;popad

        push dword ebx
        push dword formatd
        call [printf]
        add esp,4*2 ;printen von ebx(Anzahl) und stellen der Parameter von rechts nach links
        
      final:
        
        ; exit(0)
        push    dword 0      
        call    [exit]       