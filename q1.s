		INCLUDE core_cm4_constants.s		; Load Constant Definitions
		INCLUDE stm32l476xx_constants.s      
		
		AREA calculateModulo, CODE, READONLY
		EXPORT __main
		ENTRY

iterateStr PROC
		
		LDRB r2, [r1], #1
		CMP r2, #0 ; check if we reach the null character
		BNE convert
		B back
		
convert CMP r2, #'0'
		BLT stop
		CMP r2, #'9'
		BLE handleDigit
		
		CMP r2, #'A'
		BLT stop
		CMP r2, #'F'
		BLE handleUpperCase
		
		CMP r2, #'a'
		BLT stop
		CMP r2, #'f'
		BLE handleLowerCase
		
back	BX LR
		
		

stop 	B	stop
		
handleDigit	SUB r3, r2, #'0'
			ADD r0, r3, r0, LSL #4
			B iterateStr
			
handleUpperCase SUB r3, r2, #'A' - 10
				ADD r0, r3, r0, LSL #4
				B iterateStr
			
handleLowerCase SUB r3, r2, #'a' - 10
				ADD r0, r3, r0, LSL #4
				B iterateStr
		
		ENDP

__main	PROC
		
		MOVW r0, #0
		LDR r1, =hex1 ; load the starting address of hex1
		BL iterateStr 
		
		MOV r4, r0 ; hex1 in 32-bit number format
		
		MOVW r0, #0
		LDR r1, =hex2 ; load the starting address of hex1
		BL iterateStr
		
		MOV r5, r0 ; hex2 in 32-bit number format
		UDIV r0, r4, r5
		MLS r0, r0, r5, r4
		
		ENDP



		AREA data, DATA, READWRITE 
hex1	DCB	"00000031", 0 ; first null terminated hex string
hex2	DCB	"0000001A", 0 ; second null terminated hex string
result	DCD	0
		END