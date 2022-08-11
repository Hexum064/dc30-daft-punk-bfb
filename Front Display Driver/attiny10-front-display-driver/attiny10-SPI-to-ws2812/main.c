/*
 * GccApplication1.c
 *
 * Created: 2022-05-26 22:54:33
 * Author : Branden
 */ 




#include <avr/io.h>
#define F_CPU 12000000UL
#define DATA_IN DDB0
#define CLK_IN DDB1
#define RGB_OUT DDB2


extern void run(void);

//#define ISC0_RISING 3
//#define EI_EN 1
//#define PCI_EN 1
//
//ISR(PCINT0_vect)
//{
	//
	//
//}

void init_clk()
{
	OSCCAL = 185;// 208; //Calibrate for 12MHz
	// Set CPU speed by setting clock prescalar:
	// CCP register must first be written with the correct signature - 0xD8
	CCP = 0xD8;
	//  CLKPS[3:0] sets the clock division factor
	CLKPSR = 0; // 0000 (1)	
	CLKMSR = CLKMS0; //Make sure we are using the interal 8Mhz
}

void init_io()
{
	//Init the outputs
	DDRB = 1 << RGB_OUT;
	////Enable external interrupt on rising edge
	//EICRA = ISC0_RISING;
	////Select pin 1 for the pin change interrupt 
	//PCMSK = PCINT1;
	////Enable Pin Chagne interrupt
	//PCIFR = PCI_EN;
	////Finally, enable the external interrupt
	//EIMSK = EI_EN;
}

int main(void)
{
	init_clk();
	init_io();
	
	uint8_t clk_in_mask = 1 << CLK_IN;
	uint8_t data_in_mask = 1 <<DATA_IN;
	uint8_t rgb_out_mask = 1 << RGB_OUT;
	
	run();
	
    ///* Replace with your application code */
    //while (1) 
    //{
		//if ((PINB & clk_in_mask)) //if clk is high
		//{
			//PORTB |= rgb_out_mask;
			////Do some No Ops to burn a few cycles with the output pin high
	//
//
			//
			//if ((PINB & data_in_mask)) //If data is high, add some more no ops
			//{
				////asm("NOP");
				////asm("NOP");
				////asm("NOP");
				////asm("NOP");
				//
			//}
			//
			////set the output to low until the next clock
//
			//PORTB ^= rgb_out_mask;
		//}
    //}
}

