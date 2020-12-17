#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Connor Burns, 1006499255
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5(choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
sound: .byte 7
pitch: .byte 40
sound2: .byte 80
sound3: .byte 30
pitch2: .byte 10
duration: .byte 150
volume: .byte 20
displayAddress: .word 0x10008000
bufferAddress: .word 0x1000801
keyboardAddress: .word 0xffff0000
sky: .word 0x560319	#0x101f01
platform_colour: .word 0xff0101
orange: .word 0xffa500
initial_plat_X: .word 0x0000d
initial_plat_Y: .word 0x0001f

plat1_X: .space 32
plat1_Y: .word 0x00006
plat2_X: .space 32
plat2_Y: .word 0x0000c
plat3_X: .space 32
plat3_Y: .word 0x00012
plat4_X: .space 32
plat4_Y: .word 0x00018
doodler_colour: .word 0x00f111
doodler_X: .word 0x00010
doodler_Y: .word 0x000010	#0x0001d
max_jump_height: .word 	0x00000a
doodler_jump_Y: .word 0x000000
plat_move: .word 0x000000
score1: .word 0x000000
reward_X: .word 0x000005
reward_Y: .word 0x000005

.text
lw $t0, displayAddress # $t0 stores the base address for display


	

main:	jal pulldata
	jal GENERATEX
	sw, $a0, plat1_X
	jal GENERATEX
	sw $a0 plat2_X
	jal GENERATEX
	sw $a0 plat3_X
	jal GENERATEX
	sw $a0 plat4_X	#generating random x coordinate
	jal BACKGROUND
	jal DOODLER
	lw $a0, initial_plat_X		#drawing stuff
	lw $a1, initial_plat_Y
	jal PAINTPLAT
	lw $a0, plat1_X
	lw $a1, plat1_Y
	jal PAINTPLAT
	lw $a0, plat2_X
	lw $a1, plat2_Y
	jal PAINTPLAT
	lw $a0, plat3_X
	lw $a1, plat3_Y
	jal PAINTPLAT
	lw $a0, plat4_X
	lw $a1, plat4_Y
	jal PAINTPLAT
	jal CHECKSTART
	
	MAINLOOP:
		lw $t8, 0xffff0000
		beq $t8, 1, keyboard_input	#checking for keyboard input
		jal BACKGROUND
		jal PAINTLAVA
		jal DOODLER
		jal EVALUATESCORE
		
		#jal CHECKPLAT0
		
zero:		jal REWARD
		
zero1:		lw $a0, initial_plat_X		#drawing stuff
		lw $a1, initial_plat_Y
		jal PAINTPLAT
		
		#jal CHECKPLAT1
one:		lw $a0, plat1_X
		lw $a1, plat1_Y
		jal PAINTPLAT
		
		#jal CHECKPLAT2
two:		lw $a0, plat2_X
		lw $a1, plat2_Y
		jal PAINTPLAT
		
		#jal CHECKPLAT3
three:		lw $a0, plat3_X
		lw $a1, plat3_Y
		jal PAINTPLAT
		
		#jal CHECKPLAT4
four:		lw $a0, plat4_X
		lw $a1, plat4_Y
		jal PAINTPLAT
		
		lw $t0, doodler_jump_Y
		lw $t1, max_jump_height
		li $v0, 32			#schleepin
		li $a0, 100
 		syscall
		
		bne $t0, $t1 CONTINUE
		
		jal DOODLEFALL
		
		jal JUMPTRUE
		
		jal GAMEOVERTRUE
		
		

CONTINUE: 	li $v0, 32			#schleepin
		li $a0, 10
 		syscall
 		li $v0, 31
		lb $a0, pitch2
		lb $a1, duration
		lb $a2, sound2
		lb $a3, volume
		syscall	
		jal DOODLEJUMP
	
		j MAINLOOP
		
	
		
		
		
		
		li $v0, 32			#schleepin
		li $a0, 10
 		syscall
 		j MAINLOOP
	
	
 	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall


keyboard_input:	lw $t2, 0xffff0004
 		beq $t2, 0x73, respond_to_S
 		beq $t2, 0x6a, respond_to_J
 		beq $t2, 0x6b, respond_to_K
 		jr $ra
 				
CHECKALLPLATS:	jal CHECKPLAT0
		jal CHECKPLAT1
		jal CHECKPLAT2
		jal CHECKPLAT3
		jal CHECKPLAT4
		j MAINLOOP
		
CHECKPLAT0:	lw $a1, initial_plat_Y
		li $a0, 32
		ble $a1, $a0, zero
		jal GENERATEX
		sw $a0, initial_plat_X
		sw $zero, initial_plat_Y
		jr $ra
		
CHECKPLAT1:	lw $a1, plat1_Y
		li $a0, 32
		ble $a1, $a0, one
		jal GENERATEX
		sw $a0, plat1_X
		sw $zero, plat1_Y
		jr $ra	
		
CHECKPLAT2:	lw $a1, plat2_Y
		li $a0, 32
		ble $a1, $a0, two
		jal GENERATEX
		sw $a0, plat2_X
		sw $zero, plat2_Y
		jr $ra
		
CHECKPLAT3:	lw $a1, plat3_Y
		li $a0, 32
		ble $a1, $a0, three
		jal GENERATEX
		sw $a0, plat3_X
		sw $zero, plat3_Y
		jr $ra
		
		
CHECKPLAT4:	lw $a1, plat4_Y
		li $a0, 32
		ble $a1, $a0, four
		jal GENERATEX
		sw $a0, plat4_X
		sw $zero, plat4_Y
		jr $ra	

respond_to_K:	lw $t0, doodler_X	#change location when prompted
		li $t1, 30
		beq $t0, $t1, skip1
		addi $t0, $t0, 4
		sw $t0, doodler_X
skip1:		j MAINLOOP
		
respond_to_J:	lw $t0, doodler_X
		li $t1, 2
		beq $t0, $t1, skip2	#same as above
		subi $t0, $t0, 4
		sw $t0, doodler_X
skip2:		j MAINLOOP

respond_to_S:	j MAINLOOP



JUMPTRUE:	
		lw $a0, doodler_Y	#this checks all platforms of the doodlers Y is equal to a platform's Y
		lw $a1, initial_plat_Y
		beq $a0, $a1, JUMPCHECK1
		lw $a1, plat1_Y
		beq $a0, $a1, JUMPCHECK2
		lw $a1, plat2_Y
		beq $a0, $a1, JUMPCHECK3
		lw $a1, plat3_Y
		beq $a0, $a1, JUMPCHECK4
		lw $a1, plat4_Y
		beq $a0, $a1, JUMPCHECK5
		jr $ra
		
		

JUMPCHECK1:	lw $a0, doodler_Y	#jump check then goes through all the possible positions of the platform and checks if the doodlers location is equal to any of them
		lw $a1, doodler_X	
		sll $a0, $a0, 7
		sll $a1, $a1, 2
		add $a0, $a0, $a1
		lw $a2, initial_plat_Y
		lw $a3, initial_plat_X
		sll $a2, $a2, 7
		sll $a3, $a3, 2
		add $a2, $a2, $a3
		subi $a2, $a2, 1
		subi $a0, $a0, 1
		beq $a0, $a1 SEQ
		addi $a2, $a2, 1
		addi $a0, $a0, 1
		beq $a0, $a1 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		jr $ra

JUMPCHECK2:	lw $a0, doodler_Y
		lw $a1, doodler_X	
		sll $a0, $a0, 7
		sll $a1, $a1, 2
		add $a0, $a0, $a1
		lw $a2, plat1_Y
		lw $a3, plat1_X
		sll $a2, $a2, 7
		sll $a3, $a3, 2
		add $a2, $a2, $a3
		beq $a0, $a1 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		jr $ra

JUMPCHECK3:	lw $a0, doodler_Y
		lw $a1, doodler_X	
		sll $a0, $a0, 7
		sll $a1, $a1, 2
		add $a0, $a0, $a1
		lw $a2, plat2_Y
		lw $a3, plat2_X
		sll $a2, $a2, 7
		sll $a3, $a3, 2
		add $a2, $a2, $a3
		beq $a0, $a1 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		jr $ra
		
JUMPCHECK4:	lw $a0, doodler_Y
		lw $a1, doodler_X	
		sll $a0, $a0, 7
		sll $a1, $a1, 2
		add $a0, $a0, $a1
		lw $a2, plat3_Y
		lw $a3, plat3_X
		sll $a2, $a2, 7
		sll $a3, $a3, 2
		add $a2, $a2, $a3
		beq $a0, $a1 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		jr $ra
		
JUMPCHECK5:	lw $a0, doodler_Y
		lw $a1, doodler_X	
		sll $a0, $a0, 7
		sll $a1, $a1, 2
		add $a0, $a0, $a1
		lw $a2, plat4_Y
		lw $a3, plat4_X
		sll $a2, $a2, 7
		sll $a3, $a3, 2
		add $a2, $a2, $a3
		beq $a0, $a1 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		addi $a2, $a2, 4
		beq $a0, $a2 SEQ
		jr $ra
										
SEQ:		lw $t0, doodler_jump_Y
		li $t0, 0
		sw $t0, doodler_jump_Y
		li $v0, 31
		lb $a0, pitch
		lb $a1, duration
		lb $a2, sound
		lb $a3, volume
		syscall
		lw $t0, score1
		addi $t0, $t0, 1
		sw, $t0, score1
		#jal CHECKALLPLATS
		
		#jal MOVEALLPLATS
too:		#jal NEWPLAT
		j MAINLOOP		


PAINTLAVA:	lw $t0, displayAddress
		lw $t0, displayAddress
		lw $t3, orange
		addi $t0, $t0, 3968
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)
		sw $t3, 16($t0)
		sw $t3, 20($t0)
		sw $t3, 24($t0)
		sw $t3, 28($t0)
		sw $t3, 32($t0)
		sw $t3, 36($t0)
		sw $t3, 40($t0)
		sw $t3, 44($t0)
		sw $t3, 48($t0)
		sw $t3, 52($t0)
		sw $t3, 56($t0)
		sw $t3, 60($t0)
		sw $t3, 64($t0)
		sw $t3, 68($t0)
		sw $t3, 72($t0)
		sw $t3, 76($t0)
		sw $t3, 80($t0)
		sw $t3, 84($t0)
		sw $t3, 88($t0)
		sw $t3, 92($t0)
		sw $t3, 96($t0)
		sw $t3, 100($t0)
		sw $t3, 104($t0)
		sw $t3, 108($t0)
		sw $t3, 112($t0)
		sw $t3, 116($t0)
		sw $t3, 120($t0)
		sw $t3, 124($t0)
		sw $t3, 128($t0)
		jr $ra




