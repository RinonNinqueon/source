
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int
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
	.DEF _time=R3
	.DEF _time_c=R2
	.DEF _lock0=R5
	.DEF _cmd1=R4
	.DEF _i=R7
	.DEF _val1=R6
	.DEF _val2=R9
	.DEF _val3=R8
	.DEF _val4=R11
	.DEF _e1=R10
	.DEF _e2=R13
	.DEF _dir=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00

_times:
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x2,0x0
	.DB  0x3,0x0,0x4,0x0,0x5,0x0,0x6,0x0
	.DB  0x7,0x0,0x8,0x0,0x8,0x0,0x9,0x0
	.DB  0x9,0x0,0xA,0x0,0xA,0x0,0xB,0x0
	.DB  0xB,0x0,0xC,0x0,0xC,0x0,0xD,0x0
	.DB  0xD,0x0,0xE,0x0,0xE,0x0,0xF,0x0
	.DB  0xF,0x0,0x10,0x0,0x10,0x0,0x11,0x0
	.DB  0x11,0x0,0x12,0x0,0x12,0x0,0x13,0x0
	.DB  0x13,0x0,0x14,0x0,0x14,0x0,0x15,0x0
	.DB  0x15,0x0,0x16,0x0,0x16,0x0,0x17,0x0
	.DB  0x17,0x0,0x18,0x0,0x18,0x0,0x19,0x0
	.DB  0x19,0x0,0x1A,0x0,0x1A,0x0,0x1B,0x0
	.DB  0x1B,0x0,0x1C,0x0,0x1C,0x0,0x1D,0x0
	.DB  0x1D,0x0,0x1E,0x0,0x1F,0x0,0x20,0x0
	.DB  0x21,0x0,0x22,0x0,0x23,0x0,0x24,0x0
	.DB  0x25,0x0,0x26,0x0,0x27,0x0,0x28,0x0
	.DB  0x29,0x0,0x2A,0x0,0x2B,0x0,0x2C,0x0
	.DB  0x2D,0x0,0x2E,0x0,0x2F,0x0,0x30,0x0
	.DB  0x31,0x0,0x32,0x0,0x33,0x0,0x34,0x0
	.DB  0x35,0x0,0x36,0x0,0x37,0x0,0x38,0x0
	.DB  0x39,0x0,0x3A,0x0,0x3B,0x0,0x3C,0x0
	.DB  0x3D,0x0,0x3E,0x0,0x3F,0x0,0x40,0x0
	.DB  0x41,0x0,0x42,0x0,0x43,0x0,0x44,0x0
	.DB  0x45,0x0,0x46,0x0,0x47,0x0,0x48,0x0
	.DB  0x49,0x0,0x4B,0x0,0x4D,0x0,0x4F,0x0
	.DB  0x51,0x0,0x53,0x0,0x55,0x0,0x57,0x0
	.DB  0x59,0x0,0x5B,0x0,0x5D,0x0,0x5F,0x0
	.DB  0x61,0x0,0x63,0x0,0x65,0x0,0x67,0x0
	.DB  0x69,0x0,0x6B,0x0,0x6D,0x0,0x6F,0x0
	.DB  0x71,0x0,0x73,0x0,0x75,0x0,0x77,0x0
	.DB  0x7A,0x0,0x7D,0x0,0x7F,0x0,0x82,0x0
	.DB  0x85,0x0,0x88,0x0,0x8B,0x0,0x8E,0x0
	.DB  0x91,0x0,0x94,0x0,0x95,0x0,0x96,0x0
	.DB  0x9B,0x0,0x9D,0x0,0x9F,0x0,0xA4,0x0
	.DB  0xA6,0x0,0xAA,0x0,0xAE,0x0,0xB1,0x0
	.DB  0xB4,0x0,0xB8,0x0,0xBC,0x0,0xC1,0x0
	.DB  0xC8,0x0,0xCC,0x0,0xD0,0x0,0xD4,0x0
	.DB  0xD8,0x0,0xDC,0x0,0xE1,0x0,0xE6,0x0
	.DB  0xEB,0x0,0xF0,0x0,0xF5,0x0,0xFA,0x0
	.DB  0xFF,0x0,0x4,0x1,0x9,0x1,0xE,0x1
	.DB  0x14,0x1,0x1A,0x1,0x20,0x1,0x26,0x1
	.DB  0x2C,0x1,0x32,0x1,0x38,0x1,0x3E,0x1
	.DB  0x44,0x1,0x4B,0x1,0x53,0x1,0x5B,0x1
	.DB  0x63,0x1,0x6C,0x1,0x74,0x1,0x7C,0x1
	.DB  0x86,0x1,0x8E,0x1,0x96,0x1,0x9E,0x1
	.DB  0xA6,0x1,0xAE,0x1,0xB6,0x1,0xBE,0x1
	.DB  0xC6,0x1,0xCE,0x1,0xD6,0x1,0xE0,0x1
	.DB  0xEA,0x1,0xF4,0x1,0xFE,0x1,0x8,0x2
	.DB  0x12,0x2,0x1C,0x2,0x29,0x2,0x36,0x2
	.DB  0x43,0x2,0x50,0x2,0x5D,0x2,0x6A,0x2
	.DB  0x77,0x2,0x84,0x2,0x91,0x2,0x9E,0x2
	.DB  0xAD,0x2,0xBA,0x2,0xC7,0x2,0xD4,0x2
	.DB  0xE4,0x2,0xEE,0x2,0xFF,0x2,0xF,0x3
	.DB  0x20,0x3,0x31,0x3,0x42,0x3,0x53,0x3
	.DB  0x64,0x3,0x75,0x3,0x86,0x3,0x97,0x3
	.DB  0xA6,0x3,0xB9,0x3,0xCA,0x3,0xDB,0x3
	.DB  0xE8,0x3,0x9,0x4,0x2A,0x4,0x4C,0x4
	.DB  0x65,0x4,0x7E,0x4,0x97,0x4,0xB0,0x4
	.DB  0xC9,0x4,0xE2,0x4,0xFB,0x4,0x14,0x5
	.DB  0x32,0x5,0x46,0x5,0x64,0x5,0x78,0x5
	.DB  0xA0,0x5,0xAA,0x5,0xDC,0x5,0xFD,0x5
	.DB  0x1B,0x6,0x40,0x6,0x61,0x6,0x85,0x6
	.DB  0xA4,0x6,0xC5,0x6,0xE6,0x6,0x8,0x7
	.DB  0x29,0x7,0x4A,0x7,0x6C,0x7,0xD0,0x7

