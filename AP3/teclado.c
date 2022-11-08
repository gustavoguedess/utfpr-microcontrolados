
#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define VALOR_LINHA 	(*((volatile uint32_t *)0x20000020))
#define LINHA_SEL		 	(*((volatile uint32_t *)0x20000028))
#define VALOR_COLUNA 	(*((volatile uint32_t *)0x20000040))
#define TESTE			  	(*((volatile uint32_t *)0x20000060))	
#define TESTE2			  	(*((volatile uint32_t *)0x20000062))	
#define KEY_PRESSED  	(*((volatile uint32_t *)0x200000C0))

#define GPIO_PORTL 1<<10
#define GPIO_PORTM 1<<11

void SysTick_Wait1us(uint32_t delay);

uint8_t valores_teclado[4][4] = {
	{'1','2','3','A'},
	{'4','5','6','B'},
	{'7','8','9','C'},
	{'*','0','#','D'}
};

enum colunas{
	PRIMEIRA_COLUNA,
	SEGUNDA_COLUNA,
	TERCEIRA_COLUNA,
	QUARTA_COLUNA
};
enum linhas{
	PRIMEIRA_LINHA,
	SEGUNDA_LINHA,
	TERCEIRA_LINHA,
	QUARTA_LINHA
};

uint8_t last_key_pressed;

void teclado_init(void){
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTL|GPIO_PORTM);
	
	while( (SYSCTL_PRGPIO_R & (GPIO_PORTL|GPIO_PORTM) ) != (GPIO_PORTL|GPIO_PORTM) ){};
		
	//2. Zera os AMSEL
	GPIO_PORTL_AMSEL_R = 0x00;
	GPIO_PORTM_AMSEL_R = 0x00;
	
	//3. Limpar o PCTL
	GPIO_PORTL_PCTL_R = 0x00;
	GPIO_PORTM_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTL_DIR_R = 0x0F;
	GPIO_PORTM_DIR_R = 0x00;
	
	//5. Limpar os AFSEL
	GPIO_PORTL_AFSEL_R = 0x00;
	GPIO_PORTM_AFSEL_R = 0x00;
	
	//6. Setar os DEN
	GPIO_PORTL_DEN_R = 0x0F;
	GPIO_PORTM_DEN_R = 0xF0;
	
	//7. Set Pull Up
	GPIO_PORTM_PUR_R = 0xF0;
	
	last_key_pressed=0;
}

void desligar_colunas(void){
	GPIO_PORTL_DIR_R&=~0x0F;
	GPIO_PORTL_DATA_R|=0x0F;
}

void ligar_coluna(uint8_t col){
	desligar_colunas();
	
	GPIO_PORTL_DIR_R|=(1<<col);
	GPIO_PORTL_DATA_R&=~(1<<col);	
	VALOR_LINHA = GPIO_PORTL_DIR_R;
}


uint8_t check_tecla(void){
	uint8_t col, lin;
	uint8_t data;
	uint8_t pressed=0;
	
	for(col=PRIMEIRA_COLUNA; col<=QUARTA_COLUNA; col++){
		LINHA_SEL = col;
		ligar_coluna(col);
		SysTick_Wait1us(10);
		
		VALOR_COLUNA = GPIO_PORTM_DATA_R;
		data = (GPIO_PORTM_DATA_R>>4)&0x0F^0x0F;   //Lê a linha
		lin = (data==0)?0:__builtin_ctz(data); //log2 inteiro
		
		if(data!=0){
			pressed = valores_teclado[col][lin];
		}
	}	
	desligar_colunas();
	
	if(last_key_pressed!=pressed){
		last_key_pressed = pressed;
		KEY_PRESSED = pressed;
		return pressed;
	}
	KEY_PRESSED=0;
	return 0;	
}

uint8_t get_tecla(void){
	uint8_t tecla;
	while((tecla = check_tecla())==0){}
	return tecla;
}

uint8_t get_num(void){
	uint8_t tecla;
	do{
		tecla = get_tecla();
	}while(tecla<'0' && tecla>'9');
	tecla-='0';
	return tecla;
}
