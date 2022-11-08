#include <stdint.h>
#include "tm4c1294ncpdt.h"

#define GPIO_PORTN 1<<12
#define TIMER2 1<<2

uint8_t esta_girando(void);

void temporizador_init(void){
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTN);
	
	while( (SYSCTL_PRGPIO_R & (GPIO_PORTN) ) != (GPIO_PORTN) ){};
		
	//2. Zera os AMSEL
	GPIO_PORTN_AMSEL_R = 0x00;
		
	//3. Limpar o PCTL
	GPIO_PORTN_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTN_DIR_R = 0x02;
		
	//5. Limpar os AFSEL
	GPIO_PORTN_AFSEL_R = 0x00;
		
	//6. Setar os DEN
	GPIO_PORTN_DEN_R = 0x02;
	
	
		/* Temporizador */
	SYSCTL_RCGCTIMER_R |= TIMER2;
		
	while((SYSCTL_PRTIMER_R & (TIMER2) ) != (TIMER2) ){};
		
	TIMER2_CTL_R &= 0xFEFF; // coloca 0 no bit 8 (TBEN)
		
	TIMER2_CFG_R = 0x04;
	TIMER2_TBMR_R =0x2;
	TIMER2_TBILR_R  = 39999;
	TIMER2_TBPR_R = 100;

	TIMER2_IMR_R |= 1<<8;
	TIMER2_ICR_R |= 1<<8;
	NVIC_PRI6_R = 5 << 5;
	
	NVIC_EN0_R = 1 << 24;
	TIMER2_CTL_R |= 1<<8;
}

void Timer2B_Handler(void){
	TIMER2_ICR_R |= 1<<8;
	
	if(esta_girando())
		GPIO_PORTN_DATA_R^=0x02;
	else
		GPIO_PORTN_DATA_R&=~0x02;
}	