-> change {program} by your program name
```
nasm -f elf -o {program}.o {program}.asm
```

```
ld -m elf_i386 -o {program} {program}.o
```

if your OS is not 64bits, then use:
```
ld -o {program} {program}.o
```
