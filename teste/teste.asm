section .text
	global _start

	_start:
		mov eax, 3									; syscall to read
		mov ebx, 1									; read to stdout
		mov ecx, msg
		mov edx, 10
		int 0x80									; make the interruption

		mov edx, 10
		mov ecx, msg


		mov ebx, 1									; write to stdout
		mov eax, 4									; syscall to write
		int 0x80									; make the interruption

		mov ebx, 0									; error code 0
		mov eax, 1									; syscall to exit
		int 0x80									; make the interruption


section .bss
	msg		resb 10                  ; db -> define byte | 0xa -> \n
    response resb 1