SECTION .text
	global main
	extern printf

; define struct cmplx and create two example instances	
SECTION .data
	STRUC cmplx
		.real RESD 1
		.imag RESD 1
	ENDSTRUC

	cmplx_1: ISTRUC cmplx
		DD 4
		DD 5
	IEND

	cmplx_2: ISTRUC cmplx
		DD 6
		DD 3
	IEND

	; message for printf to print our result
	message DB "Ergebnis = %i + i* %i", 10, 0

main:
	
	;Real Result in eax	
	mov eax, [cmplx_1+cmplx.real]
	imul eax, [cmplx_2+cmplx.real]
	mov ebx, [cmplx_1+cmplx.imag]
	imul ebx, [cmplx_2+cmplx.imag]
	; stay real 
	imul ebx, -1
	add eax, ebx

	;Imaginary Result in ebx
	mov ebx, [cmplx_1+cmplx.real]
	imul ebx, [cmplx_2+cmplx.imag]
	mov ecx, [cmplx_1+cmplx.imag]
	imul ecx, [cmplx_2+cmplx.real]
	add ebx, ecx
	
	;Print Result
	push ebx ; third argument (imaginary part)
	push eax ; second argument (real part)
	push message ; first argument (message)
	call printf ; call to C

	; exit
	mov ebx, 0
	mov eax, 1
	int 0x80
