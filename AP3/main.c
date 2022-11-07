// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Gustavo Guedes

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);
void GPIO_Init(void);
void liga_leds(uint8_t value);
void motor_passo_proximo_mov(void);
void set_velocidade(uint8_t veloc);


int main(){
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	
	uint16_t i;
	
	
	set_velocidade(0);
	for(i=0;i<4096;i++){
		motor_passo_proximo_mov();
		SysTick_Wait1ms(2);
	}
	
	set_velocidade(1);
	for(i=0;i<2048;i++){
		motor_passo_proximo_mov();
		SysTick_Wait1ms(2);
	}
	
	while(1){}
	
}