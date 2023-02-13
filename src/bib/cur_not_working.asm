section .text
    global _start

    print:
        push ebp

        mov ecx, __readString__
        mov eax,0

        loop_print:

        pusha
        mov eax, 4									; syscall to read
		mov ebx, 1									; read to stdout
		mov edx, 1
		int 0x80									; make the interruption
        popa

        mov bl, byte [ecx]
        mov ebx,[__size__]
        cmp eax,ebx
        je exit
        inc eax
        inc ecx
        jmp loop_print

    exit:
        pop ebp
        ret

    _start:

        ; remember to pusha and popa before and after each call function
        
        call input
      

        ;call print
        
        ;call output

        ; exit program
        mov eax,1
        mov ebx,0
        int 80h

    str_2_int:
        push ebp
        ; zerando num1
        ; num1 = 0
        mov eax, 0
        mov [__num__],eax                   ; num = 0
        mov ebx, 0                          ; contador
        mov ecx,__readString__              ; ebp + 8 deve ter o inicio do coisa
                 
        loop_str_2_int:
            
            mov edx,[__size__]              ; edx = *ecx // in c lang
            cmp edx,ebx
            je fim_loop_str_2_int           ; se chegou ao final sai do loop
            mov eax,[__num__]               ; eax = valor em num1
            imul eax,10                     ; eax *= 10
            mov edx,0
            mov dl, byte [ecx]              ; edx = *ecx
            sub edx,'0'                     ; edx -= '0'
            add eax,edx                     ; eax += edx
            mov [__num__],eax               ; salva o valor num1 = eax
            inc ebx                         ; incrementa contador
            inc ecx                         ; passa pro proximo valor ?
            jmp loop_str_2_int
        fim_loop_str_2_int:
        pop ebp
        ret 

    input:
        push ebp

        mov eax, 3									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, __readString__
		mov edx, 10
		int 0x80									; make the interruption
        dec eax
        mov [__size__],eax

        ;call print
        ;pop ebp
        ;ret

        call str_2_int
        pop ebp
        ret 

    ; _start ta chamando essa label output
    output:
        ; se eu retorno aqui nao tem problema
        push ebp
        call int_2_str
        
        mov eax, 4									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, __string__
		mov edx, 10
		int 0x80									; make the interruption
        pop ebp
        ret

    int_2_str:
        push ebp
        mov eax, 0
        push dword [__num__]
        call int_size
        mov [__size__], eax

    tst:
        pop dword eax

        push dword [__size__]
        push dword [__num__]
        call int_to_str
        pop dword ebp
        pop dword ebp

        pop ebp
        ret
       
    int_size:
        push ebp
        mov ebp, esp

        mov eax, [ebp+8]
        mov cx, 10
        mov bx, 0

    int_size_loop:
        xor edx, edx
        div cx

        inc bx
        cmp eax, 0
        jne int_size_loop  

    int_size_ret:
        mov eax, ebx
        pop ebp
        ret

    int_to_str:
        push ebp
        mov ebp, esp

        mov eax, [ebp+8]
        mov bx, [ebp+12]
        mov edi, __string__

        mov [edi+5], byte 0
        sub ebx, 1

    int_to_str_loop:
        mov cx, 10
        xor edx, edx
        div cx

        add edx, '0'
        mov cl, dl
        mov [edi+ebx], cl

        dec bx
        cmp eax, 0
        jne int_to_str_loop  

    int_to_str_ret:
        pop ebp
        ret


section .data
    __num__             dw 888
    __readString__      dw '++++++++++++++++++' 

section .bss
    __string__              resw 100
    __size__                resw 1