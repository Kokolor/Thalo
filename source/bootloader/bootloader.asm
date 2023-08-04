; https://github.com/mell-o-tron/OS-Reference/ Improved code.

[org 0x7c00]

kernel_location equ 0x1000

mov [boot_disk], dl

xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, kernel_location
mov dh, 2

mov ah, 0x02
mov al, dh
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, [boot_disk]
int 0x13

; mov ax, 0x4F02
; mov bx, 0x0118
; int 0x10

mov ah, 0x0
mov al, 0x3
int 0x10

code_seg equ gdt_code - gdt_start
data_seg equ gdt_data - gdt_start

cli
lgdt [gdt_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp code_seg:start_protected_mode

jmp $

boot_disk db 0

gdt_start:
	gdt_null:
		dd 0x0
		dd 0x0

	gdt_code:
		dw 0xffff
		dw 0x0
		db 0x0
		db 0b10011010
		db 0b11001111
		db 0x0

	gdt_data:
		dw 0xffff
		dw 0x0
		db 0x0
		db 0b10010010
		db 0b11001111
		db 0x0

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

[bits 32]
start_protected_mode:
	mov ax, data_seg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	jmp kernel_location

times 510-($-$$) db 0
dw 0xaa55
