bits 32 
global start        


extern exit, printf, scanf, fopen, fclose, fprintf, fread    
import exit msvcrt.dll    
import printf msvcrt.dll
import scanf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll


global start        

extern exit               
import exit msvcrt.dll    

segment data use32 class=data
    ; Number
    message db "Zahl= ", 0
    format_number db "%d", 0
    n dd 0
   
    ; Text from file
    file_name db "pruefung.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    len equ 250
    text times len db 0
    
    ; For printing
    wort times 50 db 0
    print_format db 10 ,"%s" , 0 ; 10 is to write on a new line

segment code use32 class=code
    number:
        ; Print message for reading
        push dword message
        call [printf]
        add esp, 4
        
        ;Read number
        push dword n
        push dword format_number
        call [scanf]
        add esp, 4*2
        ret
        
    open: ; Open file
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2
        mov [file_descriptor], eax
        ret
        
    read: ; Read file and put text in "text"
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        ret
        
    close: ; Close file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
    compare:
        mov eax, dword [n]
        mov ebx, [esp+4] ; we pushed ebx on the stack
        cmp al, bl
        jne notEqual ; if number of letters != n
        
        equal: ; Print the word
        push dword wort
        push dword print_format
        call [printf]
        add esp, 4*2
        
        notEqual:
        ret
        
    reset_wort: ; Reset variable "wort"
        mov ecx, [esp+4]
        jecxz resetDone
        mov bl, 0
        mov edi, wort
        reseting:
            mov [edi], bl ; fill spaces with 0
            inc edi
        loop reseting
        resetDone:
        ret
        
    start:
        ; Read number
        call number
        
        ; Read file
        call open
        mov eax, [file_descriptor]
        cmp eax, 0
        je fertig
        call read
        call close
        ; Read done
        
        ;------------------------------------------------
        ;Actual code starts here!!!
        mov ecx, dword len
        mov esi, 0 ; Points to letter in "text"
        mov edi, 0 ; Point to where to write the letter in "wort"
        mov eax, 0 ; Used to store next letter
        mov ebx, 0 ; Stores the length of "wort"
        jecxz fertig
        
        repeta:
            
            mov al, [text+esi] ; Move next letter in eax
            
            
            cmp eax, 0 ; If it is 0 jump to last compare (code is ending)
            je lastCompare ; When the text has ended
            
            cmp eax, 2eh
            je punkt_space ; If is a '.'
            cmp eax, 20h
            je punkt_space ; If is a ' '
            
            jmp buchstabe; If it not '0', ' ' nor '.', then add the letter to the word
            
            punkt_space:
                pushad
                push ebx ; length of the current word
                call compare ; compare length (current word VS target length)
                add esp, 4
                
                popad
                pushad ; pop and save again the registers
                
                push ebx
                call reset_wort ; reset 'wort'
                add esp, 4
                
                popad
                mov ebx, 0 ; reset count
                mov edi, 0 ; Reset the pointer to first letter of 'wort'
                
                jmp resume ; Resume
            
            
            buchstabe: ; If it is a letter (gross oder klein)
                mov [wort+edi], al
                inc ebx
                inc edi
            
            resume:
            inc esi
        loop repeta
        
        lastCompare:
            push ebx ; length of the current word
            call compare ; compare length (current word VS target length)
            add esp, 4
        
        fertig:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
