;Stephen Hecht
;April 19, 2017
;
;This program allows a user to play a multi-colored etch-a-sketch game.
;
;
		.ORIG x3000
;
;Program Initialization
;
		LD R5, CENTR		; Set the cursor to center position
		LD R6, WHTCL		; Set the cursor color to white
		STR R6, R5, x0000	; Store those values to the memory-mapped display
;
;Main Loop Subroutine
;
LOOP		GETC			; Get some keyboard input!
UPUP		LD R1, WMVUP		; Loads w into Register 1 for comparison
		ADD R1, R1, R0		; Compares w to GETC value
		BRnp DOWN		; If not w, try test for s
		LD R1, UPVAL		; Load the value of "up" command to R1
		ADD R3, R5, R1		; If w, add the numbers in R5 and R1 for a potential new screen position
		LD R1, MINDV		; Loads minimum Display value into R1
		ADD R1, R1, R3		; Compares up command to minimum display value
		BRn LOOP		; If value is negative, begin again for new input
		ADD R5, R3, x0000	; If value is positive, store new cursor location to R5
		BRnzp DRAW		; Draw cursor to screen
;
DOWN		LD R1, SMVDN		; Loads s into Register 1 for comparison
		ADD R1, R1, R0		; Compares s to GETC value
		BRnp LEFT		; If not s, try test for a
		LD R1, DNVAL		; Load the value of "down" command to R1
		ADD R3, R5, R1		; If s, add the numbers in R5 and R1 for a potential new screen position
		LD R1, MAXDV		; Loads maximum Display value into R1
		ADD R1, R1, R3		; Compares up command to maximum display value
		BRp LOOP		; If value is positive, begin again for new input
		ADD R5, R3, x0000	; If value is negative, store new cursor location to R5
		BRnzp DRAW		; Draw cursor to screen
;
LEFT		LD R1, AMVLT		; Loads a into Register 1 for comparison
		ADD R1, R1, R0		; Compares a to GETC value
		BRnp RITE		; If not a, try test for d
		ADD R3, R5, xFFFF	; If a, add the numbers in R5 and -1 for a potential new screen position
		LD R1, HMASK		; Loads lower seven bits as 1 value into R1
		AND R1, R1, R3		; Compares up command to maximum display value
		BRz LOOP		; If value is zero, begin again for new input
		ADD R5, R3, x0000	; If value is nonzero, store new cursor location to R5
		BRnzp DRAW		; Draw cursor to screen
;	
RITE		LD R1, DMVRT		; Loads d into Register 1 for comparison
		ADD R1, R1, R0		; Compares d to GETC value
		BRnp RDCR		; If not d, try test for r
		ADD R3, R5, x0001	; If d, add the numbers in R5 and 1 for a potential new screen position
		LD R1, HMASK		; Loads lower seven bits as 1 value into R1
		AND R1, R1, R3		; Compares up command to maximum display value
		BRz LOOP		; If value is zero, begin again for new input
		ADD R5, R3, x0000	; If value is nonzero, store new cursor location to R5
		BRnzp DRAW		; Draw cursor to screen
;	
RDCR		LD R2, RDCLR		; Loads r into register 2
		ADD R2, R2, R0		; Compares r to GETC value
		BRnp GNCR		; If not r, try g
		LD R2, REDCL		; Load red value into R2
		ADD R6, R2, x0000	; Stores Red into R6
		BRnzp DRAW		; Draw cursor to screen
;
GNCR		LD R2 GNCLG		; Loads g into register 2
		ADD R2, R2, R0		; Compares g to GETC value
		BRnp BUCR		; If not g, try b
		LD R2, GRNCL		; Load green value into R2
		ADD R6, R2, x0000	; Stores Green into R6
		BRnzp DRAW		; Draw cursor to screen
;
BUCR		LD R2 BLCLB		; Loads b into register 2
		ADD R2, R2, R0		; Compares b to GETC value
		BRnp YLCR		; If not b, try y
		LD R2, BLUCL		; Load blue value into R2
		ADD R6, R2, x0000	; Stores Blue into R6
		BRnzp DRAW		; Draw cursor to screen
