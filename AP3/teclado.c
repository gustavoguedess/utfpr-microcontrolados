
#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTL 1<<10
#define GPIO_PORTM 1<<11

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

