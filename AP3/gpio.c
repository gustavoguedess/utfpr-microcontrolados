

#include <stdint.h>

#include "tm4c1294ncpdt.h"


void leds_init(void);
void motor_passo_init(void);

void GPIO_Init(void){
	SYSCTL_RCGCGPIO_R = 0x00;
	leds_init();
	motor_passo_init();
}