BACKGROUND:	lw $t0, displayAddress
		lw $t3, sky		#load the sky colour from memory
		add $t4, $zero, $zero 	#initialize register 4 to a value of 0 to use as a pixel counter
		addi $t5, $zero, 4096
				#set register 5 to a value of 16388 (128x128/4 + 4), used to increment pixels
		j START
START:		beq $t4, $t5, EXIT	#check if the counter is over the last pixel 
		j UPDATE
UPDATE:		sw $t3, 0($t0)		#paint the pixel the background
		addi $t0, $t0, 4	#increment value of display address
		addi $t4, $t4, 4	#increment location of next pixel
		j START			#loop
		
EXIT: 		lw $t0, displayAddress	#reset the displaycoutner
		jr $ra



DOODLER:	lw $t0, displayAddress	#draws the doodler, pretty self explanatory
		lw $t3, doodler_colour
		lw $a0 doodler_X
		lw $a1 doodler_Y
		sll $a1, $a1, 7
		sll $a0, $a0, 2
		add $a1, $a1, $a0
		add, $t0, $t0, $a1
		sw $t3, 0($t0)
		
		addi, $t0, $t0, -128
		sw $t3, 0($t0)
		
		addi, $t0, $t0, -128
		
		sw $t3, -4($t0)
		sw $t3, 4($t0)
		addi, $t0, $t0, -128
		sw $t3, 0($t0)
 		lw $t0, displayAddress	#reset the displaycoutner
 		jr $ra
 
 
 
 
 PAINTPLAT:	lw $t0, displayAddress
 		lw $t3, platform_colour	#platform colour
 		lw $t0, displayAddress	#rest display address
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
 		li $a3, 0x13fc8c07
 		bge $t0, $a3, fix			#mult y by 128
		add $a1, $a1, $a0
		add $t0, $t0, $a1
 					#draw starting platform
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)		#paint the platform
		sw $t3, 16($t0)
		sw $t3, 20($t0)
		lw $t0, displayAddress
