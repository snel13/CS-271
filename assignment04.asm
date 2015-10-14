TITLE Assignment 4			(assignment04.asm)

; Program Description : Program will prompt user for a number of random ints to see.
; User will be required to pick within the range of 10 and 200 and the computer will 
; only display Pseduo randoms between 100 and 999.  After computer displays randoms, 
; computer will find the median and display it, along with sorting the random numbers
; in decreasing fashion.  Program will display 10 numbers per line. 
; Program will color certain lines to make it easier to read.  
; Program has 1 of the 5 extra credits and program will display such EC statements as required.

; Author: Sam Nelson
; Date Created : 24 July 2015

INCLUDE Irvine32.inc
.data
LOWERLIMIT = 10
UPPERLIMIT = 200
LOWRANDNUM = 100
MAXRANDNUM = 999
title1			BYTE    "Assignment 4: Sorting rand integers",0
author			BYTE    "Author: Sam Nelson",0
date			BYTE    "Date: 24 July 2015",0
greetNprompt	BYTE	"I will display a number of random numbers",0
greetNpromptp2	BYTE    "show you the median",0
greetNpromptp3	BYTE	"and then sort the list and return it",0
greetNprompt2	BYTE	"Enter a number between 10 and 200",0
ecHeader		BYTE	"--Program Intro--", 0
extraCredit		BYTE	"**EC: number 5, Other- use padding to space ints into even columns",0
prompt			BYTE	"How many numbers should be generated? [10 .. 200]: ", 0
nTooBig			BYTE    "Number ",0
nTooBig1		BYTE    "TOO LARGE",0
nTooBig2		BYTE    ", input a number smaller than 200",0
nTooSmall		BYTE    "Number ",0
nTooSmall1		BYTE    "TOO SMALL",0
nTooSmall2		BYTE    ", input a number larger than 10",0
unsortedArray	BYTE	"The unsorted random numbers:", 0
median	  		BYTE	"The median is: ", 0
sortedMessage	BYTE	"The sorted list:", 0
spaces			BYTE	"   ", 0
n				DWORD	?	; number of random numbers to be generated
randNumbers		DWORD	UPPERLIMIT DUP(?)

.code
main PROC
;;as shown in lectures, we call randomize first
;;kind of like feeding a seed to a random generator
		call	Randomize	
		call	introduce				
;;push a refernce of n onto the stack...push the memory location of n onto the stack
;;call getData function(procedure) to populate n's memory location							
		push	OFFSET	  n				
		call	getData	
		call	Crlf
		call	Crlf
		call	Crlf			
;;push a memory location of the array and push the value of n onto the array							
		push	OFFSET randNumbers
		push	n			
		call	fillArray			
;;push a memory location for the array and for the unsortedArray string onto stack, push the value of n onto the stack
;;stack:
;;ret	      0-4
;;n	      4-8
;;randNumbers   8-12
;;unsortedArray 12-16
		push	OFFSET unsortedArray
		push	OFFSET randNumbers
		push	n
		call	displayList
;;push a memory location of the array onto the stack and the value of n...sort list and return the array
		push	OFFSET randNumbers
		push	n					
		call	sortList			
		push	OFFSET randNumbers
	  	push	n
		call	displayMedian
		call	Crlf	
		call	Crlf	
		push	OFFSET sortedMessage
		push	OFFSET randNumbers
		push	n
		call	displayList			
	exit	
main ENDP

;;introduce program, date, programmer, extra credit, and change the color for extra credit prompt to help it stand out
;;then display instructions, procedure will return to main and will not return anything extra hence ret not having an operand
introduce PROC
		mov	edx, OFFSET title1
		call	WriteString
		call	Crlf
		mov	edx, OFFSET date
		call	WriteString
		call	Crlf
		mov	edx, OFFSET author
		call	WriteString
		call	Crlf
		call	Crlf
		mov	eax, 2 + (0 * 16)
		call	setTextColor
		mov	edx, OFFSET ecHeader
		call	WriteString
		call	Crlf
		mov       edx, OFFSET extraCredit
		call	WriteString
		mov	eax, 7 + (0 * 16)
		call	setTextColor
		call	Crlf
		call	Crlf
		mov	edx, OFFSET greetNprompt
		call	WriteString
	  	call	Crlf
		mov	edx, OFFSET greetNpromptp2
		call	WriteString
		call	Crlf
		mov	edx, OFFSET greetNpromptp3
		call	WriteString
		call	Crlf
		mov	edx, OFFSET greetNprompt2
		call	WriteString
		call	Crlf
		call	Crlf
	ret
