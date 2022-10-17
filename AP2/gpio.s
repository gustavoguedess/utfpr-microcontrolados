; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 16/10/2022

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
;Declarações EDU - Defines
; =====================
; Definições dos Registradores Gerais 

SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================

; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    	0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    	0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    	0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    	0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    	0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    	0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    	0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    	0x40060510
GPIO_PORTJ_AHB_DATA_R    	EQU    	0x400603FC
GPIO_PORTJ               	EQU    	0x00000100

; PORT K
GPIO_PORTK_LOCK_R    		EQU    	0x40061520
GPIO_PORTK_CR_R      		EQU    	0x40061524
GPIO_PORTK_AMSEL_R   		EQU    	0x40061528
GPIO_PORTK_PCTL_R    		EQU    	0x4006152C
GPIO_PORTK_DIR_R     		EQU    	0x40061400
GPIO_PORTK_AFSEL_R   		EQU    	0x40061420
GPIO_PORTK_DEN_R     		EQU    	0x4006151C
GPIO_PORTK_PUR_R     		EQU    	0x40061510
GPIO_PORTK_DATA_R    		EQU    	0x400613FC
GPIO_PORTK               	EQU    	0x00000200

; PORT L
GPIO_PORTL_LOCK_R    		EQU    	0x40062520
GPIO_PORTL_CR_R      		EQU    	0x40062524
GPIO_PORTL_AMSEL_R   		EQU    	0x40062528
GPIO_PORTL_PCTL_R    		EQU    	0x4006252C
GPIO_PORTL_DIR_R     		EQU    	0x40062400
GPIO_PORTL_AFSEL_R   		EQU    	0x40062420
GPIO_PORTL_DEN_R     		EQU    	0x4006251C
GPIO_PORTL_PUR_R     		EQU    	0x40062510
GPIO_PORTL_DATA_R    		EQU    	0x400623FC
GPIO_PORTL               	EQU    	0x00000400

; PORT M
GPIO_PORTM_LOCK_R    		EQU    	0x40063520
GPIO_PORTM_CR_R      		EQU    	0x40063524
GPIO_PORTM_AMSEL_R   		EQU    	0x40063528
GPIO_PORTM_PCTL_R    		EQU    	0x4006352C
GPIO_PORTM_DIR_R     		EQU    	0x40063400
GPIO_PORTM_AFSEL_R   		EQU    	0x40063420
GPIO_PORTM_DEN_R     		EQU    	0x4006351C
GPIO_PORTM_PUR_R     		EQU    	0x40063510
GPIO_PORTM_DATA_R    		EQU    	0x400633FC
GPIO_PORTM               	EQU    	0x00000800

TESTE						EQU	0x20000000
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		EXPORT GPIO_Init
		EXPORT Listen_Keyboard
		
		IMPORT 	SysTick_Wait1ms
			
;--------------------------------------------------------------------------------
; Função InicializaGPIO
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Inicializa os bits
; ****************************************

; 1. Ativa o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; e após isso verifica no PRGPIO se a porta está pronta para uso.
			LDR   R0, =SYSCTL_RCGCGPIO_R			;Carrega o endereço do registrador RCGCGPIO
			MOV   R1, #GPIO_PORTJ					;Seta o bit da porta J
			ORR   R1, #GPIO_PORTK					;Seta o bit da porta K
			ORR   R1, #GPIO_PORTL					;Seta o bit da porta L
			ORR   R1, #GPIO_PORTM					;Seta o bit da porta M
			STR   R1, [R0]							;Move para a memória os bits das portas no endereço do RCGCGPIO

			LDR   R0, =SYSCTL_PRGPIO_R				;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR   R2, [R0]							;Lê da memória o conteúdo do endereço do registrador
			TST   R1, R2							;ANDS de R1 com R2
			BEQ   EsperaGPIO						;Se o flag Z=1, volta para o laço. Senão continua executando
			
; 2. Limpa o AMSEL
			MOV   R1, #0x00
			LDR   R0, =GPIO_PORTK_AMSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTL_AMSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTM_AMSEL_R
			STR   R1, [R0]

; 3. Limpa PCTL
			MOV   R1, #0x00
			LDR   R0, =GPIO_PORTK_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTL_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTM_PCTL_R
			STR   R1, [R0]

