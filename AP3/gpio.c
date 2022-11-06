

#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTQ 1<<14
#define GPIO_PORTA 1<<0
#define GPIO_PORTP 1<<13

void leds_init(void);

void GPIO_Init(void){
	SYSCTL_RCGCGPIO_R = (GPIO_PORTQ | GPIO_PORTA | GPIO_PORTP);
	leds_init();
}