
TITLE Assignment 2			(assignment02.asm)

; Program Description : Display fibonacci numbers for up to N terms where N is less than 46 and greater than 1.

; Author: Sam Nelson
; Date Created : 1 July 2015

INCLUDE Irvine32.inc

.data

author				BYTE	"Author: Sam Nelson ", 0
title1   	      	BYTE	"Fibonacci Numbers ", 0
instructions		BYTE	"I can show you a certain number of iterations of the fibonacci sequence ", 0
getName				BYTE	"What is your name? ", 0
getNumberP			BYTE	"How many fibonacci iterations would you like to see.",0
getNumberP1			BYTE	"I can print up to 46 iterations", 0
extraCredit2		Byte	"**EC: Doing something incredible, changing the text color to red from white", 0
caption				BYTE	"This is incredible too right??!", 0
question			BYTE	"Would you like to go again?", 0
numOfIterations		DWORD	?
prevNumber			DWORD	?
prevNumberx2		DWORD	?
colorWheel			DWORD	?
gap					BYTE	"     ",0
goodbye				BYTE	"Goodbye, ", 0
iterationTwo		BYTE	"1     1     ", 0
iterationOne		BYTE	"1", 0
temp				DWORD	?
moduloFive			DWORD	5
greetings			BYTE	"Hi, lets have some fun ", 0
userName	  		BYTE	21 DUP(0)
usersName			DWORD	?
outOfUpperBound		BYTE	"Number is greater than 46 ", 0
outOfLowerBound		BYTE	"Number is lower than 1 ", 0

;;constants defined here
UPPERLIMIT = 46	
LOWERLIMIT = 1

;;constants used for color changing
color1				DWORD	12
color2				DWORD	16 ; was 16


.code
 main PROC
;;Extra Credit promts
;		mov     edx, OFFSET extraCredit1
;		call    WriteString
;		call    CrLf
		mov     edx, OFFSET extraCredit2
		call    WriteString
		call    Crlf
		call    Crlf

;; set text to red
		mov eax, 3 + (0 * 16)
		call setTextColor

;;project introduction to include name, author name
		mov     edx, OFFSET title1
		call    WriteString	
		call    Crlf
		call    Crlf	
		mov     edx, OFFSET author
		call    WriteString
		call    Crlf
		call    Crlf

		mov     edx, OFFSET getName
		call    WriteString
		call    CrLf
;;gets user name
		mov     edx, OFFSET userName    
		mov     ecx, SIZEOF	userName    
		call    ReadString
		mov     usersName, eax

;;Say hi to the user using their name
		mov     edx, OFFSET greetings
		call    WriteString
		mov     edx, OFFSET userName
		call    WriteString		  
		call    Crlf
		call    Crlf
;;gets the number of fibonnaci sequences to show
getNumber:
		mov     edx, OFFSET getNumberP
		call    WriteString
		call    Crlf
		mov     edx, OFFSET getNumberP1
		call    WriteString
		call    Crlf
		call    ReadInt
		mov     numOfIterations, eax
		cmp     eax, UPPERLIMIT
		jg      outOfBounds		  ;;if too high jump to outOfBounds, display error and repeat
		cmp     eax, LOWERLIMIT
		jl      outOfLbounds	  ;;if too low jump to outOfLbounds, display error and repeat
		je      displayOne		  ;;if number is 1, then we will automatically just display one number
		cmp     eax, 2	    
		je      displayTwo		  ;;last check, if number is 2, then we only need to display 1, in this sequence, 1    1


;; DISPLAY FIBS
;; post test, we also need to make sure user didn't handle 3, if so we will manually handle the counter
		
		mov     ecx, numOfIterations
		cmp     ecx,3
		je      enter3
		sub     ecx, 3	            ;;we will automatically start with iteration 3 so we need to subtract 3 from the user input number
