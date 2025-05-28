.section .data
msg:
    .asciz "42\n"

.section .text
.globl _start
_start:
    mov $1, %rax        # syscall: write
    mov $1, %rdi        # file descriptor: stdout
    lea msg(%rip), %rsi # message address
    mov $3, %rdx        # length
    syscall

    mov $60, %rax       # syscall: exit
    xor %rdi, %rdi      # status 0
    syscall

