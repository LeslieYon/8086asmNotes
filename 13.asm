DSEG SEGMENT;数据段
	ARRORG DW 1,-2,3,-4,5,-6,7,-8,9,-10,11,-12,-13,-14,15,-16,-17,18,19,-20
	ARRPOS DW 14H DUP(?)
	ARRNEG DW 14H DUP(?)
	TIPPOS DB 'The number of positive:$'
	TIPNEG DB 'The number of negative:$'
	POSNUM DW 0H
	NEGNUM DW 0H
	NUMIDX DW 1,10,100,1000,10000
DSEG  ENDS

SSEG SEGMENT;堆栈段
   DW 64 DUP(?)
SSEG  ENDS

CSEG  SEGMENT;代码段
		ASSUME  CS:CSEG,DS:DSEG,SS:SSEG

SHOWNUM	PROC FAR ;此函数用于向屏幕输出一个0~65535的十进制数AX
		PUSH CX
		PUSH BX
		PUSH DX
		PUSH SI
		XOR DX,DX
		MOV BX,AX
		MOV CX,5H
INT2ASC:	MOV SI,CX
			DEC SI
			ADD SI,SI
			MOV AX,BX
			DIV WORD PTR DS:[NUMIDX+SI]
			PUSH AX
			XOR DX,DX
			MOV DL,AL
			ADD DL,30H
			MOV AH,02H
			INT 21H
			POP AX
			MUL WORD PTR DS:[NUMIDX+SI]
			SUB BX,AX
			LOOP INT2ASC
		XOR AX,AX
		POP SI
		POP DX
		POP BX
		POP CX
		RET
SHOWNUM ENDP

START:	MOV  AX,DSEG;
		MOV  DS,AX
		MOV  AX,SSEG
		MOV  SS,AX
		MOV CX,14H
		XOR SI,SI
MAINLOP:	MOV BX,DS:[ARRORG+SI]
			ADD SI,2H
			CMP BX,0
			JNS POS
NEG:		PUSH SI
			MOV SI,DS:[NEGNUM]
			MOV DS:[ARRNEG+SI],BX ;负数
			ADD SI,2H
			MOV DS:[NEGNUM],SI
			POP SI
			LOOP MAINLOP
			JMP END
POS:		PUSH SI
			MOV SI,DS:[POSNUM]
			MOV DS:[ARRPOS+SI],BX ;正数
			ADD SI,2H
			MOV DS:[POSNUM],SI
			POP SI
			LOOP MAINLOP
END:	LEA DX,TIPPOS
		MOV AH,9H
		INT 21H
		MOV AX,DS:[POSNUM]
		SHR AX,1
		CALL SHOWNUM
		
		PUSH AX
		MOV DL,0AH
		MOV AH,02H
		INT 21H
		POP AX
		
		LEA DX,TIPNEG
		MOV AH,9H
		INT 21H
		MOV AX,DS:[NEGNUM]
		SHR AX,1
		CALL SHOWNUM
		MOV  AH,4CH
		INT  21H
CSEG ENDS
END START