
#include<stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTH 1<<7

uint8_t passocompleto[4] = {0x08,0x04,0x02,0x01};
uint8_t meiopasso[8] = {0x08,0x0C,0x04,0x06,0x02,0x03,0x01,0x09};
uint32_t passo;

enum {
	MEIO_PASSO,
	PASSO_COMPLETO
} velocidade;

enum {
	HORARIO,
	ANTIHORARIO
} sentido;

void motor_passo_init(void) {
	//1. Ativa o Clock
	SYSCTL_RCGCGPIO_R |= (GPIO_PORTH);
	
	while( (SYSCTL_PRGPIO_R & GPIO_PORTH) != GPIO_PORTH ){};

	
	//2. Zera os AMSEL
	GPIO_PORTH_AHB_AMSEL_R = 0x00;
	
	//3. Limpar o PCTL
	GPIO_PORTH_AHB_PCTL_R = 0x00;
	
	//4. Setar o DIR (0 entrada, 1 saída)
	GPIO_PORTH_AHB_DIR_R = 0x0F;
	
	//5. Limpar os AFSEL
	GPIO_PORTH_AHB_AFSEL_R = 0x00;
	
	//6. Setar os DEN
	GPIO_PORTH_AHB_DEN_R = 0x0F;

	// Inicialmente desligado
	GPIO_PORTH_AHB_DATA_R = 0x00;
	
	passo = 0;
	velocidade = PASSO_COMPLETO;
	sentido = HORARIO;
}

void config_motor(uint8_t _sentido, uint8_t _velocidade) {
	sentido = _sentido; velocidade = _velocidade;
}

uint32_t get_passos_por_voltas(uint8_t voltas) {
	uint32_t tot_passos;
	if(velocidade==PASSO_COMPLETO)
		tot_passos = voltas*2048;
	if(velocidade==MEIO_PASSO)
		tot_passos = voltas*4096;
	return tot_passos;
}

void proximo_passo(void) {
	if(sentido == HORARIO) passo--;
	if(sentido == ANTIHORARIO) passo++;
	if(velocidade==PASSO_COMPLETO) 	passo = (passo+2048)%2048;
	if(velocidade==MEIO_PASSO)			passo = (passo+4096)%4096;
	
	if(velocidade==PASSO_COMPLETO)
		GPIO_PORTH_AHB_DATA_R = passocompleto[passo%4];
	if(velocidade==MEIO_PASSO)
		GPIO_PORTH_AHB_DATA_R = meiopasso[passo%8];
}

uint8_t get_parte(void) {
	uint8_t result = 0;
	if(velocidade == PASSO_COMPLETO)
			result = passo/256;
	if(velocidade == MEIO_PASSO)
			result = passo/512;
	return result;
}