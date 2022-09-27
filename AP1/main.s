; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 25/09/2022
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED3 (PF4). Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  GPIO_Init
		IMPORT 	Init
        IMPORT  Set_Display
		IMPORT 	Set_Leds
		IMPORT 	Incrementa
		IMPORT 	Iteracao
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init

; -------------------------------------------------------------------------------
; Função main()
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
	
	
	
	B MainLoop                   ;Volta para o laço principal	
;	BL Incrementa_Contador
;	MOV R0,#500
;	BL SysTick_Wait1ms
	
;Verifica_Nenhuma
;	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave está pressionada
;	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
;	MOV R0, #0                   ;Não acender nenhum LED
;	BL PortF_Output			 	 ;Chamar a função para não acender nenhum LED
;	B MainLoop					 ;Se o teste viu que nenhuma chave está pressionada, volta para o laço principal
;Verifica_SW1	
;	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 está pressionada
;	BNE Verifica_SW2             ;Se o teste falhou, pula
;	MOV R0, #2_00010000			 ;Setar o parâmetro de entrada da função como o BIT4
;	BL PortF_Output				 ;Chamar a função para setar o LED3
;	B MainLoop                   ;Volta para o laço principal
;Verifica_SW2	
;	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 está pressionada
;	BNE Verifica_Ambas           ;Se o teste falhou, pula
;	MOV R0, #2_00000001			 ;Setar o parâmetro de entrada da função como o BIT0
;	BL PortF_Output				 ;Chamar a função para setar o LED4
;	B MainLoop                   ;Volta para o laço principal	
;Verifica_Ambas
;	CMP R0, #2_00000000			 ;Verifica se ambas as chaves estão pressionadas
;	BNE MainLoop          		 ;Se o teste falhou, pula
;	MOV R0, #2_00010001			 ;Setar o parâmetro de entrada da função como o BIT0
;                                 ;e o BIT4
	


    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
