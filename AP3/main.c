// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Gustavo Guedes

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void liga_leds(uint8_t value);

int main(){
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	
	uint8_t n = 0x01;
	while(1){
		liga_leds(n);
		n=n<<1;
		SysTick_Wait1ms(250);
	}
	
}