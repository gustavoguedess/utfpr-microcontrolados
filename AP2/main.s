; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Gustavo Guedes
; 16/10/2022
; Este programa emula um cofre. Inicialmente encontra-se aberto, digita uma senha para fechar o cofre e salvar a senha
; quando é digitado a senha o cofre é aberto.


; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
		
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init
			
		IMPORT GPIO_Init
		IMPORT Listen_Keyboard

Start
	BL SysTick_Init
	BL GPIO_Init

; -------------------------------------------------------------------------------
; Função main()
MainLoop
	BL Listen_Keyboard
	; -- Codigo aqui
 	NOP 
	
	MOV R0,#100
	BL SysTick_Wait1ms
	
	B MainLoop                   ;Volta para o laço principal	
	NOP

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
