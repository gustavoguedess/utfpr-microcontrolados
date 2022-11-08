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
	
GPIO_PORTJ_AHB_IS_R			EQU 	0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU 	0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU		0x4006040C
GPIO_PORTJ_AHB_IM_R 		EQU		0x40060410
GPIO_PORTJ_AHB_RIS_R		EQU		0x40060414
GPIO_PORTJ_AHB_ICR_R		EQU 	0x4006041C

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
	
; Interrupções
NVIC_EN1_R					EQU 	0xE000E104
NVIC_PRI12_R				EQU 	0xE000E430


DEBUG_KEYBOARD_CHAR			EQU 	0x20000000
DEBUG_KEYBOARD_ROWS			EQU		0x20000020
DEBUG_PRINT_CHAR			EQU		0x2000049E
	
message_offset				EQU		0x20000040
count_frozen_message		EQU		0x20000060
	
LAST_KEY_PRESSED			EQU		0x20000001

modo_cofre					EQU		0x200000A0
	
chances						EQU		0x20000002
block_leds					EQU		0x20000010
input						EQU		0x200000C0
password					EQU		0x20000120
	
MODO_COFRE_ABERTO			EQU		0x00
MODO_COFRE_FECHANDO			EQU		0x01
MODO_COFRE_FECHADO			EQU		0x02
MODO_COFRE_ABRINDO			EQU		0x03
MODO_COFRE_TRAVADO			EQU		0x04

RW							EQU		2_010
EN							EQU		2_100
	
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2
			
; Teclado ordem
KEYBOARD_CHARS			DCB		"123A456B789C*0#D",0
DISPLAY_COFRE_ABERTO	DCB		"    Cofre aberto, digite nova senha para fechar o cofre    ",0
DISPLAY_COFRE_FECHANDO	DCB		"Cofre fechando...  ",0
DISPLAY_COFRE_FECHADO	DCB		"   Cofre fechado   ",0
DISPLAY_COFRE_ABRINDO	DCB		"Cofre abrindo...   ",0
DISPLAY_COFRE_TRAVADO	DCB		" Cofre Travado  ",0
DISPLAY_COFRE_MASTER	DCB		" Senha Mestre...",0

MASTER_PASSWORD		DCB 		"1234#",0

TIME_FROZEN_MESSAGE			EQU		30
	
	
		EXPORT GPIO_Init
		EXPORT Data_Init
		EXPORT Display_Init
		EXPORT Listen_Keyboard
		EXPORT Write_Input
		EXPORT Check_Confirm
		EXPORT Update_Display
		EXPORT Pisca_Led
			
		EXPORT GPIOPortJ_Handler
			
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
			ORR   R1, #GPIO_PORTQ					;Seta o bit da porta Q, fazendo com OR
			ORR   R1, #GPIO_PORTA					;Seta o bit da porta A, fazendo com OR
			ORR   R1, #GPIO_PORTP					;Seta o bit da porta P, fazendo com OR
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
			LDR   R0, =GPIO_PORTQ_AMSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTA_AMSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTP_AMSEL_R
			STR   R1, [R0]

; 3. Limpa PCTL
			MOV   R1, #0x00
			LDR   R0, =GPIO_PORTK_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTL_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTM_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTQ_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTA_PCTL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTP_PCTL_R
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
			STR   R1, [R0]						; pinos 7 a 4 começam como alta impedância
			
			LDR   R0, =GPIO_PORTQ_DIR_R
			MOV   R1, #2_00001111				
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTA_DIR_R
			MOV   R1, #2_11110000				
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTP_DIR_R
			MOV   R1, #2_00100000				
			STR   R1, [R0]

; 5. Limpa os bits AFSEL
			MOV   R1, #0x00
			LDR   R0, =GPIO_PORTK_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTL_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTM_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTQ_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTA_AFSEL_R
			STR   R1, [R0]
			LDR   R0, =GPIO_PORTP_AFSEL_R
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
			
			LDR   R0, =GPIO_PORTQ_DEN_R
			MOV   R1, #2_00001111				; ativa pinos 0 a 2 e 4 a 7 do port M
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTA_DEN_R
			MOV   R1, #2_11110000				; ativa pinos 0 a 2 e 4 a 7 do port M
			STR   R1, [R0]
			
			LDR   R0, =GPIO_PORTP_DEN_R
			MOV   R1, #2_00100000				; ativa pinos 0 a 2 e 4 a 7 do port M
			STR   R1, [R0]

