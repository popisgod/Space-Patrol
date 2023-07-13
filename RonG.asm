IDEAL
MODEL small
STACK 100h
P586
org 100h

DATASEG

macro terminate 
    mov AX, 2
    INT 10h
    
  mov ah,4ch
  mov al,00
  int 21h
endm      
;--------------------------------------------PrintingBmp-------------------------------------------------------------;S
PrintMode db 0 ; - 0 - for rules , 1 - for StartS , 2- for MainM ...
stor   	 	dw      0      ;our memory location storage
imgHeight dw 200  ;Height of image that fits screen
imgWidth dw 320   ;Width of image that fits screen
adjustCX dw ?     ;Adjusts register CX
filename db 20 dup (?) ;Generates the file's name 
filehandle dw ?  ;Handles the file
Header db 54 dup (0)  ;Read BMP file header, 54 bytes
Palette db 256*4 dup (0)  ;Enable colors
ScrLine db 320 dup (0)   ;Screen Line
Errormsg db 'Error', 13, 10, '$'   ;In case of not having all the files, Error message POPs
PrintADD dw ?   ;Enable to ADD new graphics

img db 'Rules.bmp', 0  
img1 db 'StartS.bmp' , 0 
img2 db 'MainM.bmp' , 0
img3 db 'GameO.bmp' , 0
img4 db 'WinS.bmp' , 0
img5 db 'ModeS.bmp' , 0
;img6 db 'GameS.bmp' , 0
;--------------------------------------------PrintingBmp-------------------------------------------------------------;E
   
;--------------------------------------------MechanicsVariables--------------------------------------------------------;S 
	HighestTime DW 0
	
	NUMBER_VALUE DW 0
	IP_TEMP DW 0
	
	HighestLevel DW 0
	GameMode DB 0
   
	temp DW ?
   
    xR DW ?
    yR DW ?
	
	BulletStartX DW ?
	BulletStartY DW ?
	BulletFlag DW ?
	BulletVelocity DW ?
	
	FirstObjectX DW ?
	FirstObjectY DW ? 
	SecondObjectX DW ?
	SecondObjectY DW ?
	TempLowest Dw ?
	CollisionFlag DW 0		
	
	BulletStartX1 DW ?
	BulletStartY1 DW ?
	BulletFlag1 DW ?
	
	
	BulletStartX2 DW ?
	BulletStartY2 DW ?
	BulletFlag2 DW ?
	
	
	StartYF DW 190
   
	startXS DW 280
	startYS DW 160
	
	
	colorS0 DB 3
	colorS1 DB 14
	
	colorP0 DB 4
	colorP1 DB 3
    colorR DB 3
    
    startXR DW ?
    endXR DW ?
    
	startXF DW 320
	
    startYR DW ?
    endYR DW ?

	SET_COLUMN DB ?
	SET_ROW DB ?
	
	startXSS DW ?
	startYSS DW ?
 	startX DW 70   
    startY DW 150
    pre_startY DW 0
    pre_startX DW 0
	
	JumpUp DW 55 
	JumpDown DW 55 
	
	WheelsChange0 DW  15, 15, 15
	
	TimeVaribleMs DB 0 ; variable used when checking the time 
	
;------------------FlagVariables 
	DrawMode DB 1 ; 1 - for spaceship , 2 - for floor , 3 - for saucer, 4 - lights.
	GameActive DB 1 ; Flags if game active ( gameplay )
	WonActive DB 0 ; 0 - won screen , 1 - animation of saver , 2 - animation of spaceship
	JumpFlag DW 0 ; Flags if SpaceShip jumps 
	SaucerFlag DW 0 ; Flags if Saucer is on screen 
	ShootingSaucerFlag DW 0 ; Flags if ShootingSaucer is on screen 
;-------------------LevelRelatedVariables
	LevelNumber DW ? ; indictes how many Levels the player played
	LeveLVelocityS DW ?
	LevelGameLength DW ?
	LeveltimeS DW ?
	
	LevelVelocityF DW ?
	LevelVelocitySpaceShip DW ?
	
	TimeVaribleS DB ?
;-------------------LevelRelatedVariables
	
;-------------------------------Velocities and time releted variablesS 
	StartTimeS DW 0
	StartTimeMs DW 0 
	GameLength DW ?
	timeS DW ?
	VelocityS DW ? ; Velocity of the Saucer 
	VelocityF DW ?  ; Velocity of the floor 
	VelocityJumpUP DW ?   
	VelocityJumpDOWN DW ?
	VelocitySpaceShip DW ?
;-------------------------------Velocities and time releted variablesE	
	StarsArr DW 100,100, 200, 30, 300, 100, 205, 50, 73 , 77 , 60 , 220 , 45 , 53, 105, 140, 210, 80, 152, 158
	StarsCounter DW 10 
;--------------------------------------Random
	NumberR DW 0
	limit DB 16
;--------------------------------------Random
	
;--------------------------------------------MechanicsVariables--------------------------------------------------------;E 
	
;---------------------------------------------------------------------------------------------------------PixelArt----------------------------------------------------------------------------------------------;S	

lights  db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 2 		
	    db 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 2 		
	    db 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 2 
	    db 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 2 
	    db 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 2 
	    db 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 2 
	    db 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 2 
	    db 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 2 
	    db 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 2 
	    db 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 2 
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 		
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 		
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 		
	    db 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 2 		
	    db 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 2 		
	    db 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 2 		
	    db 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 2 		
	    db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2 		
	    db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2 		
	    db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2 		
	    db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2 		
	    db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 		
	    db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2 	
		db 3


		
		
		
SpaceShip db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2 
		 db 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2 
		 db 1, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 4, 4, 4, 4, 4 ,4, 4, 4, 4, 4, 4, 2
		 db 1, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2
		 db 1, 4, 4, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 
		 db 1, 4, 4, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 3
		 
Saucer	 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
		 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2 
		 db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2 
		 db 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 0, 0, 4, 4, 4, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2 
		 db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
		 db 3

		 

		 

Floor	 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 2
	     db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3

;---------------------------------------------------------------------------------------------------------PixelArt----------------------------------------------------------------------------------------------;E
	

;-----------------------------------MessagesForMenus-------------------------------------------;S
	; this space is exactly one line
	TEXT_INFINTY_LEVEL_STARTED DB '---Infinity Level started---  ', '$'
	; 				'                                                                                '	
	 STORY_TEXT1 DB 'HURRY UP... JUMP INSIDE OF ME, I WILL                                           SAVE YOU ' , '$'
	
	 STORY_TEXT2 DB 'WOW THEY ARE STILL FOLLOWING US AFTER                                           ALL THIS TIME ' , '$'
		
	 STORY_TEXT3 DB 'WHAT DID YOU DO TO THEM? IT MUST"VE                                             MADE THEM REALLY ANGRY ' , '$'
	
	 STORY_TEXT4 DB 'OK WE ARE LOW ON TIME WE SHOULDN"T                                              TALK ABOUT IT NOW ' , '$'
	
	 STORY_TEXT5 DB 'ARE YOU SURE YOU ARE NOT A WANTED                                               CRIMINAL, BECAUSE IT SURE LOOKS LIKE                                            YOU ARE ONE  ' , '$'
	
	 STORY_TEXT6 DB 'WE COULD TRY AND FLY AWAY TO THE                                                OTHER SIDE OF THE PLANET  ' , '$'
	
	 STORY_TEXT7 DB 'IT LOOKS LIKE IT ONLY MADE IT WORSE,                                            WHAT WAS I THINKING TO MYSELF ' , '$'
	
	 STORY_TEXT8 DB 'I GUESS OUR DEATH IS NEAR,                                                      MAYBE SING A SONG FOR ME' , '$'
	
	 STORY_TEXT9 DB 'WOW THIS LAST SONG WAS NICE                                                     CAN YOU PLAY IT AGAIN PLS' , '$'
	
	STORY_TEXT10 DB 'WAIT YOU WERE RUNNING                                                           FROM AN EVIL CORPORATION' , '$'
	
	STORY_TEXT11 DB 'WHICH CORPORATION?' , '$'
	
	STORY_TEXT12 DB 'YOU ARE NOT ALLOWED TO TELL!?!?                                                 ARE YOU KIDDING ME' , '$'
	
	STORY_TEXT13 DB 'RIGHT NOW I"M SAVING YOU                                                        FROM BEING KILLED I THINK IT"S FAIR' , '$'
	
	STORY_TEXT14 DB 'HE"S NAME IS ELON MUSK                                                          YOU SAY WHATTTTTTT NOOOOOOOOO' , '$'
	
	STORY_TEXT15 DB 'WHY DID YOU TELL HIS NAME                                                       HE"S LIKE VOLDEMORT ' , '$'
	
	STORY_TEXT16 DB 'ELON MUSK IS OUR SAVIOR                                                         AND ONLY GOD ' , '$'
	
	TEXT_PAUSE   DB 'Pause-ESC Resume-H' , '$'	
	
	TEXT_TIMER  DB 'Timer:' , 48, 48 , 48 , '$'

	TEXT_LEVEL_COMPLETED  DB 'Level Number ' , 48, 48 , 48 , ' Completed$'
	
	TEXT_LEVEL_STARTED    DB '---- Level Number ' , 48, 48 , 48 , ' ----$'
	
	TEXT_LEVEL_LOST DB        'Level lost:  ', 48, 48 , 48 ,'$'
	TEXT_HIGHEST_LEVEL DB  'Highest Level: ', 48, 48 , 48 ,'$'
	
	TEXT_LEVEL_CURRENT_TIME DB 'Current Time:',48, 48 , 48 ,'$'
	TEXT_HIGHEST_TIME DB  'Highest Time:  ', 48, 48 , 48 ,'$'