;
YLCR		LD R2 YLCLY		; Loads y into register 2
		ADD R2, R2, R0		; Compares y to GETC value
		BRnp WTCR		; If not y, try "space"
		LD R2, YELCL		; Load yellow value into R2
		ADD R6, R2, x0000	; Stores Yellow into R6
		BRnzp DRAW		; Draw cursor to screen
;
WTCR		LD R2 WTCLW		; Loads "space" into register 2
		ADD R2, R2, R0		; Compares "space" to GETC value
		BRnp CLSN		; If not "space", try "return"
		LD R2, WHTCL		; Load white value into R2
		ADD R6, R2, x0000	; Stores White into R6
		BRnzp DRAW		; Draw cursor to screen
;
CLSN		LD R2 CLEAR		; Loads "return" into register 2
		ADD R2, R2, R0		; Compares "return" to GETC value
		BRnp GTFO		; If not "return", try q
		LD R1 MNVAL		; If "return", execute screenclear subroutine
		LD R3 BLKCL		; Sets R1 to the min display value and R3 to Black
CLRN		STR R3, R1, x0000	; Saves Black to the current cursor location value
		ADD R1, R1, x0001	; Increments the Cursor
		LD R2, MAXDV		; Loads the negative of the max display value (xFDFF)
		ADD R2, R1, R2		; Adds the current cursor location and the max display value
		BRp DRAW		; If positive(more than zero) branches to Draw
		BRnz CLRN		; If negative or zero, repeat and keep clearing the screen
;
GTFO		LD R2 LEAVE		; Loads q into register 2
		ADD R2, R2, R0		; Compares q to GETC value
		BRnp LOOP		; If not q, restart, invalid input
		BRz EXIT		; If q, halt execution
;
;
;
;Draw Subroutine
;
DRAW		STR R6, R5, x0000	; Stores color value to cursor location
		BRnzp LOOP		; Return to Main Loop (input)
;
;Exit Program
;
EXIT		HALT			; Ends execution
;
;
CENTR		.FILL xDF40 		; Center Spot on the display
;
WHTCL		.FILL x7FFF 		; White Color
BLKCL		.FILL x0000 		; Black Color
REDCL		.FILL x7C00 		; Red Color
GRNCL		.FILL x03E0 		; Green Color
BLUCL		.FILL x001F 		; Blue Color
YELCL		.FILL x7FED 		; Yellow Color
;
HMASK		.FILL x007F		; Lower 7 bits set to 1
;
UPVAL		.FILL xFF80		; Value of "up" command
DNVAL		.FILL x0080		; Value of "down" command
;
MINDV		.FILL x4000		; Negative of Minimum Display Value (xC000)
MNVAL		.FILL xC000		; Minimum display Value
MAXDV		.FILL x0201		; Negative of Maximum Display Value (xFDFF)
MXVAL		.FILL xFDFF		; Maximum display Value
;
WMVUP		.FILL xFF89		; Negative of "w" charachter (Moves cursor up)
SMVDN		.FILL xFF8D		; Negative of "s" charachter (Moves cursor down)
AMVLT		.FILL xFF9F		; Negative of "a" Charachter (Moves cursor left)
DMVRT		.FILL xFF9C		; Negative of "d" charachter (Moves cursor right)
;
RDCLR		.FILL xFF8E		; Negative of "r" charachter (Sets color red)
GNCLG		.FILL xFF99		; Negative of "g" charachter (Sets color green)
BLCLB		.FILL xFF9E		; Negative of "b" charachter (Sets color blue)
YLCLY		.FILL xFF87		; Negative of "y" charachter (Sets color to yellow)
WTCLW		.FILL xFFE0		; Negative of "space" charachter (Sets color to white)
CLEAR		.FILL xFFF6		; Negative of "return" charachter (Clears screen)
LEAVE		.FILL xFF8F		; Negative of "q" charachter (Ends execution)
;
;
.END