; 7. Habilitar resistor de pull-up interno
			LDR   R0, =GPIO_PORTJ_AHB_PUR_R
			MOV   R1, #2_0001					; pino 0 do port J tem o USR_SW1
			STR   R1, [R0]

			LDR   R0, =GPIO_PORTM_PUR_R
			MOV   R1, #2_11110000				; pinos 4,5,6,7 do port M tem pull-up ativado
            STR   R1, [R0]

; Interrupções
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #0x00
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AHB_IS_R
			MOV R1, #0x00
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AHB_IBE_R
			MOV R1, #0x00
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AHB_IEV_R
			MOV R1, #0x00
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AHB_ICR_R
			MOV R1, #0x01
			STR R1, [R0]
			
			LDR R0, =GPIO_PORTJ_AHB_IM_R
			MOV R1, #0x01
			STR R1, [R0]
			
			LDR R0, =NVIC_EN1_R
			MOV R1, #0x80000
			STR R1, [R0]
			
			LDR R0, =NVIC_PRI12_R
			MOV R1, #5
			LSL R1, #29
			STR R1, [R0]
;retorno
			BX    LR


; -------------------------------------------------------------------------------
; Função Data_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Data_Init
;=====================
; ****************************************
; Inicializa os dados
; ****************************************

	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_ABERTO
	STR R11,[R12]
	
	LDR R12,=message_offset
	MOV R11,#0
	STRB R11,[R12]
	
	LDR R12,=LAST_KEY_PRESSED
	MOV R11,#0
	STRB R11,[R12]
	
	LDR R12,=password
	MOV R11,#0
	STRB R11,[R12]
	LDR R12,=input
	MOV R11,#0
	STRB R11,[R12]
	
	LDR R12,=count_frozen_message
	LDR R11,=TIME_FROZEN_MESSAGE
	STRB R11,[R12]
	
	LDR R12,=block_leds
	MOV R11,#0
	STR R11,[R12]
	
	
	BX LR


	LTORG
;---------------------------------------------------------------------------------
; Função Display_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
Display_Init
;=====================
; ****************************************
; Inicializa o display
; ****************************************

	PUSH {LR}
	
	; Inicializar modo 2 linhas
	MOV R0,#0
	MOV R1,#0x38
	MOV R2,#40		;	Espera 40us
	BL execute_LCD
	
	; Autoincremento para a direita
	MOV R0,#0
	MOV R1,#0x06
	MOV R2,#40		;	Espera 40us
	BL execute_LCD
	
	; Configurar o cursor
	MOV R0,#0
	MOV R1,#0x0E
	MOV R2,#40		;	Espera 40us
	BL execute_LCD
	
	; Resetar display
	MOV R0,#0
	MOV R1,#0x01
	MOV R0,#2000	;	Espera 2000us (2ms)
	BL execute_LCD
	
	POP {LR}
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
	MOV R0,#10
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
	
	
	; Se ele for igual ao último valor passado, não foi tecla nova
	LDR R12,=LAST_KEY_PRESSED
	LDRB R11,[R12]
	CMP R11,R8
	ITE EQ
		MOVEQ R8,#0
		STRBNE R8,[R12]
	
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
		LDRBCC R8,[R12,R10]
	ADD R10,#1
	CMP R10,#4
	BLT check_key
	
	
	BX LR
	

; ====================================== DISPLAY ======================================
Update_Display
	PUSH {LR}	
	; Carrega em R12 o endereço da primeira letra da mensagem
	LDR R12,=message_offset
	LDRB R10,[R12]
	LDR R9,=modo_cofre
	LDR R9,[R9] ; Pega o endereço do modo do cofre
	ADD R9,R10
	BL Print_Text_LCD
	
