.ORIG x3000   
; Clear Registers 
AND R1, R1, #0 
AND R2, R2, #0 
AND R3, R3, #0 
AND R4, R4, #0 
AND R5, R5, #0 
AND R6, R6, #0 
 
; Get Bill amount 
LEA R0, promptBill 
PUTS 
JSR getInput 
JSR ValMaxBill
LD  R1, tempNum 
ST  R1, firstNum 
AND R0, R0, #0 
ST  R0, tempNum 
       
; Get second part of Bill amount if decimal point 
LD  R0, secondNum 
ADD R0, R0, #0 
BRnz NoDecimal 
  JSR getInput 
  LD  R1, tempNum 
  ST  R1, secondNum 
  LD  R6,	inSize 
  ST  R6,	secondNumSize 
NoDecimal 
AND R0, R0, #0 
ST  R0, tempNum 
 
; Get percentage of tip 
LEA R0, promptTip 
PUTS 
JSR getInput
JSR ValMaxTip 
LD  R2, tempNum 
ST  R2, tipNum 
AND R0, R0, #0 
ST  R0, tempNum 
 
JSR DoMath 
 
PrintOut 
  LEA R0, tip 
  PUTS 
  LD  R1, finalNum1
  JSR FindSizeR1
  JSR ConvertASCII
  LEA R0, outStack
  PUTS 
  LD  R0, negDec
  Not R0, R0 
  Add R0, R0, #1
  OUT
  LD  R1, finalNum2 
  ADD R1, R1, #0 
  BRz Zeros 
    JSR FindSizeR1
    LD  R0 size
    ADD R0, R0, #-1
    BRp NoZero
    JSR PrintZero
    NoZero
    JSR ConvertASCII 
    LEA R0, outStack 
    PUTS 
    BR Done 
  Zeros 
    JSR PrintZero
    JSR PrintZero
  Done 
  BR EXIT 
 
promptBill    	.STRINGZ	"\nPlease input bill amount: $"
promptTip     	.STRINGZ	"\nInput Percentage for tip: %"
tip            	.STRINGZ	"\nTip = $" 
errMaxBill      .STRINGZ  "\nError: Bill cannot be more than $328"
errMaxTip       .STRINGz  "\nError: Tip cannot be more than 100%"
errNaN          .STRINGZ  "\nError: Input must be a number"
 
tipNum        	.BLKW #1 
tempNum       	.BLKW #1 
tempNum2      	.BLKW #1
firstNum      	.BLKW #1
secondNum     	.BLKW #1
secondNumSize 	.BLKW #1
inSize        	.BLKW #1
size       	    .BLKW #1
negDec        	.FILL	xFFD2 
outStack        .BLKW	#5 
inputStack    	.BLKW	#7 
asciiDiff      	.FILL	xFFD0 
hundred         .FILL	x64 
tenThousand     .FILL	x2710 
negTenThousand	.FILL	xD8F0 
MAX             .FILL xC005
remainder     	.BLKW #1
SaveR3        	.BLKW #1 
SaveR4        	.BLKW #1
SaveR5        	.BLKW #1
SaveR6        	.BLKW #1
SaveR7        	.BLKW #1
numStack 	      .FILL	#1 
                .FILL	#10 
                .FILL	#100 
                .FILL	#1000 
                .FILL	#10000 
 
finalNum1     	.BLKW #1
finalNum2     	.BLKW #1
LF            	.FILL	xFFF6 ; FFF6 = -10 (negate ASCII LF) 
ZERO          	.FILL	xFFD0 ; FFD0 = -48 (negate ASCII 0) 
NINE          	.FILL	xFFC7 ; FFC7 = -57 (negate ASCII 9) 
NEGMAXBILL      .FILL xFEB8 ; xFEB8 = -328
NEGMAXTIP       .FILL xFF9C ; xFF06 = -100
 
EXIT TRAP x25 