firstTwo:

		mov     eax, 1
		call    WriteDec		  ;;write one to the console...this is how every fibonnaci sequence starts
		mov     edx, OFFSET gap
		call    WriteString		  ;;write five spaces
		call    WriteDec		  ;;eax still has 1 in the register, write it which is the second number in a fib sequence
		mov     edx, OFFSET gap
		call    WriteString		  ;;write another five spaces
		mov     prevNumberx2, eax ;;move 1 to previousNumberx2 since this will be the previous previous number
		mov     eax, 2			  ;;move 2 to eax which is the third number in a fib sequence
		call    WriteDec
		mov     edx, OFFSET gap
		call    WriteString
		mov     prevNumber, eax	  ;;prev number holds 2 at this point
		mov     eax, numOfIterations	  ;;move user created numberofiterations into eax for cmp
		cmp     eax, 4		  	  ;;We want to see if the user put 4 in, if they did, we jump to fib immediately skipping the next check
		je      fib
		cmp     ecx, 1		  	  ;;If we previously jumped to enter3 label because the user entered 3, then we need to exit now
		je      theEnd

fib:
		mov     eax, prevNumber	  ;;restore eax after previous check
		add     eax, prevNumberx2 ;;eax still holds 2 along with prevNumber holding 2 since mov really means to copy.  Add 1 and 2.
		call    WriteDec		  ;;writes 3
		mov     edx, OFFSET gap
		call    WriteString
		mov     temp, eax		  ;;holds 3 since add, adds the source (previousNumber2) to the destination (eax)...temp now has a copy of 3
		mov     eax, prevNumber	  ;;temp has 3, eax had 3...eax has a copy of previousNumber now...2
		mov     prevNumberx2, eax ;;move previousNumbers '2' to previousNumberx2...we went prevNumber->eax-.previousNumberx2
		mov     eax, temp		  ;;move 3 back into eax after being held in temp
		mov     prevNumber, eax	  ;;move 3 from eax too previousNumber...technically temp, eax, and previousNumber all hold 3 right now
		
		;;for spacing (first time it should be % 3, rest %5)
		mov     edx, ecx
		cdq
		div     moduloFive
		cmp     edx, 0
		jne     skip
		call    CrLf

skip:
		;;restore what was on eax
		mov     eax, temp

		;;if ecx % 3 = 0 call CrLf
		loop    fib
		mov     ebx, OFFSET caption
		mov     edx, OFFSET	question
		call    MsgBoxAsk
		cmp     eax, 6		     ;;check eax for 6 if so jump to get number again
		je      getNumber
		jmp     TheEnd

;;if number is larger than 46
outOfBounds:
		mov     edx, OFFSET outOfUpperBound	
		call    WriteString	    ;;display error message 
		call    Crlf
		call    Crlf
		jmp     getNumber	    ;;return to pick again

;;if number is less than 1
outOfLbounds:
		mov     edx, OFFSET outofLowerBound
		call    WriteString	    ;;display error message
		call    Crlf
		call    Crlf
		jmp     getNumber	    ;;return to pick again

;;displays the first iteration of fib sequence which is 1
displayOne:
		mov     edx, OFFSET iterationOne
		call    WriteString	    ;;display the first iteration of fibonnaci sequence
		jmp     TheEnd	        ;;jumps to the end of the program because this label was only called because user wanted to see 1 iteration

;;displays the second iteration of fib sequence which is 1     1
displayTwo:
		mov     edx, OFFSET iterationTwo
		call    WriteString	    ;;writes the second iteration of fibonnaci sequence which looks like this, 1     1
		jmp     TheEnd	    	;;jumps to the end of the program because user just wanted to see two iterations

;;used for if the user enters a 3 which is particularly troublesome
enter3:
		mov     ecx, 1	    	;;make the ecx 1 so that the program runs once
		jmp     firstTwo

;;displays end message
TheEnd:
		call    Crlf
		call    Crlf
		mov     edx, OFFSET goodbye
		call    WriteString	    ;;writes closure
		mov     edx, OFFSET userName
		call    WriteString	    ;;writes the usersName
		call    Crlf

exit	;; exit to operating system
main ENDP

END main