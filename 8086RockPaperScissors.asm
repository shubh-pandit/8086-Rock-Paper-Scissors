DATA SEGMENT

   PORTA EQU 00H
   PORTB EQU 02H
   PORTC EQU 04H
   PORT_CON EQU 06H ;sets alias of the i/o addresses of each port as their name

DATA ENDS

CODE SEGMENT 

ORG 0000H

START:

   MOV DX, PORT_CON
   MOV AL, 10000010B; port C (output), port A (output) in mode 0 and PORT B (INPUT) in mode 0
   OUT DX, AL 
   MOV CL, 00000000B 
   MOV CH, 00000000B ;initializing CH and CL as 0
   MOV DX, PORTA
   MOV AL, 00000000B
   OUT DX, AL
   MOV DX, PORTC
   OUT DX, AL ;turning off all the LEDs
 
GAME:
   CMP CH, 03H ;checks if both the users have given their inputs
   JZ DECISION ;if so, jumps to decision function
   MOV DX, PORTB
   IN AL,DX 
   CMP AL, 11111111B ;takes input from portb and checks if the user has pressed any button
   JNZ SELECT ;jumps to select if an input is detected
   JMP GAME ;repeats the process indefinitely
   
SELECT:
   CMP AL, 11111110B
   JZ ROCK1
   CMP AL, 11111101B
   JZ PAPER1
   CMP AL, 11111011B
   JZ SCISSORS1
   CMP AL, 11110111B
   JZ ROCK2
   CMP AL, 11101111B
   JZ PAPER2
   CMP AL, 11011111B
   JZ SCISSORS2
   CMP AL, 10111111B ;compares each choice with their respective buttons
   JZ RESET
   JMP GAME

ROCK1:
   OR CH,01H ;sets the lsb of CH to indicate that player1 has inputted their choice
   AND CL, 11111000B  ;clears the previous choice if any
   OR CL, 00000001B ;sets the bit according to the choice made (rock/paper/scissors)
   JMP GAME

PAPER1:
   OR CH,01H
   AND CL, 11111000B
   OR CL, 00000010B
   JMP GAME

SCISSORS1:
   OR CH,01H
   AND CL, 11111000B
   OR CL, 00000100B
   JMP GAME

ROCK2:
   OR CH,02H ;sets the 2nd last bit of CH to indicate player 2 has made their choice
   AND CL, 11000111B ;clears the previous choices if any (the first two bits are don't care)
   OR CL, 00001000B
   JMP GAME

PAPER2:
   OR CH,02H
   AND CL, 11000111B
   OR CL, 00010000B
   JMP GAME

SCISSORS2:
   OR CH,02H
   AND CL, 11000111B
   OR CL, 00100000B
   JMP GAME

RESET: ;resets the game
   JMP START

DECISION: ;compares every possible combination and accordingly jumps to the draw, lose and win functions
   CALL LEDOUT
   CMP CL, 00001001B
   JZ DRAW
   CMP CL, 00010001B
   JZ LOSE
   CMP CL, 00100001B
   JZ WIN
   CMP CL, 00001010B
   JZ WIN
   CMP CL, 00010010B
   JZ DRAW
   CMP CL, 00100010B
   JZ LOSE
   CMP CL, 00001100B
   JZ LOSE
   CMP CL, 00010100B
   JZ WIN
   CMP CL, 00100100B 
   JZ DRAW

LEDOUT:
   MOV AL, CL
   MOV DX, PORTA
   OUT DX, AL ;turns on the LEDs corresponding to the choice the players made
   RET


DRAW:
   MOV AL, 00000010B 
   MOV DX, PORTC
   OUT DX,AL ;turns on the draw LED
   JMP PAUSE

WIN:
   MOV AL, 00000100B
   MOV DX, PORTC
   OUT DX,AL ;turns on the player 1 win LED
   JMP PAUSE

LOSE:
   MOV AL, 00000001B
   MOV DX, PORTC
   OUT DX,AL ;turns on the player 2 win LED
   JMP PAUSE

PAUSE: ;waits until reset button is set to maintain the state of the LEDs
   MOV DX, PORTB
   IN AL,DX 
   CMP AL, 10111111B
   JZ START
   JMP PAUSE

JMP START
CODE ENDS
END
