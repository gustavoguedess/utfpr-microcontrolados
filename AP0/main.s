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
	
	LDR R0,=RAM_POS_INPUT
	LDR R1,=INPUT
	LDR R2,=INPUT_SIZE
	
saving
	SUB R2,#1
	CMP R2,#0
	BMI primes ;Se é negativo
	
	LDRB R3,[R1],#1
	STRB R3,[R0],#1
	B saving

primes
	;Fazer os primos aqui [Franziska]
	MOV R10,R0
	
; *****************************************
; * 			Bubblesort				  *
; *****************************************
	LDR R5,=RAM_POS_INPUT	;PRIMEIRO PRIMO    --TROCAR QUANDO FILTRAR OS PRIMOS
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