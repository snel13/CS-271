TITLE Assignment 1			(assignment01.asm)

; Program Description : Program will write a quick summary of what it will do
; to command line, it will accept two user entered numbers, save these two numbers
; perform addition, subtraction, multiplication, division, and modulus on these
; two numbers.It will print all answers, and then conclude with an exit message.

; Author: Sam Nelson
; Date Created : 25 June 2015


INCLUDE Irvine32.inc

.data

x	      	  DWORD       ?	      ; first number
y	          DWORD       ?	      ; second number
sum	          DWORD       ?	      ; sum ans
subt	      DWORD       ?	      ; DIFF ans
multi	      DWORD       ?	      ; multi ans
divi	      DWORD       ?	      ; divi ans
modu	      DWORD       ?	      ; modu ans
addition	  BYTE        "+", 0  ; ADD SIGN
subtration    BYTE        "-", 0  ; SUB SIGN
multiplication BYTE       "x", 0  ; MULTIPLY SIGN
division	  BYTE        "/", 0  ; DIVISION
remainder	  BYTE        " With a Remainder of ",0
equals	      BYTE        "=", 0; EQUAL
prompt1	      BYTE        "Enter two numbers and I will show you the sum, diff,product, and qutotient  ", 0
prompt2	      BYTE        "Do you wanna go again? answer in binary:  ", 0
date	      BYTE        "Date: 26 June 2015",0
titleHeader   BYTE        "**************************-----Integer Arithmetic-----**************************", 0
author	      BYTE        "Author: Sam Nelson", 0
ask1	      BYTE        "Enter number One:  ", 0
ask2	      BYTE        "Enter number two:  ", 0
userAns	      DWORD       ? ; by default it will not repeat
closeStatement BYTE        "Impressed? Bye", 0
extraCred1    BYTE        "**EC: Repeat until the user chooses to quit.",0
extraCred2    BYTE        "**EC: Validate the second number to be less than the first.",0


.code
main PROC

; Display Instructions
    mov	      edx,        OFFSET titleHeader
    call	      WriteString
    call	      Crlf
    call	      Crlf
    mov	      edx,        OFFSET author
    call	      WriteString
    call	      Crlf
    mov	      edx,        OFFSET date
    call	      WriteString
    call	      Crlf
    mov	      edx,        OFFSET extraCred1
    call	      WriteString
    call	      CrlF
    mov	      edx,        OFFSET extraCred2
    call	      WriteString
    call	      Crlf
    call	      Crlf
    mov	      edx,        OFFSET prompt1
    call	      WriteString    
    call	      Crlf
    call	      Crlf

userInput :
; get 2 numbers
; number x
    mov	      edx, OFFSET ask1
    call	      WriteString
    call	      ReadInt
    mov	      x, eax
    mov	      edx, OFFSET  ask2
    call	      WriteString
    call	      ReadInt
    mov	      y, eax

;Validate numbers to make sure in correct order (1st number highest)
    mov	      ebx,x	             ;first user number
    cmp	      ebx,eax	         ;y is already in eax
    ja	      calculations
;swap if a<b
    mov	      x,eax
    mov	      y,ebx

calculations:
; add numbers
    mov	      eax, x	         ; moves x to EAX register for addition
    add	      eax, y	         ; adds y to EAX register
    mov	      sum, eax	         ; saves EAX register to sum
    mov	      eax, x	         ; moves x to EAX register to print
    call	      WriteDec	     ; write the first user number to console
    mov	      edx, OFFSET  addition   ; shows addition sign
    call	      WriteString
    mov	      eax, y	         ; moves y to EAX register to print
    call	      WriteDec	  	 ; write the second number to console
    mov	      edx, OFFSET  equals ; prepares the equal sign
    call	      WriteString
    mov	      eax, sum	      	 ; prepares sum for print to console
    call	      WriteDec
    call	      Crlf
    call	      Crlf

; sub numbers
    mov	      eax, x
    sub	      eax, y
    mov	      subt, eax
    mov	      eax, x	      	  ; moves x to EAX register to print
    call	      WriteDec	      ; write the first user number to console
    mov	  edx, OFFSET  subtration ; shows addition sign
    call	      WriteString
    mov	      eax, y	          ; moves y to EAX register to print
    call	      WriteDec	      ; write the second number to console
    mov	      edx, OFFSET  equals ; prepares the equal sign
    call	      WriteString
    mov	      eax, subt	          ; prepares subt for print to console
    call	      WriteDec
    call	      Crlf
    call	      Crlf

; multiply numbers
    mov	      eax, x
    mov	      ebx, y
    mul	      ebx 
    mov	      multi, eax
    mov	      eax, x	          ; moves x to EAX register to print
    call	      WriteDec	      ; write the first user number to console
    mov	      edx, OFFSET  multiplication; shows addition sign
    call	      WriteString
    mov	      eax, y	      	  ; moves y to EAX register to print
    call	      WriteDec	      ; write the second number to console
    mov	      edx, OFFSET  equals ; prepares the equal sign
    call	      WriteString
    mov	      eax, multi	      ; prepares multi for print to console
    call	      WriteDec
    call	      Crlf
    call	      Crlf

; division
    mov	      edx,0				   ; Clear out remainder
    mov	      eax,x
    mov	      ebx,y
    div	      ebx
    mov	      divi,eax
    mov	      modu,edx
    mov	      edx,0
    mov	      eax,x		     
    call	      WriteDec	      ;WRITE FIRST NUMBER
    mov	      edx,OFFSET  division
    call	      WriteString	      ;WRITE DIVIDE SIGN
    mov	      eax,y		     
    call	      WriteDec	      ;WRITE SECOND NUMBER
    mov	      edx,OFFSET  equals
    call	      WriteString	      ;WRITE = SIGN
    mov	      eax,divi
    call	      WriteDec	      ;WRITE Quotiet	      
    mov	      edx,OFFSET  remainder
    call	      WriteString	      ;WRITE remainder    
    mov	      eax,modu
    call	      WriteDec	      ;WRITE MODULUS
    call	      Crlf
    call	      Crlf

; Do you want to repeat
    mov	      edx, OFFSET  prompt2; user will have 0 or 1 choice
    call	      WriteString
    call	      ReadInt
    call	      Crlf
    mov	      userAns, eax	  ; User will input their 1 or 0 into this
    mov	      eax, 1	      ; set EAX register = 1
    cmp	      eax, userAns	  ; if user entered 1 then it will jump, if they said 0 (no)than it will finish
    je	      userInput

; Closure
    mov	      edx, OFFSET  closeStatement
    call	      WriteString
    call	      Crlf
    exit

main ENDP
END main