ValMaxBill
  LD  R2, NEGMAXBILL
  ADD R6,R2,R0
  BRnz VALIDB
  LEA R0, errMaxBill
  PUTS
  JSR EXIT
  VALIDB RET

ValMaxTip
  LD  R2, NEGMAXTIP
  ADD R6,R2,R0
  BRnz VALIDT
  LEA R0, errMaxTip
  PUTS
  JSR EXIT
  VALIDT RET

ValNum
   LD R2, ZERO ;Errors if ASCII code is too low
   ADD R3, R2, R0
   BRn ErrN
   LD R2, NINE ;Errors if ASCII code is too high
   ADD R3, R2, R0
   BRp ErrN
   RET
   ErrN
     LEA R0, errNaN
     PUTS
     JSR EXIT
 
getInput
  ST  R7, SaveR7
  LEA R6, inputStack
  AND R4, R4, #0
  AND R5, R5, #0
  GetChar GETC
    LD  R2,	LF
    ADD R3, R2, R0
    BRz Done1
    LD  R3, negDec
    ADD R3, R3, R0
    BRz Decimal
    OUT
    JSR ValNum
    JSR Push
    ADD R4, R4, #1
    ST  R4, inSize
    ADD R5, R4, #-6
    BRn GetChar
  Decimal
    OUT
    ST  R4, secondNum
  Done1
    LEA R6, inputStack 
    LEA R4, numStack 
    LD  R5, asciiDiff
    LD  R3, inSize 
    ADD R3, R3, #-1 
  MultiplyOut 
    LDR R1, R6, #0 
    ADD R1, R1, R5 
    ADD R2, R4, R3 
    LDR R2, R2, #0 
    ST  R3, SaveR3 
    ST  R4, SaveR4 
    ST  R6, SaveR6 
    JSR MultiplyR1R2 
    ST  R6, tempNum2 
    LD  R3, SaveR3  
    LD  R4, SaveR4  
    LD  R6, SaveR6 
    LD  R1, tempNum2 
    LD  R0, tempNum 
    ADD R0, R0, R1 
    ST  R0, tempNum 
    ADD R6, R6, #1 
    ADD R3, R3, #-1 
    BRzp MultiplyOut 
  LD  R7, SaveR7 
  RET 
 
PrintZero
  ST  R7, SaveR7  
  LD  R0, ZERO
  NOT R0, R0
  ADD R0, R0, #1
  OUT
  LD  R7, SaveR7
  RET
 
ConvertASCII 
  ST  R7, SaveR7 
  ST  R1, tempNum2
  LD  R3, size 
 
  LEA R6, outStack 
  Loop 
    LEA R5, numStack 
    ADD R3, R3, #-1 
    ADD R5, R5, R3 
    LDR R2, R5, #0 
    LD  R1, tempNum2 
    ST  R3, SaveR3 
    ST  R4, SaveR4 
    ST  R5, SaveR5 
    ST  R6, SaveR6 
    JSR DivideR1R2 
    AND	R0,	R0,	#0 
    ADD	R0,	R0,	R6 
    LD  R3, SaveR3 
    LD  R4, SaveR4 
    LD  R5, SaveR5 
    LD  R6, SaveR6 
    LD  R5, remainder 
    LD  R4, asciiDiff
    NOT R4, R4
    ADD R4, R4, #1
    ADD R0, R0, R4
    JSR Push
    ST  R5, tempNum2
    ADD R3, R3, #0  
    BRp Loop 
  ADD R0, R0, #0 
  LD  R7, SaveR7 
  RET 

Push ; Push R0 onto the stack in R6
  ST  R3, SaveR3
  LD  R3, MAX
  ADD R3, R6, R3 ; Check for overflow
  BRz EXIT
  STR R0, R6, #0
  ADD R6, R6, #1
  LD  R3, SaveR3
  RET
 