; 4. DIR para 0 se for entrada, 1 se for saída

			LDR   R0, =GPIO_PORTK_DIR_R
			MOV   R1, #2_11111111				; 8 pinos do port K serão saída
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTL_DIR_R
			MOV   R1, #2_00000000				; pinos 0,1,2,3 (linhas teclado) são definidos como saída
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTM_DIR_R
			MOV   R1, #2_11110111				; pinos 0,1,2 do port M serão saídas
												; pinos 7 a 4 começam como alta impedância
			STR   R1, [R0]

; 5. Limpa os bits AFSEL
			MOV   R1, #0x00
			LDR   R0, =GPIO_PORTK_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTL_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTM_AFSEL_R
			STR   R1, [R0]
			
; 6. Seta os bits de DEN para habilitar I/O digital			
			LDR   R0, =GPIO_PORTJ_AHB_DEN_R
			MOV   R1, #2_0001					; ativa pino 0 do port J
			STR   R1, [R0]

			LDR   R0, =GPIO_PORTK_DEN_R
			MOV   R1, #2_11111111				; ativa 8 pinos do port K
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTL_DEN_R
			MOV   R1, #2_00001111				; ativa pinos 0 a 3 do port L
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTM_DEN_R
			MOV   R1, #2_11110111				; ativa pinos 0 a 2 e 4 a 7 do port M
			STR   R1, [R0]

; 7. Habilitar resistor de pull-up interno
			LDR   R0, =GPIO_PORTJ_AHB_PUR_R
			MOV   R1, #2_0001					; pino 0 do port J tem o USR_SW1
			STR   R1, [R0]

			LDR   R0, =GPIO_PORTL_PUR_R
			MOV   R1, #2_00001111				; pinos 4,5,6,7 do port M tem pull-up ativado
            STR   R1, [R0]
			
;retorno
			BX    LR


			
; ========================== TECLADO ==========================
; -------------------------------------------------------------------------------
; Função Listen_Keyboard
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R8
; Modifica: R9, R10,R11,R12
Listen_Keyboard
; *******************************************************************************
; Retorna Caractere selecionado do teclado 
; *******************************************************************************
	PUSH {LR}
	MOV R8,#0
	
	; Liga cada uma das colunas 0,1,2,3
	MOV R9,#0
next_column
	; Liga a coluna
	BL Turn_On_Column_Keyboard
	; Espera 1ms
	MOV R0,#1
	BL SysTick_Wait1ms
	; Pega caractere ativo
	BL Listen_Key
	
	; Incrementa a coluna e para o loop caso seja a coluna 4 ou maior
	ADD R9,#1
	CMP R9,#4
	BLT next_column
	
	; Desliga todas as colunas
	BL Turn_Off_Columns_Keyboard
	
	POP {LR}
	BX LR
	
; -------------------------------------------------------------------------------
; Função Turn_On_Column_Keyboard
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R9 <- coluna a ser ativada no teclado (0 a 3)
; Modifica: R10,R11,R12
Turn_On_Column_Keyboard
; *******************************************************************************
; Liga um coluna do teclado 
; *******************************************************************************
	MOV R10,#2_1
	LSL R10,R10,R9	; Máscara da coluna a ser ligada
	
	LDR R12,=GPIO_PORTM_DATA_R
	LDR R11,[R12]
	AND R11,#2_00001111 ; Desativa todas as linhas
	ORR R11,R10
	STR R11,[R12]
	BX LR
		
; -------------------------------------------------------------------------------
; Função Turn_Off_Columns_Keyboard
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R11,R12
Turn_Off_Columns_Keyboard
	LDR R12,=GPIO_PORTM_DATA_R
	LDR R11,[R12]
	AND R11,#2_00001111 ; Desativa todas as linhas
	STR R11,[R12] 

	BX LR

; -------------------------------------------------------------------------------
; Função Listen_Key
; Parâmetro de entrada: R9 <- coluna a ser ativada no teclado (0 a 3)
; Parâmetro de saída: R8 <- Caractere ativado, caso tenha
; Modifica: R11,R12
Listen_Key
; *******************************************************************************
; Liga um coluna do teclado 
; *******************************************************************************
	LDR R11,=GPIO_PORTL_DATA_R
	LDR R12,[R11]
	LDR R11,=TESTE
	STR R12,[R11,R9]
	NOP
	
	BX LR



;---------------------------------------------------------------------------------

    ALIGN                           ; garante que o fim da seção está alinhada 
	END                             ; fim do arquivo
