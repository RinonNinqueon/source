
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ds1820_devices=R3
	.DEF _temp=R4
	.DEF _t_old=R6
	.DEF _out=R2
	.DEF _i=R9
	.DEF _j=R8

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_leds:
	.DB  0xDB,0xA,0xC7,0x4F,0x1E,0x5D,0xDD,0xB
	.DB  0xDF,0x5F,0xD5,0x84
_bit_mask_G100:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

_0x28:
	.DB  0x0,0x0,0x13,0x0,0x0,0x0,0x10,0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x02
	.DW  _0x28*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,0x00
	OUT  GPIOR0,R30
	OUT  GPIOR1,R30
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10.06.2016
;Author  : NeVaDa
;Company : SBE Software
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;//FUSES: 0xDE 0xD9 0xFF
;//-U lfuse:w:0xde:m -U hfuse:w:0xd9:m -U efuse:w:0xff:m
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;//#define _display_err_
;//#include <Math.h>
;
;
;// 1 Wire Bus functions
;#asm
   .equ __w1_port=0x18 ;PORTB
   .equ __w1_bit=0
; 0000 0025 #endasm
;#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds18b20_cli.h>
;
;// maximum number of DS1820 devices
;// connected to the 1 Wire bus
;#define MAX_DS1820 2
;// number of DS1820 devices
;// connected to the 1 Wire bus
;unsigned char ds1820_devices;
;// DS1820 devices ROM code storage area,
;// 9 bytes are used for each device
;// (see the w1_search function description in the help)
;unsigned char ds1820_rom_codes[MAX_DS1820][9];
;
;#define SetBit(x,y) (x|=y)
;#define ClrBit(x,y) (x&=~y)
;#define TestBit(x,y) (x&y)
;
;#define port_sh PORTB
;#define pin_sh  0x02
;#define pin_st  0x04
;#define pin_d   0x08
;
;#define port_ds PORTD
;#define led1    0x10
;#define led2    0x20
;#define led3    0x40
;#define button  0x02
;#define jumper  0x01
;#define led_rd  0x04
;#define led_gr  0x08
;
;//Массив для 74HC595 -> Семисегментник || 0-7 = A-G+DP
;flash unsigned char leds[12] = {
; 0b11011011,        //0
; 0b00001010,        //1
; 0b11000111,        //2
; 0b01001111,        //3
; 0b00011110,        //4
; 0b01011101,        //5
; 0b11011101,        //6
; 0b00001011,        //7
; 0b11011111,        //8
; 0b01011111,         //9
; 0b11010101,        //E
; 0b10000100};       //r
;//unsigned char rom[8];
;
;unsigned int temp = 19, t_old;    //Температура
;bit term = 0;           //Текущий датчик (из двух)
;bit pause = 0;          //1 -- уже нажали кнопку, таймер установлен чуть больше
;bit minus = 0;
;unsigned char out = 0;    //Переменная для вывода одного числа на семисегментник
;unsigned char i = 0;    //Инкремент
;unsigned char j = led1;    //Инкремент
;//unsigned char o1 = 0;   //out для знаков
;
;//Функция работы со сдвиговым регистром 74HC595
;void inline shift_out(unsigned char data)
; 0000 0063 {

	.CSEG
_shift_out:
; 0000 0064     ClrBit(port_sh, pin_st);
;	data -> Y+0
	CBI  0x18,2
; 0000 0065     ClrBit(port_sh, pin_sh);
	CBI  0x18,1
; 0000 0066 
; 0000 0067 	for(i = 0; i < 8; i++)
	CLR  R9
_0x4:
	LDI  R30,LOW(8)
	CP   R9,R30
	BRSH _0x5
; 0000 0068 	{
; 0000 0069 		if(data & 0x80)
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x6
; 0000 006A 			SetBit(port_sh, pin_d);
	SBI  0x18,3
; 0000 006B 		else
	RJMP _0x7
_0x6:
; 0000 006C 			ClrBit(port_sh, pin_d);
	CBI  0x18,3
; 0000 006D 
; 0000 006E 		SetBit(port_sh, pin_sh);
_0x7:
	SBI  0x18,1
; 0000 006F 
; 0000 0070 		ClrBit(port_sh, pin_sh);
	CBI  0x18,1
; 0000 0071 		data <<= 1;
	LD   R30,Y
	LSL  R30
	ST   Y,R30
; 0000 0072 	}
	INC  R9
	RJMP _0x4
_0x5:
; 0000 0073 
; 0000 0074     SetBit(port_sh, pin_st);
	SBI  0x18,2
; 0000 0075 }
	ADIW R28,1
	RET
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007A {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007B     ClrBit(port_ds, 0b01110000);     //ВЫКЛ все
	IN   R30,0x12
	ANDI R30,LOW(0x8F)
	OUT  0x12,R30
; 0000 007C 
; 0000 007D     switch (j)
	MOV  R30,R8
; 0000 007E     {
; 0000 007F     case led1:
	CPI  R30,LOW(0x10)
	BRNE _0xB
; 0000 0080         #ifdef _display_err_
; 0000 0081         if (temp == 0xFFF)
; 0000 0082         {
; 0000 0083             out = leds[10];
; 0000 0084             break;
; 0000 0085         }
; 0000 0086         #endif
; 0000 0087 
; 0000 0088         out = 0x04 * minus;
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	LSL  R30
	LSL  R30
	MOV  R2,R30
; 0000 0089 
; 0000 008A         if (term)
	SBIS 0x13,0
	RJMP _0xC
; 0000 008B         {
; 0000 008C             ClrBit(port_ds, led_gr);
	CBI  0x12,3
; 0000 008D             SetBit(port_ds, led_rd);
	SBI  0x12,2
; 0000 008E         }
; 0000 008F         else
	RJMP _0xD
_0xC:
; 0000 0090         {
; 0000 0091             ClrBit(port_ds, led_rd);
	CBI  0x12,2
; 0000 0092             SetBit(port_ds, led_gr);
	SBI  0x12,3
; 0000 0093         }
_0xD:
; 0000 0094 
; 0000 0095         break;
	RJMP _0xA
; 0000 0096 
; 0000 0097     case led2:
_0xB:
	CPI  R30,LOW(0x20)
	BRNE _0xE
; 0000 0098         #ifdef _display_err_
; 0000 0099         if (temp == 0xFFF)
; 0000 009A         {
; 0000 009B             out = leds[11];
; 0000 009C             break;
; 0000 009D         }
; 0000 009E         #endif
; 0000 009F 
; 0000 00A0         out = t_old / 10;        //Десятки
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RJMP _0x26
; 0000 00A1 
; 0000 00A2         out = leds[out];        //Вывод числа через массив
; 0000 00A3         break;
; 0000 00A4 
; 0000 00A5     case led3:
_0xE:
	CPI  R30,LOW(0x40)
	BRNE _0xA
; 0000 00A6         #ifdef _display_err_
; 0000 00A7         if (temp == 0xFFF)
; 0000 00A8         {
; 0000 00A9             out = leds[11];
; 0000 00AA             break;
; 0000 00AB         }
; 0000 00AC         #endif
; 0000 00AD 
; 0000 00AE         out = t_old % 10;        //Единицы
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
_0x26:
	MOV  R2,R30
; 0000 00AF 
; 0000 00B0         out = leds[out];        //Вывод числа через массив
	MOV  R30,R2
	LDI  R31,0
	SUBI R30,LOW(-_leds*2)
	SBCI R31,HIGH(-_leds*2)
	LPM  R2,Z
; 0000 00B1         break;
; 0000 00B2     }
_0xA:
; 0000 00B3 
; 0000 00B4     shift_out(out);         //выводим на индикатор
	ST   -Y,R2
	RCALL _shift_out
; 0000 00B5     SetBit(port_ds, j);     //ВКЛ
	IN   R30,0x12
	OR   R30,R8
	OUT  0x12,R30
; 0000 00B6 
; 0000 00B7     j <<= 1;                //меняем индикатор
	LSL  R8
; 0000 00B8     if (j > led3)
	LDI  R30,LOW(64)
	CP   R30,R8
	BRSH _0x10
; 0000 00B9         j = led1;
	LDI  R30,LOW(16)
	MOV  R8,R30
; 0000 00BA }
_0x10:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00BE {
_timer1_ovf_isr:
	ST   -Y,R30
; 0000 00BF // Place your code here
; 0000 00C0     //Если была нажата кнопка, уже подождали много
; 0000 00C1     if (pause)
	SBIS 0x13,1
	RJMP _0x11
; 0000 00C2     {
; 0000 00C3         TCCR1B=0x02;        //Таймер побыстрее
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00C4         pause = 0;
	CBI  0x13,1
; 0000 00C5     }
; 0000 00C6 
; 0000 00C7     //Кнопарь
; 0000 00C8     if (!TestBit(PIND, button))
_0x11:
	SBIC 0x10,1
	RJMP _0x14
; 0000 00C9     {
; 0000 00CA         term = ~term;       //Меняем датчик
	SBIS 0x13,0
	RJMP _0x15
	CBI  0x13,0
	RJMP _0x16
_0x15:
	SBI  0x13,0
_0x16:
; 0000 00CB         TCCR1B=0x03;        //Таймер помедленнее
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 00CC         pause = 1;          //Нажали
	SBI  0x13,1
; 0000 00CD     }
; 0000 00CE }
_0x14:
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 00D3 {
_main:
; 0000 00D4 // Declare your local variables here
; 0000 00D5 // Input/Output Ports initialization
; 0000 00D6 // Port A initialization
; 0000 00D7 // Func2=In Func1=In Func0=In
; 0000 00D8 // State2=T State1=T State0=T
; 0000 00D9 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00DA DDRA=0x00;
	OUT  0x1A,R30
; 0000 00DB 
; 0000 00DC // Port B initialization
; 0000 00DD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 00DE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=T
; 0000 00DF PORTB=0x00;
	OUT  0x18,R30
; 0000 00E0 DDRB=0xFE;
	LDI  R30,LOW(254)
	OUT  0x17,R30
; 0000 00E1 
; 0000 00E2 // Port D initialization
; 0000 00E3 // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 00E4 // State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 00E5 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00E6 DDRD=0x7C;
	LDI  R30,LOW(124)
	OUT  0x11,R30
; 0000 00E7 
; 0000 00E8 // Timer/Counter 0 initialization
; 0000 00E9 // Clock source: System Clock
; 0000 00EA // Clock value: 7,813 kHz
; 0000 00EB // Mode: Normal top=FFh
; 0000 00EC // OC0A output: Disconnected
; 0000 00ED // OC0B output: Disconnected
; 0000 00EE TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EF TCCR0B=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00F0 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00F1 OCR0A=0x00;
	OUT  0x36,R30
; 0000 00F2 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00F3 
; 0000 00F4 // Timer/Counter 1 initialization
; 0000 00F5 // Clock source: System Clock
; 0000 00F6 // Clock value: 7,813 kHz
; 0000 00F7 // Mode: Normal top=FFFFh
; 0000 00F8 // OC1A output: Discon.
; 0000 00F9 // OC1B output: Discon.
; 0000 00FA // Noise Canceler: Off
; 0000 00FB // Input Capture on Falling Edge
; 0000 00FC // Timer1 Overflow Interrupt: On
; 0000 00FD // Input Capture Interrupt: Off
; 0000 00FE // Compare A Match Interrupt: Off
; 0000 00FF // Compare B Match Interrupt: Off
; 0000 0100 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0101 TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0102 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0103 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0104 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0105 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0106 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0107 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0108 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0109 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 010A 
; 0000 010B // External Interrupt(s) initialization
; 0000 010C // INT0: Off
; 0000 010D // INT1: Off
; 0000 010E // Interrupt on any change on pins PCINT0-7: Off
; 0000 010F GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0110 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0111 
; 0000 0112 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0113 TIMSK=0x82;
	LDI  R30,LOW(130)
	OUT  0x39,R30
; 0000 0114 //TIMSK=0x00;
; 0000 0115 
; 0000 0116 // Universal Serial Interface initialization
; 0000 0117 // Mode: Disabled
; 0000 0118 // Clock source: Register & Counter=no clk.
; 0000 0119 // USI Counter Overflow Interrupt: Off
; 0000 011A USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 011B 
; 0000 011C // Analog Comparator initialization
; 0000 011D // Analog Comparator: Off
; 0000 011E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 011F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0120 
; 0000 0121 // Determine the number of DS1820 devices
; 0000 0122 // connected to the 1 Wire bus
; 0000 0123 
; 0000 0124 ds1820_devices=w1_search(0xf0, ds1820_rom_codes);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R30,LOW(_ds1820_rom_codes)
	ST   -Y,R30
	RCALL _w1_search
	MOV  R3,R30
; 0000 0125 
; 0000 0126 //Инициализация двух датчиков
; 0000 0127 ds18b20_init( &ds1820_rom_codes[0][0], -30, 60, DS18B20_9BIT_RES);
	LDI  R30,LOW(_ds1820_rom_codes)
	RCALL SUBOPT_0x0
; 0000 0128 ds18b20_init( &ds1820_rom_codes[1][0], -30, 60, DS18B20_9BIT_RES);
	__POINTB1MN _ds1820_rom_codes,9
	RCALL SUBOPT_0x0
; 0000 0129 
; 0000 012A // Global enable interrupts
; 0000 012B #asm("sei")
	sei
; 0000 012C 
; 0000 012D while (1)
_0x19:
; 0000 012E       {
; 0000 012F         if (TestBit(PIND, jumper))
	SBIS 0x10,0
	RJMP _0x1C
; 0000 0130             temp = ds18b20_temperature1(&ds1820_rom_codes[~term][0]);
	LDI  R30,0
	SBIS 0x13,0
	LDI  R30,1
	RJMP _0x27
; 0000 0131         else
_0x1C:
; 0000 0132             temp = ds18b20_temperature1(&ds1820_rom_codes[term][0]);
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
_0x27:
	LDI  R26,LOW(9)
	RCALL __MULB12U
	SUBI R30,-LOW(_ds1820_rom_codes)
	ST   -Y,R30
	RCALL _ds18b20_temperature1
	MOVW R4,R30
; 0000 0133 
; 0000 0134         #asm("cli")
	cli
; 0000 0135 
; 0000 0136         if (temp != 0xFFF)
	RCALL SUBOPT_0x1
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x1E
; 0000 0137         {
; 0000 0138             if ((temp & 0x8000) == 0)
	SBRC R5,7
	RJMP _0x1F
; 0000 0139                 minus = 0;
	CBI  0x13,2
; 0000 013A             else
	RJMP _0x22
_0x1F:
; 0000 013B             {
; 0000 013C                 minus = 1;
	SBI  0x13,2
; 0000 013D                 temp = ~temp + 1;
	MOVW R30,R4
	COM  R30
	COM  R31
	ADIW R30,1
	MOVW R4,R30
; 0000 013E             }
_0x22:
; 0000 013F 
; 0000 0140             temp = (unsigned char)(temp >> 4);
	MOVW R30,R4
	RCALL __LSRW4
	MOV  R4,R30
	CLR  R5
; 0000 0141             t_old = temp;
	MOVW R6,R4
; 0000 0142         }
; 0000 0143 
; 0000 0144         #asm("sei")
_0x1E:
	sei
; 0000 0145       };
	RJMP _0x19
; 0000 0146 }
_0x25:
	RJMP _0x25

	.CSEG