introduce ENDP

getData PROC
;;procedure will display a prompt asking for user number of ints they wanna see, procedure takes in an address to variable 
;; 'n' and stores user input in that memory location.  procedure will then return this value to main show by 4 byte operand with ret instruction
;;procedure will also perform data validation and use a simple loop until user gets it right; text color has been changed to help 
;;setup stack frame record
		push	ebp		
		mov	ebp, esp   
getUserNumber:
	    mov	edx, OFFSET prompt
	    call	WriteString
	    call	ReadInt
	    cmp	eax, UPPERLIMIT
	    jg	tooBig
		cmp	eax, LOWERLIMIT
		jl	tooSmall
;;place the address of (shown by the []) n in ebx
;;store input variable currently held in eax by default in n
		mov	ebx, [ebp+8]	
		mov	[ebx], eax	
		pop	ebp
        ret     4  
tooBig:
		mov       eax, 6 + (0 * 16)
		call      setTextColor
		mov       edx, OFFSET nTooBig
		call      WriteString
		mov       eax, 5 + (0 * 16)
		call      setTextColor
		mov       edx, OFFSET nTooBig1
		call      WriteString
		mov       eax, 6 + (0 * 16)
		call      setTextColor
		mov       edx, OFFSET nTooBig2
		call      WriteString
		call      Crlf
		call      Crlf
		mov       eax, 7 + (0 * 16)
		call      setTextColor
		jmp       getUserNumber
tooSmall:
		mov       eax, 6 + (0 * 16)
	    call      setTextColor
		mov       edx, OFFSET nTooSmall
		call      WriteString
		mov       eax, 9 + (0 * 16)
	    call      setTextColor
		mov       edx, OFFSET nTooSmall1
	    call      WriteString
		mov       eax, 6 + (0 * 16)
	    call      setTextColor
		mov       edx, OFFSET nTooSmall2
		call      WriteString
		call      Crlf
		call      Crlf
		mov       eax, 7 + (0 * 16)
		call      setTextColor
		jmp       getUserNumber
getData ENDP

fillArray PROC
;;procedure receives the value of n and passes it to ecx to act as the counter, procedure receives the address of the array to fill
;;edi will contain the address of the array.  RandomRange will be fed eax to generate a random number.  We will tell RandomRange to select
;;from 900 ints but we will have to increase the number it returns in eax by 100 or LOWERANDNUM since it will select between 0-900
;;we will then pass eax (the random int) to the address of the array location, and then we will increase edi by 4 bytes to point to next
;;array location address.  We return 8 because ret =4 and 4+8 gets to 12 which is where our array starts.
;;setup stack frame record
		push	ebp
		mov	ebp, esp
;;pass a copy of whats in the address location ebp+8 (which is n) into ecx
;;pass a copy of whats in the address location ebp+12 (which is the array) into ecx
		mov	ecx, [ebp+8]	
		mov	edi, [ebp+12]	
again:
		mov	eax, MAXRANDNUM	
		sub	eax, LOWRANDNUM	
;;after line 204, eax will contain 900		
		inc	eax		
		call	RandomRange		
		add	eax, LOWRANDNUM	
		mov	[edi], eax	
		add	edi, 4		
		loop	again
		pop	ebp
        ret     8
fillArray ENDP

;;Procedure will receive the address of the array (ebp+12) and the value of n to use as a counter
;;code taken from book...bsort.asm; Sort starts with first Array element (ebp+12), and cycles through inner loop until the condition
;;of eax which now holds (ebp+12 or the first elements) not being less than 
;;I HAVE MODIFIED THE CODE FROM THE BOOK; I DID THIS TO MAKE IT EASIER TO READ
;;setup stack frame record
sortList PROC
		push	ebp
		mov	ebp, esp
		mov	ecx, [ebp+8]
;;dec ecx cause we do not want to over run the array
		dec	ecx	
outerLoop:
		push	ecx
		mov	esi, [ebp+12]			
