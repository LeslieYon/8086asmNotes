DSEG SEGMENT;数据段
   STRING1 DB 1,2,3,4,5
DSEG  ENDS
ESEG  SEGMENT;附加段
   STRING2 DB 5 DUP(?)
ESEG  ENDS
SSEG SEGMENT;堆栈段
   DW 10 DUP(?)
SSEG  ENDS
CSEG  SEGMENT;代码段
		ASSUME  CS:CSEG,DS:DSEG;声明各段于段寄存器的关系
		ASSUME  ES:ESEG,SS:SSEG
START:	MOV  AX,DSEG;设定数据段
		MOV  DS,AX
		MOV  AX,ESEG;设定附加段
		MOV  ES,AX
		MOV  AX,SSEG;设定堆栈段
		MOV  SS,AX
		
		LEA  SI,STRING1;将str1复制到str2的位置
		LEA  DI,STRING2
		MOV  CX,5
		CLD;设置复制方向为从低到高
		REP  MOVSB
		
		MOV  AH,4CH;程序结束
		INT  21H
CSEG ENDS
END START