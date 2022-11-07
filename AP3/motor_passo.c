
#include<stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTH 1<<7

uint8_t meiopasso[8] = {0x08,0x0C,0x04,0x06,0x02,0x03,0x01,0x09};
uint8_t passocompleto[8] = {0x08,0x04,0x02,0x01,0x08,0x04,0x02,0x01};
int8_t estado;

enum {
	MEIO_PASSO,
	PASSO_COMPLETO
} velocidade;

enum{
	HORARIO,
	ANTIHORARIO
} sentido;

void motor_passo_init(void){
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
	
	estado = 0;
	velocidade = PASSO_COMPLETO;
	sentido = HORARIO;
}

void set_velocidade(uint8_t veloc){
	velocidade = veloc;
}

void set_sentido(uint8_t sentid){
	sentido = sentid;
}

void motor_passo_proximo_mov(void){
	if(sentido == HORARIO) estado++;
	else estado--;
	
	if(estado==-1) estado=7;
	estado%=8;
	
	uint8_t value;
	if(velocidade==PASSO_COMPLETO)
		value = passocompleto[estado];
	else
		value = meiopasso[estado];
	
	GPIO_PORTH_AHB_DATA_R = value;
}

uint8_t get_pizza(){
	uint8_t result;
	if(velocidade == PASSO_COMPLETO)
			result = passos/256;
	if(velocidade == MEIO_PASSO)
			result = passos/512;
	return result;
}