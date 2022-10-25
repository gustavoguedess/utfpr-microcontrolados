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
; Função main()
MainLoop
	; Retorna o caractere lido em R8. 
	BL Listen_Keyboard 
	
	; Escreve o caractere no Input, se houver algum botão pressionado
	BL Write_Input
	
	; Checa se foi pressionado o botão #
	BL Check_Confirm
	
	; Atualiza o display com o testo
	BL Update_Display
 	
	BL Pisca_Led 
	
	MOV R0,#1
	BL SysTick_Wait1ms
	
	B MainLoop                   ;Volta para o laço principal	
	NOP

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
