bits 32

global start

extern exit, fopen, fclose, fread, printf, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll


segment data use 32 class=data
    file db "data.txt", 0
    file2 db "output.txt", 0
    len equ 100
    buffer times 100 db 0 
    s times 201 db 0
    mode db "r", 0 
    mode2 db "w", 0 
    descriptor dd -1
    descriptor2 dd -1
    nr_caractere dd 0
    format db "%s", 0
    
    
segment code use32 class=code
	start:
	push dword mode
	push dword file
	call [fopen]
	add esp, 4*2
	
	cmp eax, 0
	je final
	
	mov [descriptor], eax
	
	push dword [descriptor]
	push dword len
	push dword 1
	push dword buffer
	call [fread]
	add esp, 4*4
	
	cmp eax, 0
	je final
	
	mov [nr_caractere], eax
	
	mov esi, 0
	mov edi, 0
	
	while_build_s:
		cmp edi, [nr_caractere]
		je final
			
		mov al, [buffer + edi]
		mov [s + esi], al
			
		;Check if the character is alphanumeric
		;0-9 are before the letters in the ascii table
        
        cmp al, 32
        je alphaNumeric
        
		cmp al, '0'
		jl notAlphaNumeric
		cmp al, '9'
		jl alphaNumeric
			
		cmp al, 'A'
		jl notAlphaNumeric
		cmp al, 'Z'
		jl alphaNumeric
			
		cmp al, 'a'
		jl notAlphaNumeric
		cmp al, 'z'
		jl alphaNumeric
            
		notAlphaNumeric:
			inc esi
			mov [s + esi], al
			
			
		alphaNumeric:
		inc esi
		inc edi
		jmp while_build_s
	
	final:
	
	push dword [descriptor]
	call [fclose]
	add esp, 4
    
    ;push dword s
    ;push format
    ;call [printf]
	
    push dword mode2
    push dword file2
    call [fopen]
    add esp, 4*2 
    mov [descriptor2], eax 
    cmp eax, 0
    je final2 
    push dword s
    push dword format
    push dword [descriptor2]
    call [fprintf]
    add esp, 4*3
    push dword [descriptor2]
    call [fclose]
    add esp, 4
    final2:
    
	push dword 0
	call [exit]
