DSEG SEGMENT;数据段
	TIP DB 'Please input the number of ring times:$'
DSEG  ENDS

CSEG  SEGMENT;代码段
		ASSUME  CS:CSEG,DS:DSEG
START:	MOV  AX,DSEG
		MOV  DS,AX
		LEA DX,TIP;提示信息
		MOV AH,9H
		INT 21H
		XOR AX,AX;获取输入
		MOV AH,01H
		INT 21H
		SUB AL,30H
		XOR CX,CX
		MOV CL,AL
MLOOP:		MOV DL,07H;循环响铃
			MOV AH,02H
			INT 21H
			LOOP MLOOP
		MOV  AH,4CH
		INT  21H
CSEG ENDS
END START