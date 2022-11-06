
#include <stdint.h>
#include "C:\tm4c1294ncpdt.h"


void leds_init(void){
	//2. Zera os AMSEL
	GPIO_PORTQ_AMSEL_R = 0x00;
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTP_AMSEL_R = 0x00;
	
	//3. Limpar o PCTL
	GPIO_PORTQ_PCTL_R = 0x00;
	GPIO_PORTA_AHB_PCTL_R = 0x00;
	GPIO_PORTP_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTQ_DIR_R = 0x0F;
	GPIO_PORTA_AHB_DIR_R = 0xF0;
	GPIO_PORTP_DIR_R = (1<<5);
	
	//5. Limpar os AFSEL
	GPIO_PORTQ_AFSEL_R = 0x00;
	GPIO_PORTA_AHB_AFSEL_R = 0x00;
	GPIO_PORTP_AFSEL_R = 0x00;
	
	//6. Setar os DEN
	GPIO_PORTQ_DEN_R = 0x0F;
	GPIO_PORTA_AHB_DEN_R = 0xF0;
	GPIO_PORTP_DEN_R = (1<<5);
	
}

void liga_leds(uint8_t value){
	GPIO_PORTQ_DATA_R = value&0x0F;
	GPIO_PORTA_AHB_DATA_R = value&0xF0;
	GPIO_PORTP_DATA_R = 1<<5;
}

void desliga_leds(){
	GPIO_PORTQ_DATA_R = 0x00;
	GPIO_PORTA_AHB_DATA_R = 0x00;
	GPIO_PORTP_DATA_R = 0x00;
}