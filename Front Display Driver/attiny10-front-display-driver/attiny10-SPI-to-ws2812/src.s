
/*
 * src.s
 *
 * Created: 2022-05-27 10:52:58
 *  Author: Branden
 */ 


.text
.global run
run:
	LDI R16, 4		//load a value into r16 for setting rgb output high
	LDI R17, 0		//load a value to clear all ouputs
main_loop:

	SBIS 0, 1		//look at bit 1 in PINB. This is the clock input. if it's clear, just keep looping
	RJMP main_loop

	OUT 2, R16		//since we got here, we know the clock was set, so turn on the output



	//todo: possibly add nops

	SBIS 0, 0		//Look at the data bit and skip the jump to clear if it's set so the output is left on a bit longer
	RJMP clear

	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP

clear_and_restart: //here we immediately start the loop again after clearing
	OUT 2, R17
	RJMP main_loop

clear:	//Here we clear and wait for low clock
	OUT 2, R17		//Clear the outputs

wait_for_clk_low:
	
	SBIC 0, 1	//Wait till the clock goes low before we jump to the beginning of the loop
	RJMP wait_for_clk_low

	RJMP main_loop