_ds18b20_select:
	ST   -Y,R17
	cli
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x2000003
	LDI  R30,LOW(0)
	RJMP _0x2020004
_0x2000003:
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000004
	LDI  R30,LOW(85)
	RCALL SUBOPT_0x2
	sei
	LDI  R17,LOW(0)
_0x2000006:
	cli
	LDD  R26,Y+1
	LD   R30,X
	RCALL SUBOPT_0x2
	sei
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2000006
	RJMP _0x2000008
_0x2000004:
	cli
	LDI  R30,LOW(204)
	RCALL SUBOPT_0x2
	sei
_0x2000008:
	LDI  R30,LOW(1)
_0x2020004:
	LDD  R17,Y+0
	ADIW R28,2
	RET
_ds18b20_read_spd:
	RCALL __SAVELOCR2
	LDD  R30,Y+2
	RCALL SUBOPT_0x3
	BRNE _0x2000009
	LDI  R30,LOW(0)
	RJMP _0x2020003
_0x2000009:
	cli
	LDI  R30,LOW(190)
	RCALL SUBOPT_0x2
	sei
	LDI  R17,LOW(0)
	__POINTBRM 16,___ds18b20_scratch_pad
_0x200000B:
	cli
	PUSH R16
	SUBI R16,-1
	RCALL _w1_read
	POP  R26
	ST   X,R30
	sei
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x200000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
_0x2020003:
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
_ds18b20_temperature1:
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x4
	BRNE _0x2000010
	RCALL SUBOPT_0x1
	RJMP _0x2020002
