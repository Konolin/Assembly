bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
extern function
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll            
import scanf  msvcrt.dll

global zeichenkette1
global zeichenkette2
global zeichenkette3
global zeichenkette4

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    zeichenkette1 times 100 dd  0
    zeichenkette2 times 100 dd  0
    zeichenkette3 times 100 dd  0
    zeichenkette4 times 100 dd  0
    format db "%u",0
    nr dd 0
    message1 db "nr1= ", 0
    message2 db "nr2= ", 0
    message3 db "nr3= ", 0
    space dd " ", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;Erste Zeichenkette:Lesen
        mov esi, 0
        loop_1:
               
            push dword message1  ;ich drucke der Text 'nr1= '(ich schreibe nr1 weil die Zahl in der erste Zeichenkette gelegt werden soll)
            call [printf] 
            add esp, 4*1        ;ich gebe die Parameter auf dem Stack frei
                           
            push dword nr       ;ich lese eine Zahl in Variable nr
            push dword format
            call [scanf] 
            add esp,4*2 
            
           
            mov eax, [nr]       ;ich speichere den Wert von nr in eax ein
            cmp eax, 0 
            je final1            ;es endet wenn nr ist 0
            mov [zeichenkette1+esi],eax      ;wir speichern die Zahlen in der Zeichenkette
         
            add esi,4            ;wir addieren 4 weil 4 bytes
           
        loop loop_1
        final1:
        
        mov eax, esi ; ich speichere den Wert von der Register esi in eax
        
        ;Zweite Zeichenkette:Lesen
        mov esi, 0
        loop_2:   
            push dword message2  ;ich drucke der Text 'nr2= '(ich schreibe nr2 weil die Zahl in der zweite Zeichenkette gelegt werden soll)
            call [printf] 
            add esp, 4*1        ;ich gebe die Parameter auf dem Stack frei
                           
            push dword nr       ;ich lese eine Zahl in Variable nr
            push dword format
            call [scanf] 
            add esp,4*2 
            
           
            mov ebx, [nr]       ;ich speichere den Wert von nr in ebx ein
            cmp ebx, 0 
            je final2            ;es endet wenn nr ist 0
            mov [zeichenkette2+esi],ebx       ;wir speichern die Zahlen in der Zeichenkette
         
            add esi,4            ;wir addieren 4 weil 4 bytes
           
        loop loop_2
        final2:
        
        mov ebx, esi ; ich speichere den Wert von der Register esi in ebx
        
        mov esi, 0
        loop_3:
               
            push dword message3  ;ich drucke der Text 'nr3= '(ich schreibe nr3 weil die Zahl in der zweite Zeichenkette gelegt werden soll)
            call [printf] 
            add esp, 4*1        ;ich gebe die Parameter auf dem Stack frei
                           
            push dword nr       ;ich lese eine Zahl in Variable nr
            push dword format
            call [scanf] 
            add esp,4*2 
            
           
            mov ecx, [nr]       ;ich speichere den Wert von nr in ecx ein
            cmp ecx, 0 
            je final3            ;es endet wenn nr ist 0
            mov [zeichenkette3+esi],ecx      ;wir speichern die Zahlen in der Zeichenkette
         
            add esi,4            ;wir addieren 4 weil 4 bytes
           
        loop loop_3
        final3:
        
        mov ecx, esi ; ich speichere den Wert von der Register esi in ecx
        
        mov edi, 0
        mov esi, 0
        loop_start_1:
            mov edx,0  ;ich speichere 
            mov edx, [zeichenkette1+esi]   
            cmp edx, 0  
            je sfarsit1
            
            cmp eax, esi
            je final1_1
            mov edx, [zeichenkette1+esi]
            mov [zeichenkette4+edi], edx  
            
            add esi, 4
            add edi, 4
            
            
            
            final1_1:
            
        loop loop_start_1
        sfarsit1:
        
        mov esi, 0
        loop_start_2:
            mov edx,0
            mov edx, [zeichenkette2+esi]   
            cmp edx, 0
            je sfarsit2
            
            cmp ebx, esi
            je final2_1 
            
            mov edx, [zeichenkette2+esi]
            mov [zeichenkette4+edi], edx  
            
            add esi, 4
            add edi, 4
            
            final2_1:
            
        loop loop_start_2
        sfarsit2:
        
        
        mov esi, 0
        loop_start_3:
            mov edx,0
            mov edx, [zeichenkette3+esi]   
            cmp edx, 0
            je sfarsit3
            
            cmp ecx, esi
            je final3_1 
            
            mov edx, [zeichenkette3+esi]
            mov [zeichenkette4+edi], edx  
            
            add esi, 4
            add edi, 4
            
            final3_1:
            
        loop loop_start_3
        sfarsit3:
        
        mov eax, edi
        
        mov edi, 0
        loop_start_4:
            mov edx,0
            mov edx, [zeichenkette4+edi]   
            cmp edx, 0
            je sfarsit4
            
            cmp eax, edi
            je final4_1 
            
            push dword [zeichenkette4+edi]
            push dword format
            call [printf]
            add esp, 4
            add edi, 4
            
            push dword space 
            call [printf] 
            add esp, 4 
            
            final4_1:
            
        loop loop_start_4
        sfarsit4:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program