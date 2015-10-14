TITLE Assignment 3			(assignment03.asm)

; Program Description : This program will write a table of n composite numbers.  Composite means not prime.  Program will accept a number between 1 and 400.  Program will arrange primes for extra credit, program will also utilize the Sieve of Erathosthenes for extra credit.  Program will also accept user input so that all 400 numbers just don't display all at once.  User will see 50 at a time and be required to push a button to see more.

; Author: Sam Nelson
; Date Created : 20 July 2015

INCLUDE Irvine32.inc
.data
title1           BYTE    "Programming Assignment #3: Composite Numbers", 0
author	         BYTE    "Author: Sam Nelson", 0
date	         BYTE    "Date: 20 July 2015", 0
ecHeader	     BYTE    "--Program Intro--", 0
extraCredit1     BYTE    "**EC1: Aligned Columns.", 0
extraCredit2     BYTE    "**EC2: Display numbers in pages, display pages with user button input", 0
extraCredit3     BYTE    "**EC3: Use prime divosors to simplify program...otherwise known as Sieve of Eratosthenes.", 0
greetNprompt     BYTE    "I will show you composite numbers, how many would you like to see?",0
greetNprompt2    BYTE    "Enter a number between 1 and 400",0
instructions     BYTE    "Enter the number of composite numbers you would like to see.", 0
instructions2    BYTE    "I'll accept orders for up to 400 composites.", 0
close            BYTE    "Thanks for your curriosity, Bye!", 0
nTooBig	         BYTE    "Number too large, input a number smaller than 400", 0
nTooSmall	     BYTE    "Number too small, input a number bigger than 1", 0
gridFull	     BYTE    "---Press a keyboard button to see more Numbers---", 0
erastNumber      DWORD   2, 3, 5, 7, 0	    ;;2,3,5,7 are the actual primes....0 is a terminator
n                DWORD   ? 

;; start our temporary counter at 4...1,2,3 are not composite numbers, 4 of course is and 5 will not be
tempNum	         DWORD   4  
;;counts number of composites printed
printCounter     DWORD   ? 
;;counts the number of line items...every 10 we will enter a new line
lineCounter      DWORD   0 
threeSpace       BYTE    "   ", 0 
twoSpace	     BYTE    "  ", 0 
oneSpace	     BYTE    " ", 0   
gridSize         DWORD   ? 
    
    
LINEMAX = 10	    ;;max size of a line...10 compoosites will fit
GRIDMAX = 50	    ;;max size of page....will fit 50 composites
LOWERLIMIT = 1
UPPERLIMIT = 400

.code
main PROC

    call introduction
    call getUserData
    call showComposite
    call farewell

    exit

main ENDP


;;INTRODUCTION PROCEDURE

introduction PROC
    mov   		edx, OFFSET title1
    call    	WriteString
    call    	CrLf
    mov	  		edx, OFFSET date
    call		WriteString
    call		Crlf
    mov	  		edx, OFFSET author
    call		WriteString
    call		Crlf
    call		Crlf    
;;CHANGE TEXT COLOR FOR THIS PORTION
;;set text to purple
    mov	  		eax, 5 + (0 * 16)
    call		setTextColor
    mov	  		edx, OFFSET ecHeader
    call		WriteString
    call		Crlf
    mov   		edx, OFFSET extraCredit1
    call    	WriteString
    call    	Crlf
    mov	  		edx, OFFSET extraCredit2
    call		WriteString
    call		Crlf
    mov	  		edx, OFFSET extraCredit3
    call		WriteString
    call		Crlf
    call		Crlf
    ret
    introduction ENDP


;;GET USER DATA PROCEDURE

getUserData PROC
;;CHANGE TEXT COLOR BACK TO WHITE FOR THIS PORTION
;;set text to white
    mov	  		eax, 7 + (0 * 16)
    call  		setTextColor
;;greet
    mov   		edx, OFFSET greetNprompt
    call    	WriteString
    call    	Crlf
;;get number and compare    
    mov	  		edx, OFFSET greetNprompt2
    call		WriteString
    call		Crlf
    call  		ReadInt
    cmp   		eax, UPPERLIMIT
    jg    		tooBig
    cmp   		eax, LOWERLIMIT
    jl    		tooSmall
    mov   		n, eax
    ret
    getUserData ENDP
tooBig:
    mov   		edx, OFFSET nTooBig
    call    	WriteString
    call    	CrLf
    jmp     	getUserData
tooSmall:
    mov   		edx, OFFSET nTooSmall
    call    	WriteString
    call    	CrLf
    jmp   		getUserData


;;SHOW COMPOSITE 

showComposite PROC
;;set the counter, line size, and the grid size to 0...this happens once per program
    mov     	printCounter, 0 
    mov     	lineCounter, 0
    mov     	gridSize, 0