decrement_count
	LDR R12,=count_frozen_message
	LDRB R11,[R12]
	
	; Decrementa, se chegar a zero, recomeça o timer
	SUB R11,#1
	CMP R11,#0
	IT MI ; Se for negativo recomeça
		LDRMI R11,=TIME_FROZEN_MESSAGE
	STRB R11,[R12]
	
	; Se o timer for diferente de zero, pula o incremento do offset
	CMP R11,#0
	BHI finish
	
increment_offset
	LDR R12,=message_offset
	LDRB R11,[R12]
	
	; Se achou o final, recomeça. caso contrário, incrementa.
	CMP R8,#1
	ITE EQ
		MOVEQ R11,#0
		ADDNE R11,#1
	STRB R11,[R12]
	
finish
	
	POP {LR}
	BX LR

;---------------------------------------------------------------------------------
; R9 <- Endereço do primeiro caractere
; R8 <- Caso tenha acabado o texto

Print_Text_LCD
	PUSH {LR, R10, R11, R12}
	
	; Coloca o cursor no início da primeira linha
	MOV R0,#0
	MOV R1,#0x80
	MOV R2,#40
	BL execute_LCD

	LDR R12,=DEBUG_PRINT_CHAR
	
	MOV R8,#0

	MOV R10,#0 ; Contador de caracteres
next_char
	MOV R0,#1
	LDRB R1,[R9,R10]
	MOV R2,#40
	
	STRB R1,[R12]
	; Se o caractere for vazio, seta o R8 e para
	CMP R1,#0
	IT EQ
		MOVEQ R8,#1
	BEQ finish_print
	
	BL execute_LCD
	
	ADD R10,#1
	CMP R10,#17
	BLT next_char
	
finish_print

	POP {LR, R10, R11, R12}
	BX LR

;---------------------------------------------------------------------------------
; Função execute_LCD
; Parâmetro de entrada: R0 <- RS para indicar se é comando (0) ou dado (1)
;						R1 <- comando/dado, 
;						R2 <- Tempo necessário para executar o comando em us
; Parâmetro de saída: Não tem
execute_LCD
; *******************************************************************************
; Executa o comando ou dado no LCD 
; *******************************************************************************

	PUSH {LR,R10,R11,R12}
	
	LDR R12,=GPIO_PORTM_DATA_R
	LDR R11,[R12] 	; 	Coleta configuração do display
	BIC R11,#2_111	;	Limpa configuração do display
	LDR R10,=EN
	ORR R11,R10		;	Ativa o enable
	ORR R11,R0		;	Seta o modo da instrução
	STR	R11,[R12]	;	Salva configuração
	
	MOV R0,#10
	BL SysTick_Wait1us	;	Espera 10us para a configuração
	
	LDR R12,=GPIO_PORTK_DATA_R
	STRB R1,[R12]
	
	MOV R0,R2
	BL SysTick_Wait1us	;	Espera o tempo suficiente para executar o comando
	
	LDR R12,=GPIO_PORTM_DATA_R
	LDR R11,[R12] 	; 	Coleta configuração do display
	BIC R11,#2_111	;	Limpa configuração do display
	STR	R11,[R12]	;	Salva configuração
	
	POP {LR,R10,R11,R12}
	BX LR


; -------------------------------------------------------------------------------
; Função Write_Input
; Parâmetro de entrada: R9 <- coluna a ser ativada no teclado (0 a 3)
; Parâmetro de saída: R8 <- Caractere pressionado, caso tenha
; Modifica: R10,R11,R12
Write_Input
; *******************************************************************************
; Escreve o caractere na senha 
; *******************************************************************************
	; Caso não tenha valor lido, pula
	CMP R8,#0
	BEQ finish_write_input
	
	
	LDR R12,=input
next_char_input
	LDRB R11,[R12],#1
	CMP R11,#0
	BNE next_char_input
	
	SUB R12,#1
	STRB R8,[R12],#1
	MOV R11,#0
	STRB R11,[R12]
	
finish_write_input
	
	BX LR

	LTORG
