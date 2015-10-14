TITLE Assignment 5b			(assignment05b.asm)

; Program Description : Program will be a combinatorics game.  It will generate and display problems
; with random numbers and ask the user to answer the question.  Program uses code from lectures for 
; random number generation, for WriteString macro, and from the text book in chapter 8 for calculating a 
; factorial.  

; I tried to create a writeDec macro, so that I could change the text color of all decimals, but I was unsuccesful.
; Creating this macro overwrote the random int every time.  

; Program accounts for capital and lower case y's and n's.  Program accounts for all non ints and all non chars in areas
; applicable to such an input (inputing a char answer for a problem is not accepted, inputing a number for a y or n question is not accepted)


; Author: Sam Nelson
; Date Created : 3 Aug 2015

INCLUDE Irvine32.inc

LOWn = 3	
HIn = 12	
LOWr = 1

writeStringMacro	MACRO	buffer
					push	edx
					mov	edx, OFFSET buffer
					call	WriteString
					pop	edx
ENDM

.data
title1	  	        BYTE	"Assignment 5b: Combinatorics test", 0
author	  	        BYTE	"Author: Sam Nelson", 0
date		        BYTE	"Date: 3 August 2015", 0
instructions	    BYTE	"I will display a combinatation problem using random numbers", 0
instructionsp2	    BYTE	" using n numbers 1-13 and r numbers between 1 and infinite", 0
instructions2	    BYTE	"Please enter the answer after the problem is displayed", 0
prompt1		        BYTE	"Problem: ", 0
prompt2		        BYTE	"Number of elements in the set: ", 0
prompt3		        BYTE	"Number of elements to choose from the set: ", 0
prompt4		        BYTE	"How many ways can you choose? ", 0
result1		        BYTE	"There are ", 0
result2		        BYTE	" combinations of ", 0
result3		        BYTE	" items from a set of ", 0
incorrectAns	    BYTE	"You need more practice.", 0
correctAns	        BYTE	"You are correct!", 0
notYN	  	        BYTE	"Invalid response. ", 0
notANum		        BYTE	"Input is not a number.", 0
moreQues		    BYTE	"Another problem (y/n)? ", 0
response		    BYTE	3 DUP(0)	; user response for another problem
capY		        BYTE	"Y", 0
y		        	BYTE	"y", 0
capN		        BYTE	"N", 0
no		        	BYTE	"n", 0
close   		    BYTE	"Bye", 0
;;users input....this is a string of ascii values
stringInput	        BYTE	3 DUP(0)	
;;suspected answer - user input
userInput		    DWORD	?	
;;actual answer-program calculated
answer		        DWORD	?	
n		        	DWORD	?	
r		        	DWORD	?	

.code
main PROC
;;call randomize at start of program as instructed in lectures
				call	Randomize				
				call	introduction
;;loop to produce extra tries
anotherProblem:
;;Push a memory location for n and r onto the stack so it can be given a value to hold, return value is held by default in byes 0-4
;;stack:
;;ret		0-4
;;r		4-8
;;n		8-12
		        push	OFFSET n
		        push	OFFSET r
		        call	generateProblem
;;Push a memory location for userInput onto the stack so it can be populated.
;;stack:
;;ret		0-4
;;userInput	4-8
		        push	OFFSET userInput
		        call	getData					
;;Push the value of n and r onto the stack, then push a memory location for the calculated answer onto the stack to hold the calculated
;;answer, return will be at its default location on stack.  These are all offset by 4 bytes because they are Dwords.
;;stack:
;;ret		0-4
;;answer		4-8
;;r		8-12
;;n		12-16
		        push	n
		        push	r
		        push	OFFSET answer
		        call	combinatoricsProblem			
;;push the values of n, r, userInput, and answer onto stack, these are all dwords and are all offset by 4.  Returns if response is correct or not.
;;stack:
;;ret		0-4
;;answer		4-8
;;userInput	8-12
;;r		12-16
;;n		16-20
		        push	n
		        push	r
		        push	userInput
		        push	answer
		        call	showResults				
;;no stack needed, returns a response.
		        call	getResponse				
;;will compare user response with default values of y or n using cmpsb.
;;cmpsb will compare string bytes...in this case it will use si and di registers
;;we only need to compare it to y....if n then we will just fall through to the end of program.
		        mov	esi, OFFSET response	
		        mov	edi, OFFSET y
		        cmpsb
		        je	anotherProblem
		        mov	esi, OFFSET response
		        mov	edi, OFFSET capY
		        cmpsb
		        je		anotherProblem
		        writeStringMacro	close			
		        call	CrLf
		        exit						
main ENDP

introduction PROC
		        writeStringMacro	title1
		        call	Crlf
		        writeStringMacro	author
		        call	Crlf
		        writeStringMacro	date
		        call	Crlf
		        call	Crlf