;;CHANGE TEXT COLOR BACK TO WHITE FOR THIS PORTION
;;set text to green
    mov	  		eax, 2 + (0 * 16)
    call	  	setTextColor

numbersContinue:    
;;Checks gridsize with max gridsize of 50...if the two are equal, pause for user to review 
;;numbers and push a button for next 50 numbers
    mov     	eax, gridSize
    cmp     	eax, GRIDMAX
    je      	newGrid
;;Compare user inputed number and the printCounter ...if the number of times we printed so far
;;equals the number the user entered...time to exit
    mov     	eax, n
    cmp     	eax, printCounter 
    je      	exitProgram
;;calls sub routine isComposite to perform the actual work    
    call    	isComposite
;;when sub routine returns we need to increase temp for next go
    inc     	tempNum
;;checks amount of numbers on line with max line size...if equal then we create a new line    
    mov     	eax, lineCounter
    cmp     	eax, LINEMAX
    je      	printNewLine
    jmp     	numbersContinue  

printNewLine:
    call    	CrLf
    mov     	lineCounter, 0
    jmp     	numbersContinue 
    
newGrid:
    mov     	edx, OFFSET gridFull
    call    	WriteString
    
buttonPush:
    mov     	eax, 1 
    call    	Delay
    call    	ReadKey 
    jz      	buttonPush
    mov     	gridSize, 0
    call    	CrLf
    call    	CrLf
    jmp     	numbersContinue 
    
 
exitProgram:
    ret

isComposite PROC
    pushad
;;if its 5 or 7 we do not need to check divisibility...this is a simple equality check
;;we do not need one for 2 and 3 because we start at 4, after we get to 7, we check temp number
;;against 2, 3, 5, and 7. 
    mov     	eax, tempNum
    cmp     	eax, 5
    je      	finishErastLoop
    cmp     	eax, 7
    je      	finishErastLoop
;;clear quotient    
    mov     	ebx, 0   
    mov     	esi, OFFSET erastNumber
     
checkErastDivsor:
    mov     	edx, 0
    mov     	eax, tempNum
    mov     	ebx, [esi]
    div     	ebx
;;check if these a remainder after dividing with 2, 3, 5, or 7...if not then it is a composite.
    cmp     	edx, 0  
    jz      	compositeFound 
;;if there was a remainder, then it wasn't a composite and we need to keep searching with the 
;; Erast numbers, thus we will
;;increase stack location which esi is keeping track of
;;stack is erastNumbers, 2,3,5,7 with a 0 terminator
    inc     	esi     
    mov     	ebx, [esi]
;;we will compare ebx which now holds the stack value that we increased too...if ebx holds the 
;;0 terminator then we will jump to finish the division loop
    cmp     	ebx, 0
    je      	finishErastLoop
    jmp     	checkErastDivsor

compositeFound:
    mov     	eax, tempNum
;;this is how we keep uniform columns
    call    	spacing
;;writes the composite
    call    	WriteDec
    inc     	printCounter ; add 1 to composite print count
    inc     	lineCounter
    inc     	gridSize
    
finishErastLoop:
    popad
    ret
isComposite ENDP

;;creates a uniform grid of numbers using 3 comparrison statements
;;it is only possible to create a uniform grid by modifying spacing
;;spaces int prior to printing actual int...this will control spacing between previous int
;;and this int each time an int is printed...example...if 9 exists on the line, the next int is 11
;;thus we need 2 instead of 3 spaces between 9 and 11 to hold true to columns.

spacing PROC
    pushad
    mov     	eax, tempNum
;;Take the temporary number and compare it to 10, 100, and 1000...
;;10,100, and 1000 are the smallest two, three, and 4 digit numbers possible...if the number
;;being compared is less than 100 for instance, it is for sure a two digit number as long as 
;;computer does these checks in order
    cmp     	eax, 10
    jl      	oneNum
    cmp     	eax, 100
    jl      	twoNum
    cmp     	eax, 1000
    jl      	threeNum
    
    oneNum:
    mov     	edx, OFFSET threeSpace
    call    	WriteString
    jmp     	_endPadding
    
    twoNum:
    mov     	edx, OFFSET twoSpace
    call    	WriteString
    jmp     	_endPadding
    
    threeNum:
    mov     	edx, OFFSET oneSpace
    call    	WriteString
    jmp     	_endPadding
    
    _endPadding:
    popad
    ret

spacing ENDP
showComposite ENDP

;;DISPLAYS CLOSURE
farewell PROC
    call    	CrLf
    call    	CrLf
;;shows exit message
    mov     	edx, OFFSET close
    call    	WriteString
    call    	CrLf

    ret
farewell ENDP
END main