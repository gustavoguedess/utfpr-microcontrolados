
#include<stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTJ 1<<8

void parar(void);

void botao_init(void) {
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTJ);
	
	while( (SYSCTL_PRGPIO_R & GPIO_PORTJ) != GPIO_PORTJ ){};

	
	//2. Zera os AMSEL
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	
	//3. Limpar o PCTL
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	
	//5. Limpar os AFSEL
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	
	//6. Setar os DEN
	GPIO_PORTJ_AHB_DEN_R = 0x01;
	
	//7. Pull up
	GPIO_PORTJ_AHB_PUR_R = 0x01;
		
	// Interrupções
	GPIO_PORTJ_AHB_IM_R = 0x00;
	GPIO_PORTJ_AHB_IS_R = 0x00;
	GPIO_PORTJ_AHB_IBE_R = 0x00;
	GPIO_PORTJ_AHB_IEV_R = 0x00;
	GPIO_PORTJ_AHB_ICR_R = 0x01;
	GPIO_PORTJ_AHB_IM_R = 0x01;
	
	NVIC_EN1_R = 0x80000;
	NVIC_PRI12_R = 5<<29;
}

void GPIOPortJ_Handler(void){
	parar();
	
	GPIO_PORTJ_AHB_ICR_R = 0x01;
}