_0x2000010:
	LDD  R30,Y+4
	RCALL SUBOPT_0x3
	BRNE _0x2000011
	RCALL SUBOPT_0x1
	RJMP _0x2020002
_0x2000011:
	cli
	LDI  R30,LOW(68)
	RCALL SUBOPT_0x2
	sei
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RCALL SUBOPT_0x4
	BRNE _0x2000012
	RCALL SUBOPT_0x1
	RJMP _0x2020002
_0x2000012:
	RCALL _w1_init
	LDS  R18,___ds18b20_scratch_pad
	CLR  R19
	__GETB1HMN ___ds18b20_scratch_pad,1
	LDI  R30,LOW(0)
	__ORWRR 18,19,30,31
	MOVW R30,R18
_0x2020002:
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
_ds18b20_init:
	LDD  R30,Y+3
	RCALL SUBOPT_0x3
	BRNE _0x2000013
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000013:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	cli
	LDI  R30,LOW(78)
	RCALL SUBOPT_0x2
	LDD  R30,Y+1
	RCALL SUBOPT_0x2
	LDD  R30,Y+2
	RCALL SUBOPT_0x2
	LD   R30,Y
	RCALL SUBOPT_0x2
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2000014
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000014:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2000016
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2000016
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2000015
_0x2000016:
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000015:
	LDD  R30,Y+3
	RCALL SUBOPT_0x3
	BRNE _0x2000018
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000018:
	LDI  R30,LOW(72)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RCALL _w1_init
_0x2020001:
	ADIW R28,4
	RET

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_ds1820_rom_codes:
	.BYTE 0x12

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R30,LOW(226)
	ST   -Y,R30
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _ds18b20_init

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(4095)
	LDI  R31,HIGH(4095)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	RJMP _w1_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RCALL _ds18b20_select
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDD  R30,Y+4
	ST   -Y,R30
	RCALL _ds18b20_read_spd
	CPI  R30,0
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	inc  r30
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	ldi  r22,8
	ld   r23,y+
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
	ld   r26,y
	clr  r27
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	ldd  r30,y+1
	st   -y,r30
	rcall _w1_write
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,2
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	add  r30,r26
	clr  r31
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

_w1_dow_crc8:
	clr  r30
	ld   r24,y
	tst  r24
	breq __w1_dow_crc83
	ldi  r22,0x18
	ldd  r26,y+1
	clr  r27
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,2
	ret

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULB12U:
	MOV  R0,R26
	SUB  R26,R26
	LDI  R27,9
	RJMP __MULB12U1
__MULB12U3:
	BRCC __MULB12U2
	ADD  R26,R0
__MULB12U2:
	LSR  R26
__MULB12U1:
	ROR  R30
	DEC  R27
	BRNE __MULB12U3
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