fix:		jr $ra
 
 
 
 
 DOODLEFALL:	lw $t0, doodler_Y	#load current jump height
		addi $t0, $t0, 1	#add 1
		sw $t0, doodler_Y
		li $v0, 31
		lb $a0, pitch2
		lb $a1, duration
		lb $a2, sound3
		lb $a3, volume
		syscall			#store new y location in doodler
		jr $ra
		
DOODLEJUMP:	lw $t0, doodler_jump_Y	#load current jump height
		lw $t1, max_jump_height	#load max jump height
		lw $t2, doodler_Y
				#load doodler Y
		bge $t0, $t1, MAINLOOP	#if jump height equal max height, bracnh
					
 		subi $t2, $t2, 1	#subtract 1 height from doodler location
		sw $t2, doodler_Y	#loads new y location into memory
		addi $t0, $t0, 1	#add 1 to current jump height(increment)
		sw $t0, doodler_jump_Y
		
finish:		jal MOVEALLPLATS
		#jal CHECKALLPLATS
		#jal NEWPLAT		#store new jump height
		j MAINLOOP		#jump back to central loop
		

		
		
		
 INC:		sw $zero, doodler_jump_Y
		j MAINLOOP
 		
		
 
 GENERATEX:	li $v0, 42
		li $a0, 0
		li $a1, 26		#generating random x coordinate
		syscall
		jr $ra

