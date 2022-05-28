/*
 * output_rgb.c
 *
 * Created: 2022-05-28 9:55:42
 *  Author: Branden
 */ 

//A note to remember, XL = r26, XH = r27, YL = r28, YH = r29, ZL = r30, ZH = r31


.text
.global output_rgb
output_rgb:

	
	//Using R19 for current color value
	//Using R20 for bit loop counter
	//Using R21 for color byte loop counter
	//Using r18 for LED loop counter
	//R24 will be an initial offset for the left side color index
	//r22 will be an initial offset for the right side color index




	push r28


	clr r18
	clr r19
	clr r20
	clr r21
	

main_loop_left_start:
	//This is the start of the loop that outputs all of the LED data

//Start LED 1 of 2
	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)
	//And the left-side color indexes array address into y
	ldi YL, lo8(left_side_color_indexes)
	ldi YH, hi8(left_side_color_indexes)

	//output left side first
	//Green, Red, and Blue are each loaded then output individually

	//We only want to use the first 2 bits in r24 because the color index array is only 4 elements in size
	andi r24, 0x03		//Only keep the first 2 bits
	add	r28, r24		//Add the r24 offset to YL
	//Now we can load and inc 
	ld r19, Y+			//This is just the index for the actual color
	//Now get the color
	add r26, r19		//Add the offset from the color index array. 

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_left_led_0:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_left_led_0:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
												
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_left_led_0										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop
	

clear_left_led_0:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_left_led_0
	
	//might need some NOPs here
	nop
	nop

continue_left_led_0:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_left_led_0

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_left_led_0

	clr r21

//Start LED 2 of 2
	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)
	//And the left-side color indexes array address into y
	ldi YL, lo8(left_side_color_indexes)
	ldi YH, hi8(left_side_color_indexes)

	add	r28, r24		//Add the r24 offset to YL
	//Now we can load and inc 
	ld r19, Y+			//This is just the index for the actual color
	//Now get the color
	add r26, r19		//Add the offset from the color index array. 

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_left_led_1:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_left_led_1:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
											
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_left_led_1										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop


clear_left_led_1:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_left_led_1
	
	//might need some NOPs here
	nop
	nop

continue_left_led_1:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_left_led_1

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_left_led_1

	inc r24			//Move to the next color
	clr r21

	inc r18			//inc our LED loop counter
	
	sbrs r18, 2		//If bit 2 is set, that means we have gone through this loop 4 times and all of the left side LEDs should be set
	rjmp main_loop_left_start


//This is the end of the left side lighting code



//This is the beginning of the right side lighting code
//This side has 5 rows of 4 LEDs then 2 rows of 3 LEDs, so there will be a bit of extra loop counting

	clr r19
	clr r20
	clr r21
	ldi r18, 0x01 //Starting with 1 because we will be loading 7 LED rows (5 rows of 4 and 2 rows of 3), so this way we can check for bit 3 to be set
	//Since the last two rows have only three, we will conditionally jump to the end of the loop for those last two rows

main_loop_right_start:	

//Start LED 1 of 4
	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)

	//We only want to use the first 3 bits in r22 because the color array is only 8 elements in size
	andi r22, 0x07		//Only keep the first 3 bits
	add r26, r22		//Add the r22 offset to XL. Need to do it 3 times because we are jumping by 3 bytes
	add r26, r22
	add r26, r22

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_right_led_0:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_right_led_0:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
												
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_right_led_0										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop
	

clear_right_led_0:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_left_led_0
	
	//might need some NOPs here
	nop
	nop

continue_right_led_0:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_right_led_0

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_right_led_0

	clr r21

//Start LED 2 of 4

	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)

	//We only want to use the first 3 bits in r22 because the color array is only 8 elements in size
	andi r22, 0x07		//Only keep the first 3 bits
	add r26, r22		//Add the r22 offset to XL. Need to do it 3 times because we are jumping by 3 bytes
	add r26, r22
	add r26, r22

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_right_led_1:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_right_led_1:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
												
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_right_led_1										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop
	

clear_right_led_1:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_left_led_1
	
	//might need some NOPs here
	nop
	nop

continue_right_led_1:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_right_led_1

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_right_led_1

	clr r21

//Start LED 3 of 4

	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)

	//We only want to use the first 3 bits in r22 because the color array is only 8 elements in size
	andi r22, 0x07		//Only keep the first 3 bits
	add r26, r22		//Add the r22 offset to XL. Need to do it 3 times because we are jumping by 3 bytes
	add r26, r22
	add r26, r22

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_right_led_2:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_right_led_2:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
												
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_right_led_2										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop
	

clear_right_led_2:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_right_led_2
	
	//might need some NOPs here
	nop
	nop

continue_right_led_2:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_right_led_2

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_right_led_2

	clr r21

	//if our LED counter, r18, >= 6 (1 based instead of 0), skip the last led since rows 6 and 7 only have 3 leds
	cpi r18, 0x06
	brsh right_led_loop_end

//Start LED 4 of 4
	//Start off by getting the address for the colors array into X
	ldi XL, lo8(colors)
	ldi XH, hi8(colors)

	//We only want to use the first 3 bits in r22 because the color array is only 8 elements in size
	andi r22, 0x07		//Only keep the first 3 bits
	add r26, r22		//Add the r22 offset to XL. Need to do it 3 times because we are jumping by 3 bytes
	add r26, r22
	add r26, r22

	ldi r21, 0x01		//Starting r21 a 1 instead of 0 so we can just check for bit 2 when inc and we only loop 3 times instead of 4

byte_out_start_right_led_3:
	//Now we can start outputting color data
	ld r19, X+			//Load the first color byte into r19 and inc X
bit_out_start_right_led_3:
	sbi 0x02, 2			//Set bit 2 in PORTB			
	
	//No NOP needed
												
	sbrs r19, 7		//bit 7 because ws2812b is MSB first. left shift will be applied 1 by 1											
	rjmp clear_right_led_3										

	//more NOPs for timing for a 1 bit
	nop
	nop
	nop
	nop
	nop
	nop
	

clear_right_led_3:
	cbi 0x02, 2		//Now clear bit 2 in the output and do more processing
	nop
	nop

	sbrc r19, 0		//If the bit is 0, then we want to wait longer so we skip the jump, else, we just continue the loop by jumping										
	rjmp continue_right_led_3
	
	//might need some NOPs here
	nop
	nop

continue_right_led_3:	
	inc r20
	lsl r19			//Move to the next bit
	sbrs r20, 3		//If bit 3 is set, we counted to 8 so we are done.
	rjmp bit_out_start_right_led_3

	clr 20			//Reset the bit loop counter
	inc r21			//inc to the next color byte
	
	sbrs r21, 2		//If bit 2 is set (r21 = 0x04), the we have output all the color bytes for the current color
	rjmp byte_out_start_right_led_3

right_led_loop_end:
	
	clr r21

	inc r22			//Move to the next color
	inc r18			//inc our LED loop counter


	sbrs r18, 3		//If bit 3 is set, that means we have gone through this loop 5 (+ our starting 3) times and all of the left side LEDs should be set
	rjmp main_loop_right_start

	pop r28

	ret