;-----------------------------------MessagesForMenus-------------------------------------------;E

;---------------------------------------------------------------------------------------------------------------------------------------CODESEG
CODESEG



;-------------------------------------------------------------------------------------------------------------------PrintBmp-------------------------------------------------------------------------------------------------------------------------------;


;Prints the bmp file provided
;IN: AX - img OFFSET, imgHeight (dw), imgWidth (dw), PrintADD (dw)
;OUT: Printed bmp file
PROC NUMBER_STDOU ; number value , si - message offset , number of charcters 
	pop [IP_TEMP]
	
	pop [NUMBER_VALUE]
	
	mov [temp], 10
	XOR DX, DX
	cmp [NUMBER_VALUE], 0
	JE NUMBER_STDOU_TIMER
	
	mov ax, [NUMBER_VALUE]
	div [temp]
	
	NUMBER_STDOU_TIMER:
	
	pop si 
	;pop [NUMBER_STDOU_PLACE]
	
	pop bx 
	;add si , [NUMBER_STDOU_PLACE]
	mov [byte si+bx] , 48
	;add si , 1
	mov [byte si+bx+1] , 48
	;add si , 1
	mov [byte si+bx+2] , 48
	
	cmp [NUMBER_VALUE], 0
	JE SOMETHINGCOOL
	
	cmp [NUMBER_VALUE], 99
	JG NUMBER_PRINT_STDOU
	
	 
	add [si+bx+1] , ax
	
	
	;add si , 1
	add [si+bx+2] , dx

	
	JMP SOMETHINGCOOL
	
	NUMBER_PRINT_STDOU:
	add [si+bx+2] , dx
	xor dx, dx
	div [temp]
	
	add [si+bx+1] , dx
	
	add [si+bx] , ax
	
	SOMETHINGCOOL:

	push  si
	CALL STDOU
	
	
	
	push [IP_TEMP]
	ret
ENDP NUMBER_STDOU


PROC STDOU
	pop [temp]
		
;shows Message for getting inside the Saver 
	mov BL, 05h
	mov AH, 02h  ; set cursor position
	mov BH, 00h	 ; set page number 
	mov DH, [SET_ROW]  ; set row
	mov DL, [SET_COLUMN]  ; set column
	INT 10h
	
	mov ah, 09h  ; write string to stdou
	
	pop dx ; give dx a pointer to the string
	INT 21h ; Print the string	
		

	push [temp]
	ret
ENDP STDOU
	



PROC PrintBmp
	PUSH cx
	PUSH di
	PUSH si
	PUSH cx
	PUSH AX
		
	
	CMP [PrintMode], 0 ; rules screen 
	JE Rules
	
	CMP [PrintMode], 1  ; Opening screen 
	JE StartScreen
	
	CMP [PrintMode], 2  ; main menu screen 
	JE MainMenu
	
	CMP [PrintMode], 3   ; Lost screen 
	JE LostScreen
	
	CMP [PrintMode], 4   ; Lost screen 
	JE WinS
	
	CMP [PrintMode], 5   ; Mode screen 
	JE ModeS

	;CMP [PrintMode], 6   ; Mode screen 
	;JE TaylorS

;TaylorS:
	;mov AX, OFFSET img6
	;JMP StartBmp
	
ModeS:
	mov AX, OFFSET img5
	JMP StartBmp

WinS:
	mov AX, OFFSET img4
	JMP StartBmp
	
LostScreen:
	mov AX, OFFSET img3
	JMP StartBmp

MainMenu:
	mov AX, OFFSET img2
	JMP StartBmp
StartScreen:
	mov AX, OFFSET img1
	JMP StartBmp
Rules:
	mov AX, OFFSET img
	JMP StartBmp
	
	
StartBmp:
	
	xor di, di
	mov di, AX
	mov si, OFFSET filename
	mov cx, 20
Copy:
	mov al, [di]
	mov [si], al
	INC di
	INC si
	LOOP Copy
	POP AX
	POP cx
	POP si
	POP di
	CALL OpenFile
	CALL ReadHeader
	CALL ReadPalette
	CALL CopyPal
	CALL CopyBitMap
	CALL CloseFile
	
	POP cx
	RET
ENDP PrintBmp


;in PROC PrintBmp
PROC OpenFile
	mov ah,3Dh
	xor al,al ;for reading only
	mov dx, OFFSET filename
	INT 21h
	jc OpenError
	mov [filehandle],AX
	RET
OpenError:
	mov dx,OFFSET Errormsg
	mov ah,9h
	INT 21h
	RET
ENDP OpenFile

;in PROC PrintBmp
PROC ReadHeader
;Read BMP file header, 54 bytes
	mov ah,3Fh
	mov bx,[filehandle]
	mov cx,54
	mov dx,OFFSET Header
	INT 21h
	RET
ENDP ReadHeader

;in PROC PrintBmp
PROC ReadPalette
;Read BMP file color palette, 256 colors*4bytes for each (400h)
	mov ah,3Fh
	mov cx,400h
	mov dx,OFFSET Palette
	INT 21h
	RET
ENDP ReadPalette

;in PROC PrintBmp
PROC CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	mov si,OFFSET Palette
	mov cx,256
	mov dx,3C8h ;port of Graphics Card
	mov al,0 ;number of first color
	;Copy starting color to port 3C8h
	OUT dx,al
	;Copy palette itself to port 3C9h
	INC dx
PalLOOP:
	;Note: Colors in a BMP file are saved as BGR values rather than RGB.	
	mov al,[si+2] ;get red value
	SHR al,2 	; MAX. is 255, but video palette mAXimal value is 63. Therefore DIViding by 4
	OUT dx,al ;send it to port
	mov al,[si +1];get green value
	SHR al,2
	OUT dx,al	;send it
	mov al,[si]
	SHR al,2
	OUT dx,al 	;send it
	ADD si,4	;PoINT to next color (There is a null chr. after every color)
	LOOP PalLOOP
	RET
ENDP CopyPal

;in PROC PrintBmp
PROC CopyBitMap
; BMP graphics are saved upside-down.
; Read the graphic line by line ([height] lines in VGA format),
; displaying the lines from bottom to top.
	mov AX,0A000h ;value of start of video memory
	mov es,AX	
	PUSH AX
	PUSH bx
	mov AX, [imgWidth]
	mov bx, 4
	DIV bl
	
	CMP ah, 0
	jne NotZero
Zero:
	mov [adjustCX], 0
	JMP Continue
NotZero:
	mov [adjustCX], 4
	xor bx, bx
    mov bl, ah
	SUB [adjustCX], bx
Continue:
	POP bx
	POP AX
	mov cx, [imgHeight]	;reading the BMP data - upside down
	
