section .text
	global _start

    _start:
        push dword num
        call str_len

        mov [len], esi
        call str_2_int
        
    exit:
        mov ebx, 0									; error code 0
        mov eax, 1									; syscall to exit
        int 0x80									; make the interruption

    str_2_int:
        push ebp
        mov ebp, esp

        mov ecx, 0
        mov ebx, 0

    str_2_int_loop:
        mov eax, 0
        mov al, byte [num+ebx]
        sub al, '0'

        mov edi, esi
        sub edi, 1
        dec esi
    pow:
        cmp edi, 0
        je one
        jmp exp
        one: imul eax, byte 1
            jmp str_2_int_c
        exp: imul eax, byte 10
        dec edi
        cmp edi, 0
        jg pow

    str_2_int_c:
        add ecx, eax
        inc ebx
        cmp esi, 0
        jg str_2_int_loop


    str_2_int_ret:
        pop ebp
        ret
    
    str_len:
        push ebp
        mov ebp, esp

        mov eax, [ebp+8]
        mov edi, eax

        mov esi, 0

    str_len_loop:
        ; add esi, 3
        mov eax, [edi+esi]
        mov [char], eax

        inc esi                                     ; incrementing
        cmp [char], byte 0                                 ; compare
        jne str_len_loop
    
    str_len_ret:
        sub esi, 1
        pop ebp
        ret

section .data
    num     db '20754',0

section .bss
    char    resb 1
    len     resb 1