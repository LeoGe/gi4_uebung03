SECTION .data
	x DD 10
	ergebnis DD 0
	message DB "Ergebnis = %i", 10, 0
	array DD 5, 4, 3, 2, 1
	array_len DD 5*4
	
extern printf

;SECTION .bss
;	ergebnis: resd 1

SECTION .text
	global main
	global polynom_a
	global polynom_b
	global polynom_c

main:
	;call polynom_a
	;call polynom_b
	;call polynom_c
	call polynom_e

polynom_a:
	mov eax, 2
	imul eax
	mov ebx, 3
	imul ebx
	
	mov ebx, 2
	mov ecx, 4
	imul ebx, ecx 
	
	add eax, ebx
	add eax, -5 
	
	ret

polynom_b:
	mov eax, [x]
	imul eax
	mov ebx, 3
	imul ebx

	mov ebx, [x]
	mov ecx, 4
	imul ebx, ecx

	add eax, ebx
	add eax, -5

	mov [ergebnis], eax

	call print_ergebnis

	ret

polynom_c:
	; 0x000000210000000200000007
	; 0x210000000200000007000000
	mov eax, [x]
	imul eax
	mov ebx, [array]
	imul ebx

	mov ebx, [x]
	mov ecx, [array+4]
	imul ebx, ecx

	add eax, ebx
	add eax, [array+8]

	mov [ergebnis], eax

	call print_ergebnis

	ret

polynom_e:
	mov eax, [array]
	mov esi, 4

polynom_rec:
	cmp esi, [array_len]
	jl less
	mov [ergebnis], eax
	call print_ergebnis
	ret
less:
	imul eax, [x]
	add eax, [array+esi]
	add esi, 4
	call polynom_rec
	ret

print_ergebnis:
	mov eax, [ergebnis]
	push eax

	push message
	call printf
	add esp, 8
	ret