GENERATEXJEEZ:	li $v0, 42
		li $a0, 0
		li $a1, 10		#generating random x coordinate
		syscall
		jr $ra
		
GAMEOVERTRUE:	lw $a0, doodler_Y		#check if doodler is off the screen
		
		li $a1, 31
		bge $a0, $a1, PAINTGAMEOVER
		jal MAINLOOP
	
			
PLATFORMMOVETRUE:	lw $a0, doodler_jump_Y
			lw $a1, max_jump_height
			bne $a0, $a1, MOVEALLPLATS
		
 
MOVEALLPLATS:		jal NEWPLAT
			
fix1:			jal MOVEPLAT1
			jal MOVEPLAT2
			jal MOVEPLAT3
			jal MOVEPLAT4
			jal MOVEPLAT0
			j MAINLOOP
				
MOVEPLAT1:		
			lw $a0, plat1_Y
			addi $a0, $a0, 1
			
			sw $a0, plat1_Y
			jr $ra
test:						
MOVEPLAT2:		lw $a0, plat2_Y
			addi $a0, $a0, 1
			sw $a0, plat2_Y
			jr $ra

MOVEPLAT3:		lw $a0, plat3_Y
			addi $a0, $a0, 1
			sw $a0, plat3_Y
			jr $ra
MOVEPLAT4:		lw $a0, plat4_Y
			addi $a0, $a0, 1
			sw $a0, plat4_Y
			jr $ra
MOVEPLAT0:		lw $a0, initial_plat_Y
			addi $a0, $a0, 1
			sw $a0, initial_plat_Y
			jr $ra
			

NEWPLAT:	
		lw $t0, displayAddress
		lw $a1, initial_plat_Y
		li $a2, 32
		bge $a1, $a2, MODIFY1
		lw $a1, plat1_Y
		li $a2, 32
		bge $a1, $a2, MODIFY2
		lw $a1, plat2_Y
		li $a2, 32
		bge $a1, $a2, MODIFY3
		lw $a1, plat3_Y
		li $a2, 32
		bge $a1, $a2, MODIFY4
		lw $a1, plat4_Y
		li $a2, 32
		bge $a1, $a2, MODIFY5
		lw $t0, displayAddress
		j fix1

