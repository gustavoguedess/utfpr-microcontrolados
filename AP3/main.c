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

/* Funções led */
void liga_leds(uint8_t value);

/* Funções do motor*/
void config_motor(uint8_t _sentido, uint8_t _velocidade);
void proximo_passo(void);
uint32_t get_passos_por_voltas(uint8_t voltas);
uint8_t get_parte(void);

/* Funções teclado */
uint8_t get_tecla(void);
uint8_t get_num(void);

enum estado{
	INICIO,
	GIRANDO,
	FIM
} estado;

void parar(void){
	estado = FIM;
}

void girar_motor(uint8_t voltas, uint8_t sentido, uint8_t velocidade) {
	uint32_t i;
	uint32_t tot_passos;
	uint8_t parte;
	
	estado = GIRANDO;
	
	// Configura o sentido e a velocidade
	config_motor(sentido, velocidade);
	
	// Pega a quantidade de passos por voltas
	tot_passos = get_passos_por_voltas(voltas);
	
	for(i=0; i<tot_passos; i++) {
		if(estado!=GIRANDO) break;
		
		// Move o motor
		proximo_passo();
		
		// Acende o led
		parte = get_parte();
		liga_leds(1<<parte);
		
		// Espera 2ms
		SysTick_Wait1ms(2);
	}
	
	parar();
}

/* Função main */
int main() {
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	
	//girar_motor(1,1,0);
	//girar_motor(1,0,0);
	//girar_motor(3,1,0);
	uint8_t voltas;
	uint8_t sentido;
	uint8_t velocidade;
	
	while(1){
		estado = INICIO;
		while(get_tecla()!='*'){};
			
		// Coleta voltas
		voltas = get_num();
		if(voltas==0) voltas=10;
			
		// Coleta sentido
		sentido = get_num();
			
		// Coleta velocidade
		velocidade = get_num();
			
		girar_motor(voltas,sentido,velocidade);
	}
}