PrintBmpLOOP:
	PUSH cx
	xor di, di
	PUSH cx
	DEc cx
	Multi:
		ADD di, 320
		LOOP Multi
	POP cx

    ADD di, [PrintADD]
	mov ah, 3fh
	mov cx, [imgWidth]
	ADD cx, [adjustCX]
	mov dx, OFFSET ScrLine
	INT 21h
	;Copy one line INTo video memory
	cld	;Cleardirection flag - due to the use of rep
	mov cx, [imgWidth]
	mov si, OFFSET ScrLine
	rep MOVsb 	;do cx times:
				;mov es:di,ds:si -- Copy single value form ScrLine to video memory
				;INC si --INC - because of cld
				;INC di --INC - because of cld
	POP cx
	LOOP PrintBmpLOOP
	RET
ENDP CopyBitMap

;in PROC PrintBmp
PROC CloseFile
	mov ah,3Eh
	mov bx,[filehandle]
	INT 21h
	RET
ENDP CloseFile



;-------------------------------------------------------------------------------------------------------------------PrintBmp-------------------------------------------------------------------------------------------------------------------------------;

;--------------------------------------------------RandomNumberGeneRETor---------------------------------------------------;
PROC RandomNumber
  mov BX, [NumberR]
  mov AX, 40h
  mov es, AX
Random:
  mov AX, [es:06ch]
  xor al, [byte cs:bx]
  and al, 00001111b
  mov dl, al
  ADD bx, AX
  CMP dl, 16
  JG Random
  CMP dl, 0
  JE Random
  mov [byte ptr NumberR], dl
  RET
ENDP RandomNumber

;--------------------------------------------------RandomNumberGeneRETor---------------------------------------------------;
PROC ClearDisplay
	CALL SwitchToGraphicsMode
	RET
ENDP ClearDisplay

PROC SwitchToGraphicsMode
    mov AX, 13h
    INT 10h
    
    RET
ENDP SwitchToGraphicsMode

PROC PSaucer
	PUSHA
	PUSH [startX]
	PUSH [startY]


	mov bx , [startXS]
	mov [startX], bx
	mov bx , [startYS]
	mov [startY] , bx 
	
	
	mov bh, [colorP0]
	mov al, [colorS0]
	mov [colorP0] , al
	mov bl, [colorP1]
	mov al, [colorS1]
	mov [colorP1] , al
	mov [DrawMode], 3
	CALL PrintP
	
	mov [colorP1], bl
	mov [colorP0], bh 
	mov [drawMode], 1
	POP [startY]
	POP [startX]
	POPA 
	RET
ENDP


PROC DSaucer
	PUSHA
	PUSH [startX]
	PUSH [startY]


	mov bx , [startXS]
	mov [startX], bx
	mov bx , [startYS]
	mov [startY] , bx 
	
	
	mov bh, [colorP0]
	mov [colorP0] , 0
	
	mov bl, [colorP1]
	mov [colorP1], 0
	
	
	
	mov [DrawMode], 3
	CALL PrintP
	mov [colorP1], bl
	mov [colorP0], bh 
	mov [drawMode], 1
	POP [startY]
	POP [startX]
	POPA 
	RET
ENDP


PROC PFloor
	PUSHA

	PUSH [startX]
	PUSH [startY]
	 ; drawing the floor 
	mov [colorP0] , 7
	mov bx, [startXF]
	mov [startX] , bx
	mov bx, [startYF]
	mov [startY] , bx
	mov [DrawMode] , 2	
	CALL PrintP	
	mov [DrawMode] , 1
    POP [startY]
	POP [startX]	
	mov [colorP0], 4

	POPA
	RET
ENDP PFloor

PROC DFloor
	PUSHA 

	PUSH [startX]
	PUSH [startY]
	mov [colorP0] , 0
	mov bx, [startXF]
	mov [startX] , bx
	mov bx, [startYF]
	mov [startY] , bx

	mov [DrawMode] , 2	
	CALL PrintP	
	mov [DrawMode] , 1
	
    POP [startY]
	POP [startX]	
	mov [colorP0], 4
	
	POPA
	RET
ENDP DFloor

PROC DisplayDot
    mov al, [colorR]
    mov bl, 0
    
    mov cx, [xR]
    mov dx, [yR]
    
    mov ah, 0Ch
    INT 10h

    RET
ENDP DisplayDot


PROC DisplayLine
    mov cx, [startXR]
    mov [xR], cx
    
DisplayDotLOOP:
    CALL DisplayDot
    INC [xR]
    
    mov cx, [endXR]
    INC cx
    CMP [xR], cx
    
    jne DisplayDotLOOP

    RET
ENDP DisplayLine



PROC DisplayRect
	PUSHA

    mov dx, [startYR]
    mov [yR], dx
    
DisplayLineLOOP:
    CALL DisplayLine
    INC [yR]
    
    mov dx, [endYR]
    INC dx
    CMP [yR], dx
    
    jne DisplayLineLOOP
	
	POPA
    RET
ENDP DisplayRect


;-----------------------------PrintP-------------------------------;

PROC PrintP  ; Print pictures with pixel images
	PUSHA 
	

	CMP [DrawMode]	, 1  ; draw mode 1 indictes SpaceShip 
	JE SpaceShip1
	
	CMP [DrawMode] , 2   ; draw mode 2 indictes Floor 
	JE Floor1
	
	CMP [DrawMode] , 3  ; draw mode 3 indictes saucer 
	JE Saucer1
	
	CMP [DrawMode] , 4  ; draw mode 4 indictes lights 
	JE Lights1
	
Saucer1:
	mov si , OFFSET Saucer
	JMP StartPrintP
SpaceShip1:
	mov si , OFFSET SpaceShip
	JMP StartPrintP
Floor1:
	mov si, OFFSET Floor
	JMP StartPrintP
Lights1:
	mov si, OFFSET lights
	JMP StartPrintP
	

StartPrintP:	

    PUSH CX
    PUSH DX
    mov CX, [startX]
    mov [pre_startX], CX
    mov DX, [startY]
    mov [pre_startY], DX
    POP DX
    POP CX

    mov AH,12  ;set the configuration to writing a pixel (0ch)
    mov BH,00  ;set the page number
    JMP show_next_pixel_SpaceShip

    show_next_pixel_SpaceShip:
	
        mov CX,[startX] ;set the line (x)
        mov DX, [startY] ;set the line (Y)
        mov bl, [si]

        CMP bl, 0  ;if b1 == 0
        JE Paint_pixel_SpaceShip ;jump to Paint_pixel

        CMP bl, 4  ;if b1 == 5
        JE Paint_pixel_SpaceShip1 ;jump to Paint_pixel


        CMP bl, 1  ;if b1 == 1
        JE skip_pixel_SpaceShip ;jump to skip_pixel

        CMP bl, 2  ;if b1 == 0
        JE next_row_SpaceShip ;jump to next_raw

        CMP bl, 3  ;if b1 == 3
        JE stop_show_pixel_SpaceShip ;jump to Paint_pixel

    skip_pixel_SpaceShip:
        ;INC [startX] ;x++
        INC [startX]
        INC si  ;si++
        JMP show_next_pixel_SpaceShip ;jump to show_next_pixel

	Paint_pixel_SpaceShip1:
		mov AL, [colorP1]
        INT 16  ;execute the configuration (10h)
        INC [startY]
        INT 16
        DEc [startY]
        INC si  ;si++
        INT 16
        INC [startY]
        INT 16
        DEc [startY]
        INC [startX]
        JMP show_next_pixel_SpaceShip ;jump to show_next_pixel
		
    Paint_pixel_SpaceShip:
		mov AL, [colorP0]
        INT 16  ;execute the configuration (10h)
        INC [startY]
        INT 16
        DEc [startY]
        INC si  ;si++
        INT 16
        INC [startY]
        INT 16
        DEc [startY]
        INC [startX]
        JMP show_next_pixel_SpaceShip ;jump to show_next_pixel

    next_row_SpaceShip:
        INC [startY]
        mov CX, [pre_startX]
        mov [startX], CX
        INC si  ;si++
        JMP show_next_pixel_SpaceShip ;jump to show_next_pixel

    stop_show_pixel_SpaceShip:
        mov CX, [pre_startX]
        mov [startX], CX

        mov DX, [pre_startY]
        mov [startY], DX

		POPA
        
		RET