MODIFY1:	jal GENERATEX
		li $a2, 1
		sw, $a2, initial_plat_Y
		sw, $a0, initial_plat_X	
		lw $t0, displayAddress
		j NEWPLAT
MODIFY2:	jal GENERATEX
		li $a2, 1
		sw, $a2, plat1_Y
		sw, $a0, plat1_X
		lw $t0, displayAddress
		j NEWPLAT
MODIFY3:	jal GENERATEX
		li $a2, 1
		sw, $a2, plat2_Y
		sw, $a0, plat2_X
		lw $t0, displayAddress
		j NEWPLAT
		
MODIFY4:	jal GENERATEX
		li $a2, 1
		sw, $a2, plat3_Y
		sw, $a0, plat3_X
		lw $t0, displayAddress
		j NEWPLAT
MODIFY5:	jal GENERATEX
		li $a2, 1
		sw, $a2, plat4_Y
		sw, $a0, plat4_X
		lw $t0, displayAddress
		j NEWPLAT
		

#GAMEOVERRETRY:	#jal PAINTGAMEOVER	

	
		
PAINTGAMEOVER:	jal BACKGROUND
		li $a0, 6
		li $a1, 16
		lw $t3, platform_colour	
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
 					#mult y by 128
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)	
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)
		addi $t0, $t0, 16
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		
		addi $t0, $t0, 8
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, -256
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		
		addi $t0, $t0, -1692
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)	
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 12($t0)
		addi $t0, $t0, 16
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		
 		j CHECKFORRETRY			#draw starting platform
			
CHECKFORRETRY:	lw $t8, 0xffff0000
		beq $t8, 1, keyboard_input
		jal ENDSINPUT
		j CHECKFORRETRY
		
ENDSINPUT:	lw $t2, 0xffff0004
 		beq $t2, 0x73, respond_to_S2
 		j CHECKFORRETRY

respond_to_S2:	j RESET



RESET:	lw $t0, 64($sp)
	sw $t0, reward_Y
	lw $t0, 60($sp)
	sw $t0, reward_X
	lw $t0 56($sp)
	sw $t0, score1
	lw $t0, 52($sp)
	sw $t0, initial_plat_X
	lw $t0, 48($sp)
	sw $t0, initial_plat_Y
	lw $t0, 44($sp)
	sw $t0, plat1_X
	lw $t0, 40($sp)
	sw $t0, plat1_Y
	lw $t0, 36($sp)
	sw $t0, plat2_X
	lw $t0, 32($sp)
	sw $t0, plat2_Y
	lw $t0, 28($sp)
	sw $t0, plat3_X
	lw $t0, 24($sp)
	sw $t0, plat3_Y
	lw $t0, 20($sp)
	sw $t0, plat4_X
	lw $t0, 16($sp)
	sw $t0, plat4_Y
	lw $t0, 12($sp)
	sw $t0, doodler_X
	lw $t0, 8($sp)
	sw $t0, doodler_Y
	lw $t0, 4($sp)
	sw $t0, doodler_jump_Y
	lw $t0, 0($sp)
	sw $t0, plat_move
	addi $sp, $sp, 52
	j main


pulldata:	lw $t0, displayAddress # $t0 stores the base address for display
		subi $sp, $sp, 64	#store all data points in the stack pointer to reset later
		lw $t0,plat_move
		sw $t0,0($sp)
		lw $t0,doodler_jump_Y
		sw $t0, 4($sp)
		lw $t0,doodler_Y
		sw $t0, 8($sp)
		lw $t0,doodler_X
		sw $t0, 12($sp)
		lw $t0,plat4_Y
		sw $t0, 16($sp)
		lw $t0,plat4_X
		sw $t0, 20($sp)
		lw $t0,plat3_Y
		sw $t0, 24($sp)
		lw $t0,plat3_X
		sw $t0, 28($sp)
		lw $t0,plat2_Y
		sw $t0, 32($sp)
		lw $t0,plat2_X
		sw $t0, 36($sp)
		lw $t0,plat1_Y
		sw $t0, 40($sp)
		lw $t0,plat1_X
		sw $t0, 44($sp)
		lw $t0,initial_plat_Y
		sw $t0, 48($sp)
		lw $t0,initial_plat_X
		sw $t0, 52($sp)
		lw $t0, score1
		sw $t0, 56($sp)
		lw $t0, reward_X 
		sw $t0, 60($sp)
		lw $t0, reward_Y
		sw $t0, 64($sp)
		jr $ra