; -------------------------------------------------------------------------------
; Função Check_Confirm
; Parâmetro de entrada: R8 <- Caractere pressionado, caso tenha
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Check_Confirm
; *******************************************************************************
; Escreve o caractere na senha 
; *******************************************************************************
	PUSH {LR}
	
	LDR R12,=modo_cofre
	LDR R12,[R12]
	
	;	MODO FECHANDO
	LDR R11,=DISPLAY_COFRE_FECHANDO
	CMP R12,R11
	BLEQ Close_Cofre
	
	;	MODO ABRINDO
	LDR R11,=DISPLAY_COFRE_ABRINDO
	CMP R12,R11
	BLEQ Open_Cofre		

	
checar_enter
	; Caso não tenha valor lido, pula
	CMP R8,#0x23 ; Checa se é igual ao caractere #. Se for diferente sai.
	BNE finish_check_confirm
	
	; MODO ABERTO
	LDR R11,=DISPLAY_COFRE_ABERTO
	CMP R12,R11
	BLEQ Closing_Cofre
	
	; MODO FECHADO
	LDR R11,=DISPLAY_COFRE_FECHADO
	CMP R12,R11
	BLEQ Request_Open
	
	; MODO TRAVADO
	LDR R11,=DISPLAY_COFRE_MASTER
	CMP R12,R11
	BLEQ Request_Master_Open
	
reset_input
	; Recomeçando o offset
	LDR R12,=message_offset
	MOV R11,#0
	STRB R11,[R12]
	
	; Limpa input
	LDR R12,=input
	MOV R11,#0
	STRB R11,[R12]

finish_check_confirm

	POP {LR}
	BX LR


; -------------------------------------------------------------------------------
; Função Set_Password
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Set_Password
; *******************************************************************************
; Transfere a entrada para a senha
; *******************************************************************************
	PUSH {LR}

	;	Transfere a senha do input para password
	LDR R12,=input
	LDR R11,=password
	MOV R9,#0
next_char_set_password
	LDRB R10,[R12]
	STRB R10,[R11],#1
	STRB R9,[R12],#1
	
	CMP R10,#0x23 ; Se o caractere não for um #, ir pro próximo caractere
	BNE next_char_set_password
	
	POP {LR}
	BX LR 
	

; -------------------------------------------------------------------------------
; Função Request_Open
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Request_Open
; *******************************************************************************
; Checa se a senha está correta e abre o cofre caso afirmativo
; *******************************************************************************
	PUSH {LR}
	
	LDR R12,=input
	LDR R11,=password
	BL Cmp_Strings
	
	;Se tiver tudo igual, chamar função de abrir cofre
	CMP R8,#1
	BLEQ Opening_Cofre
	BEQ finish_request_open
	
	; Decrementa a chance 
decrease_chance
	LDR R12,=chances
	LDRB R11,[R12]
	SUB R11,#1
	STRB R11,[R12]
	
	;	Se não tiver mais chances, Travar Cofre
	CMP R11,#0
	BEQ Travar_Cofre
	
finish_request_open
	
	POP {LR}
	BX LR 

; -------------------------------------------------------------------------------
; Função Request_Master_Open
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Request_Master_Open
; *******************************************************************************
; Checa se a senha é a senha mestre e abre o cofre caso afirmativo
; *******************************************************************************
	PUSH {LR}
	
	; Compara se strings são iguais
	LDR R12,=input
	LDR R11,=MASTER_PASSWORD
	BL Cmp_Strings
	
	; Se a senha estiver certa R8=1, abre o cofre
	CMP R8,#1
	BLEQ Opening_Cofre	
	BLNE Travar_Cofre
	
	POP {LR}
	BX LR 

; -------------------------------------------------------------------------------
; Função Cmp_Strings
; Parâmetro de entrada: R11 - string1 , R12 - string2
; Parâmetro de saída: R8 (1 - se strings forem iguais, 0 caso contrário)
; Modifica: R9,R10
Cmp_Strings
; *******************************************************************************
; Compara Strings
; *******************************************************************************
	; Criar flag certo ou errado (1 - senha certa | 0 - senha errada)
	MOV R8,#1
next_char_request_open
	LDRB R10,[R12],#1
	LDRB R9,[R11],#1
	
	CMP R10,R9
	IT NE
		MOVNE R8,#0
	
	CMP R10,#0x23 ; Se o caractere não for um #, ir pro próximo caractere
	BNE next_char_request_open
	BX LR

; ========================== OPERAÇÕES COFRE ====================================

