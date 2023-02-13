%: %.asm
	nasm -f elf -o $*.o $*.asm
	ld -m elf_i386 -o $* $*.o