CHECKSTART:	lw $t8, 0xffff0000
		beq $t8, 1, STARTGAME	
		j CHECKSTART
		
STARTGAME:	lw $t2, 0xffff0004
 		beq $t2, 0x73, respond_to_S
 		j CHECKSTART






DRAWZERO:	#li $a0, 31
		#li $a1, 0
		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		addi $t0, $t0, -12
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		jr $ra

DRAWONE:	#li $a0, 31
		#li $a1, 0
		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		jr $ra

DRAWTWO:	#li $a0, 31
		#li $a1, 0
			
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, -12($t0)
		sw $t3, -8($t0)
		sw $t3, -4($t0)
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -12($t0)
		sw $t3, -8($t0)
		sw $t3, -4($t0)
		sw $t3, 0($t0)
		jr $ra

DRAWTHREE:	#li $a0, 31
		#li $a1, 0
			
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7
 		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		jr $ra



DRAWFOUR:		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7
 		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, -4($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -4($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -4($t0)
		addi $t0, $t0, 128
		sw $t3, -4($t0)
		addi $t0, $t0, 128
		jr $ra


DRAWFIVE:		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7
 		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		jr $ra

DRAWSIX:	
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7
 		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		jr $ra

						
	
DRAWSEVEN:		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		jr $ra

																																			
DRAWEIGHT:		
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		addi $t0, $t0, -12
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, -128
		sw $t3, 0($t0)
		addi $t0, $t0, 256
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		jr $ra
																																																																																																									
DRAWNINE:	
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, -4($t0)
		sw $t3, -8($t0)
		sw $t3, -12($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		jr $ra

																																																																																																																																																																																																																																																																																																																											
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																												
DRAWCASEO:	lw $t3, orange
		li $a0, 31
		li $a1, 0
		bne $t0, $0, WONN 
		jal DRAWZERO
		
WONN:		li $t2, 1
		bne $t0, $t2, TWOO
		jal DRAWONE
		
TWOO:		li $t2, 2
		bne $t0, $t2, THREEE
		jal DRAWTWO		
		
THREEE:		li $t2, 3
		bne $t0, $t2, FOURR
		jal DRAWTHREE

FOURR:		li $t2, 4
		bne $t0, $t2, FIVEE
		jal DRAWFOUR		
				
FIVEE:		li $t2, 5
		bne $t0, $t2, SIXX
		jal DRAWFIVE

SIXX:		li $t2, 6
		bne $t0, $t2, SEVENN
		jal DRAWSIX
		
SEVENN:		li $t2, 7
		bne $t0, $t2, EIGHTT
		jal DRAWSEVEN
		
EIGHTT:		li $t2, 8
		bne $t0, $t2, NINEE
		jal DRAWEIGHT
		
NINEE:		jal DRAWNINE	
####################################################### Second digit 
		li $a0, 26
		li $a1, 0
		bne $t1, $0, WON11 
		jal DRAWZERO																																																																																																																																										
WON11:		li $t2, 1
		bne $t1, $t2, TWO11
		jal DRAWONE
		
TWO11:		li $t2, 2
		bne $t1, $t2, THREE11
		jal DRAWTWO		
		
THREE11:	li $t2, 3
		bne $t1, $t2, FOUR1
		jal DRAWTHREE

FOUR11:		li $t2, 4
		bne $t1, $t2, FIVE11
		jal DRAWFOUR		
				
FIVE11:		li $t2, 5
		bne $t1, $t2, SIX11
		jal DRAWFIVE

SIX11:		li $t2, 6
		bne $t1, $t2, SEVEN11
		jal DRAWSIX
		
SEVEN11:	li $t2, 7
		bne $t1, $t2, EIGHT11
		jal DRAWSEVEN
		
EIGHT11:	li $t2, 8
		bne $t1, $t2, NINE11
		jal DRAWEIGHT
		
NINE11:		jal DRAWNINE																																																																																																																																																																																																																					
		j zero

DRAWCASE:	lw $t3, platform_colour	
		li $a0, 31
		li $a1, 0
		bne $t0, $0, WON 
		jal DRAWZERO
		
WON:		li $t2, 1
		bne $t0, $t2, TWO
		jal DRAWONE
		
TWO:		li $t2, 2
		bne $t0, $t2, THREE
		jal DRAWTWO		
		
THREE:		li $t2, 3
		bne $t0, $t2, FOUR
		jal DRAWTHREE

FOUR:		li $t2, 4
		bne $t0, $t2, FIVE
		jal DRAWFOUR		
				
FIVE:		li $t2, 5
		bne $t0, $t2, SIX
		jal DRAWFIVE

SIX:		li $t2, 6
		bne $t0, $t2, SEVEN
		jal DRAWSIX
		
SEVEN:		li $t2, 7
		bne $t0, $t2, EIGHT
		jal DRAWSEVEN
		
EIGHT:		li $t2, 8
		bne $t0, $t2, NINE
		jal DRAWEIGHT
		
NINE:		jal DRAWNINE	
####################################################### Second digit 
		li $a0, 26
		li $a1, 0
		bne $t1, $0, WON1 
		jal DRAWZERO																																																																																																																																										
WON1:		li $t2, 1
		bne $t1, $t2, TWO1
		jal DRAWONE
		
TWO1:		li $t2, 2
		bne $t1, $t2, THREE1
		jal DRAWTWO		
		
THREE1:		li $t2, 3
		bne $t1, $t2, FOUR1
		jal DRAWTHREE

FOUR1:		li $t2, 4
		bne $t1, $t2, FIVE1
		jal DRAWFOUR		
				
FIVE1:		li $t2, 5
		bne $t1, $t2, SIX1
		jal DRAWFIVE

SIX1:		li $t2, 6
		bne $t1, $t2, SEVEN1
		jal DRAWSIX
		
SEVEN1:		li $t2, 7
		bne $t1, $t2, EIGHT1
		jal DRAWSEVEN
		
EIGHT1:		li $t2, 8
		bne $t1, $t2, NINE1
		jal DRAWEIGHT
		
NINE1:		jal DRAWNINE																																																																																																																																																																																																																					
		j zero





EVALUATESCORE:	lw $t0, score1
		li $t1, 10
		div $t0, $t1
		mfhi $t0
		mflo $t1
		beq $t0, $0, orangee
		j DRAWCASE
orangee:	j DRAWCASEO

DRAWEXLAMATION:	lw $a0, reward_X
		addi $a0, $a0, 10
		lw $a1, reward_Y
		addi $a1, $a1, 3
		lw $t3, orange	
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1	#draw GG
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		j zero1


DRAWJEEZ:	lw $a0, reward_X
		addi $a0, $a0, 5
		li $a1, 10
		addi $a1, $a1, 3
		lw $t3, orange	
 		lw $t0, displayAddress
 		sll $a0, $a0, 2		#mult x by 4
 		sll $a1, $a1, 7	
		add $a1, $a1, $a0
		add $t0, $t0, $a1
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		
	
		addi $t0, $t0, 8
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, 256
		addi $t0, $t0, 8
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		addi $t0, $t0, 128
		sw $t3, 0($t0)
		sw $t3, 4($t0)
		sw $t3, 8($t0)
		j zero1

REWARD:		lw $a0, score1
		li $a1, 10
		div $a0, $a1
		mfhi $a1
		li $a0, 5
		beq $a1, $a0, DRAWEXLAMATION 
		beq $a1, $0, DRAWJEEZ
		jal GENERATEXJEEZ
		sw $a0, reward_X
		lw $a1, doodler_Y
		sw $a1, reward_Y
		j zero1
