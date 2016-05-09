SECTION .text
	global main
	extern printf
	
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

	message DB "Ergebnis = %i + i* %i", 10, 0

main:
	
	;Real Result in eax	
	mov eax, [cmplx_1+cmplx.real]
	imul eax, [cmplx_2+cmplx.real]
	mov ebx, [cmplx_1+cmplx.imag]
	imul ebx, [cmplx_2+cmplx.imag]
	imul ebx, -1
	add eax, ebx

	;Imaginary Result in ebx
	mov ebx, [cmplx_1+cmplx.real]
	imul ebx, [cmplx_2+cmplx.imag]
	mov ecx, [cmplx_1+cmplx.imag]
	imul ecx, [cmplx_2+cmplx.real]
	add ebx, ecx
	
	;Print Result
	push ebx
	push eax
	push message
	call printf
	

	mov ebx, 0
	mov eax, 1
	int 0x80
