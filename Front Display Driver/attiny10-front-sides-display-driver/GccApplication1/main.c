/*
 * GccApplication1.c
 *
 * Created: 2022-05-28 0:55:43
 * Author : Branden
 */ 

#define F_CPU 12000000UL

#include <avr/io.h>
#include <util/delay.h>


#define RGB_OUT DDB2
#define RIGHT_RGB_LED_COUNT 8
#define LEFT_RGB_LED_COUNT 26
#define RGB_LED_COUNT (RIGHT_RGB_LED_COUNT + LEFT_RGB_LED_COUNT)
#define RGB_LED_BYTE_COUNT (RGB_LED_COUNT * 3)


const uint8_t colors[8][3] = 
{
	//grb
	{0,18,48},		//purple	
	{0,0,96},		//blue
	{24,0,48},		//cyan
	{64,0,0},		//green
	{32,32,0},		//yellow
	{32,64,0},		//orange
	{0,64,0},		//red
	{0,38,32},		//violet	
};

const uint8_t left_side_color_indexes[4]=
{
	6 * 3, 4 * 3, 3 * 3, 1 * 3 //Everything is * 3 because there are 3 bytes per color
};

void init_clk()
{
	OSCCAL =  208; //Calibrate for 12MHz
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
}

extern void output_rgb(uint8_t left_offset, uint8_t right_offset);

int main(void)
{
	init_clk();
	init_io();
	
	uint8_t li = 0;
	uint8_t ri = 0;
	
	while(1)
	{
		output_rgb(li, ri);
		_delay_ms(500);
		ri++;
		li = ri >> 1 ;
	}
}

