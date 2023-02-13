section .text
    global _start

    _start:

        ; remember to pusha and popa before and after each call function
        call input

        mov eax, 4									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, msg
		mov edx, 10
		int 0x80									; make the interruption

        ;mov edx, 123
        ;mov [__num__], edx
        ;call output

        ; exit program
        mov eax,1
        mov ebx,0
        int 80h

    str_2_int:
        push ebp
        mov eax, 0
        mov [num1],eax
        mov ebx, 0                   ; contador 
                 
        loop_str_2_int:
            mov edx,[msg + ebx*2]       ; pega o valor do ebx-esimo da string
            cmp edx,'\n'                ; compara se chegou ao final
            je fim_loop_str_2_int       ; se chegou ao final sai do loop
            mov eax,[num1]              ; eax = valor em num1
            imul eax,10                      ; eax *= 10
            sub edx,'0'                 ; edx -= '0'
            add eax,edx                 ; eax += edx
            mov [num1],eax              ; salva o valor num1 = eax
            add ebx,1                     ; incrementa contador
            jmp loop_str_2_int
        fim_loop_str_2_int:
        pop ebp
        ret

    input:
        push ebp
        mov eax, 3									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, msg
		mov edx, 10
		int 0x80									; make the interruption
        
        pop ebp
        ret

        pusha
        call str_2_int
        popa
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

    ; output ta chamando essa label int_2_str
    int_2_str:
        ; se eu retorno aqui ele da seg fault
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
    strnum db '123'
    __num__     dw 20754
    msg         dw '++++++++++++++++++++++' 
    num1        dw 888

section .bss

    ;msg resb 10
    result_int_str_reverse  resb 100
    result_int_str          resb 100
    result_int_str_size     resb 100
    __string__              resw 100
    __size__                resw 1