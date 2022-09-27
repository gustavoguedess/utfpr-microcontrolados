; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 25/09/2022

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================

; Defini��es dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; DISPLAY-7
; PORT Q
GPIO_PORTQ_LOCK_R    	    EQU    0x40066520
GPIO_PORTQ_CR_R      	    EQU    0x40066524
GPIO_PORTQ_AMSEL_R   	    EQU    0x40066528
GPIO_PORTQ_PCTL_R    	    EQU    0x4006652C
GPIO_PORTQ_DIR_R     	    EQU    0x40066400
GPIO_PORTQ_AFSEL_R   	    EQU    0x40066420
GPIO_PORTQ_DEN_R     	    EQU    0x4006651C
GPIO_PORTQ_PUR_R     	    EQU    0x40066510	
GPIO_PORTQ_DATA_R    	    EQU    0x400663FC
GPIO_PORTQ               	EQU    2_100000000000000
; PORT A
GPIO_PORTA_LOCK_R    	    EQU    0x40058520
GPIO_PORTA_CR_R      	    EQU    0x40058524
GPIO_PORTA_AMSEL_R   	    EQU    0x40058528
GPIO_PORTA_PCTL_R    	    EQU    0x4005852C
GPIO_PORTA_DIR_R     	    EQU    0x40058400
GPIO_PORTA_AFSEL_R   	    EQU    0x40058420
GPIO_PORTA_DEN_R     	    EQU    0x4005851C
GPIO_PORTA_PUR_R     	    EQU    0x40058510	
GPIO_PORTA_DATA_R    	    EQU    0x400583FC
GPIO_PORTA               	EQU    2_000000000000001
; PORT B
GPIO_PORTB_LOCK_R    	    EQU    0x40059520
GPIO_PORTB_CR_R      	    EQU    0x40059524
GPIO_PORTB_AMSEL_R   	    EQU    0x40059528
GPIO_PORTB_PCTL_R    	    EQU    0x4005952C
GPIO_PORTB_DIR_R     	    EQU    0x40059400
GPIO_PORTB_AFSEL_R   	    EQU    0x40059420
GPIO_PORTB_DEN_R     	    EQU    0x4005951C
GPIO_PORTB_PUR_R     	    EQU    0x40059510	
GPIO_PORTB_DATA_R    	    EQU    0x400593FC
GPIO_PORTB               	EQU    2_000000000000010
; PORT P
GPIO_PORTP_LOCK_R    	    EQU    0x40065520
GPIO_PORTP_CR_R      	    EQU    0x40065524
GPIO_PORTP_AMSEL_R   	    EQU    0x40065528
GPIO_PORTP_PCTL_R    	    EQU    0x4006552C
GPIO_PORTP_DIR_R     	    EQU    0x40065400
GPIO_PORTP_AFSEL_R   	    EQU    0x40065420
GPIO_PORTP_DEN_R     	    EQU    0x4006551C
GPIO_PORTP_PUR_R     	    EQU    0x40065510	
GPIO_PORTP_DATA_R    	    EQU    0x400653FC
GPIO_PORTP               	EQU    2_010000000000000


CONTADOR					EQU		0x20000000
PASSOS						EQU		0x20000001
SINAL						EQU		0x20000002
POSICAO						EQU		0x20000003
PRESSIONADO					EQU		0x20000004



; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2
		
