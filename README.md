# Tip-Calculator

Description:
This assembly program is designed to calculate a tip amount based on user input for the bill amount and tip percentage. It uses the LC-3 assembly language and follows a structured approach to perform the calculations.

Program Structure:
1. Initialization:
   - The program starts at memory address x3000.
   - It clears several registers (R1 to R6) to ensure they are set to zero.

2. Input:
   - It prompts the user to input the bill amount and tip percentage.
   - User input is obtained through a custom getInput function.
   - The program validates the input to ensure it is within certain limits (bill amount <= $328, tip percentage <= 100%).

3. Calculation:
   - The program calculates the tip amount using the provided bill amount and tip percentage.
   - It performs various arithmetic operations to determine the final tip amount.
   - The results are stored in memory locations (finalNum1 and finalNum2).

4. Output:
   - The program displays the calculated tip amount.
   - It converts the numerical result into ASCII characters and prints them.

5. Subroutines:
   - Several subroutines are defined within the program, such as ValMaxBill, ValMaxTip, ValNum, getInput, Push, DoMath, PrintZero, ConvertASCII, Round, MultiplyR1R2, DivideR1R2, and FindSizeR1.

6. Data Storage:
   - Various memory locations are reserved for storing data and constants, such as bill amount, tip percentage, temporary values, and ASCII-related data.

7. Error Handling:
   - The program handles errors gracefully by displaying appropriate error messages when input validation fails.

Usage:
1. Load this assembly code onto an LC-3 simulator or emulator.
2. Run the program, and it will prompt you for the bill amount and tip percentage.
3. Enter valid input, and the program will display the calculated tip amount.

Note:
- Ensure that you have an LC-3 simulator or emulator set up to run this assembly program.