DoMath 
  LD  R1, firstNum ; Multiply the whole part of the number by the tip percentage
  LD  R2, tipNum 
  JSR MultiplyR1R2 
  ST  R6, firstNum 
 
  LD  R1, firstNum ; Divide firstNum by 100 to get Dollar amount. 
  LD  R2, hundred 
  JSR DivideR1R2
 
  ST  R6, finalNum1 
 
  LD  R1, remainder
  LD  R2, hundred 
  JSR MultiplyR1R2 
 
  ST  R6, firstNum 
   
  LD  R1, secondNum 
  ADD R1, R1, #0 
  BRz NotSingleDig 
    LD	R3,	secondNumSize 
    ADD R3, R3, #-1 
    BRnp NotSingleDig 
      AND R2, R2, #0 
      ADD R2, R2, #10 
      JSR MultiplyR1R2 
      ST  R6, secondNum 
  NotSingleDig 
 
  LD  R1, secondNum 
  LD  R2, tipNum 
  JSR MultiplyR1R2 
  ST  R6, secondNum 
 
  LD  R1, firstNum 
  LD  R2, secondNum 
  ADD R6, R1, R2 
  ST  R6, finalNum2 
 
  LD  R3, finalNum2 
  LD  R4, negTenThousand 
  ADD R3, R3, R4 
  BRn NotOverTenThousand 
    LD  R1,	finalNum1 
    AND R2, R2, #0 
    ADD R2, R2, #1 
    ADD R6, R1, R2 
    ST  R6,	finalNum1 
    LD  R1,	finalNum2 
    LD  R2,	tenThousand 
    NOT R2, R2 
    ADD R2, R2, #1 
    ADD R6, R1, R2 
 
    ST  R6,	finalNum2 
  NotOverTenThousand 

  LD  R1, finalNum2
  AND R2, R2, #0 
  ADD R2, R2, #10
  JSR DivideR1R2
  JSR Round ; Added rounding subroutine

  AND R1, R1, #0 
  ADD R1, R1, R6
  JSR DivideR1R2
  JSR Round
 
  ST  R6, finalNum2 
   
  JSR PrintOut 

Round
  LD  R3, remainder
  ADD R3, R3, #-5
  BRn RoundDown 
    ADD R6, R6, #1 ; Rounds up if remainder is higher than 5
  RoundDown
  RET

; R6 = result 
MultiplyR1R2 
  AND R6, R6, #0 
  AND R3, R3, #0 
  ADD R3, R2, #0 
  Multiply 
    ADD R6, R6, R1 
    ADD R3, R3, #-1 
  BRp Multiply 
  RET 
 
; R6 = result 
DivideR1R2 
  AND R3, R3, #0 
  ADD R3, R1, #0 
  AND R4, R4, #0 
  ADD R4, R2, #0 
  NOT R4, R4 
  ADD R4, R4, #1 
  AND R6, R6, #0 
  Divide 
    ST  R3, remainder ; Stores remainder before the Done check
    ADD R3, R3, R4 
    BRn Done2 
    ADD R6, R6, #1  
    BR Divide 
  Done2
  RET 
 
FindSizeR1 ; Finds the size of R1
  ST  R7, SaveR7
  LEA R3, numStack
  AND R5, R5, #0
  ADD R1, R1, #0 ; If it is zero, just skip the size check
  BRz FoundSize
  ADD R5, R5, #4 
  FindSize 
    ADD R2, R3, R5 
    LDR R2, R2, #0 
    ST  R5, SaveR5 
    ST  R3, SaveR3
    JSR DivideR1R2
    LD  R5, SaveR5 
    LD  R3, SaveR3 
    ADD R6, R6, #0 
    BRp FoundSize 
    ADD R5, R5, #-1 
    BRnzp FindSize 
  FoundSize 
    ADD R5, R5, #1 
    ST  R5, size 
  LD  R7, SaveR7 
  RET 
 
.END 