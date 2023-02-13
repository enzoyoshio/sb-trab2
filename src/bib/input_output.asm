section .text
    global _start



    _start:

        ; remember to pusha and popa before and after each call function
        call input
        mov ebx, dword [__num1__]
        mov dword [num2], ebx

        call input
        mov ebx, dword [__num1__]
        mov dword [num3], ebx

        dbb:
        mov eax, dword [num2]
        mov eax, dword [num3]

        jmp exit

        pusha
        mov edx, dword [num2]
        mov dword [__num__], edx
        call output
        popa

        pusha
        mov edx, dword [num2]
        mov dword [__num__], edx
        call output
        popa
        
        
        ;call print

        mov edx, [num3]
        mov dword [__num__], edx
        call output

        mov edx, dword [num2]
        mov dword [__num__], edx
        call output


    exit:
        ; exit program
        mov eax,1
        mov ebx,0
        int 80h

    str_2_int:
        push ebp

        mov eax, 0
        mov dword [__num1__],eax
        mov ebx, 0                   ; contador
        mov edx,__string__
                 
        loop_str_2_int:
            
            mov ecx, dword [__size__]              ; ecx = *edx // in c lang
            cmp ecx,ebx
            je fim_loop_str_2_int       ; se chegou ao final sai do loop
            mov eax, dword [__num1__]              ; eax = valor em __num1__
            imul eax,10                 ; eax *= 10
            mov ecx,0
            mov cl, byte [edx]               ; ecx = *edx
            sub ecx,'0'                 ; edx -= '0'
            add eax,ecx                 ; eax += edx
            mov dword [__num1__],eax              ; salva o valor __num1__ = eax
            inc ebx                     ; incrementa contador
            inc edx                     ; passa pro proximo valor ?
            jmp loop_str_2_int
        fim_loop_str_2_int:
        pop ebp
        ret

    input:
        push ebp
        mov ebp, esp

        mov eax, 3									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, __string__
		mov edx, 10
		int 0x80									; make the interruption
        dec eax
        mov dword [__size__],eax
        
        pusha
        call str_2_int
        popa
        pop ebp
        ret

    ; _start ta chamando essa label output
    output:
        push ebp
        call int_2_str
        
        mov eax, 4									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, __string__
		mov edx, dword [__size__]
		int 0x80									; make the interruption
        pop ebp
        ret

    int_2_str:
        push ebp
        mov eax, 0
        push dword [__num__]
        call int_size
        mov dword [__size__], eax

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

        mov eax, dword [ebp+8]
        mov ecx, 10
        mov ebx, 0

    int_size_loop:
        xor edx, edx
        div ecx

        inc ebx
        cmp eax, 0
        jne int_size_loop  

    int_size_ret:
        mov eax, ebx
        pop ebp
        ret

    clear_loop:
        push ebp
        mov eax,20
        mov ebx,__string__

        loop_clear:
            mov [ebx], byte 0
            inc ebx
            dec eax
            cmp eax,0
            jne loop_clear
        pop ebp
        ret

    int_to_str:
        push ebp
        mov ebp, esp

        mov eax, dword [ebp+8]
        mov ebx, 0
        mov ebx, dword [ebp+12]
        mov edi, __string__
        
        pusha
        ;call clear_loop
        popa

        ;add edi, ebx
        ;mov [edi], byte 0
        ;mov edi, __string__
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
    strnum db '123'
    __num__     dd 20754
    msg         dw '++++++++++++++++++++++' 
    __num1__        dd 888
    num1 dw 10
    num2 dw 100
    num3 dw 100

section .bss

    ;__num__ resw 10
    ;msg resb 10
    result_int_str_reverse  resb 100
    result_int_str          resb 100
    result_int_str_size     resb 100
    __string__              resd 100
    __stringOut__           resd 100
    __size__                resd 2