ENDP

;-----------------------------PrintP-------------------------------;

;Deletes Pictures of PrintP function withOUT changing the colours.
;Uses the DrawMode Variable (what to Delete...) 
;---------------------------DeletePrintP----------------------------------;

PROC CollisionCheck 
	
	pop [temp]	
	pop [FirstObjectX]
	pop [FirstObjectY]
	pop [SecondObjectX]
	pop [SecondObjectY]
	;------Checks if Y values INTersect 
								; The top of the Saucer is 170.
		mov AX, [FirstObjectY]
		mov BX, [SecondObjectY] 		; The top of the SpaceShip.
		
		pop [TempLowest]
		ADD AX, [TempLowest] ; The lowest poINT of the SpaceShip is 14 pixels lower than the highest poINT.
		
		CMP AX, BX ; Checks if Ship lowestPoINT bellow Saucer highest poINT.
		JL POP_PAUSE_START ;JL because Y values start go Top-Down
		pop [TempLowest]
		ADD BX , [TempLowest] ; 8
		
		CMP [FirstObjectY], BX
		JG POP_PAUSE_Middle
		
		JMP POP_PAUSE_END
		POP_PAUSE_START:
		pop [TempLowest]
		
		POP_PAUSE_Middle:	
		pop [TempLowest]
		pop [TempLowest]
		
		JMP EndCollision
		POP_PAUSE_END:
	;------Checks if X values INTersect 
		mov AX, [FirstObjectX] ; X value of Ship start.
		mov BX, [SecondObjectX] ; X value of Saucer start.
		 
		 
		pop [TempLowest] 
		ADD AX, [TempLowest] ; X value of Ship End.
		pop [TempLowest] 
		ADD BX, [TempLowest] ; X value of Saucer End.

		;end of the ship inside saucer 
		CMP AX, [SecondObjectX]
		JL CollisionEndPause
		
		CMP AX, BX
		JL CollisionOccurred	
			
	CollisionEndPause:

		CMP [FirstObjectX], BX
		JG EndCollision

		mov BX, [SecondObjectX]
		CMP [FirstObjectX], BX
		JG CollisionOccurred			

		jmp EndCollision

	CollisionOccurred: 
	MOV [CollisionFlag] , 1

	EndCollision:

	push [temp] 
	ret 
ENDP CollisionCheck








PROC PPAUSEB
	push [startXR]
	push [endXR]
	push [startYR]
	push [endYR]
		
	mov cx, 2
	mov [startXR], 295
LOOPPAUSE:
	mov [StartYR], 5
	mov [endYR], 20
	mov BX, [startXR]
	mov [endXR], BX
	
	add [endXR], 5
	
	pusha
	
	call DisplayRect 
	
	popa
	
	add [startXR], 11
	
	LOOP LOOPPAUSE

	pop [startXR]
	pop [endXR]
	pop [startYR]
	pop [endYR]


	ret
ENDP PPAUSEB

PROC DPAUSEB
	push [startXR]
	push [endXR]
	push [startYR]
	push [endYR]
	mov al, [colorR]
	
	mov [startXR], 295
	mov [colorR], 0
	mov cx, 2
	
LOOPPAUSE1:
	mov [StartYR], 5
	mov [endYR], 20
	mov BX, [startXR]
	mov [endXR], BX
	
	add [endXR], 5
	
	pusha
	
	call DisplayRect 
	
	popa
	
	add [startXR], 11
	
	LOOP LOOPPAUSE1

	mov [colorR] , al
	pop [startXR]
	pop [endXR]
	pop [startYR]
	pop [endYR]


	ret
ENDP DPAUSEB


PROC Plights
	PUSHA
	PUSH [startX]
	PUSH [startY]


	mov bx , [startXS]
	mov [startX], bx
	mov bx , [startYS]
	mov [startY] , bx 
	
	SUB [startX], 1
	ADD [startY], 10
	
	
	mov bh, [colorP0]
	mov al, [colorS0]
	mov [colorP0] , al
	mov bl, [colorP1]
	mov al, [colorS1]
	mov [colorP1] , al
	mov [DrawMode], 4
	CALL PrintP
	
	mov [colorP1], bl
	mov [colorP0], bh 
	mov [drawMode], 1
	POP [startY]
	POP [startX]
	POPA 
	RET

	ret
ENDP Plights

PROC Dlights

	PUSHA
	PUSH [startX]
	PUSH [startY]


	mov bx , [startXS]
	mov [startX], bx
	mov bx , [startYS]
	mov [startY] , bx 
	SUB [startX], 1
	ADD [startY], 10
	
	
	mov bh, [colorP0]
	mov [colorP0] , 0
	
	mov bl, [colorP1]
	mov [colorP1], 0
	
	
	
	mov [DrawMode], 4
	CALL PrintP
	mov [colorP1], bl
	mov [colorP0], bh 
	mov [drawMode], 1
	POP [startY]
	POP [startX]
	POPA 
	RET




	ret
ENDP Dlights

PROC DeletePrintP
	PUSHA
	
	mov bh , [colorP0]
	mov bl , [colorP1]

	mov [colorP0], 0
	mov [colorP1], 0

	CALL PrintP
	
	mov [colorP0], bh
	mov [colorP1], bl
	POPA 
	RET 
ENDP 


;--------------------------DeletePrintP----------------------------------;


;----------------------MoveSpaceShip----------------------------;

;----------------------MoveUp
PROC MoveUp
    CMP [startY], 3
    JE EndMoveUp
	
	CALL DeletePrintP
	mov [colorR], 0
	mov BX,[VelocityJumpUP]
    SUB [startY], BX  
    CALL PrintP
	
	mov [colorR], 3
  EndMoveUp:
    RET
ENDP MoveUp

;----------------------MoveDown
PROC MoveDown	
  	mov [colorR], 0
 	CALL DeletePrintP
	mov BX,[VelocityJumpDOWN]
    ADD [startY], BX 
    CALL PrintP
	
	mov [colorR], 3
  EndMoveDown:
    RET
ENDP MoveDown

;----------------------MoveRight


proc PrintStars
		mov cx, [StarsCounter]
		PUSH [startXR]
		PUSH [startYR]
		PUSH [endXR]
		push [endYR]
		mov bx , offset StarsArr
		MOV dh , [colorR]
	LoopStars:
		MOV AX,[bx]
		MOV [startXR], ax
		MOV AX , [startXR]
		MOV [endXR], AX
		add [endXR],2
		
		MOV ax, [bx +2]
		MOV [startYR],ax
		MOV AX , [startYR]
		MOV [endYR], AX
		add [endYR], 2
		MOV [colorR], 15
		
		Call DisplayRect
		add bx, 4
		
		loop LoopStars
		MOV [colorR] , dh
		pop [endYR]
		pop [endXR]
		pop [startYR]
		pop [startXR]
	ret 
ENDP PrintStars 




PROC MoveRight

	CMP [startX], 260
    JG EndMoveRight
	
	mov [colorR], 0
	CALL DeletePrintP
	
	mov BX,[VelocitySpaceShip]
    ADD [startX], BX
    CALL PrintP
	
	mov [colorR], 3
  EndMoveRight:
    RET
ENDP MoveRight

;----------------------MoveLeft

PROC MoveLeft
	MOV BX , [startX] 
	SUB BX , [VelocitySpaceShip]
    CMP BX, 0
    JL EndMoveLeft
	
	CALL DeletePrintP
	mov [colorR], 0

	mov BX,[VelocitySpaceShip]
    SUB [startX], BX
    CALL PrintP
	
	mov [colorR], 3

  EndMoveLeft:
    RET
		
ENDP MoveLeft

;----------------------MoveSpaceShip----------------------------;

;-----------------------JumpSection--------------------------;

PROC Jump
	CMP [JumpUp], 0
	JLE JumpDown1
JumpUp1:
	CALL MoveUp
	mov BX, [VelocityJumpUP]
	SUB [JumpUp], BX
JMP EndJump

JumpDown1:
	CALL MoveDown
	mov BX, [VelocityJumpDOWN]
	SUB [JumpDown],BX
	
	CMP [JumpDown], 0
	JG EndJump	
	mov [JumpFlag], 0
EndJump:
	RET
ENDP Jump