_0x3:
	.DB  0x4
_0x55:
	.DB  0x0,0x0,0x11,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x2,0x0
_0x0:
	.DB  0x20,0x20,0x50,0x72,0x65,0x73,0x65,0x74
	.DB  0x20,0x23,0x0,0x20,0x6D,0x73,0x0,0x45
	.DB  0x6C,0x65,0x63,0x74,0x72,0x6F,0x2D,0x48
	.DB  0x61,0x72,0x6D,0x6F,0x6E,0x69,0x78,0x0
	.DB  0x20,0x20,0x23,0x31,0x20,0x45,0x63,0x68
	.DB  0x6F,0x20,0x62,0x79,0x0,0x20,0x52,0x69
	.DB  0x6E,0x6F,0x6E,0x20,0x4E,0x69,0x6E,0x71
	.DB  0x75,0x65,0x6F,0x6E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _dir_cnt
	.DW  _0x3*2

	.DW  0x0B
	.DW  _0x15
	.DW  _0x0*2

	.DW  0x04
	.DW  _0x15+11
	.DW  _0x0*2+11

	.DW  0x11
	.DW  _0x39
	.DW  _0x0*2+15

	.DW  0x0D
	.DW  _0x39+17
	.DW  _0x0*2+32

	.DW  0x10
	.DW  _0x39+30
	.DW  _0x0*2+45

	.DW  0x0C
	.DW  0x02
	.DW  _0x55*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;Date    : 07.04.2013
