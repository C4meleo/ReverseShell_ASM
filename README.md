# ReverseShell_ASM

For launch the program :

-> nasm -f elf32 file.asm && ld -m elf_i386 -s -o file file.o && ./file
-> nc -lv 4444