;-----------------------JumpSection--------------------------;


;-----------------------------------------------------------------RestSettings----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
PROC ResetAll
	pusha
	CALL ResetPara
	CALL ResetParaNext
	popa 
	RET
ENDP ResetAll


PROC ResetPara
	pusha
	
	cmp [GameMode], 2
	JE FinishResetPara
	
	mov [LevelVelocitySpaceShip] , 6
	mov [VelocityJumpUP] , 6
	mov [VelocityJumpDOWN]  , 3
	mov [LeveLVelocityS], 8
	mov [LeveltimeS], 20
	mov [LevelGameLength], 250
	mov [LevelNumber] , 1
	mov [LevelVelocityF], 4
	mov [BulletVelocity] , 2 
	mov [StartTimeS] , 0
	JMP FinishResetPara
	
	FinishResetPara:
	popa 
	RET
ENDP ResetPara


PROC ResetParaNext
	pusha 
;Regular Variables 
	mov [BulletStartX] , 0
	mov [BulletStartY] , 0
	mov [BulletStartY1] , 0
	mov [BulletStartX1] , 0
	mov [BulletFlag] , 0	
	mov [BulletFlag1] , 0
	mov [StartTimeS] , -1
	mov [startXS] , 280
	mov [startYS] , 160	
	mov [TimeVaribleS] ,0
	mov [TimeVaribleMs] ,0
	mov [startXF], 320
	mov [JumpFlag] , 0
	mov [SaucerFlag], 0
	mov [startX], 0   
    mov [startY], 167 ; variable used when checking the time 
	mov [DrawMode], 1 
	mov [JumpUp] , 60 
	mov [JumpDown] , 60 
	mov [StartTimeMs], 0
	mov [startXSS] , 0
	mov [startYSS] , 40 
	mov [WonActive], 0
	mov [colorS0], 3
	mov [colorS1] , 14
	mov [ShootingSaucerFlag], 0
;Level Related Variables Section 

	mov BX, [LeveltimeS]
	mov [timeS], BX
	mov BX, [LeveLVelocityS]
	mov [VelocityS], BX
	mov BX, [LevelGameLength]
	mov [GameLength], BX
	mov BX, [LevelVelocityF]
	mov [VelocityF] , BX
	mov BX, [LevelVelocitySpaceShip]
	mov [VelocitySpaceShip] , BX
	
	CMP [LevelNumber],1
	JL SkipShootingSaucerFlag
	mov [ShootingSaucerFlag],1
	SkipShootingSaucerFlag:
	
	popa 
	RET
ENDP ResetParaNext
	
	

PROC NextLevel
	mov [StartTimeS] , 0
	INC [LevelNumber]
	add [LevelGameLength], 120
	
	Cmp [LeveltimeS], 8
	JLE SkipLeveltimeS
	sub [LeveltimeS] , 1
	SkipLeveltimeS:
	
	Cmp [LeveLVelocityS], 16
	JGE SkipLeveLVelocityS
	add [LeveLVelocityS], 1
	SkipLeveLVelocityS:
	
	
	Cmp [BulletVelocity],  8
	JGE SkipBulletVelocity
	add [BulletVelocity], 1
	SkipBulletVelocity:
	
	Cmp [LevelVelocitySpaceShip], 16
	JGE SkipLevelVelocitySpaceShip
	add [LevelVelocitySpaceShip], 1
	SkipLevelVelocitySpaceShip:
	
	Cmp [LevelVelocityF], 20
	JGE SkipLevelVelocityF
	add	[LevelVelocityF] , 1
	SkipLevelVelocityF:

	Call ResetParaNext
	
	ret
ENDP NextLevel

PROC PrintTimer
	pusha

	mov [SET_COLUMN] , 00h
	mov [SET_ROW] , 02h
	mov [temp] , 6
	push [temp]
	push offset TEXT_TIMER
	push [StartTimeS]
	call NUMBER_STDOU	
	
	popa 
	ret 
ENDP PrintTimer
;-----------------------------------------------------------------RestSettings----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;


;---------------------------------------------------------------------------------------MainGame-----------------------------------------------------------------------------------------;



;--------------------loading the Game--------------------------;
PROC MainGame
	
BeforeMenuScreen:
	CALL ResetAll   ; reset all para  
	mov [PrintMode] , 2
	CALL PrintBmp ; print the menu screen image 
		
MenuScreen:
	; menu screen keyboard loop and options 
	mov ah, 1
    INT 16h
    JZ MenuScreen
	
    mov ah, 0
    INT 16h
 
	CMP ah, 21h
    JE CALLRulesMenu
	
	CMP ah, 1Fh
    JE CALLStart	
	
	CMP ah, 20h   
	JE CALLDifficultyMenu
	
	CMP ah, 1h   
	JE CALLEndGame
	
    
	JMP MenuScreen

	CALLRulesMenu:
		CALL ClearDisplay
		mov [PrintMode], 0
		CALL PrintBmp
	
	RulesKeyBoard:
		;CALL ShowRulesScreen
		mov ah, 1
		INT 16h
		JZ RulesKeyBoard
		mov ah, 0
		INT 16h
		
		CMP ah, 1h
		JE BeforeMenuScreen

		JMP RulesKeyBoard
		
	CALLStart: ; starts the game on story mode 
		mov [GameActive],1  
		CALL ClearDisplay
		JMP StartMainGame
		
		JMP MenuScreen
		
	CALLDifficultyMenu: ; choose mode 
		CALL ClearDisplay
		mov [PrintMode], 5
		CALL PrintBmp
		
		KeyboardModeLoop:  ; choose mode keyboard loop 
		
		mov ah, 1
		INT 16h
		JZ KeyboardModeLoop
		mov ah, 0
		INT 16h
		
		
		CMP ah, 1h
		JE BeforeMenuScreen ; ESC to go back 
		
		CMP ah, 1fh    ; 's' for story mode 
		JE storyMode
		
		CMP ah, 17h   
		JE infintyMode  ; 'i' for infinity mode  
		
		JMP KeyboardModeLoop

		storyMode:
			call ResetAll
			Mov [GameMode], 1  
			
			JMP KeyboardModeLoop
		infintyMode:
			MOV CX,100
			lEVELlOOP:
				CALL NextLevel 
				loop lEVELlOOP
			Mov [GameMode], 2
			

		JMP KeyboardModeLoop
		

;------------------------MainMenu---------------------------------;

;--------------------loading the Game--------------------------;


StartMainGame:
	CALL ClearDisplay ; clearing the screen 
	CALL PrintP   ; Printing the spaceship.
	mov [colorR], 3
	CALL PrintTimer
	CALL PFloor ; drawing the floor
	
	mov [SET_COLUMN] , 00h
	mov [SET_ROW] , 00h
	push offset TEXT_PAUSE ; printing pause buttons options 
	CALL STDOU
	
;----------------------------------------------------PrintingLevel	
	cmp [GameMode], 2
	JE InfintyLevelStarted ; if it's infinity mode print a different entry sign
	
	; prints regular level screen entry sign  
	mov [SET_COLUMN] , 07h
	mov [SET_ROW] , 06h	
	mov [temp], 18
	push [temp] 
	push offset TEXT_LEVEL_STARTED
	push [levelNumber]
	call NUMBER_STDOU
	
;----------------------------------------------------PrintingLevel	
	JMP MainGameLOOP
	
InfintyLevelStarted:
	mov [SET_COLUMN] , 07h
	mov [SET_ROW] , 06h
	push offset TEXT_INFINTY_LEVEL_STARTED
	CALL STDOU		
	
MainGameLOOP:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINTING

	

; skipCollision

	CMP [GameActive] , 0
	JE LostScreenOptions
	
	CMP [WonActive], 1
	JNE PrintLightsSkip
	
	Call Plights
	JMP TimeSection
	