;Author  : NeVaDa
;Company :
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
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 001C #endasm
;#include <lcd.h>
;
;#define SetBit(x,y) (x|=y)
;#define ClrBit(x,y) (x&=~y)
;#define TestBit(x,y) (x&y)
;
;#define D_LEFT	0
;#define D_NONE	1
;#define D_RIGHT	2
;
;#define p_c 0b00000001
;#define p_d 0b00000010
;#define p_r	0b00000100
;#define p_l	0b00001000
;#define p_e 0b00010000
;#define enc	PIND
;
;#define _dir_cnt 4
;#define _dir_cnt2 8
;
;/*-------SPI------*/
;
;#define nSS			3
;#define SDI 		5
;#define	SCK			6
;
;#define	SPI_PORT	PORTD
;
;#define HI(x) SPI_PORT |= (1<<(x))
;#define LO(x) SPI_PORT &= ~(1<<(x))
;
;#define max_time  0xFF
;#define max_ee 5
;
;flash unsigned int times[256]= {   0,    0,    1,    2,    3,    4,    5,    6,    7,    8,    8,    9,    9,   10,   10,   11,              //   0 -  15
;                                  11,   12,   12,   13,   13,   14,   14,   15,   15,   16,   16,   17,   17,   18,   18,   19,              //  16 -  31
;                                  19,   20,   20,   21,   21,   22,   22,   23,   23,   24,   24,   25,   25,   26,   26,   27,              //  32 -  47
;                                  27,   28,   28,   29,   29,   30,   31,   32,   33,   34,   35,   36,   37,   38,   39,   40,              //  48 -  63
;                                  41,   42,   43,   44,   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,   55,   56,              //  64 -  79
;                                  57,   58,   59,   60,   61,   62,   63,   64,   65,   66,   67,   68,   69,   70,   71,   72,              //  80 -  95
;                                  73,   75,   77,   79,   81,   83,   85,   87,   89,   91,   93,   95,   97,   99,  101,  103,              //  96 - 111
;                                 105,  107,  109,  111,  113,  115,  117,  119,  122,  125,  127,  130,  133,  136,  139,  142,              // 112 - 127
;                                 145,  148,  149,  150,  155,  157,  159,  164,  166,  170,  174,  177,  180,  184,  188,  193,              // 128 - 143
;                                 200,  204,  208,  212,  216,  220,  225,  230,  235,  240,  245,  250,  255,  260,  265,  270,              // 144 - 159
;                                 276,  282,  288,  294,  300,  306,  312,  318,  324,  331,  339,  347,  355,  364,  372,  380,              // 160 - 175
;                                 390,  398,  406,  414,  422,  430,  438,  446,  454,  462,  470,  480,  490,  500,  510,  520,              // 176 - 191
;                                 530,  540,  553,  566,  579,  592,  605,  618,  631,  644,  657,  670,  685,  698,  711,  724,              // 192 - 207
;                                 740,  750,  767,  783,  800,  817,  834,  851,  868,  885,  902,  919,  934,  953,  970,  987,              // 208 - 223
;                                1000, 1033, 1066, 1100, 1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300, 1330, 1350, 1380, 1400,              // 224 - 239
;                                1440, 1450, 1500, 1533, 1563, 1600, 1633, 1669, 1700, 1733, 1766, 1800, 1833, 1866, 1900, 2000};             // 240 - 255
;
;unsigned char time = 0, time_c = 0;
;unsigned char lock0 = 0;
;unsigned char cmd1 = 0b00010001;
;unsigned char i;
;unsigned char val1, val2, val3, val4;
;unsigned char e1 = 0, e2 = 0;
;unsigned char dir = 2, dir_cnt = _dir_cnt;

	.DSEG