innerLoop:
		mov	eax, [esi]
		cmp	[esi+4], eax		
		jl	noSwap					
		xchg	eax, [esi+4]			
		mov	[esi], eax
noSwap:
		add	esi, 4					
		sub	ecx, 1
		cmp       ecx, 0
		jg        innerLoop
		pop	ecx
		sub       ecx, 1
		cmp       ecx, 0
		jg        outerLoop
		pop	ebp
        ret     8
sortList ENDP 

;;EDX will contain unsortedArray message at address location ebp +16, esi will contain address for array location at ebp +12, and the counters will be at ebp+8
;;eax will hold the current value in esi mem loc, if ebx is 10...print line and start again, esi will be increased by 4 bytes each time to point to new mem loc in array
;;return the array ...ret 12 because ret is worth 4
;;setup stack frame record
displayList PROC
		push	ebp
		mov	ebp, esp
		mov	edx, [ebp+16]		
		call	WriteString
		call	Crlf
		mov	esi, [ebp+12]		
		mov	ecx, [ebp+8]		
		mov ebx,0
more:
		mov	eax, [esi]			
		call	WriteDec
		inc	ebx					
		mov	edx, OFFSET spaces	
		call	WriteString
		cmp	ebx, 10				
		jne	noNewLine			
		call	Crlf				
		mov ebx,0
noNewLine:
		add	esi, 4				
		loop	more
		call	Crlf
		pop	ebp
    ret	  12
displayList ENDP

;;divide eax in half to get to middle of array, compare edx to 0 (edx holds the remainder from the division...if 0 array is even filled if odd it is odd filled)
;;if array is even filled, avg two middle numbers and display this
;;
displayMedian PROC
		call	Crlf
		push	ebp
		mov	ebp, esp
		mov	edx, OFFSET median
		mov	eax, 10 + (0 * 16)
		call	setTextColor
		call	WriteString
		mov	edx, 0
;;value of n, divide by 2, compare remainder to 0, if 0 then even else odd
		mov	eax, [ebp+8]			
		mov	ebx, 2
		div	ebx						
		cmp	edx, 0					
		jne	oddNum					
; if number of elements is even, median is the average of the two middle numbers
evenNum:
;;decrease because we want the start of the first middle number...which is the end of the last non middle number
		dec	eax						
;;prep ebx with 4...4 represents 4 bytes which is the size of dword
		mov	ebx, 4				
;;multiply eax by 4...for instance if 'n' is 140, then line 297 tells us to divide eax by 2...so eax ('n') is now 70...we multiply 70 by 4 to get the 
;;location of the FIRST middle number in bytes from the start of the array.
		mul	ebx		
;;move the address of the array into esi				
		mov	esi, [ebp+12]
;;add to that address eax...which is now the offset in bytes of the first middle number
		add	esi, eax	    			
;;move the value of this memory location into ebx
		mov	ebx, [esi]
		sub	esp, 20		
;;move the first value into DWORD PTR[ebp-4]			
		mov	DWORD PTR[ebp-4], ebx
;;increament the address mem location by 4...which pushes us past the first middle number into the second
		add	esi, 4					
		mov	ebx, [esi]
;;save this value in DWORD PTR[ebp-8]
		mov	DWORD PTR[ebp-8], ebx	
;;clear edx so we can get a remainder
		mov	edx, 0
;;mov the first middle number into eax then add second middle number to eax.  Divide eax by ebx (ebx contains 2)
		mov	eax, [ebp-4]
		add	eax, [ebp-8]
		mov	ebx, 2
		div	ebx		
		call	WriteDec
		call	Crlf
		jmp	endNum
; if number of elements is odd, median is just the middle number
oddNum:
;;move 4 into ebx...4 represents 4 bytes whihc is the size of dword
		mov	ebx, 4				
;;multiply eax by 4...this gives us the offset from the start of array in bytes of the location of the middle
		mul	ebx					
;;place the start of the array in esi then add eax to the start of the arry to create an offset to the location of the middle
		mov	esi, [ebp+12]	
		add	esi, eax			
;;move the value of this memory location into eax, print this	
		mov	eax, [esi]			
		call	WriteDec
		call	Crlf
endNum:
		mov	eax, 7 + (0 * 16)
		call	setTextColor
;;remove the local values from the stack 
		mov	esp, ebp			
		pop	ebp
ret     8
displayMedian ENDP

END main