PrintLightsSkip:
;--------------------------------------------------------------GameSection
;-----------------------Collision Detection with SpaceShip ( for the time being it will finish the game )
	mov [CollisionFlag], 0
	Cmp [SaucerFlag] ,0 
	Je SkipCollisionWithSaucer

	push 36 
	push 38
	push 8
	push 13
	push [startYS]
	push [startXS]
	push [startY]
	push [startX] 
	call CollisionCheck

	SkipCollisionWithSaucer:
	
	push 36 
	push 2
	push 14
	push 2
	push [startY]
	push [startX]
	push [BulletStartY]
	push [BulletStartX] 
	call CollisionCheck

	push 36 
	push 2
	push 14
	push 2
	push [startY]
	push [startX]
	push [BulletStartY1]
	push [BulletStartX1] 
	call CollisionCheck
	
	
	cmp [CollisionFlag], 1
	JE CALLLostScreen


	;------------------------TimeSection------------------------------;S
	TimeSection:
		mov ah, 2ch ;get the system time 
		INT 21h
		
		
		CMP DH, [TimeVaribleS]  ; checking if 1 sec has passed IF FALSE jumps to keyboard section.
		JE SkipSecond   ; is the current time equal to the pervious time 
		mov [TimeVaribleS], DH
		
		
		
		CMP [WonActive], 1
		JE SkipSecond
		
		CMP [WonActive], 2
		JE SkipSecond
		
		
		inc [StartTimeS]
		
		CMP [StartTimeS] , 3
		JNE SkipDeletingLevelN
		; delete the start level screen 
			PUSH [startXR]
			PUSH [startYR]
			PUSH [endXR]
			push [endYR]
			MOV bh , [colorR]
			
			MOV [startXR], 30
			MOV [endXR], 300
			MOV [endYR] , 60
			MOV [startYR],45
			MOV [colorR], 0
			
			Call DisplayRect
			
			MOV [colorR] , bh
			pop [endYR]
			pop [endXR]
			pop [startYR]
			pop [startXR]
		
		SkipDeletingLevelN:
		
		CALL PrintTimer	
		SkipSecond:
		CMP DL, [TimeVaribleMs]  ; checking if 1/100 sec has passed IF FALSE jumps to keyboard section.
		JE KeyBoard   ; is the current time equal to the pervious time 
		mov [TimeVaribleMs], DL
		INC [StartTimeMs]
			
		call PrintStars
		
		Mov [PrintMode], 1
		Call PrintP
		
			CMP [WonActive], 2
			JE SpaceShipUpW

			CMP [startYS], 100
			JL WonStart1
			
			CMP [WonActive], 1
			JE FloorSkip

			CMP [StartXS], 9
			JG SkipWonToShootingSaucer
			
			mov BX, [GameLength]
			CMP [StartTimeMs], BX
			JL SkipWonToShootingSaucer
		
		
			JMP WonStart
		
			SpaceShipUpW:	; moves the spaceship if he presses E below the savior . 

				mov [DrawMode], 1
				Call MoveUp
				CALL Plights
				CMP [startY], 105
				JL WinScreen
				


				JMP TimeSection

				
			WonStart:   ;what happens if he gets to the end 
				CALL DSaucer
				mov [startYS], 40
				mov BX, [startXSS]
				mov [startXS], BX
				CALL DSaucer

				mov [SaucerFlag], 0
				mov [startYS], 0  
				mov [startXS], 160 ; setting the X Y of the Saver (saucer)
				mov [WonActive], 1  ; activating won mode 
				

				
			WonStart1:  ; displaying the saver
				
				; printing the savior coming down 

				mov [colorS0], 14  ; main body color 
				mov [colorS1] , 2  ; secondry c

				SUB [startYS] ,  3 

				CALL DSaucer  
				CALL Dlights	
				ADD [startYS] ,  3
				
				CALL PSaucer	
				CALL Plights
				ADD [startYS] ,  3
				
				
				CMP [startYS], 32  ; show story when the savior starts coming down 
				JG SaverMessage
				JMP ASaverMessage 
				
				SaverMessage: ; Story Mode of The Game
				mov [SET_COLUMN] , 02h
				mov [SET_ROW],  04h
				cmp [LevelNumber], 1
				JE Story1	
				cmp [LevelNumber], 2
				JE Story2	
				cmp [LevelNumber], 3
				JE Story3	
				cmp [LevelNumber], 4
				JE Story4	
				cmp [LevelNumber], 5
				JE Story5	
				cmp [LevelNumber], 6
				JE Story6	
				cmp [LevelNumber], 7
				JE Story7	
				cmp [LevelNumber], 8
				JE Story8	
				cmp [LevelNumber], 9
				JE Story9	
				cmp [LevelNumber], 10
				JE Story10	
				cmp [LevelNumber], 11
				JE Story11	
				cmp [LevelNumber], 12
				JE Story12	
				cmp [LevelNumber], 13
				JE Story13	
				cmp [LevelNumber], 14
				JE Story14	
				cmp [LevelNumber], 15
				JE Story15	
				cmp [levelNumber], 15
				JG Story16
					
				Story1:
					push offset STORY_TEXT1
					call STDOU
					JMP ASaverMessage
				Story2:
					push offset STORY_TEXT2
					call STDOU
					JMP ASaverMessage
				Story3:
					push offset STORY_TEXT3
					call STDOU
					JMP ASaverMessage
				Story4:
					push offset STORY_TEXT4
					call STDOU
					JMP ASaverMessage
				Story5:

					push offset STORY_TEXT5
					call STDOU
					JMP ASaverMessage
				Story6:
					push offset STORY_TEXT6
					call STDOU
					JMP ASaverMessage
				Story7:
					push offset STORY_TEXT7
					call STDOU
					JMP ASaverMessage
				Story8:
					push offset STORY_TEXT8
					call STDOU
					JMP ASaverMessage
				Story9:
					push offset STORY_TEXT9
					call STDOU
					JMP ASaverMessage
				Story10:
					push offset STORY_TEXT10
					call STDOU
					JMP ASaverMessage
				Story11:
					push offset STORY_TEXT11
					call STDOU
					JMP ASaverMessage
				Story12:
					push offset STORY_TEXT12
					call STDOU
					JMP ASaverMessage
				Story13:
					push offset STORY_TEXT13
					call STDOU
					JMP ASaverMessage
				Story14:
					push offset STORY_TEXT14
					call STDOU
					JMP ASaverMessage
				Story15:
					push offset STORY_TEXT15
					call STDOU
					JMP ASaverMessage
				Story16:
					push offset STORY_TEXT16
					call STDOU
					JMP ASaverMessage

;---------------------------------------------------------------------------------------------------BADLY OPTIMIZED
				
			ASaverMessage:	
				
				CMP [startYS], 100
				JL FloorSkip ; if savior was printed make the floor stop
				JMP KeyBoard
				
				
				

			