DIGITOS		DCB		2_00111111,2_00000110,2_01011011,2_01001111,2_01100110,2_01101101,2_01111101,2_00000111,2_01111111,2_01100111
SEQUENCIA	DCB		2_10000001,2_01000010,2_00100100,2_00011000,2_00011000,2_00100100,2_01000010,2_10000001
		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT Set_Display			; Permite chamar PortN_Output de outro arquivo
		EXPORT Iteracao		        ; Permite chamar PortJ_Input de outro arquivo
		EXPORT Incrementa	;
		EXPORT Init					;
		EXPORT Set_Leds			
		

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTJ                 ;Seta o bit da porta J
			ORR     R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
			ORR     R1, #GPIO_PORTA					;Seta o bit da porta A, fazendo com OR
			ORR     R1, #GPIO_PORTB					;Seta o bit da porta B, fazendo com OR
			ORR     R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTJ                 ;Seta os bits correspondentes �s portas para fazer a compara��o
			
			ORR     R2, #GPIO_PORTQ                 ;Seta o bit da porta Q, fazendo com OR
			ORR     R2, #GPIO_PORTA                 ;Seta o bit da porta A, fazendo com OR
			ORR     R2, #GPIO_PORTB                 ;Seta o bit da porta B, fazendo com OR
			ORR     R2, #GPIO_PORTP                 ;Seta o bit da porta P, fazendo com OR
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da mem�ria
			
            LDR     R0, =GPIO_PORTQ_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta Q
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta Q da mem�ria
            LDR     R0, =GPIO_PORTA_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta A
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta A da mem�ria
            LDR     R0, =GPIO_PORTB_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta B da mem�ria
            LDR     R0, =GPIO_PORTP_AMSEL_R		;Carrega o R0 com o endere�o do AMSEL para a porta P
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta P da mem�ria
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria
			
            LDR     R0, =GPIO_PORTQ_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta Q
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria
            LDR     R0, =GPIO_PORTA_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta A
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria
            LDR     R0, =GPIO_PORTB_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta F
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria
            LDR     R0, =GPIO_PORTP_PCTL_R      ;Carrega o R0 com o endere�o do PCTL para a porta F
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da mem�ria
; 4. DIR para 0 se for entrada, 1 se for sa�da
			; O certo era verificar os outros bits da PF para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria
			
            LDR     R0, =GPIO_PORTQ_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta Q
			MOV     R1, #2_00001111					;PQ0 & PQ1 & PQ2 & PQ3 para ligar uma barra do display-7
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTA_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta A
			MOV     R1, #2_11110000					;PQ4 & PQ5 & PQ6 & PQ7 para ligar uma barra do display-7
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTB_DIR_R			;Carrega o R0 com o endere�o do DIR para a porta B
			MOV     R1, #2_00110000					;PB5 & PB4 para resistor do display-7
            STR     R1, [R0]						;Guarda no registrador
            LDR     R0, =GPIO_PORTP_DIR_R			;
			MOV     R1, #2_00100000					;
            STR     R1, [R0]						;Guarda no registrador
			
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			
            LDR     R0, =GPIO_PORTQ_AFSEL_R     	;Carrega o endere�o do AFSEL da porta Q
            STR     R1, [R0]                        ;Escreve na porta
            LDR     R0, =GPIO_PORTA_AFSEL_R     	;Carrega o endere�o do AFSEL da porta A
            STR     R1, [R0]                        ;Escreve na porta
            LDR     R0, =GPIO_PORTB_AFSEL_R			;Carrega o endere�o do AFSEL da porta F
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTP_AFSEL_R			;Carrega o endere�o do AFSEL da porta P
            STR     R1, [R0]						;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
            LDR     R0, =GPIO_PORTQ_DEN_R				;Carrega o endere�o do DEN
			MOV     R1, #2_00001111                     ;Ativa os pinos PQ0 & PQ1 & PQ2 & PQ3 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
            LDR     R0, =GPIO_PORTA_DEN_R				;Carrega o endere�o do DEN
			MOV     R1, #2_11110000                     ;Ativa os pinos PQ4 & PQ5 & PQ6 & PQ7 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
            LDR     R0, =GPIO_PORTB_DEN_R				;Carrega o endere�o do DEN
            MOV     R1, #2_00110000                    	;Ativa os pinos PB5 e PB4 como I/O Digital
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital
            LDR     R0, =GPIO_PORTP_DEN_R				;Carrega o endere�o do DEN
            MOV     R1, #2_00100000                    	;
            STR     R1, [R0]							;Escreve no registrador da mem�ria funcionalidade digital
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
            
;retorno            
			BX      LR

; -------------------------------------------------------------------------------
; Fun��o Init
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Init
	LDR R1,=CONTADOR
	MOV R0,#0
	STRB R0,[R1]
	
	LDR R1,=PASSOS
	MOV R0,#1
	STRB R0,[R1]
	
	LDR R1,=SINAL
	MOV R0,#1
	STRB R0,[R1]
	
	LDR R1,=PRESSIONADO
	MOV R0,#0
	STRB R0,[R1]
	
	LDR R1,=POSICAO
	MOV R0,#0
	STRB R0,[R1]
	
	BX LR

; -------------------------------------------------------------------------------
; Fun��o PortB_Set_Display
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
Set_Leds
	PUSH {LR}
	BL Set_Off_Display
	POP {LR}
	
	LDR R1, =GPIO_PORTP_DATA_R
	MOV R0,#2_00100000
	STR R0,[R1]
	
	LDR R2,=SEQUENCIA
	LDR R1,=POSICAO
	LDRB R1,[R1]
	LDRB R0,[R2,R1] ;Coleta a sequencia de LEDS
	
	LDR R2,=GPIO_PORTA_DATA_R
	AND R1,R0,#2_11110000
	STR R1,[R2]
	LDR R2,=GPIO_PORTQ_DATA_R
	AND R1,R0,#2_00001111
	STR R1,[R2]	

	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Fun��o PortB_Set_Display
