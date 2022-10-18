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

DEBUG_KEYBOARD_CHAR			EQU 	0x20000000
DEBUG_KEYBOARD_ROWS			EQU		0x20000020
	
modo_cofre					EQU		0x20000040
MODO_COFRE_ABERTO			EQU		0x00
MODO_COFRE_FECHADO			EQU		0x01
MODO_COFRE_ABRINDO			EQU		0x02

RS							EQU		2_001
RW							EQU		2_010
E							EQU		2_100
	
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
			
; Teclado ordem
KEYBOARD_CHARS			DCB		"123A456B789C*0#D",0
DISPLAY_COFRE_ABERTO	DCB		"Cofre aberto, digite nova senha para fechar o cofre",0
DISPLAY_COFRE_FECHADO	DCB		"Cofre fechando",0
DISPLAY_COFRE_ABRINDO	DCB		"Cofre abrindo",0
DISPLAY_COFRE_TRAVADO	DCB		"Cofre Travado",0

		EXPORT GPIO_Init
		EXPORT Data_Init
		EXPORT Listen_Keyboard
		EXPORT Update_Display
			
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Wait1us
			
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
			MOV   R1, #2_00001111				; pinos 0,1,2,3 (linhas teclado) são definidos como saída
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTM_DIR_R
			MOV   R1, #2_00000111				; pinos 0,1,2 do port M serão saídas
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

			LDR   R0, =GPIO_PORTM_PUR_R
			MOV   R1, #2_11110000				; pinos 4,5,6,7 do port M tem pull-up ativado
            STR   R1, [R0]
			
;retorno
			BX    LR


; -------------------------------------------------------------------------------
Data_Init
	LDR R12,=modo_cofre
	MOV R11,=MODO_COFRE_ABERTO
	STRB R11,[R12]
	
	BX LR
			
; ====================================== TECLADO ======================================

; -------------------------------------------------------------------------------
; Função Listen_Keyboard
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R8 <- Caractere pressionado, caso tenha
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
	BL SysTick_Wait1us
	; Pega caractere ativo
	BL Listen_Key
	
	; Incrementa a coluna e para o loop caso seja a coluna 4 ou maior
	ADD R9,#1
	CMP R9,#4
	BLT next_column
	
	; Desliga todas as colunas
	BL Turn_Off_Columns_Keyboard

	; --- DEBUG SHOW KEYBOARD CHAR ---
	LDR R12,=DEBUG_KEYBOARD_CHAR
	STRB R8,[R12]
	; --------------------------------
	
	POP {LR}
	BX LR
	
; -------------------------------------------------------------------------------
; Função Turn_On_Column_Keyboard
; Parâmetro de entrada: R9 <- coluna a ser ativada no teclado (0 a 3)
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Turn_On_Column_Keyboard
; *******************************************************************************
; Liga um coluna do teclado 
; *******************************************************************************
	MOV R10,#2_1
	LSL R10,R10,R9	; Máscara da coluna a ser ligada (0x10, 0x20, 0x40 ou 0x80)
	
	LDR R12,=GPIO_PORTL_DIR_R
	LDR R11,[R12]
	BIC R11,#0x0F
	ORR R11,R10
	STR R11,[R12]
	
	LDR R12,=GPIO_PORTL_DATA_R
	LDR R11,[R12] 	; Lê as portas que estão definidas
	ORR R11,#0x0F 	; Desativa todas as colunas do teclado setando com 1 
	BIC R11,R10		; Seta a coluna como 0 para ativar
	STR R11,[R12]
	BX LR
		
; -------------------------------------------------------------------------------
; Função Turn_Off_Columns_Keyboard
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R11,R12
Turn_Off_Columns_Keyboard
	LDR R12,=GPIO_PORTL_DATA_R
	LDR R11,[R12]
	ORR R11,#0x0F ; Desativa todas as linhas
	STR R11,[R12] 
	
	
	LDR R12,=GPIO_PORTL_DIR_R
	LDR R11,[R12]
	ORR R11,#0x0F ; Seta todas as colunas como 0 para mudar para direção de entrada
	STR R11,[R12] 

	BX LR

; -------------------------------------------------------------------------------
; Função Listen_Key
; Parâmetro de entrada: R9 <- coluna a ser ativada no teclado (0 a 3)
; Parâmetro de saída: R8 <- Caractere pressionado, caso tenha
; Modifica: R10,R11,R12
Listen_Key
; *******************************************************************************
; Liga um coluna do teclado 
; *******************************************************************************
	; Faz a leitura da linha
	LDR R12,=GPIO_PORTM_DATA_R
	LDR R11,[R12]
	
	; -- DEBUG write the row values --
	LDR R12,=DEBUG_KEYBOARD_ROWS
	STRB R11,[R12,R9]
	; --------------------------------
	
	; Posiciona o caractere inicial da linha
	LDR R12,=KEYBOARD_CHARS	
	MOV R10,#4 		; Quantidade de dígitos que tem cada coluna
	MUL R10,R10,R9 	; Quandos caracteres precisa pular
	ADD R12,R10		; Caractere que começa a linha
	
	LSR R11,#4 ; Desloca o dado lido 4 bits para a direita (0xE0-> 0x0E)
	
	MOV R10,#0
check_key
	LSRS R11,#1
	IT CC
		LDRCC R8,[R12,R10]
	ADD R10,#1
	CMP R10,#4
	BLT check_key
	
	
	BX LR
	

; ====================================== DISPLAY ======================================
Update_Display
	; TODO 
	
	BX LR


;---------------------------------------------------------------------------------
; Entrada: R9 <- comando
Send_Comand_LCD
	; TODO
	
	BX LR

;---------------------------------------------------------------------------------
Display_Init
	PUSH {LR}
	
	; Inicializar modo 2 linhas
	LDR R9,#0x38 
	BL Send_Comand_LCD
	MOV R0,#40
	BL SysTick_Wait1us
	
	; Autoincremento para a direita
	LDR R9,#0x06
	BL Send_Comand_LCD
	MOV R0,#40
	BL SysTick_Wait1us
	
	; Configurar o cursor
	LDR R9,#0x0E
	BL Send_Comand_LCD
	MOV R0,#40
	BL SysTick_Wait1us
	
	; Resetar display
	LDR R9,#0x01
	BL Send_Comand_LCD
	MOV R0,#2
	BL SysTick_Wait1ms
	
	POP {LR}
	BX LR


;---------------------------------------------------------------------------------



    ALIGN                           ; garante que o fim da seção está alinhada 
	END                             ; fim do arquivo
