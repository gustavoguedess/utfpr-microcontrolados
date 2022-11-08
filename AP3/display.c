
#include <stdint.h>
#include "tm4c1294ncpdt.h"

#define GPIO_PORTM 1<<11
#define GPIO_PORTK 1<<9

void SysTick_Wait1us(uint32_t delay);


void execute_LCD(uint8_t rs, uint8_t comando, uint32_t tempo){
	// Enable command
	GPIO_PORTM_DATA_R&=~0x07; 
	GPIO_PORTM_DATA_R|=0x04;
	GPIO_PORTM_DATA_R|=rs;
	
	SysTick_Wait1us(10);
	
	// Send command
	GPIO_PORTK_DATA_R=comando;
	
	// Clear Config
	GPIO_PORTM_DATA_R&=~0x07;
	
	SysTick_Wait1us(tempo);
}

void print_lcd(uint8_t str[]){
	// Reseta Display
	execute_LCD(0,0x01,2000);
	// Set Cursor posição (0,0)
	execute_LCD(0, 0x80,40);
	
	uint32_t i;
	for(i=0; str[i]!='\0'; i++){
		execute_LCD(1,str[i],40);
	}
}

void display_init(void) {
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTM | GPIO_PORTK);
	
	while( (SYSCTL_PRGPIO_R & (GPIO_PORTM | GPIO_PORTK) ) != (GPIO_PORTM | GPIO_PORTK) ){};
		
	//2. Zera os AMSEL
	GPIO_PORTM_AMSEL_R = 0x00;
	GPIO_PORTK_AMSEL_R = 0x00;
		
	//3. Limpar o PCTL
	GPIO_PORTM_PCTL_R = 0x00;
	GPIO_PORTK_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTM_DIR_R |= 0x07;
	GPIO_PORTK_DIR_R = 0xFF;
	
	//5. Limpar os AFSEL
	GPIO_PORTM_AFSEL_R = 0x00;
	GPIO_PORTK_AFSEL_R = 0x00;
	
	//6. Setar os DEN
	GPIO_PORTM_DEN_R |= 0x07;
	GPIO_PORTK_DEN_R = 0xFF;
		
	
	// Modo 2 linhas
	execute_LCD(0,0x38,40);
	
	// Autoincremento para direita
	execute_LCD(0,0x06,40);
	
	// Configurar Cursor
	execute_LCD(0,0x0E,40);
	
	// Reseta Display
	execute_LCD(0,0x01,2000);
	
	print_lcd((uint8_t*)"testando");
}