;volatile unsigned char v_time[max_ee];
;
;
;void setRes(unsigned char cmd2)
; 0000 005B {

	.CSEG
_setRes:
; 0000 005C     cmd1 = 0b00010001;
;	cmd2 -> Y+0
	LDI  R30,LOW(17)
	MOV  R4,R30
; 0000 005D 	LO(SCK);
	CBI  0x12,6
; 0000 005E 	delay_us(1);
	RCALL SUBOPT_0x0
; 0000 005F 	PORTB &= ~0b00001000;
	CBI  0x18,3
; 0000 0060 	delay_us(1);
	RCALL SUBOPT_0x0
; 0000 0061 
; 0000 0062 	for(i = 0; i < 8; i++)
	CLR  R7
_0x5:
	LDI  R30,LOW(8)
	CP   R7,R30
	BRSH _0x6
; 0000 0063 	{
; 0000 0064 		if(cmd1 & 0x80)
	SBRS R4,7
	RJMP _0x7
; 0000 0065 			SPI_PORT |= 0b00100000; //HI(SDI);
	SBI  0x12,5
; 0000 0066 		else
	RJMP _0x8
_0x7:
; 0000 0067 			SPI_PORT &= ~0b00100000;//LO(SDI);
	CBI  0x12,5
; 0000 0068 
; 0000 0069 		delay_us(1);
_0x8:
	RCALL SUBOPT_0x1
; 0000 006A 		SPI_PORT |= 0b01000000;//HI(SCK);
; 0000 006B 
; 0000 006C 		delay_us(1);
; 0000 006D 		SPI_PORT &= ~0b01000000;//LO(SCK);
; 0000 006E 		cmd1 <<= 1;
	LSL  R4
; 0000 006F 	}
	INC  R7
	RJMP _0x5
_0x6:
; 0000 0070 
; 0000 0071 
; 0000 0072 	for(i = 0; i < 8; i++)
	CLR  R7
_0xA:
	LDI  R30,LOW(8)
	CP   R7,R30
	BRSH _0xB
; 0000 0073 	{
; 0000 0074 		if(cmd2 & 0x80)
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0xC
; 0000 0075 			SPI_PORT |= 0b00100000; //HI(SDI);
	SBI  0x12,5
; 0000 0076 		else
	RJMP _0xD
_0xC:
; 0000 0077 			SPI_PORT &= ~0b00100000;//LO(SDI);
	CBI  0x12,5
; 0000 0078 
; 0000 0079 		delay_us(1);
_0xD:
	RCALL SUBOPT_0x1
; 0000 007A 		SPI_PORT |= 0b01000000;//HI(SCK);
; 0000 007B 
; 0000 007C 		delay_us(1);
; 0000 007D 		SPI_PORT &= ~0b01000000;//LO(SCK);
; 0000 007E 		cmd2 <<= 1;
	LD   R30,Y
	LSL  R30
	ST   Y,R30
; 0000 007F 	}
	INC  R7
	RJMP _0xA
_0xB:
; 0000 0080 
; 0000 0081 	delay_us(1);
	RCALL SUBOPT_0x0
; 0000 0082 	PORTB |= 0b00001000; //(1<<(nSS));
	SBI  0x18,3
; 0000 0083 }
	RJMP _0x2020001
;
;void LCDWriteInt(unsigned int val)
; 0000 0086 {
_LCDWriteInt:
; 0000 0087 	/***************************************************************
; 0000 0088 	This function writes a integer type value to LCD module
; 0000 0089 
; 0000 008A 	Arguments:
; 0000 008B 	1)unsigned char val	: Value to print
; 0000 008C 
; 0000 008D 	2)unsigned char field_length :total length of field in which the value is printed
; 0000 008E 	must be between 1-3 if it is -1 the field length is no of digits in the val
; 0000 008F 
; 0000 0090 	****************************************************************/
; 0000 0091 
; 0000 0092     val1 = val % 10;
;	val -> Y+0
	RCALL SUBOPT_0x2
	RCALL __MODW21U
	MOV  R6,R30
; 0000 0093     val2 = (val / 10) % 10;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	MOV  R9,R30
; 0000 0094     val3 = (val / 100) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x3
	MOV  R8,R30
; 0000 0095     val4 = (val / 1000) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x3
	MOV  R11,R30
; 0000 0096 
; 0000 0097     if (val4 != 0)
	TST  R11
	BREQ _0xE
; 0000 0098     lcd_putchar(48 + val4);
	MOV  R30,R11
	RCALL SUBOPT_0x5
; 0000 0099     if (val3 != 0 || val4 != 0)
_0xE:
	LDI  R30,LOW(0)
	CP   R30,R8
	BRNE _0x10
	CP   R30,R11
	BREQ _0xF
_0x10:
; 0000 009A     lcd_putchar(48 + val3);
	MOV  R30,R8
	RCALL SUBOPT_0x5
; 0000 009B     if (val2 != 0 || val3 != 0 || val4 != 0)
_0xF:
	LDI  R30,LOW(0)
	CP   R30,R9
	BRNE _0x13
	CP   R30,R8
	BRNE _0x13
	CP   R30,R11
	BREQ _0x12
_0x13:
; 0000 009C     lcd_putchar(48 + val2);
	MOV  R30,R9
	RCALL SUBOPT_0x5
; 0000 009D     lcd_putchar(48 + val1);
_0x12:
	MOV  R30,R6
	RCALL SUBOPT_0x5
; 0000 009E }
	RJMP _0x2020002