; -------------------------------------------------------------------------------
; Função Opening_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R11,R12
Opening_Cofre
; *******************************************************************************
; Abre o Cofre
; *******************************************************************************
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_ABRINDO
	STR R11,[R12]
	
	BX LR
; -------------------------------------------------------------------------------
; Função Open_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R0, R11,R12
Open_Cofre
; *******************************************************************************
; Abre o Cofre
; *******************************************************************************
	PUSH {LR}
	
	;	Esperar 5s
	MOV R0,#1000
	BL SysTick_Wait1ms
	;	Muda o modo
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_ABERTO
	STR R11,[R12]
	
	;	Desliga Leds
	MOV R11,#0x0000
	LDR R12,=block_leds
	STR R11,[R12]
	
	POP {LR}
	BX LR


; -------------------------------------------------------------------------------
; Função Closing_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R0,R11,R12
Closing_Cofre
; *******************************************************************************
; Fechando o Cofre
; *******************************************************************************
	PUSH {LR}
	
	;	Input -> Password
	BL Set_Password
	
	;	Esperar 1s
	MOV R0,#200
	BL SysTick_Wait1ms
	
	;	Muda para o modo de cofre FECHANDO
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_FECHANDO
	STR R11,[R12]
	
	;	Dar 3 chances para abrir o cofre
	LDR R12,=chances
	MOV R11,#3
	STRB R11,[R12]
	
	POP {LR}
	BX LR
	
; -------------------------------------------------------------------------------
; Função Close_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R0,R11,R12
Close_Cofre
; *******************************************************************************
; Fecha o Cofre
; *******************************************************************************
	PUSH {LR}
	
	;	Esperar 5s
	MOV R0,#1000
	BL SysTick_Wait1ms
	;	Muda o modo
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_FECHADO
	STR R11,[R12]
	
	POP {LR}
	BX LR
; -------------------------------------------------------------------------------
; Função Travar_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R11,R12
Travar_Cofre
; *******************************************************************************
; Trava o Cofre
; *******************************************************************************
	; Modo Travado
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_TRAVADO
	STR R11,[R12]
	
	;	Liga Leds
	MOV R11,#0xFFFF
	LDR R12,=block_leds
	STR R11,[R12]
	
	BX LR

; -------------------------------------------------------------------------------
; Função Master_Pass_Cofre
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R11,R12
Master_Pass_Cofre
; *******************************************************************************
; Trava o Cofre
; *******************************************************************************
	; MODE COFRE MASTER
	LDR R12,=modo_cofre
	LDR R11,=DISPLAY_COFRE_MASTER
	STR R11,[R12]
	
	; Limpa input
	LDR R12,=input
	MOV R11,#0
	STRB R11,[R12]
	
	BX LR
	
; ===================================== LED =====================================
; -------------------------------------------------------------------------------
; Função Liga_Led
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R10,R11,R12
Pisca_Led
; *******************************************************************************
; Pisca Led
; *******************************************************************************
	PUSH {LR}
	
	LDR R12,=GPIO_PORTP_DATA_R
	MOV R11,#2_00100000
	STRB R11,[R12]
	
	LDR R12,=block_leds
	LDR R10,[R12]
	
	LDR R12,=GPIO_PORTA_DATA_R
	MOV R11,#0xF0
	AND R11, R10
	STRB R11,[R12]
	LDR R12,=GPIO_PORTQ_DATA_R
	MOV R11,#0x0F
	AND R11,R10
	STRB R11,[R12]
	
	MOV R0,#5
	BL SysTick_Wait1ms
	
	;	Shift pra direita
	ROR R10,R10,#1
	LDR R12,=block_leds
	STR R10,[R12]
	
	POP {LR}
	BX LR
	

;---------------------------------------------------------------------------------

GPIOPortJ_Handler
	
	PUSH {LR}
	
	
	BL Master_Pass_Cofre

	; Possibilita interromper de novo
	LDR R0, =GPIO_PORTJ_AHB_ICR_R
	MOV R1, #0x01
	STR R1, [R0]
	
	POP {LR}
	BX LR



    ALIGN                           ; garante que o fim da seção está alinhada 
	END                             ; fim do arquivo
