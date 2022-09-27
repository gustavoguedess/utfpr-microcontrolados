; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 25/09/2022
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED3 (PF4). Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  GPIO_Init
		IMPORT 	Init
        IMPORT  Set_Display
		IMPORT 	Set_Leds
		IMPORT 	Incrementa
		IMPORT 	Iteracao
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init

; -------------------------------------------------------------------------------
; Fun��o main()
Start  			
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL Init
	MOV R12,#0
	
MainLoop
	BL Iteracao
	
	MOV R0,#1
	BL Set_Display
	MOV R0,#1
	BL SysTick_Wait1ms
	
	MOV R0,#0
	BL Set_Display
	MOV R0,#1
	BL SysTick_Wait1ms
	
	BL Set_Leds
	MOV R0,#1
	BL SysTick_Wait1ms
	
	ADD R12,#1
	CMP R12,#50
	
	BLO MainLoop
	
	BL Incrementa
	MOV R12,#0
	
	
	
	B MainLoop                   ;Volta para o la�o principal	


    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
