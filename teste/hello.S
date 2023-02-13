section .text
global _start
str_2_int:
 push ebp
 mov eax, 0
 mov [__num1__],eax
 mov ebx, 0
 mov edx,__string__
 loop_str_2_int:
 mov ecx,[__size__]
 cmp ecx,ebx
 je fim_loop_str_2_int
 mov eax,[__num1__]
 imul eax,10
 mov ecx,0
 mov cl, byte [edx]
 sub ecx,'0'
 add eax,ecx
 mov [__num1__],eax
 inc ebx
 inc edx
 jmp loop_str_2_int
 fim_loop_str_2_int:
 pop ebp
 ret
 input:
 push ebp
 mov eax, 3
 mov ebx, 1
 mov ecx, __string__
 mov edx, 10
 int 0x80
 dec eax
 mov [__size__],eax
 pusha
 call str_2_int
 popa
 pop ebp
 ret
 input_c:
 mov eax, 3
 mov ebx, 1
 int 0x80
 ret
 input_s:
 mov eax, 3
 mov ebx, 1
 int 0x80
 ret
 output:
 push ebp
 call int_2_str
 mov eax, 4
 mov ebx, 1
 mov ecx, __string__
 mov edx, [__size__]
 int 0x80
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
 output_c:
 mov ebx, 1
 mov eax, 4
 int 0x80
 ret
 output_s:
 mov ebx, 1
 mov eax, 4
 int 0x80
 ret
 
_start:

mov eax,[num1]
mov [__num__], eax
call output

mov eax,1
mov ebx,0
int 0x80


section .bss
 __string__              resw 100
 __size__                resw 1
 hello resb 50 
section .data
 __report__ db 'Quantidade de Bytes lidos/escritos = '
 __num__     dw 20754
 msg         dw '++++++++++++++++++++++'
 __num1__        dw 888
    num1 dw 10
