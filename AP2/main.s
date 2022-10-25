; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 16/10/2022
; Este programa emula um cofre. Inicialmente encontra-se aberto, digita uma senha para fechar o cofre e salvar a senha
; quando � digitado a senha o cofre � aberto.


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2



; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
		
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init
			
		IMPORT GPIO_Init
		IMPORT Data_Init
		IMPORT Display_Init
		IMPORT Listen_Keyboard
		IMPORT Write_Input
		IMPORT Check_Confirm
		IMPORT Update_Display
		IMPORT Pisca_Led
Start
	BL SysTick_Init
	BL GPIO_Init
	BL Data_Init
	BL Display_Init

; -------------------------------------------------------------------------------
; Fun��o main()
MainLoop
	; Retorna o caractere lido em R8. 
	BL Listen_Keyboard 
	
	; Escreve o caractere no Input, se houver algum bot�o pressionado
	BL Write_Input
	
	; Checa se foi pressionado o bot�o #
	BL Check_Confirm
	
	; Atualiza o display com o testo
	BL Update_Display
 	
	BL Pisca_Led 
	
	MOV R0,#1
	BL SysTick_Wait1ms
	
	B MainLoop                   ;Volta para o la�o principal	
	NOP

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