;-----------------------------Saucer----------------------------; 
;/////////////////////////////////////////////////////////////////
;--------------------------Displaying the Saucer ( Printing and Deleting ) 
	SkipWonToShootingSaucer:
		CMP [ShootingSaucerFlag], 1
		JNE SkipShootingSaucer
		
		CMP [StartTimeMs], 80 
		JL SkipShootingSaucer
		
		CMP [startYSS],5
		JL DeleteSS
		
		mov BX , [GameLength]
		SUB BX , [StartTimeMs]
		CMP BX, 40
		JL GoUpSS
		
		mov BX , [startX]
		CMP [startXSS], BX
		JE PrintSS
		
		
		mov BX , [startX]
		CMP [startXSS], BX
		JL GoRightSS
		
		CMP [startXSS], BX
		JE skiptoBullet
		
		JMP GoLeftSS
	
		
	PrintSS:
		PUSH [startYS]
		PUSH [startXS]
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX, [startXSS]
		mov [startXS], BX
		CALL PSaucer
		POP [startXS]
		POP [startYS]
		
		
		JMP skiptoBullet
		
	DeleteSS:
		PUSH [startYS]
		PUSH [startXS]
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX, [startXSS]
		mov [startXS], BX
		CALL DSaucer
		
		mov [SET_COLUMN] , 00h
		mov [SET_ROW] , 00h
		push offset TEXT_PAUSE
		CALL STDOU
		
		;CALl PrintTimer
		
		POP [startXS]
		POP [startYS]
		
		
		JMP skiptoBullet
	GoUpSS:
		PUSH [startYS]
		PUSH [startXS]
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX, [startXSS]
		mov [startXS], BX
		CALL DSaucer
		
		mov BX , [VelocitySpaceShip] 
		SUB [startYSS], BX 
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX ,[startXSS]
		mov [startXS], BX
		 ; Speed of the Saucer ( Changes How much it Moves EachTime - 4 pixels every 1/100s ) 
		CALL PSaucer
		
		mov [SET_COLUMN] , 00h
		mov [SET_ROW] , 00h
		push offset TEXT_PAUSE
		CALL STDOU
		
		CALL PrintTimer

		
		POP [startXS]
		POP [startYS]
		
		
		JMP skiptoBullet
	
	GoLeftSS:
		PUSH [startYS]
		PUSH [startXS]
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX, [startXSS]
		mov [startXS], BX
		CALL DSaucer
		mov BX , [VelocitySpaceShip] 
		SUB [startXSS], BX 
		
		mov BX ,[startXSS]
		mov [startXS], BX
		 ; Speed of the Saucer ( Changes How much it Moves EachTime - 4 pixels every 1/100s ) 
		CALL PSaucer
		
		POP [startXS]
		POP [startYS]
		
		
		JMP skiptoBullet
	
	GoRightSS:
	
		PUSH [startYS]
		PUSH [startXS]
		mov BX, [startYSS]
		mov [startYS], BX
		mov BX, [startXSS]
		mov [startXS], BX
		CALL DSaucer
		
		mov BX, [VelocitySpaceShip] 
		ADD [startXSS], BX 
		
		mov BX ,[startXSS]
		mov [startXS], BX
		 ; Speed of the Saucer ( Changes How much it Moves EachTime - 4 pixels every 1/100s ) 
		CALL PSaucer
		
		POP [startXS]
		POP [startYS]
	
	skiptoBullet:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Shooting Bullet 

		
	CMP [StartTimeMs], 100
	JL StartS2
	
	CMP [BulletFlag], 1
	JE Shooting
	
	mov BX , [GameLength]
	SUB BX , [StartTimeMs]
	CMP BX, 40
	JL Shooting
	
	
	resetBullet:
		mov [BulletFlag], 1
		mov bx , [startYSS]
		mov [BulletStartY] , BX
		add [BulletStartY], 16
		mov bx , [startXSS]
		mov [BulletStartX] , BX
		add [BulletStartX], 16
	Shooting:	
		MOV BX , [BulletVelocity]
		SUB [BulletStartY] , BX
		
		PUSH [startXR]
		PUSH [startYR]
		PUSH [endXR]
		push [endYR]
		MOV ch , [colorR]
		
		MOV BX , [BulletStartX]
		MOV [startXR], BX
		MOV [endXR], BX
		ADD [endXR], 2
		
		MOV BX , [BulletStartY]
		MOV [startYR],BX
		MOV [endYR] , BX 
		ADD [endYR] ,3 
		MOV [colorR], 0
		
		Call DisplayRect
		
		MOV [colorR] , ch
		pop [endYR]
		pop [endXR]
		pop [startYR]
		pop [startXR]	
		
		CMP [BulletStartY], 195
		JL Shooter1


		mov BX , [GameLength]
		SUB BX , [StartTimeMs]
		CMP BX, 40
		JL StartS2
	

		Shooter1:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV BX , [BulletVelocity]
		add [BulletStartY] ,BX
		
		PUSH [startXR]
		PUSH [startYR]
		PUSH [endXR]
		push [endYR]
		MOV ch , [colorR]
		
		MOV BX , [BulletStartX]
		MOV [startXR], BX
		MOV [endXR], BX
		ADD [endXR], 2
		
		MOV BX , [BulletStartY]
		MOV [startYR],BX
		MOV [endYR] , BX 
		ADD [endYR] ,3 
		MOV [colorR], 9
		
		Call DisplayRect
		
		MOV [colorR] , ch
		pop [endYR]
		pop [endXR]
		pop [startYR]
		pop [startXR]	
		MOV BX , [BulletVelocity]
		add [BulletStartY] ,BX
		
		CMP [BulletStartY], 195
		JL StartS2
	
		MOV [BulletFlag], 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Shooting Bullet 
	StartS2:	
	
	
	CMP [StartTimeMs], 115
	JL SkipShootingSaucer
	
	CMP [BulletFlag1], 1
	JE ShootingS
	
	mov BX , [GameLength]
	SUB BX , [StartTimeMs]
	CMP BX, 40
	JL ShootingS
	
	
	resetBulletS:
		mov [BulletFlag1], 1
		mov bx , [startYSS]
		mov [BulletStartY1] , BX
		add [BulletStartY1], 16
		mov bx , [startXSS]
		mov [BulletStartX1] , BX
		add [BulletStartX1], 16
	ShootingS:	
		MOV BX , [BulletVelocity]
		SUB [BulletStartY1] , BX
		
		PUSH [startXR]
		PUSH [startYR]
		PUSH [endXR]
		push [endYR]
		MOV ch , [colorR]
		
		MOV BX , [BulletStartX1]
		MOV [startXR], BX
		MOV [endXR], BX
		ADD [endXR], 2
		
		MOV BX , [BulletStartY1]
		MOV [startYR],BX
		MOV [endYR] , BX 
		ADD [endYR] ,3 
		MOV [colorR], 0
		
		Call DisplayRect
		
		MOV [colorR] , ch
		pop [endYR]
		pop [endXR]
		pop [startYR]
		pop [startXR]	
		
		CMP [BulletStartY1], 195
		JL Shooter1S

		mov BX , [GameLength]
		SUB BX , [StartTimeMs]
		CMP BX, 40
		JL SkipShootingSaucer
	

		Shooter1S:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		MOV BX , [BulletVelocity]
		add [BulletStartY1] ,BX
		
		PUSH [startXR]
		PUSH [startYR]
		PUSH [endXR]
		push [endYR]
		MOV ch , [colorR]
		
		MOV BX , [BulletStartX1]
		MOV [startXR], BX
		MOV [endXR], BX
		ADD [endXR], 2
		
		MOV BX , [BulletStartY1]
		MOV [startYR],BX
		MOV [endYR] , BX 
		ADD [endYR] ,3 
		MOV [colorR], 9
		
		Call DisplayRect
		
		MOV [colorR] , ch
		pop [endYR]
		pop [endXR]
		pop [startYR]
		pop [startXR]	
	
		MOV BX , [BulletVelocity]
		add [BulletStartY1] ,BX
		
		CMP [BulletStartY1], 195
		JL SkipShootingSaucer
	
		MOV [BulletFlag1], 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	SkipShootingSaucer:
		
		CMP [SaucerFlag], 1
		JE MoveSaucer
		SUB [timeS], 1
		CMP [timeS], 0
		JE MoveSaucer
		JMP SkipSaucer
	
	MoveSaucer:
		mov [SaucerFlag], 1 ; Flaging Saucer
		mov BX, [VelocityS] ; velocity of saucer
		CMP [startXS], BX  ; Saucer will Dissappear based on its Speed 
		JL CreateNewSaucer ; If saucer is in Near End of Screen make it Dissappear.

		CALL DSaucer
		mov BX , [VelocityS] 
		SUB [startXS], BX  ; Speed of the Saucer ( Changes How much it Moves EachTime - 4 pixels every 1/100s ) 
		CALL PSaucer

		JMP SkipSaucer

	CreateNewSaucer:
		CALL DSaucer
		mov [SaucerFlag], 0
		mov [startXS], 280
		mov [startYS], 150
		mov BX, [NumberR]
		
		SHL BX, 1
		

		ADD [startYS], BX
		; setting the limit for the RandomNumberGeneRETor 
		 ; generate Random number 
		mov AX, [LeveltimeS]
		mov [timeS], AX
		SHL BX, 1
		ADD [timeS], BX; setting the Random number as Delay time between saucers
		mov [NumberR], 0
		JMP SkipSaucer
	
	SkipSaucer:
	;-----------------------------Saucer----------------------------; 
	;//////////////////////////////////////////////////////////////// 	
	;-----------------------------Floor----------------------------; 

		 ; deleting the floor the floor 

		CALL DFloor
		mov BX , [VelocityF]
		SUB [startXF], BX ; MOVing the floor ( MOVing VelocityF pixels every 1/100s )
		
		; drawing the new floor
		CALL PFloor
		CMP [startXF] , 0 ; if the floot did a full circle jump back to start 
		JG FloorSkip
		mov [startXF], 320
		
	;------------------------FloorRest

		mov [StartYF] , 185
		CALL   DFloor
		mov [StartYF] , 190
		CALL   PFloor
		FloorSkip:	
	;-----------------------------Floor----------------------------; 
		
		CMP [JumpFlag], 0 ; if Jumping CALL Jump
		JE KeyBoard ; CALLing Jump function 


		CALLJumpA:
				CALL Jump