; display instructions
		        writeStringMacro	instructions
		        call	Crlf
		        writeStringMacro	instructionsp2
		        call	Crlf
		        call	Crlf
		        writeStringMacro	instructions2
		        call	Crlf
		        ret
introduction ENDP

;;generateProblem will create random numbers for number of objects to pick (n) and size of pool to pick from (r).  Computer can select from number of objects to pick from
;;between 3 and 12 or 9 total possibilities (+1).  Computer can select between a pool size of 1 to n thus n has to be picked first.
generateProblem PROC
;;setup stack frame
		        push	ebp
		        mov	ebp, esp
		        mov	eax, HIn			
		        sub	eax, LOWn	
		        inc	eax
		        call	RandomRange		
;;before eax was 0-Hin, now with the addition of Lown it is between lowN and hiN
		        add	eax, LOWn		
;;place random number in ebx which has the stack memory location of n
		        mov	ebx, [ebp+12]	
		        mov	[ebx], eax				
		        call	RandomRange		
;;place random number in ebx which now has the stack memory location of r
		        mov	ebx, [ebp+8]	
		        mov	[ebx], eax		
		        call	Crlf
		        call	Crlf
		        writeStringMacro	prompt1
		        call	Crlf
		        writeStringMacro	prompt2
		        mov	ebx, [ebp+12]
;;prints n and r later after corresponding prompts
		        mov	eax, [ebx]		
		        call	WriteDec
		        call	Crlf
		        writeStringMacro	prompt3
		        mov	ebx, [ebp+8]	
		        mov	eax, [ebx]
		        call	WriteDec
		        call	Crlf
		        pop	ebp
		        ret	8
generateProblem ENDP

;;Function will take a string in and look at each byte; string will be stored in ascii values and thus we will have to truncate ascii value to look at values between 48
;;and 57 which is reserved for decimal numbers 0-9.  
getData PROC
;;setup stack frame
		        push	ebp
		        mov	ebp, esp						
tryAgain:
		        mov	eax, 0					
		        mov	ebx, [ebp+8]			
		        mov	[ebx], eax
		        writeStringMacro	prompt4		
		        mov	edx, OFFSET stringInput
		        mov	ecx, 3		
;;will return into eax the size of the string (presumably the string is of numbers now and thus this will tell us how big the number is in digits)			
		        call	ReadString				
		        mov	ecx, eax					
		        mov	esi, OFFSET stringInput	

getNext:
;;ebp+8 is the address of userInput, move this into ebx then copy the value in this mem location into eax
;;move the value of 10 into ebx, then multiply user
		        mov	ebx, [ebp+8]			
		        mov	eax, [ebx]				
		        mov	ebx, 10					
		        mul	ebx					
		        mov	ebx, [ebp+8]		
		        mov	[ebx], eax			
		        mov	al, [esi]			
		        cmp	al, 48				
		        jl	invalid
		        cmp	al, 57
		        jg	invalid
;;point to next number in string to evaluate
		        inc	esi						
		        sub	al, 48				
		        mov	ebx, [ebp+8]			
		        add	[ebx], al			
		        loop	getNext
		        jmp	quit
invalid:
;;if number is less than 48 or number is greater than 57....it isn't a number
		        writeStringMacro	notANum	
		        call	Crlf
		        jmp	tryAgain
quit:							
		        pop	ebp
		        ret	4
getData ENDP

;;will utilize local stack variables at locations -4, -8, -12, and -16.  -16 will hold local variable number of elements in set minus number picked...factorial of this 
;;-12 will hold answer of the subtraction problem previously mentioned, -8 will hold number picked factorial (r) and -4 will hold pool size factorial (n).
;;n! / (r!(n-r)!)
combinatoricsProblem PROC
;;setup stack frame
		        push	ebp
		        mov	ebp, esp
		        push	eax				
		        push	ebx
		        push	edx
;;mem address of n
		        push	[ebp+16]		
;;mem address of answer
		        push	[ebp+8]			
;;recursive function to get factorial(listed below) of n
		        call	factorial		
;;stores factorial from previous line in ebx
		        mov	ebx, [ebp+8]				
;;move the address of ebx into eax				
		        mov	eax, [ebx]
;;move the address of the answer for n! into local variable ebp-4 where we expect it
		        mov	DWORD PTR [ebp-4], eax		
;;push mem location of r onto stack and answer, call factorial function and store result in answer, store mem location of result in ebp-8 as local variable
		        push	[ebp+12]		
		        push	[ebp+8]			
		        call	factorial		
		        mov	ebx, [ebp+8]			
		        mov	eax, [ebx]
		        mov	DWORD PTR [ebp-8], eax	
