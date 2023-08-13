bits 32

global start
extern exit
import exit msvcrt.dll

segment data use32 class=data
    s1 db 5, 2, 1, 17, 8, 3
    l equ $-s1
    s2 db 6, 2, 8, 1, 2, 5
    d times l db 0

segment code use32 class=code
    start:
        mov ecx, l
        mov esi, 0
        
        jecxz sfarsit 
        repeta:   
            mov al, [s1+esi]  ;wir speichern den Glied von s1 mit index esi in al
            mov bl, [s2+esi]  ;wir speichern den Glied von s1 mit index esi in bl
            
            cmp al, bl        ;Wir vergleichen die Elemente
            jle element_in_second_array  ;jump if lower equal
            
            element_in_first_array:
                mov [d+esi], al  ;wir speichern in d was in al ist
                inc esi          ;wir erhöhen esi
                jmp sfarsit_element_in_first_array   
                
            element_in_second_array:  
                mov [d+esi], bl  ;wir speichern in d was in bl ist
                inc esi          ;wir erhöhen esi
                
            sfarsit_element_in_first_array: 
        loop repeta
        sfarsit:  
        
        push    dword 0
        call    [exit]
