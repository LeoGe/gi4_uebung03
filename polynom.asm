SECTION .data
	x_b DD 3
	x DD 4
	ergebnis DD 0
	; message to print the result with printf
	message DB "Ergebnis = %i", 10, 0
	;array with koeffizient_len in byte
	koeffizient DD 33, 2, 7
	koeffizient_len DD 3*4
	
SECTION .text
	global main
	global polynom_a
	global polynom_b
	global polynom_c
	global polynom_d
	global polynom_e
	extern printf

main:
	call polynom_a
	call polynom_b
	call polynom_c
	call polynom_d
	call polynom_e

	;end program with exit code 0
	mov ebx, 0
	mov eax, 1
	int 0x80

polynom_a:
	; eax = 2^2
	mov eax, 2
	imul eax

	; coefficient
	mov ebx, 3

	; eax = eax * ebx
	imul ebx
	
	; ebx = 2^1
	mov ebx, 2

	; coefficient
	mov ecx, 4

	; eax = 4 * 2^1
	imul ebx, ecx 
	
	; eax = 3 * 2^2 + 4 * 2^1
	add eax, ebx

	; eax = 3 * 2^2 + 4 * 2^1 + (-5)
	add eax, -5 
	
	ret

polynom_b:
	; eax = x^2
	mov eax, [x_b]
	imul eax

	; coefficient
	mov ebx, 3

	; eax = 3 (ebx) * x^2
	imul ebx

	; ebx = 4 (ecx) * x (ebx)
	mov ebx, [x_b]
	mov ecx, 4
	imul ebx, ecx

	; eax = 3 * x^2 (eax) + 4*x (ebx)
	add eax, ebx

	; eax = 3 * x^2 + 4*x^1 (eax) + (-5)
	add eax, -5

	; save result in ergebnis
	mov [ergebnis], eax

	; print to console
	call print_ergebnis

	ret

polynom_c:
	; memorylayout:
	; 0x210000000200000007000000
	
	; ebx = x^2 * koeffizient[0]
	mov eax, [x]
	imul eax
	imul eax, [koeffizient]

	; ebx = x * koeffizient[1]
	mov ebx, [x]
	imul ebx, [koeffizient+4]

	; eax = x^2 * koeffizient[0] + x * koeffizient[1]
	add eax, ebx

	; eax = x^2 * koeffizient[0] + x * koeffizient[1] + koeffizient[2]
	add eax, [koeffizient+8]

	; save and print result
	mov [ergebnis], eax
	call print_ergebnis

	ret

; with Horner's method
; memory improvement:
; the whole algorithm uses only one register
; run time improvement:
; less multiplications (here just 2) and less additions (here 2)
; the Horner method needs only n additions and n multiplications, the naive algorithm at most (n^2+n)/2

polynom_d:
	; the innermost term
	; eax = x*koeffizient[0] + koeffizient[1]
	mov eax, [koeffizient]
	imul eax, [x]
	add eax, [koeffizient+4]

	; eax = (x*koeffizient[0] + koeffizient[1]) * x
	imul eax, [x]

	; eax = (x*koeffizient[0] + koeffizient[1]) * x + koeffizient[2]
 	add eax, [koeffizient+8]

	; save and print result
	mov [ergebnis], eax
	call print_ergebnis

	ret

; recursive horner scheme
polynom_e:
	; initialize coefficient and koeffizient index
	mov eax, [koeffizient]
	mov esi, 4

polynom_rec:
	; compare koeffizient index with koeffizient length, if esi smaller than the koeffizient length then jump to less
	cmp esi, [koeffizient_len]
	jl less

	; save and print the result
	mov [ergebnis], eax
	call print_ergebnis

	ret

less:
	; eax_n = x*eax_(n-1) + koeffizient[n]
	imul eax, [x]
	add eax, [koeffizient+esi]
	add esi, 4

	; recursive call
	call polynom_rec
	ret

; print result with printf
print_ergebnis:
	; push the result on the stack (second argument)
	mov eax, [ergebnis]
	push eax

	; push the message on the stack (first argument)
	push message

	; call to C
	call printf

	; reset stack pointer (length is 8 byte: message pointer (32bit) + result (32bit))
	add esp, 8

	ret