;;do n-r, store result in local variable ebp-12, if n-r is 0 then answer is 1 and we will jmp to another part to put 1
		        mov	eax, [ebp+16]			
		        mov	ebx, [ebp+12]			
		        sub	eax, ebx				
		        cmp	eax, 0					
		        je	resultIsOne				
		        mov	DWORD PTR [ebp-12], eax	
;;get factorial of n-r...store in ebx and the move to permanent location of local variable ebp-16
		        push	[ebp-12]				
		        push	[ebp+8]					
		        call	factorial				
		        mov	ebx, [ebp+8]				
		        mov	eax, [ebx]
		        mov	DWORD PTR [ebp-16], eax		
		        mov	eax, [ebp-8]			
		        mov	ebx, [ebp-16]			
;;r!(n-r)!
		        mul	ebx
		        mov	edx, 0
		        mov	ebx, eax				
		        mov	eax, [ebp-4]			
;;n! / (r!(n-r)!)
		        div	ebx	
;;store eax which holds the quotient in answer which is held  in mem location ebp+8 and then exit as we have found the answer					
		        mov	ebx, [ebp+8]
		        mov	[ebx], eax				
		        jmp	quit
resultIsOne:						
		        mov	eax, 1
		        mov	ebx, [ebp+8]
		        mov	[ebx], eax				
		        mov	eax, [ebx]
quit:
		        pop	edx						
		        pop	ebx
		        pop	eax
;;remove local variables from stack
		        mov	esp, ebp				
		        pop	ebp
		        ret	12
combinatoricsProblem ENDP


;;n, r, or (n-r) will be stored in stack bytes 12-16...we will call ebp+12 to get access to these variables to perform factorial on it
;;ebp+8 will hold answer variable memory location so we can return factorial 
factorial PROC
;;setup stack frame
		        push	ebp
		        mov	ebp, esp
		        mov	eax, [ebp+12]	
		        mov	ebx, [ebp+8]	
;;if incoming number is equal to 0 then factorial is 1 and we will fall through the program to set eax equal to 1, store 1 in mem location of answer, and exit
;;otherwise we will continue to recurse:
		        cmp	eax, 0			
		        ja	recurse			
		        mov	esi, [ebp+8]
		        mov	eax, 1			
		        mov	[esi], eax
		        jmp	quit
recurse:
		        dec		eax				
		        push	eax
		        push	ebx
		        call	factorial
		        mov	esi, [ebp+8]	
		        mov	ebx, [esi]		
		        mov	eax, [ebp+12]		
		        mul	ebx				
		        mov	[esi], eax		
quit:		
		        pop	ebp				
		        ret	8
factorial ENDP

showResults PROC
;;setup stack frame
		        push	ebp
		        mov	ebp, esp
		        call	Crlf
		        writeStringMacro	result1
;;move previously calculated answer into eax to write it out to screen, move r into eax and write r to screen with corresponding prompt, do same with n
		        mov	eax, [ebp+8]		
		        call	WriteDec
		        writeStringMacro	result2
		        mov	eax, [ebp+16]				
		        call	WriteDec
		        writeStringMacro	result3
		        mov	eax, [ebp+20]		
		        call	WriteDec
		        call	Crlf
;;compare users response with answer if correct then print a correct (correct answer will equal the calculated answer) if not print incorrect answer response 
;;users answer is in stack position 8-12 and the actual answer is in stack position 4-8
		        mov	eax, [ebp+12]		
		        cmp	eax, [ebp+8]		
		        je	correct				
		        writeStringMacro	incorrectAns		
		        call	Crlf
		        call	Crlf
		        jmp	quit
correct:
		        writeStringMacro	correctAns
		        call	Crlf
		        call	Crlf
quit:								
		        pop	ebp
		        ret	16
showResults ENDP

getResponse PROC
askAgain:
		        call	Crlf
;;compare a user inputed value (y or n) to a constant y or n too determine if another problem is given.  If n, program quits with exit msg
		        writeStringMacro	moreQues
;;move the memory location for the response in
		        mov	edx, OFFSET response
		        mov	ecx, 2					
		        call	ReadString
;;the 4 sections below will account for user entered expresions n N y Y.  They all will jump to the same spot to be evaluated further (up in main)
;;If the expression isn't one of these it will loop again after displaying a prompt showing that they  did not enter the right response.
		        mov	esi, OFFSET response
		        mov	edi, OFFSET y
		        cmpsb
		        je	quit
		        mov	esi, OFFSET response
		        mov	edi, OFFSET capY
		        cmpsb
		        je	quit
		        mov	esi, OFFSET response
		        mov	edi, OFFSET capN
		        cmpsb
		        je	quit					
		        mov	esi, OFFSET response
		        mov	edi, OFFSET no
		        cmpsb
		        je	quit			
		        writeStringMacro	notYN	
		        jmp	askAgain	
quit:
		        ret
getResponse ENDP

END main