;------------------------TimeSection------------------------------;E

;-------------------------------------KEYBOARD
	KeyBoard:	
		; main game keyboard loop 
		CMP [WonActive], 2
		JE TimeSection

		mov ah, 1
		INT 16h
		JZ MainGameLOOP
		mov ah, 0
		INT 16h
	 
		CMP ah, 1h    ; checks if ESC is pressed 
		JE PauseGame
	 
		CMP ah, 1Eh
		JE CALLMoveLeft       ; checks if A is pressed
		
		CMP ah, 20h
		JE CALLMoveRight	; checks if the D key is pressed 
			
		CMP ah, 12h         ; checks if E key is pressed ( WON OR SHoot )
		JE CALLWONorShoot
		
		CMP [JumpFlag], 1
		JE MainGameLOOP
		
		CMP ah, 39h   ; checks if Space is pressed 
		JE CALLJump
	
		JMP MainGameLOOP
		
		
		PauseGame: ; PAUSE BUTTON LOOP 
			CALL PPAUSEB
				mov ah, 1
				INT 16h
				JZ PauseGame
				
				mov ah, 0
				INT 16h
			
				CMP ah, 23h   
				JE DeletePause
				
				JMP PauseGame
			
			DeletePause:
				call DPAUSEB
	
			JMP MainGameLOOP
		
		CALLWONorShoot: ; Shoot or WinScreen According to the Place On screen and mode (WonActive -1 for WinScreen)
			CMP [startYS], 100 ; if the saver didn't come down enough don't allow E.
			JL Shoot
			CMP [startX], 150
			JL Shoot
			CMP [startX], 165
			JG Shoot
			CMP [WonActive], 1
			JNE Shoot
			mov [WonActive], 2
			JMP TimeSection
			Shoot:
			
			JMP MainGameLOOP 
		
		CALLMoveLeft: ;MOVE THE SHIP LEFT 
			CALL RandomNumber
			CALL MoveLeft
			
			JMP MainGameLOOP
		
		CALLMoveRight: ;MOVE THE SHIP Right 
			CALL RandomNumber
			CALL MoveRight
			
			JMP MainGameLOOP
		
		CALLJump: ;calls jump and activates the jump flag 
			CALL RandomNumber
			mov [JumpFlag], 1
			mov [JumpDown],48
			mov [JumpUp], 48
			CALL Jump
			
			JMP MainGameLOOP

	
;---------------------------------WinScreen------------------------------------;s
	WinScreen:
		;cmp [LevelNumber] ,15
;----------------------------------------	secret 
		;JL TaylorSwiftIsMine   
		;mov [PrintMode], 6
		;call PrintBmp
		;mov ah, 1h  ; press anybutton to start main game
		;INT 21h
		;TaylorSwiftIsMine:
;----------------------------------------   secret 
		call ClearDisplay
		mov [PrintMode], 4
		CALL PrintBmp   ; prints win screen 
			
		; prints level which level the player just completed 
		mov [SET_COLUMN] , 06h
		mov [SET_ROW] , 04h
		mov [temp], 13
		push [temp]
		push offset TEXT_LEVEL_COMPLETED
		push [LevelNumber]
		call NUMBER_STDOU
			

		WinScreenOptions:   ; Win screen keyboard options loop 
		
			xor ax , ax
			mov ah, 1
			INT 16h
			JZ WinScreenOptions
			mov ah, 0
			INT 16h
		
			
		
			CMP ah, 1h 
			JE CALLEndGame ; Press ESC to Exit Game uses terminate macro from the Lost screen options			
			
			CMP ah, 13h
			JE NextLevelRestart ; press R to restart game uses the label of the call lost screen (will keep the settings )
			
			CMP ah, 10h
			JE CALLMenu ; press Q to Jump to menu ( uses the label of the call lost screen ) 
			
			CMP ah, 31h ; press N to continue to NextLevel
			JE CallNextLevel

			JMP WinScreenOptions
			
		CallNextLevel:  ; calls next levels and jumps back to StartMainGame
			mov [GameActive], 1
			call NextLevel
			JMP StartMainGame
		
		NextLevelRestart:
			CALL ResetParaNext
			mov [GameActive], 1
			JMP StartMainGame			
;---------------------------------WinScreen------------------------------------;E


;-------------------------LostScreen--------------------------------;S
; This part checks if he broke the record in story mode 
	CALLLostScreen: 
		CMP [GameMode] , 2
		JE InfintyLevelBreakRecord
		
		MOV BX , [HighestLevel]
		CMP [LevelNumber], BX
		JL  DidntBreakRecord
		
		MOV BX, [LevelNumber]
		MOV [HighestLevel],BX
		JMP DidntBreakRecord
		
	
	InfintyLevelBreakRecord:
; This part checks if he broke the record in infinity mode 
	
		MOV BX , [HighestTime]
		CMP [StartTimeS], BX
		JL  DidntBreakRecord
		
		MOV BX, [StartTimeS]
		MOV [HighestTime],BX
	
	
DidntBreakRecord:
		mov [PrintMode], 3
		CALL PrintBmp
	
	
	cmp [GameMode], 2
	JE SkipHereIfHighLevel
;----------------------------------------------------
;Prints current level in lost screen 	
			
	mov [SET_COLUMN] , 01h
	mov [SET_ROW] , 02h
	mov [temp], 13
	push [temp] 
	push offset TEXT_LEVEL_LOST
	push [LevelNumber]
	CALL NUMBER_STDOU			
			
;----------------------------------------------------		
;Prints Highest level in lost screen 	

	mov [SET_COLUMN] , 01h
	mov [SET_ROW] , 04h	
	mov [temp], 15
	push [temp] 
	push offset TEXT_HIGHEST_LEVEL
	push [HighestLevel]
	CALL NUMBER_STDOU
			
	JMP SkipHereIfStoryMode
;----------------------------------------------------		
SkipHereIfHighLevel:

;Prints current level in lost screen 	
	
	mov [SET_COLUMN] , 01h
	mov [SET_ROW] , 02h
	mov [temp], 13
	push [temp] 
	push offset  TEXT_LEVEL_CURRENT_TIME
	push [StartTimeS]
	call NUMBER_STDOU
			
;----------------------------------------------------
;Prints Highest Time in lost screen 	

	mov [SET_COLUMN] , 01h
	mov [SET_ROW] , 04h
	mov [temp], 15
	push [temp] 
	PUSH offset TEXT_HIGHEST_TIME
	push [HighestTime]
	call NUMBER_STDOU	
		
	
		
SkipHereIfStoryMode:	
		
		mov [GameActive], 0
		LostScreenOptions:
			
			mov ah, 1
			INT 16h
			JZ MainGameLOOP
		   
			mov ah, 0
			INT 16h
			
			CMP ah, 1h
			JE CALLEndGame

			CMP ah, 13h
			JE CALLRestart
			
			CMP ah, 10h
			JE CALLMenu

			JMP MainGameLOOP

				CALLRestart:
					CALL ResetAll   
					mov [GameActive], 1
					JMP StartMainGame
					
				CALLEndGame:
					terminate  ; terminate macro ( switches to text mode and exits program ) 

				CALLMenu:   ; clears screen and jumps to menu part 
					CALL ClearDisplay 
					JMP BeforeMenuScreen   
	
	
	
;-------------------------LostScreen--------------------------------;E
ENDP MainGame



PROC MainRonGLozmanisMyName 
    CALL SwitchToGraphicsMode  ; switch to graphics mode 
	mov [PrintMode] ,1 
	CALL PrintBmp ; Printing entrence screen
	mov ah, 1h  ; press anybutton to start main game
	INT 21h
    CALL MainGame  ; calls the main function
ret 
ENDp MainRonGLozmanisMyName 

;---------------------------------------------------------------Start------------------------------------------------------------------------------------------;

Start:
    mov AX, @data
    mov ds, AX

	Call MainRonGLozmanisMyName

END Start