; Par�metro de entrada: R0 <-- qual display
; Par�metro de sa�da: N�o tem
Set_Display
	PUSH {LR}
	BL Set_Off_Leds
	POP {LR}


	;Ativa o display dado como entrada
	CMP R0,#0
	ITE EQ
		MOVEQ R1,#2_00100000	;Caso 0, seleciona o display à direita
		MOVNE R1,#2_00010000	;Caso 1, seleciona o display à esquerda
	LDR R2,=GPIO_PORTB_DATA_R
	STR R1, [R2]
	
	;Pega o dígito do Contador correspondente ao display
	LDR R2,=CONTADOR
	LDRB R1,[R2]		;Valor do Contador
	MOV R2,#10		;Divisor para pegar o dígito
	UDIV R3,R1,R2	;Divisor 
	CMP R0,#0		;Verifica qual dígito é
	ITE EQ
		MLSEQ R0,R2,R3,R1	;Caso 0, coloca o valor das unidades
		MOVNE R0,R3		;Caso 1, coloca o valor das dezenas
	
	;Pega a codificação do display
	PUSH {LR}
	BL Get_Display_Code
	POP {LR}
	
	;Insere a codificação no display
	LDR	R2, =GPIO_PORTA_DATA_R			    ;
	STR R0, [R2]                            ;
	LDR	R2, =GPIO_PORTQ_DATA_R			    ;
	STR R1, [R2]                            ;


	BX LR									;Retorno
; -------------------------------------------------------------------------------
; Fun��o Set_Off_Display
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Set_Off_Display
	;Desliga o Display
	MOV R1,#2_00000000
	LDR R2,=GPIO_PORTB_DATA_R
	STR R1, [R2]
	
	BX LR
; -------------------------------------------------------------------------------
; Fun��o Set_Off_Leds
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Set_Off_Leds
	;Desliga o Display
	MOV R1,#2_00000000
	LDR R2,=GPIO_PORTP_DATA_R
	STR R1, [R2]
	
	BX LR
; -------------------------------------------------------------------------------
; Fun��o Get_Display_Code
; Par�metro de entrada: R0 <-- número
; Par�metro de sa�da: R0 --> conversão para PA
;					  R1 --> conversão para PQ
Get_Display_Code
	LDR R3,=DIGITOS
	LDRB R2,[R3,R0]
	AND R0,R2,#2_11110000
	AND R1,R2,#2_00001111
	BX LR

; -------------------------------------------------------------------------------
; Fun��o Incrementa
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Incrementa
	LDR R3,=CONTADOR
	LDRB R0,[R3]
	LDR R2,=PASSOS
	LDRB R1,[R2]
	LDR R2,=SINAL
	LDRB R2,[R2]
	
	CMP R2,#1			;Se for positivo
	ITE EQ
		ADDEQ R0,R1
		SUBNE R0,R1
	
	CMP R0,#100			;Se CONTADOR for maior que 100, subtrai 100
	BLO Salvar_Quantidade
	CMP R2,#1
	ITE EQ
		SUBEQ R0,#100
		ADDNE R0,#100

Salvar_Quantidade
	STRB R0,[R3]			;Salva o número no CONTADOR
	
	LDR R3,=POSICAO
	LDRB R0,[R3]
	ADD R0,#1
	CMP R0,#8
	IT EQ
		MOVEQ R0,#0
	STRB R0,[R3]
	BX LR

; -------------------------------------------------------------------------------
; Fun��o Incrementa_Passo
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Incrementa_Passo
	LDR R1,=PASSOS
	LDRB R0,[R1]
	
	ADD R0,#1			;Incrementa o CONTADOR
	
	CMP R0,#10			;Verifica se é maior ou igual a 10
	IT HS
		MOVHS R0,#1 	;Reseta a quantidade de PASSOS
	STRB R0,[R1]			;Salva o número do PASSOS
	BX LR

; -------------------------------------------------------------------------------
; Fun��o Inverter_Passo
; Par�metro de entrada: Não tem
; Par�metro de sa�da: Não tem
Inverter_Passo
	LDR R1,=SINAL
	LDRB R0,[R1]
	
	RSB R0,#0			;NEG R0,#1				;INVERTER BIT
	
	STRB R0,[R1]			;Salva o número do PASSOS
	BX LR


; -------------------------------------------------------------------------------
; Fun��o Iteracao
; Par�metro de entrada: R0 --> o valor da leitura
; Par�metro de sa�da: Não tem
Iteracao
	PUSH {LR}
	BL PortJ_Input
	POP {LR}
	MOV R3,R0
	
	LDR R2,=PRESSIONADO
	LDRB R1,[R2]
	
	BIC R1,R3 				;Pega os botões que não estavam clicados e agora estão
	
Check_SW1
	ANDS R5,R1,#2_01		;Verifica se o SW1 foi clicado
	BEQ Check_SW2			;Se o botão 0 não foi pressionado

	PUSH {LR}
	BL Incrementa_Passo
	POP {LR}
	
Check_SW2
	ANDS R5,R1,#2_10		;Verifica se o SW2 foi clicado
	BEQ Salvar_Estado		;Se não foi pressionado

	PUSH {LR}
	BL Inverter_Passo
	POP {LR}
	
Salvar_Estado	
	STRB R3,[R2]				;Salva o estado atual
	
	BX LR
	
; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]	
	BX LR									;Retorno

;---------------------------------------------------------------------------------

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo