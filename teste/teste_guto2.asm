section .text
	global _start

    _start:     
        mov eax, 0
        push dword [num]
        call int_size
        mov [size], eax

    tst:
        pop eax

        push dword [size]
        push dword [num]
        call int_to_str

        mov eax, 4
        mov ebx, 1
        mov ecx, string
        mov edx, 6
        int 0x80									; make the interruption


    exit:
        mov ebx, 0									; error code 0
        mov eax, 1									; syscall to exit
        int 0x80									; make the interruption

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
        mov edi, string

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
    num     dd 20754

section .bss
    string    resb 100
    size     resb 1