;
;void lcd_out(void)
; 0000 00A1 {
_lcd_out:
; 0000 00A2     lcd_clear();
	RCALL _lcd_clear
; 0000 00A3 
; 0000 00A4 	lcd_puts("  Preset #");
	__POINTB1MN _0x15,0
	RCALL SUBOPT_0x6
; 0000 00A5 //    lcd_putchar(' ');
; 0000 00A6 
; 0000 00A7     if (time > 0)	lcd_putchar('<');	else	lcd_putchar(' ');
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x16
	LDI  R30,LOW(60)
	RJMP _0x50
_0x16:
	LDI  R30,LOW(32)
_0x50:
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 00A8 	LCDWriteInt(time+1);
	MOV  R30,R3
	SUBI R30,-LOW(1)
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00A9 	if (time < max_ee - 1)	lcd_putchar('>');	else	lcd_putchar(' ');
	LDI  R30,LOW(4)
	CP   R3,R30
	BRSH _0x18
	LDI  R30,LOW(62)
	RJMP _0x51
_0x18:
	LDI  R30,LOW(32)
_0x51:
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 00AA 
; 0000 00AB 	lcd_gotoxy(3, 1);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x7
; 0000 00AC 
; 0000 00AD 	if (time_c > 0)			lcd_putchar('<');	else	lcd_putchar(' ');
	LDI  R30,LOW(0)
	CP   R30,R2
	BRSH _0x1A
	LDI  R30,LOW(60)
	RJMP _0x52
_0x1A:
	LDI  R30,LOW(32)
_0x52:
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 00AE 	LCDWriteInt(times[time_c]);
	MOV  R30,R2
	LDI  R26,LOW(_times*2)
	LDI  R27,HIGH(_times*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	RCALL SUBOPT_0x8
	RCALL _LCDWriteInt
; 0000 00AF 	if (time_c < max_time)	lcd_putchar('>');	else	lcd_putchar(' ');
	LDI  R30,LOW(255)
	CP   R2,R30
	BRSH _0x1C
	LDI  R30,LOW(62)
	RJMP _0x53
_0x1C:
	LDI  R30,LOW(32)
_0x53:
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 00B0 
; 0000 00B1 	lcd_puts(" ms");
	__POINTB1MN _0x15,11
	RCALL SUBOPT_0x6
; 0000 00B2 }
	RET

	.DSEG
_0x15:
	.BYTE 0xF
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00B6 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B7 // Place your code here
; 0000 00B8     if (TestBit(enc, p_r) && TestBit(enc, p_l))
	SBIS 0x10,2
	RJMP _0x1F
	SBIC 0x10,3
	RJMP _0x20
_0x1F:
	RJMP _0x1E
_0x20:
; 0000 00B9         e1 = 0;
	CLR  R10
; 0000 00BA     if (!TestBit(enc, p_r) && TestBit(enc, p_l))
_0x1E:
	SBIC 0x10,2
	RJMP _0x22
	SBIC 0x10,3
	RJMP _0x23
_0x22:
	RJMP _0x21
_0x23:
; 0000 00BB         e1 = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 00BC     if (!TestBit(enc, p_r) && !TestBit(enc, p_l))
_0x21:
	SBIC 0x10,2
	RJMP _0x25
	SBIS 0x10,3
	RJMP _0x26
_0x25:
	RJMP _0x24
_0x26:
; 0000 00BD         e1 = 2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 00BE     if (TestBit(enc, p_r) && !TestBit(enc, p_l))
_0x24:
	SBIS 0x10,2
	RJMP _0x28
	SBIS 0x10,3
	RJMP _0x29
_0x28:
	RJMP _0x27
_0x29:
; 0000 00BF         e1 = 3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 00C0 
; 0000 00C1     switch (e2)
_0x27:
	MOV  R30,R13
; 0000 00C2     {
; 0000 00C3         case 0: if (e1 == 1)
	CPI  R30,0
	BRNE _0x2D
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x2E
; 0000 00C4                     dir = 0;
	CLR  R12
; 0000 00C5                 if (e1 == 3)
_0x2E:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x2F
; 0000 00C6                     dir = 2;
	RCALL SUBOPT_0x9
; 0000 00C7                 break;
_0x2F:
	RJMP _0x2C
; 0000 00C8         case 1: if (e1 == 2)
_0x2D:
	CPI  R30,LOW(0x1)
	BRNE _0x30
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x31
; 0000 00C9                     dir = 0;
	CLR  R12
; 0000 00CA                 if (e1 == 0)
_0x31:
	TST  R10
	BRNE _0x32
; 0000 00CB                     dir = 2;
	RCALL SUBOPT_0x9
; 0000 00CC                 break;
_0x32:
	RJMP _0x2C
; 0000 00CD         case 2: if (e1 == 3)
_0x30:
	CPI  R30,LOW(0x2)
	BRNE _0x33
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x34
; 0000 00CE                     dir = 0;
	CLR  R12
; 0000 00CF                 if (e1 == 1)
_0x34:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x35
; 0000 00D0                     dir = 2;
	RCALL SUBOPT_0x9
; 0000 00D1                 break;
_0x35:
	RJMP _0x2C
; 0000 00D2         case 3: if (e1 == 0)
_0x33:
	CPI  R30,LOW(0x3)
	BRNE _0x2C
	TST  R10
	BRNE _0x37
; 0000 00D3                     dir = 0;
	CLR  R12
; 0000 00D4                 if (e1 == 2)
_0x37:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x38
; 0000 00D5                     dir = 2;
	RCALL SUBOPT_0x9
; 0000 00D6                 break;
_0x38:
; 0000 00D7     }
_0x2C:
; 0000 00D8 
; 0000 00D9     e2 = e1;
	MOV  R13,R10
; 0000 00DA }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;void main(void)
; 0000 00DD {
_main:
; 0000 00DE // Declare your local variables here
; 0000 00DF 
; 0000 00E0 // Crystal Oscillator division factor: 1
; 0000 00E1 #pragma optsize-
; 0000 00E2 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00E3 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00E4 #ifdef _OPTIMIZE_SIZE_
; 0000 00E5 #pragma optsize+
; 0000 00E6 #endif
; 0000 00E7 
; 0000 00E8 // Input/Output Ports initialization
; 0000 00E9 // Port A initialization
; 0000 00EA // Func2=In Func1=In Func0=In
; 0000 00EB // State2=T State1=T State0=T
; 0000 00EC PORTA=0x00;
	OUT  0x1B,R30
; 0000 00ED DDRA=0x00;
	OUT  0x1A,R30
; 0000 00EE 
; 0000 00EF // Port B initialization
; 0000 00F0 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00F1 // State7=0 State6=0 State5=0 State4=0 State3=1 State2=0 State1=0 State0=0
; 0000 00F2 PORTB=0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 00F3 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00F4 
; 0000 00F5 // Port D initialization
; 0000 00F6 // Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F7 // State6=0 State5=0 State4=P State3=P State2=P State1=P State0=P
; 0000 00F8 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00F9 DDRD=0x60;
	LDI  R30,LOW(96)
	OUT  0x11,R30
; 0000 00FA 
; 0000 00FB 
; 0000 00FC // Timer/Counter 0 initialization
; 0000 00FD // Clock source: System Clock
; 0000 00FE // Clock value: 1000,000 kHz
; 0000 00FF // Mode: Normal top=FFh
; 0000 0100 // OC0A output: Disconnected
; 0000 0101 // OC0B output: Disconnected
; 0000 0102 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0103 TCCR0B=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0104 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0105 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0106 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 0107 
; 0000 0108 // Timer/Counter 1 initialization
; 0000 0109 // Clock source: System Clock
; 0000 010A // Clock value: 8000,000 kHz
; 0000 010B // Mode: CTC top=OCR1A
; 0000 010C // OC1A output: Discon.
; 0000 010D // OC1B output: Discon.
; 0000 010E // Noise Canceler: Off
; 0000 010F // Input Capture on Falling Edge
; 0000 0110 // Timer1 Overflow Interrupt: Off
; 0000 0111 // Input Capture Interrupt: Off
; 0000 0112 // Compare A Match Interrupt: On
; 0000 0113 // Compare B Match Interrupt: Off
; 0000 0114 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0115 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0116 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0117 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0118 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0119 ICR1L=0x00;
	OUT  0x24,R30
; 0000 011A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 011B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 011C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 011D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 011E 
; 0000 011F // External Interrupt(s) initialization
; 0000 0120 // INT0: On
; 0000 0121 // INT0 Mode: Falling Edge
; 0000 0122 // INT1: Off
; 0000 0123 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0124 //GIMSK=0x40;
; 0000 0125 //MCUCR=0x02;
; 0000 0126 //EIFR=0x40;
; 0000 0127 
; 0000 0128 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0129 MCUCR=0x00;
	OUT  0x35,R30
; 0000 012A EIFR=0x00;
	OUT  0x3A,R30
; 0000 012B 
; 0000 012C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 012D TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 012E 
; 0000 012F // Universal Serial Interface initialization
; 0000 0130 // Mode: Disabled
; 0000 0131 // Clock source: Register & Counter=no clk.
; 0000 0132 // USI Counter Overflow Interrupt: Off
; 0000 0133 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0134 
; 0000 0135 // Analog Comparator initialization
; 0000 0136 // Analog Comparator: Off
; 0000 0137 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0138 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0139 
; 0000 013A // LCD module initialization
; 0000 013B lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 013C 
; 0000 013D lcd_clear();
	RCALL _lcd_clear
; 0000 013E lcd_puts("Electro-Harmonix");
	__POINTB1MN _0x39,0
	RCALL SUBOPT_0x6
; 0000 013F delay_ms(1000);
	RCALL SUBOPT_0xA
; 0000 0140 lcd_gotoxy(0, 1);
; 0000 0141 lcd_puts("  #1 Echo by");
	__POINTB1MN _0x39,17
	RCALL SUBOPT_0x6
; 0000 0142 delay_ms(1000);
	RCALL SUBOPT_0xA
; 0000 0143 lcd_gotoxy(0, 1);
; 0000 0144 //lcd_puts("  Digital Delay");
; 0000 0145 lcd_puts(" Rinon Ninqueon");
	__POINTB1MN _0x39,30
	RCALL SUBOPT_0x6
; 0000 0146 delay_ms(1000);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
	RCALL _delay_ms
; 0000 0147 
; 0000 0148 //lcd_clear();
; 0000 0149 //lcd_gotoxy(0, 0);
; 0000 014A //lcd_puts("  Digital Delay ");
; 0000 014B //lcd_gotoxy(0, 1);
; 0000 014C //lcd_puts(" Rinon Ninqueon ");
; 0000 014D 
; 0000 014E //delay_ms(1000);
; 0000 014F 
; 0000 0150 
; 0000 0151 lcd_out();
	RCALL _lcd_out
; 0000 0152 // Global enable interrupts
; 0000 0153 #asm("sei")
	sei
; 0000 0154 
; 0000 0155 i = 0;
	CLR  R7
; 0000 0156 while (i < max_ee)
_0x3A:
	LDI  R30,LOW(5)
	CP   R7,R30
	BRSH _0x3C
; 0000 0157     v_time[i++] = 175;
	MOV  R30,R7
	INC  R7
	SUBI R30,-LOW(_v_time)
	LDI  R26,LOW(175)
	STD  Z+0,R26
	RJMP _0x3A
_0x3C:
; 0000 0159 time_c = v_time[0];
	LDS  R2,_v_time
; 0000 015A 
; 0000 015B setRes(time_c);
	RCALL SUBOPT_0xB
; 0000 015C 
; 0000 015D while (1)
_0x3D:
; 0000 015E {
; 0000 015F     if (dir != 1)               //обработка энкодера
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ _0x40
; 0000 0160     {
; 0000 0161         if (dir == 0)
	TST  R12
	BRNE _0x41
; 0000 0162         {
; 0000 0163             if (dir_cnt == 0)
	LDS  R30,_dir_cnt
	CPI  R30,0
	BRNE _0x42
; 0000 0164 		    {
; 0000 0165                 if (time_c > 0)
	LDI  R30,LOW(0)
	CP   R30,R2
	BRSH _0x43
; 0000 0166     	    	    time_c--;
	DEC  R2
; 0000 0167                 dir_cnt = _dir_cnt;
_0x43:
	LDI  R30,LOW(4)
	STS  _dir_cnt,R30
; 0000 0168             }
; 0000 0169             dir_cnt--;
_0x42:
	LDS  R30,_dir_cnt
	SUBI R30,LOW(1)
	RJMP _0x54
; 0000 016A         }
; 0000 016B         else
_0x41:
; 0000 016C         {
; 0000 016D             if (dir_cnt == _dir_cnt2)
	LDS  R26,_dir_cnt
	CPI  R26,LOW(0x8)
	BRNE _0x45
; 0000 016E             {
; 0000 016F                 if (time_c < max_time)
	LDI  R30,LOW(255)
	CP   R2,R30
	BRSH _0x46
; 0000 0170         		    time_c++;
	INC  R2
; 0000 0171                 dir_cnt = _dir_cnt;
_0x46:
	LDI  R30,LOW(4)
	STS  _dir_cnt,R30
; 0000 0172             }
; 0000 0173             dir_cnt++;
_0x45:
	LDS  R30,_dir_cnt
	SUBI R30,-LOW(1)
_0x54:
	STS  _dir_cnt,R30
; 0000 0174         }
; 0000 0175 
; 0000 0176     	setRes(time_c);
	RCALL SUBOPT_0xB
; 0000 0177 
; 0000 0178         dir = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0179 		lcd_out();
	RCALL _lcd_out
; 0000 017A     }
; 0000 017B 
; 0000 017C 
; 0000 017D 	if (!TestBit(enc, p_c))     //предыдущий пресет
_0x40:
	SBIC 0x10,0
	RJMP _0x47
; 0000 017E 	{
; 0000 017F 		if (!TestBit(lock0, 0x01))
	SBRC R5,0
	RJMP _0x48
; 0000 0180 		{
; 0000 0181 			SetBit(lock0, 0x01);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xC
; 0000 0182 
; 0000 0183             v_time[time] = time_c;
; 0000 0184 
; 0000 0185             if (time > 0)
	LDI  R30,LOW(0)
	CP   R30,R3
	BRSH _0x49
; 0000 0186                 time--;
	DEC  R3
; 0000 0187 
; 0000 0188             time_c = v_time[time];
_0x49:
	RCALL SUBOPT_0xD
; 0000 0189             setRes(time_c);
; 0000 018A 			lcd_out();
	RCALL _lcd_out
; 0000 018B 		}
; 0000 018C 	}
_0x48:
; 0000 018D 	else
	RJMP _0x4A
_0x47:
; 0000 018E 		ClrBit(lock0, 0x01);
	LDI  R30,LOW(254)
	AND  R5,R30
; 0000 018F 
; 0000 0190     if (!TestBit(enc, p_d))     //следующий пресет
_0x4A:
	SBIC 0x10,1
	RJMP _0x4B
; 0000 0191 	{
; 0000 0192 		if (!TestBit(lock0, 0x02))
	SBRC R5,1
	RJMP _0x4C
; 0000 0193 		{
; 0000 0194 			SetBit(lock0, 0x02);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xC
; 0000 0195             v_time[time] = time_c;
; 0000 0196 
; 0000 0197             if (time < max_ee-1)
	LDI  R30,LOW(4)
	CP   R3,R30
	BRSH _0x4D
; 0000 0198                 time++;
	INC  R3
; 0000 0199             time_c = v_time[time];
_0x4D:
	RCALL SUBOPT_0xD
; 0000 019A             setRes(time_c);
; 0000 019B 			lcd_out();
	RCALL _lcd_out
; 0000 019C 		}
; 0000 019D 	}
_0x4C:
; 0000 019E 	else
	RJMP _0x4E
_0x4B:
; 0000 019F 		ClrBit(lock0, 0x02);
	LDI  R30,LOW(253)
	AND  R5,R30
; 0000 01A0 }
_0x4E:
	RJMP _0x3D
; 0000 01A1 }
_0x4F:
	RJMP _0x4F

	.DSEG
_0x39:
	.BYTE 0x2E
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G100:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	LD   R30,Y
	SUBI R30,-LOW(__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0xE
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	RJMP _0x2020002
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xE
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xE
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	RJMP _0x2020001
_lcd_puts:
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LD   R30,X+
	STD  Y+1,R26
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
_0x2020002:
	ADIW R28,2
	RET
__long_delay_G100:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G100:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xF
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0xE
	RCALL __long_delay_G100
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xE
	RCALL __long_delay_G100
	LDI  R30,LOW(133)
	RCALL SUBOPT_0xE
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xE
	RCALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_dir_cnt:
	.BYTE 0x1
_v_time:
	.BYTE 0x5
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	RCALL SUBOPT_0x0
	SBI  0x12,6
	RCALL SUBOPT_0x0
	CBI  0x12,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	SUBI R30,-LOW(48)
	ST   -Y,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(2)
	MOV  R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
	RCALL _delay_ms
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ST   -Y,R2
	RJMP _setRes

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	OR   R5,R30
	MOV  R30,R3
	SUBI R30,-LOW(_v_time)
	ST   Z,R2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_v_time)
	ADD  R26,R3
	LD   R2,X
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100


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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

;END OF CODE MARKER
__END_OF_CODE:
