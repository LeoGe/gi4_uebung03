.PHONY=all

all:
	nasm -f elf32 -g -F dwarf -l polynom.lst polynom.asm
	gcc -m32 -o polynom polynom.o	
	
	nasm -f elf32 -g -F dwarf -l mul_cmplx.lst mul_cmplx.asm
	gcc -m32 -o mul_cmplx mul_cmplx.o	

clean:
	rm -f polynom.o
