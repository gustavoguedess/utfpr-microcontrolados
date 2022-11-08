
#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTL 1<<10
#define GPIO_PORTM 1<<11

uint8_t valores[4][4] = {
	{'1','2','3','A'},
	{'4','5','6','B'},
	{'7','8','9','C'},
	{'*','0','#','D'}
}

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

void teclado_init(void){
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTL|GPIO_PORTM);
	
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
}

void ligar_coluna(uint8_t col){
	GPIO_PORTL_DIR_R&=~(1<<col);
}
void desligar_coluna(void){
	GPIO_PORTL_DATA_R|=0x0F;
	GPIO_PORTL_DIR_R|=0x0F;
}
uint8_t get_tecla(void){
	uint8_t col;
	for(col=PRIMEIRA_COLUNA; col<=QUARTA_COLUNA; col++){
		ligar_coluna(col);
	}
	desligar_colunas();
}
