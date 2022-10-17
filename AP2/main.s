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
		IMPORT Listen_Keyboard

Start
	BL SysTick_Init
	BL GPIO_Init

; -------------------------------------------------------------------------------
; Fun��o main()
MainLoop
	BL Listen_Keyboard
	; -- Codigo aqui
 	NOP 
	
	MOV R0,#100
	BL SysTick_Wait1ms
	
	B MainLoop                   ;Volta para o la�o principal	
	NOP

    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo