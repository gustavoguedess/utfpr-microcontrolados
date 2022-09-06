; main.s
; Gustavo Guedes
; 04/09/2022
		
		THUMB
RAM_POS_INPUT	EQU 0x20000200
RAM_POS_PRIMES	EQU 0x20000300
		AREA DATA,ALIGN=2

		AREA |.text|,CODE,READONLY,ALIGN=2
INPUT		DCB	50,65,229,201,101,43,27,2,5,210,101,239,73,29,207,135,33,227,13,9
INPUT_SIZE 	EQU 20

		EXPORT Start
			
Start

Saving
	LDR R0,=RAM_POS_INPUT ;Endereço de entrada
	LDR R1,=INPUT
	LDR R2,=INPUT_SIZE
	
nextInput
	SUB R2,#1
	CMP R2,#0
	BMI SavingFim ;Se não tem mais item
	
	LDRB R3,[R1],#1
	STRB R3,[R0],#1
	B nextInput
SavingFim
	MOV R10,R0 ;Salva ultimo endereço no R10
	
; *****************************************
; * 		    Primos  				  *
; *****************************************

Primes

	; conferir a numeracao dos registradores
	LDR R1, =RAM_POS_INPUT ;Registrador read
	LDR R2, =RAM_POS_PRIMES ;Registrador write
	MOV R4, #0 ;comprimento da lista de primos
	MOV R0,R10 ;Endereço do último valor de entrada

TestaSePrimo
	CMP R0, R1
	BEQ FimPrimos ;Se posições forem iguais, fim da lista
	
	LDRB R12, [R1], #1 ;Coloca número a ser testado no registrador *R12*
	
	CMP R12, #1
	BEQ CopiaPrimo ;Se número igual a 1, copia o primo
	
	MOV R3, #2 ;Coloca primeiro divisor a ser testado no *R3*
Divisao
	CMP R12, R3
	BEQ CopiaPrimo ;se numero for igual ao divisor atual, copia 
	UDIV R11, R12, R3
	MLS R11, R11, R3, R12
	CMP R11, #0
	BEQ TestaSePrimo ;se resto da divisão = 0, passa para o próximo
	ADD R3, #1
	B Divisao
	
CopiaPrimo
	STRB R12, [R2], #1 ;copia número primo para a memória
	ADD R4, #1 ;atualiza lista de primos
	B TestaSePrimo

FimPrimos
	MOV R10,R2
; *****************************************
; * 			Bubblesort				  *
; *****************************************
	LDR R5,=RAM_POS_PRIMES	;PRIMEIRO PRIMO    --TROCAR QUANDO FILTRAR OS PRIMOS
	MOV R6,R10				;ULTIMO PRIMO	   --TROCAR QUANDO FILTRAR OS PRIMOS
	
Bubblesort
	CMP R5,R6 ; PRIMEIRO PRIMO < ULTIMO PRIMO?
	BHS finish
	
	MOV R0,R5
	SUB R6,#1
	
bubblecicle
	CMP R0,R6 ; PRIMO ATUAL < ULTIMO PRIMO?
	BHS Bubblesort
	LDRB R1,[R0]
	LDRB R2,[R0,#1]
	CMP R2,R1 ; PRIMO SEGUINTE < PRIMO ATUAL?
	ITT LO
		STRBLO R1,[R0,#1]
		STRBLO R2,[R0]
	ADD R0,#1
	B bubblecicle
	
finish	
	NOP

	ALIGN
	END