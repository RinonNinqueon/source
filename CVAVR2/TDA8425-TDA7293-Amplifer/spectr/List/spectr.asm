
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _textx=R5
	.DEF _texty=R4
	.DEF _curx=R7
	.DEF _cury=R6
	.DEF _K=R9
	.DEF _I=R8
	.DEF _Tmp_s=R10
	.DEF _Tmp_c=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Sinus:
	.DB  0x0,0x0,0x32,0x0,0x62,0x0,0x8E,0x0
	.DB  0xB5,0x0,0xD5,0x0,0xED,0x0,0xFB,0x0
	.DB  0xFF,0x0,0xFB,0x0,0xED,0x0,0xD5,0x0
	.DB  0xB5,0x0,0x8E,0x0,0x62,0x0,0x32,0x0
	.DB  0x0,0x0,0xCE,0xFF,0x9E,0xFF,0x72,0xFF
	.DB  0x4B,0xFF,0x2B,0xFF,0x13,0xFF,0x5,0xFF
	.DB  0x1,0xFF,0x5,0xFF,0x13,0xFF,0x2B,0xFF
	.DB  0x4B,0xFF,0x72,0xFF,0x9E,0xFF,0xCE,0xFF
	.DB  0x0,0x0,0x32,0x0,0x62,0x0,0x8E,0x0
	.DB  0xB5,0x0,0xD5,0x0,0xED,0x0,0xFB,0x0
_Okno:
	.DB  0x0,0x3,0xA,0x17,0x28,0x3C,0x54,0x6D
	.DB  0x86,0xA0,0xB8,0xCE,0xE1,0xF0,0xFA,0xFF
	.DB  0xFF,0xFA,0xF0,0xE1,0xCE,0xB8,0xA0,0x86
	.DB  0x6D,0x54,0x3C,0x28,0x17,0xA,0x3,0x0
_L1:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE
	.DB  0xFF
_L2:
	.DB  0x0,0x80,0xC0,0xE0,0xF0,0xF8,0xFC,0xFE
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF
_sym:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x4F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x40,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x71,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x3A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x70,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x2,0x1
	.DB  0x2,0x2,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49
	.DB  0x49,0x33,0x7F,0x49,0x49,0x49,0x36,0x7F
	.DB  0x1,0x1,0x1,0x3,0xE0,0x51,0x4F,0x41
	.DB  0xFF,0x7F,0x49,0x49,0x49,0x41,0x77,0x8
	.DB  0x7F,0x8,0x77,0x41,0x49,0x49,0x49,0x36
	.DB  0x7F,0x10,0x8,0x4,0x7F,0x7C,0x21,0x12
	.DB  0x9,0x7C,0x7F,0x8,0x14,0x22,0x41,0x20
	.DB  0x41,0x3F,0x1,0x7F,0x7F,0x2,0xC,0x2
	.DB  0x7F,0x7F,0x8,0x8,0x8,0x7F,0x3E,0x41
	.DB  0x41,0x41,0x3E,0x7F,0x1,0x1,0x1,0x7F
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x41
	.DB  0x41,0x22,0x1,0x1,0x7F,0x1,0x1,0x47
	.DB  0x28,0x10,0x8,0x7,0x1C,0x22,0x7F,0x22
	.DB  0x1C,0x63,0x14,0x8,0x14,0x63,0x7F,0x40
	.DB  0x40,0x40,0xFF,0x7,0x8,0x8,0x8,0x7F
	.DB  0x7F,0x40,0x7F,0x40,0x7F,0x7F,0x40,0x7F
	.DB  0x40,0xFF,0x1,0x7F,0x48,0x48,0x30,0x7F
	.DB  0x48,0x30,0x0,0x7F,0x0,0x7F,0x48,0x48
	.DB  0x30,0x22,0x41,0x49,0x49,0x3E,0x7F,0x8
	.DB  0x3E,0x41,0x3E,0x46,0x29,0x19,0x9,0x7F
	.DB  0x20,0x54,0x54,0x54,0x78,0x3C,0x4A,0x4A
	.DB  0x49,0x31,0x7C,0x54,0x54,0x28,0x0,0x7C
	.DB  0x4,0x4,0x4,0xC,0xE0,0x54,0x4C,0x44
	.DB  0xFC,0x38,0x54,0x54,0x54,0x18,0x6C,0x10
	.DB  0x7C,0x10,0x6C,0x44,0x44,0x54,0x54,0x28
	.DB  0x7C,0x20,0x10,0x8,0x7C,0x7C,0x41,0x22
	.DB  0x11,0x7C,0x7C,0x10,0x28,0x44,0x0,0x20
	.DB  0x44,0x3C,0x4,0x7C,0x7C,0x8,0x10,0x8
	.DB  0x7C,0x7C,0x10,0x10,0x10,0x7C,0x38,0x44
	.DB  0x44,0x44,0x38,0x7C,0x4,0x4,0x4,0x7C
	.DB  0x7C,0x14,0x14,0x14,0x8,0x38,0x44,0x44
	.DB  0x44,0x20,0x4,0x4,0x7C,0x4,0x4,0xC
	.DB  0x50,0x50,0x50,0x3C,0x30,0x48,0xFC,0x48
	.DB  0x30,0x44,0x28,0x10,0x28,0x44,0x7C,0x40
	.DB  0x40,0x40,0xFC,0xC,0x10,0x10,0x10,0x7C
	.DB  0x7C,0x40,0x7C,0x40,0x7C,0x7C,0x40,0x7C
	.DB  0x40,0xFC,0x4,0x7C,0x50,0x50,0x20,0x7C
	.DB  0x50,0x50,0x20,0x7C,0x7C,0x50,0x50,0x20
	.DB  0x0,0x28,0x44,0x54,0x54,0x38,0x7C,0x10
	.DB  0x38,0x44,0x38,0x8,0x54,0x34,0x14,0x7C

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x204005F:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x204005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <math.h>
;#include <delay.h>
;
;flash int /*Tab_sin*/Sinus[40]={0 , 50 , 98 , 142 , 181 , 213 , 237 , 251, 255 , 251 , 237 , 213 , 181 , 142 , 98 , 50, 0 , -50 , -98 , -142 , -181 , -213 , -237 , -251, -255 , -251 , -237 , -213 , -181 , -142 , -98 , -50, 0 , 50 , 98 , 142 , 181 , 213 , 237 , 251};
;//flash int Tab_sin[128]={0, 12, 24, 37, 49, 61, 74, 85, 97, 109, 120, 131, 141, 151, 161, 171, 180, 188, 197, 204, 212, 218, 224, 230, 235, 240, 244, 247, 250, 252, 253, 254, 255, 254, 253, 252, 250, 247, 244, 240, 235, 230, 224, 218, 212, 204, 197, 188, 180, 171, 161, 151, 141, 131, 120, 109, 97, 85, 74, 61, 49, 37, 24, 12, 0, -12, -24, -37, -49, -61, -74, -85, -97, -109, -120, -131, -141, -151, -161, -171, -180, -188, -197, -204, -212, -218, -224, -230, -235, -240, -244, -247, -250, -252, -253, -254, -255, -254, -253, -252, -250, -247, -244, -240, -235, -230, -224, -218, -212, -204, -197, -188, -180, -171, -161, -151, -141, -131, -120, -109, -97, -85, -74, -61, -49, -37, -24, -12};
;
;flash unsigned char /*Okno_hanning*/Okno[32]={0 , 3 , 10 , 23 , 40 , 60 , 84 , 109 , 134 , 160 , 184 , 206 , 225 , 240 , 250 , 255 , 255 , 250 , 240 , 225 , 206 , 184 , 160 , 134 , 109 , 84 , 60 , 40 , 23 , 10 , 3 , 0};
;
;//flash char Okno_hamming[32]={20 , 23 , 30 , 42 , 57 , 76 , 97 , 120 , 144 , 168 , 190 , 210 , 228 , 241 , 251 , 255 , 255 , 251 , 241 , 228 , 210 , 190 , 168 , 144 , 120 , 97 , 76 , 57 , 42 , 30 , 23 , 20};
;
;//flash char Okno_blackman[32]={0 , 1 , 4 , 10 , 18 , 31 , 48 , 69 , 94 , 122 , 151 , 181 , 208 , 230 , 246 , 255 , 255 , 246 , 230 , 208 , 181 , 151 , 122 , 94 , 69 , 48 , 31 , 18 , 10 , 4 , 1 , 0};
;
;//flash char L1[17]={32 , 32 , 32 , 32 , 32 , 32 , 32 , 32 , 32 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 255};
;flash unsigned char L1[17]={0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF};
;
;//flash char L2[17]={32 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255};
;flash unsigned char L2[17]={0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF};
;
;#define _xtal 8000000
;
;#define Falloff 1
;//#define Lcd_offset 1
;#define Sensitivity 40
;
;#define Timer1_h _xtal / 44000
;#define Timer1_l _xtal / 200
;
;#define Level_a 8 -(Sensitivity * 0.4)
;
;
;#define SetBit(x,y) (x|=y)
;#define ClrBit(x,y) (x&=~y)
;#define TestBit(x,y) (x&y)
;
;//LCD
;#define LCD_RST 0b00001000
;#define LCD_E   0b00000100
;#define LCD_RW  0b00000010
;#define LCD_RS  0b00000001
;#define LCD_CS2 0b00010000
;#define LCD_CS1 0b00100000
;
;#define LCD_DB PORTD
;#define LCD_DBI PIND
;#define LCD_IO DDRD
;#define LCD_COM PORTB
;
;#include "ks0108_1.h"

	.CSEG
_WriteCom:
;	Com -> Y+1
;	CS -> Y+0
	IN   R30,0x18
	LD   R26,Y
	OR   R30,R26
	OUT  0x18,R30
	CBI  0x18,0
	CBI  0x18,1
	NOP
	NOP
	LDD  R30,Y+1
	OUT  0x12,R30
	SBI  0x18,2
	NOP
	NOP
	RJMP _0x2080004
_WriteData:
;	data -> Y+1
;	CS -> Y+0
	IN   R30,0x18
	LD   R26,Y
	OR   R30,R26
	OUT  0x18,R30
	SBI  0x18,0
	CBI  0x18,1
	NOP
	NOP
	LDD  R30,Y+1
	OUT  0x12,R30
	SBI  0x18,2
	NOP
	NOP
_0x2080004:
	CBI  0x18,2
	__DELAY_USB 11
	IN   R30,0x18
	ANDI R30,LOW(0xCF)
	OUT  0x18,R30
	ADIW R28,2
	RET
_WriteXY:
;	x -> Y+2
;	y -> Y+1
;	CS -> Y+0
	LDD  R30,Y+1
	SUBI R30,-LOW(184)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _WriteCom
	LDD  R30,Y+2
	SUBI R30,-LOW(64)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _WriteCom
	ADIW R28,3
	RET
_init_lcd:
	SBI  0x18,3
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _WriteXY
	LDI  R30,LOW(192)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _WriteCom
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _WriteCom
	RET
_clear:
	ST   -Y,R17
	ST   -Y,R16
;	x -> R17
;	y -> R16
	LDI  R17,LOW(0)
_0x4:
	CPI  R17,64
	BRSH _0x5
	LDI  R16,LOW(0)
_0x7:
	CPI  R16,8
	BRSH _0x8
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _WriteXY
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _WriteData
	SUBI R16,-1
	RJMP _0x7
_0x8:
	SUBI R17,-1
	RJMP _0x4
_0x5:
	LD   R16,Y+
	LD   R17,Y+
	RET
;	x -> Y+4
;	y -> Y+2
;	CS -> R17
;	textCS -> R16
;	data -> Y+3
;	inv -> Y+2
;	textL -> R17
;	CS -> R16
;	str -> Y+3
;	n -> Y+2
;	inv -> Y+1
;	a -> R17
;	CS -> Y+1
;	data -> R17
;	data -> Y+4
;	readx -> Y+3
;	ready -> Y+1
;	CS -> R17
;	CS -> R17
;	x -> Y+2
;	y -> Y+1
;	CS -> R17
;
;unsigned char K;
;unsigned char I;
;int Tmp_s;
;int Tmp_c;
;unsigned int Beta;
;unsigned int Suma;
;unsigned char Sam;
;bit Sampling;
;int Rex_t, Imx_t;
;int Data[32];
;unsigned int Sample_h[32];
;unsigned int Sample_l[32];
;//unsigned char Okno[32];
;int Rex[16];
;//int Sinus[40];
;unsigned char Result[16], Result_o[16];
;float Sing;
;int Level;
;unsigned char Line1d[16];
;unsigned char Line2d[16];
;unsigned char Falloff_count[16];
;unsigned int maxl = 0;
;
;void ARU_h()
; 0000 004B {
_ARU_h:
; 0000 004C     for(I = 0; I < 32; I++)
	CLR  R8
_0x16:
	LDI  R30,LOW(32)
	CP   R8,R30
	BRSH _0x17
; 0000 004D         Sample_h[I] = Sample_h[I]*(1024/maxl);
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	INC  R8
	RJMP _0x16
_0x17:
; 0000 004E }
	RET
;
;void ARU_l()
; 0000 0051 {
_ARU_l:
; 0000 0052     for(I = 0; I < 32; I++)
	CLR  R8
_0x19:
	LDI  R30,LOW(32)
	CP   R8,R30
	BRSH _0x1A
; 0000 0053         Sample_l[I] = Sample_l[I]*(1024/maxl);
	CALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0x1
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	INC  R8
	RJMP _0x19
_0x1A:
; 0000 0054 }
	RET
;
;unsigned int Getadc(unsigned char adc_input)
; 0000 0057 {
_Getadc:
; 0000 0058 ADMUX=adc_input | (0b01000000 & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0059 // Delay needed for the stabilization of the ADC input voltage
; 0000 005A delay_us(10);
	CALL SUBOPT_0x3
; 0000 005B // Start the AD conversion
; 0000 005C ADCSRA|=0x40;
; 0000 005D // Wait for the AD conversion to complete
; 0000 005E while ((ADCSRA & 0x10)==0);
_0x1B:
	SBIS 0x6,4
	RJMP _0x1B
; 0000 005F ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0060 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0061 }
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0064 {
_timer1_compa_isr:
	CALL SUBOPT_0x4
; 0000 0065     TCNT1 = 0;
; 0000 0066 //    if ((ADCSRA & 0x10)==0){
; 0000 0067     Sam++;
; 0000 0068 //    WriteXY(Sam, 4, LCD_CS1);WriteData(0xFF,LCD_CS1);
; 0000 0069     ClrBit(TIMSK,0b00010000);
	ANDI R30,0xEF
	CALL SUBOPT_0x5
; 0000 006A     Sample_h[Sam-1] = Getadc(0);                       //            'WY¯SZE PASMO
	CALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _Getadc
	POP  R26
	POP  R27
	CALL SUBOPT_0x7
; 0000 006B     if (Sample_h[Sam-1] > maxl)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRSH _0x1E
; 0000 006C         maxl = Sample_h[Sam-1];
	CALL SUBOPT_0xA
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	STS  _maxl,R30
	STS  _maxl+1,R31
; 0000 006D /*    WriteXY(0, 4, LCD_CS1);
; 0000 006E     WriteData(Sample_h[Sam-1],LCD_CS1);   */
; 0000 006F //    ADCW=0;
; 0000 0070     SetBit(TIMSK,0b00010000);
_0x1E:
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
; 0000 0071     if (Sam == 32)
	LDS  R26,_Sam
	CPI  R26,LOW(0x20)
	BRNE _0x1F
; 0000 0072     {
; 0000 0073         ClrBit(TIMSK,0b00010000);   //Disable Compare1a
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
; 0000 0074         Sampling = 0;
	CLT
	BLD  R2,0
; 0000 0075     }    //           }
; 0000 0076 }
_0x1F:
	RJMP _0x71
;
;// Timer1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 007A {
_timer1_compb_isr:
	CALL SUBOPT_0x4
; 0000 007B     TCNT1 = 0;
; 0000 007C //    if ((ADCSRA & 0x10)==0){
; 0000 007D     Sam++;
; 0000 007E //    WriteXY(Sam, 5, LCD_CS1);WriteData(0xFF,LCD_CS1);
; 0000 007F     ClrBit(TIMSK,0b00001000);
	ANDI R30,0XF7
	CALL SUBOPT_0x5
; 0000 0080     Sample_l[Sam-1] = Getadc(1);
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _Getadc
	POP  R26
	POP  R27
	CALL SUBOPT_0x7
; 0000 0081      if (Sample_l[Sam-1] > maxl)
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	BRSH _0x20
; 0000 0082         maxl = Sample_l[Sam-1];                       //           'NI¯SZE PASMO
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	STS  _maxl,R30
	STS  _maxl+1,R31
; 0000 0083     SetBit(TIMSK,0b00001000);
_0x20:
	IN   R30,0x39
	ORI  R30,8
	OUT  0x39,R30
; 0000 0084     if (Sam == 32)
	LDS  R26,_Sam
	CPI  R26,LOW(0x20)
	BRNE _0x21
; 0000 0085     {
; 0000 0086         ClrBit(TIMSK,0b00001000);  //Disable Compare1b
	IN   R30,0x39
	ANDI R30,0XF7
	OUT  0x39,R30
; 0000 0087         Sampling = 0;
	CLT
	BLD  R2,0
; 0000 0088     }         //          }
; 0000 0089 }
_0x21:
_0x71:
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
;void Sample_h_()
; 0000 008C {
_Sample_h_:
; 0000 008D //'pobiera 32 próbki z czêstotliwoœci¹ 44kHz
; 0000 008E //Config Adc = Single , Prescaler = 4 , Reference = Avcc
; 0000 008F //'ADC dzia³a ju¿ doœæ niestabilnie na preskalerze 2 ale na 4 ju¿ sie nie wyrobi i prubkuje z f=37kHz
; 0000 0090 //' przez du¿e f pojawiaja sie szumy jak podajemy sygna³ z generatora
; 0000 0091     ADCSRA=0b10000010;
	LDI  R30,LOW(130)
	OUT  0x6,R30
; 0000 0092     delay_us(10);
	CALL SUBOPT_0x3
; 0000 0093 //    ADMUX=0b01000000;
; 0000 0094     ADCSRA|=0x40;//Start Adc
; 0000 0095 
; 0000 0096     TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0097     SetBit(TIMSK,0b00010000);     //Enable Compare1a
	IN   R30,0x39
	ORI  R30,0x10
	RJMP _0x2080003
; 0000 0098     Sam = 0;
; 0000 0099     Sampling = 1;
; 0000 009A }
;
;void Sample_l_()
; 0000 009D {
_Sample_l_:
; 0000 009E //'pobiera 32 próbki z czêstotliwoœci¹ 2kHz
; 0000 009F //    Config Adc = Single , Prescaler = Auto , Reference = Avcc
; 0000 00A0     ADCSRA=0b10000010;
	LDI  R30,LOW(130)
	OUT  0x6,R30
; 0000 00A1     delay_us(10);
	CALL SUBOPT_0x3
; 0000 00A2 //    ADMUX=0b01000001;
; 0000 00A3     ADCSRA|=0x40;//    Start Adc
; 0000 00A4 
; 0000 00A5     TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 00A6     SetBit(TIMSK,0b00001000);    //Enable Compare1b
	IN   R30,0x39
	ORI  R30,8
_0x2080003:
	OUT  0x39,R30
; 0000 00A7     Sam = 0;
	LDI  R30,LOW(0)
	STS  _Sam,R30
; 0000 00A8     Sampling = 1;
	SET
	BLD  R2,0
; 0000 00A9 }
	RET
;
;void Copy_high()
; 0000 00AC {
_Copy_high:
; 0000 00AD     Level = 0;
	CALL SUBOPT_0xC
; 0000 00AE 
; 0000 00AF     for (K = 1; K<=32; K++)
_0x23:
	LDI  R30,LOW(32)
	CP   R30,R9
	BRLO _0x24
; 0000 00B0     {
; 0000 00B1         Sample_h[K-1] = Sample_h[K-1] >> 2;
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
	CALL __LSRW2
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 00B2         Level = Level + Sample_h[K-1];
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 00B3     }
	INC  R9
	RJMP _0x23
_0x24:
; 0000 00B4 
; 0000 00B5     Level = Level >> 5;
	CALL SUBOPT_0x10
; 0000 00B6 
; 0000 00B7     for (K = 1; K<=32; K++)
_0x26:
	LDI  R30,LOW(32)
	CP   R30,R9
	BRSH PC+3
	JMP _0x27
; 0000 00B8     {
; 0000 00B9         Data[K-1] = Sample_h[K-1] - Level;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL SUBOPT_0x13
; 0000 00BA         Data[K-1] = Data[K-1] * Okno[K-1];
	CALL SUBOPT_0x14
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	MOVW R26,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x15
; 0000 00BB         Data[K-1] = Data[K-1] >> 8;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CALL SUBOPT_0x17
; 0000 00BC 
; 0000 00BD         if (Data[K-1] > 127)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRLT _0x28
; 0000 00BE             Data[K-1] = 127;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
; 0000 00BF         if (Data[K-1] < -127)
_0x28:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CPI  R30,LOW(0xFF81)
	LDI  R26,HIGH(0xFF81)
	CPC  R31,R26
	BRGE _0x29
; 0000 00C0             Data[K-1] = -127;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x19
; 0000 00C1     }
_0x29:
	INC  R9
	RJMP _0x26
_0x27:
; 0000 00C2 }
	RET
;
;void Copy_low()
; 0000 00C5 {
_Copy_low:
; 0000 00C6     Level = 0;
	CALL SUBOPT_0xC
; 0000 00C7 
; 0000 00C8     for (K = 1; K<=32; K++)
_0x2B:
	LDI  R30,LOW(32)
	CP   R30,R9
	BRLO _0x2C
; 0000 00C9     {
; 0000 00CA         Sample_l[K-1] = Sample_l[K-1] >> 2;
	CALL SUBOPT_0x11
	CALL SUBOPT_0xB
	CALL SUBOPT_0x16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL __LSRW2
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 00CB         Level = Level + Sample_l[K-1];
	CALL SUBOPT_0x11
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
; 0000 00CC     }
	INC  R9
	RJMP _0x2B
_0x2C:
; 0000 00CD 
; 0000 00CE     Level = Level >> 5;
	CALL SUBOPT_0x10
; 0000 00CF 
; 0000 00D0     for (K = 1; K<=32; K++)
_0x2E:
	LDI  R30,LOW(32)
	CP   R30,R9
	BRSH PC+3
	JMP _0x2F
; 0000 00D1     {
; 0000 00D2         Data[K-1] = Sample_l[K-1] - Level;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	CALL SUBOPT_0x13
; 0000 00D3         Data[K-1] = Data[K-1] * Okno[K-1];
	CALL SUBOPT_0x14
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	MOVW R26,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x15
; 0000 00D4         Data[K-1] = Data[K-1] >> 8;
	CALL SUBOPT_0x14
	CALL SUBOPT_0x16
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CALL SUBOPT_0x17
; 0000 00D5 
; 0000 00D6         if (Data[K-1] > 127)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRLT _0x30
; 0000 00D7             Data[K-1] = 127;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
; 0000 00D8         if (Data[K-1] < -127)
_0x30:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x8
	CPI  R30,LOW(0xFF81)
	LDI  R26,HIGH(0xFF81)
	CPC  R31,R26
	BRGE _0x31
; 0000 00D9             Data[K-1] = -127;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	CALL SUBOPT_0x19
; 0000 00DA     }
_0x31:
	INC  R9
	RJMP _0x2E
_0x2F:
; 0000 00DB }
	RET
;
;void DFT()   //Discrete Fourier Transform  //Äèñêðåòíîå ïðåîáðàçîâàíèå ôóðüå
; 0000 00DE {            //X(k) = SUMM from n=0 to N-1 (x(n) * exp(-2*pi*i*k*n/N))
_DFT:
; 0000 00DF     for (K = 1; K<= 15; K++)
	LDI  R30,LOW(1)
	MOV  R9,R30
_0x33:
	LDI  R30,LOW(15)
	CP   R30,R9
	BRSH PC+3
	JMP _0x34
; 0000 00E0     {        //ðàñêëàäûâàåì íà:
; 0000 00E1         Rex_t = 0;            //Re äåéñòâèòåëüíóþ (cos(x) = sin(x + pi/2)) è
	LDI  R30,LOW(0)
	STS  _Rex_t,R30
	STS  _Rex_t+1,R30
; 0000 00E2         Imx_t = 0;            //Im ìíèìóþ ÷àñòè (sin(x))
	STS  _Imx_t,R30
	STS  _Imx_t+1,R30
; 0000 00E3 
; 0000 00E4         for (I = 0; I<=31; I++)
	CLR  R8
_0x36:
	LDI  R30,LOW(31)
	CP   R30,R8
	BRSH PC+3
	JMP _0x37
; 0000 00E5         {
; 0000 00E6             Beta = I * K;
	MOV  R26,R8
	CLR  R27
	MOV  R30,R9
	LDI  R31,0
	CALL __MULW12
	CALL SUBOPT_0x1A
; 0000 00E7             Beta = Beta & 31;  //Beta < 32
	ANDI R30,LOW(0x1F)
	ANDI R31,HIGH(0x1F)
	CALL SUBOPT_0x1A
; 0000 00E8             Tmp_s = Sinus[Beta] * Data[I];      //im = sin(ki)*x(i)  //2pi = 32  =>  2pi/32 = 1
	LDI  R26,LOW(_Sinus*2)
	LDI  R27,HIGH(_Sinus*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1B
	MOVW R26,R0
	CALL __MULW12
	MOVW R10,R30
; 0000 00E9             Tmp_c = Sinus[Beta + 7] * Data[I];  //+pi/2  =  cos
	LDS  R30,_Beta
	LDS  R31,_Beta+1
	LSL  R30
	ROL  R31
	__ADDW1FN _Sinus,14
	CALL SUBOPT_0x1B
	MOVW R26,R0
	CALL __MULW12
	MOVW R12,R30
; 0000 00EA 
; 0000 00EB             Tmp_s = Tmp_s >> 8;  //äëÿ íîðìèðîâêè [-255; 255] ý sin(x)
	MOV  R10,R11
	CLR  R11
	SBRC R10,7
	COM  R11
; 0000 00EC 
; 0000 00ED             Tmp_c = Tmp_c >> 8;
	MOV  R12,R13
	CLR  R13
	SBRC R12,7
	COM  R13
; 0000 00EE 
; 0000 00EF             Rex_t = Rex_t + Tmp_c; //SUMM
	MOVW R30,R12
	LDS  R26,_Rex_t
	LDS  R27,_Rex_t+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1C
; 0000 00F0             Imx_t = Imx_t - Tmp_s;
	SUB  R30,R10
	SBC  R31,R11
	STS  _Imx_t,R30
	STS  _Imx_t+1,R31
; 0000 00F1        }
	INC  R8
	RJMP _0x36
_0x37:
; 0000 00F2 
; 0000 00F3        Rex_t = Rex_t >> 3;
	LDS  R30,_Rex_t
	LDS  R31,_Rex_t+1
	CALL __ASRW3
	CALL SUBOPT_0x1C
; 0000 00F4 
; 0000 00F5        Imx_t = Imx_t >> 3;
	CALL __ASRW3
	STS  _Imx_t,R30
	STS  _Imx_t+1,R31
; 0000 00F6 
; 0000 00F7        Tmp_c = Rex_t * Rex_t;      //Re^2
	LDS  R30,_Rex_t
	LDS  R31,_Rex_t+1
	LDS  R26,_Rex_t
	LDS  R27,_Rex_t+1
	CALL __MULW12
	MOVW R12,R30
; 0000 00F8        Tmp_s = Imx_t * Imx_t;      //Im^2
	LDS  R30,_Imx_t
	LDS  R31,_Imx_t+1
	LDS  R26,_Imx_t
	LDS  R27,_Imx_t+1
	CALL __MULW12
	MOVW R10,R30
; 0000 00F9 
; 0000 00FA        Tmp_c = Tmp_c + Tmp_s;      //z^2 = Re^2 + Im^2
	__ADDWRR 12,13,10,11
; 0000 00FB        Rex[K] = isqrt(Tmp_c);      //z
	MOV  R30,R9
	LDI  R26,LOW(_Rex)
	LDI  R27,HIGH(_Rex)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	ST   -Y,R13
	ST   -Y,R12
	CALL _isqrt
	POP  R26
	POP  R27
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 00FC     }
	INC  R9
	RJMP _0x33
_0x34:
; 0000 00FD }
	RET
;
;void Calculate_high()
; 0000 0100 {
_Calculate_high:
; 0000 0101     Suma = Rex[3-1];
	CALL SUBOPT_0x1D
; 0000 0102     Result[9-1] = Suma;
	__PUTB1MN _Result,8
; 0000 0103 
; 0000 0104     Suma = Rex[4-1];
	CALL SUBOPT_0x1E
; 0000 0105     Result[10-1] = Suma;
	__PUTB1MN _Result,9
; 0000 0106 
; 0000 0107     Suma = Rex[5-1];
	CALL SUBOPT_0x1F
; 0000 0108     Result[11-1] = Suma;
	LDS  R30,_Suma
	__PUTB1MN _Result,10
; 0000 0109 
; 0000 010A     Suma = Rex[6-1];
	CALL SUBOPT_0x20
; 0000 010B     Result[12-1] = Suma;
	LDS  R30,_Suma
	__PUTB1MN _Result,11
; 0000 010C 
; 0000 010D     Suma = Rex[7-1];
	CALL SUBOPT_0x21
; 0000 010E     if (Rex[8-1] > Suma)
	BRSH _0x38
; 0000 010F          Suma = Rex[8-1];
	CALL SUBOPT_0x22
; 0000 0110     Result[13-1] = Suma;
_0x38:
	LDS  R30,_Suma
	__PUTB1MN _Result,12
; 0000 0111 
; 0000 0112     Suma = Rex[9-1];
	CALL SUBOPT_0x23
; 0000 0113     if (Rex[10-1] > Suma)
	BRSH _0x39
; 0000 0114         Suma = Rex[10-1];
	CALL SUBOPT_0x24
; 0000 0115     Result[14-1] = Suma;
_0x39:
	LDS  R30,_Suma
	__PUTB1MN _Result,13
; 0000 0116 
; 0000 0117     Suma = Rex[11-1];
	CALL SUBOPT_0x25
; 0000 0118     if (Rex[12-1] > Suma)
	BRSH _0x3A
; 0000 0119         Suma = Rex[12-1];
	CALL SUBOPT_0x26
; 0000 011A     if (Rex[13-1] > Suma)
_0x3A:
	CALL SUBOPT_0x27
	BRSH _0x3B
; 0000 011B         Suma = Rex[13-1];
	CALL SUBOPT_0x28
; 0000 011C     Result[15-1] = Suma;
_0x3B:
	LDS  R30,_Suma
	__PUTB1MN _Result,14
; 0000 011D 
; 0000 011E     Suma = Rex[14-1];
	CALL SUBOPT_0x29
; 0000 011F     if (Rex[15-1] > Suma)
	BRSH _0x3C
; 0000 0120         Suma = Rex[15-1];
	CALL SUBOPT_0x2A
; 0000 0121     if (Rex[16-1] > Suma)
_0x3C:
	CALL SUBOPT_0x2B
	BRSH _0x3D
; 0000 0122         Suma = Rex[16-1];
	CALL SUBOPT_0x2C
; 0000 0123     Result[16-1] = Suma;
_0x3D:
	LDS  R30,_Suma
	__PUTB1MN _Result,15
; 0000 0124 }
	RET
;
;void Calculate_low()
; 0000 0127 {
_Calculate_low:
; 0000 0128     Suma = Rex[2-1];
	__GETW1MN _Rex,2
	STS  _Suma,R30
	STS  _Suma+1,R31
; 0000 0129     Result[1-1] = Suma;
	LDS  R30,_Suma
	STS  _Result,R30
; 0000 012A 
; 0000 012B     Suma = Rex[3-1];
	CALL SUBOPT_0x1D
; 0000 012C     Result[2-1] = Suma;
	__PUTB1MN _Result,1
; 0000 012D 
; 0000 012E     Suma = Rex[4-1];
	CALL SUBOPT_0x1E
; 0000 012F     Result[3-1] = Suma;
	__PUTB1MN _Result,2
; 0000 0130 
; 0000 0131     Suma = Rex[5-1];
	CALL SUBOPT_0x1F
; 0000 0132     if (Rex[6-1] > Suma)
	__GETW2MN _Rex,10
	LDS  R30,_Suma
	LDS  R31,_Suma+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x3E
; 0000 0133         Suma = Rex[6-1];
	CALL SUBOPT_0x20
; 0000 0134     Result[4-1] = Suma;
_0x3E:
	LDS  R30,_Suma
	__PUTB1MN _Result,3
; 0000 0135 
; 0000 0136     Suma = Rex[7-1];
	CALL SUBOPT_0x21
; 0000 0137     if (Rex[8-1] > Suma)
	BRSH _0x3F
; 0000 0138         Suma = Rex[8-1];
	CALL SUBOPT_0x22
; 0000 0139     Result[5-1] = Suma;
_0x3F:
	LDS  R30,_Suma
	__PUTB1MN _Result,4
; 0000 013A 
; 0000 013B     Suma = Rex[9-1];
	CALL SUBOPT_0x23
; 0000 013C     if (Rex[10-1] > Suma)
	BRSH _0x40
; 0000 013D         Suma = Rex[10-1];
	CALL SUBOPT_0x24
; 0000 013E     Result[6-1] = Suma;
_0x40:
	LDS  R30,_Suma
	__PUTB1MN _Result,5
; 0000 013F 
; 0000 0140     Suma = Rex[11-1];
	CALL SUBOPT_0x25
; 0000 0141     if (Rex[12-1] > Suma)
	BRSH _0x41
; 0000 0142         Suma = Rex[12-1];
	CALL SUBOPT_0x26
; 0000 0143     if (Rex[13-1] > Suma)
_0x41:
	CALL SUBOPT_0x27
	BRSH _0x42
; 0000 0144         Suma = Rex[13-1];
	CALL SUBOPT_0x28
; 0000 0145     Result[7-1] = Suma;
_0x42:
	LDS  R30,_Suma
	__PUTB1MN _Result,6
; 0000 0146 
; 0000 0147     Suma = Rex[14-1];
	CALL SUBOPT_0x29
; 0000 0148     if (Rex[15-1] > Suma)
	BRSH _0x43
; 0000 0149         Suma = Rex[15-1];
	CALL SUBOPT_0x2A
; 0000 014A     if (Rex[16-1] > Suma)
_0x43:
	CALL SUBOPT_0x2B
	BRSH _0x44
; 0000 014B         Suma = Rex[16-1];
	CALL SUBOPT_0x2C
; 0000 014C     Result[8-1] = Suma;
_0x44:
	LDS  R30,_Suma
	__PUTB1MN _Result,7
; 0000 014D }
	RET
;
;void Save()
; 0000 0150 {
_Save:
; 0000 0151     for (K = 1; K<=16; K++)//                                             'w ci¹gu jednej pêtli obliczany i wyœwietlany 1 s³upek 1/10;
	LDI  R30,LOW(1)
	MOV  R9,R30
_0x46:
	LDI  R30,LOW(16)
	CP   R30,R9
	BRSH PC+3
	JMP _0x47
; 0000 0152     {
; 0000 0153         Sing = Result[K-1] * 0.1;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Result)
	SBCI R31,HIGH(-_Result)
	CALL SUBOPT_0x2D
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3DCCCCCD
	CALL SUBOPT_0x2E
; 0000 0154 
; 0000 0155 //      'If K = 1 Then Sing = Sing * 0.5                             ' umnie jakos zawysoko skacz¹, byæ moze przez brak filtrów mozna usunaæ
; 0000 0156 //    ' If K = 2 Then Sing = Sing * 0.75
; 0000 0157 
; 0000 0158         Sing = log10(Sing);
	CALL __PUTPARD1
	CALL _log10
	STS  _Sing,R30
	STS  _Sing+1,R31
	STS  _Sing+2,R22
	STS  _Sing+3,R23
; 0000 0159 
; 0000 015A         Sing = Sensitivity * Sing;
	__GETD2N 0x42200000
	CALL SUBOPT_0x2E
; 0000 015B         Tmp_c = Sing+ Level_a;
	__GETD2N 0x41000000
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41800000
	CALL __SWAPD12
	CALL __SUBF12
	CALL __CFD1
	MOVW R12,R30
; 0000 015C 
; 0000 015D         if (Tmp_c < 0)
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE _0x48
; 0000 015E             Tmp_c = 0;
	CLR  R12
	CLR  R13
; 0000 015F         if (Tmp_c > 16)
_0x48:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x49
; 0000 0160             Tmp_c = 16;
	MOVW R12,R30
; 0000 0161 
; 0000 0162         Result[K-1] = Tmp_c;//                                            'przeniesienie Resultu z TMP_C do zmiennej Result
_0x49:
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Result)
	SBCI R31,HIGH(-_Result)
	ST   Z,R12
; 0000 0163 
; 0000 0164 
; 0000 0165         if (Result[K-1] > Result_o[K-1])
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_Result)
	SBCI R31,HIGH(-_Result)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_Result_o)
	SBCI R31,HIGH(-_Result_o)
	LD   R30,Z
	CP   R30,R26
	BRSH _0x4A
; 0000 0166             Result_o[K-1] = Result[K-1];
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_Result_o)
	SBCI R31,HIGH(-_Result_o)
	MOVW R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_Result)
	SBCI R31,HIGH(-_Result)
	LD   R30,Z
	RJMP _0x70
; 0000 0167         else
_0x4A:
; 0000 0168         {
; 0000 0169             if (Falloff_count[K-1] == Falloff)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Falloff_count)
	SBCI R31,HIGH(-_Falloff_count)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRNE _0x4C
; 0000 016A             {
; 0000 016B                 if (Result_o[K-1] > 0)
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Result_o)
	SBCI R31,HIGH(-_Result_o)
	LD   R26,Z
	CPI  R26,LOW(0x1)
	BRLO _0x4D
; 0000 016C                     Result_o[K-1]--;
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Result_o)
	SBCI R31,HIGH(-_Result_o)
	MOVW R26,R30
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 016D                 Falloff_count[K-1] = 0;
_0x4D:
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Falloff_count)
	SBCI R31,HIGH(-_Falloff_count)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 016E             }
; 0000 016F             Falloff_count[K-1]++;
_0x4C:
	CALL SUBOPT_0x11
	SUBI R30,LOW(-_Falloff_count)
	SBCI R31,HIGH(-_Falloff_count)
	MOVW R26,R30
	LD   R30,X
	SUBI R30,-LOW(1)
_0x70:
	ST   X,R30
; 0000 0170         }
; 0000 0171 
; 0000 0172         Line1d[K-1] = L1[Result_o[K-1]];
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_Line1d)
	SBCI R31,HIGH(-_Line1d)
	CALL SUBOPT_0x2F
	SUBI R30,LOW(-_L1*2)
	SBCI R31,HIGH(-_L1*2)
	LPM  R30,Z
	ST   X,R30
; 0000 0173         Line2d[K-1] = L2[Result_o[K-1]];
	CALL SUBOPT_0x11
	MOVW R0,R30
	SUBI R30,LOW(-_Line2d)
	SBCI R31,HIGH(-_Line2d)
	CALL SUBOPT_0x2F
	SUBI R30,LOW(-_L2*2)
	SBCI R31,HIGH(-_L2*2)
	LPM  R30,Z
	ST   X,R30
; 0000 0174 
; 0000 0175     }
	INC  R9
	RJMP _0x46
_0x47:
; 0000 0176     //OUT LCD
; 0000 0177 //    clear();
; 0000 0178 
; 0000 0179     WriteXY(0, 6, LCD_CS1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(6)
	CALL SUBOPT_0x30
; 0000 017A     for(I=0; I<8; I++)
_0x4F:
	LDI  R30,LOW(8)
	CP   R8,R30
	BRSH _0x50
; 0000 017B         for(K=0; K<8; K++)
	CLR  R9
_0x52:
	LDI  R30,LOW(8)
	CP   R9,R30
	BRSH _0x53
; 0000 017C             WriteData(Line1d[I],LCD_CS1);
	CALL SUBOPT_0x31
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _WriteData
	INC  R9
	RJMP _0x52
_0x53:
; 0000 017E WriteXY(0, 6, 0b00010000);
	INC  R8
	RJMP _0x4F
_0x50:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(6)
	CALL SUBOPT_0x32
; 0000 017F     for(I=8; I<16; I++)
_0x55:
	LDI  R30,LOW(16)
	CP   R8,R30
	BRSH _0x56
; 0000 0180         for(K=0; K<8; K++)
	CLR  R9
_0x58:
	LDI  R30,LOW(8)
	CP   R9,R30
	BRSH _0x59
; 0000 0181             WriteData(Line1d[I],LCD_CS2);
	CALL SUBOPT_0x31
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _WriteData
	INC  R9
	RJMP _0x58
_0x59:
; 0000 0183 WriteXY(0, 7, 0b00100000);
	INC  R8
	RJMP _0x55
_0x56:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x30
; 0000 0184     for(I=0; I<8; I++)
_0x5B:
	LDI  R30,LOW(8)
	CP   R8,R30
	BRSH _0x5C
; 0000 0185         for(K=0; K<8; K++)
	CLR  R9
_0x5E:
	LDI  R30,LOW(8)
	CP   R9,R30
	BRSH _0x5F
; 0000 0186             WriteData(Line2d[I],LCD_CS1);
	CALL SUBOPT_0x33
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _WriteData
	INC  R9
	RJMP _0x5E
_0x5F:
; 0000 0187 WriteXY(0, 7, 0b00010000);
	INC  R8
	RJMP _0x5B
_0x5C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x32
; 0000 0188     for(I=8; I<16; I++)
_0x61:
	LDI  R30,LOW(16)
	CP   R8,R30
	BRSH _0x62
; 0000 0189         for(K=0; K<8; K++)
	CLR  R9
_0x64:
	LDI  R30,LOW(8)
	CP   R9,R30
	BRSH _0x65
; 0000 018A             WriteData(Line2d[I],LCD_CS2);
	CALL SUBOPT_0x33
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _WriteData
	INC  R9
	RJMP _0x64
_0x65:
; 0000 018B }
	INC  R8
	RJMP _0x61
_0x62:
	RET
;
;void main()
; 0000 018E {
_main:
; 0000 018F     DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0190     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0191     DDRC=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 0192     DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0193 
; 0000 0194     PORTA=0b11000000;
	LDI  R30,LOW(192)
	OUT  0x1B,R30
; 0000 0195     PORTB=0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0196     PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0197     PORTD=0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0198 
; 0000 0199     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 019A     TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 019B     TCNT1=0x00;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 019C 
; 0000 019D     OCR1A=Timer1_h;
	LDI  R30,LOW(181)
	LDI  R31,HIGH(181)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 019E     OCR1B=Timer1_l;
	LDI  R30,LOW(40000)
	LDI  R31,HIGH(40000)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 019F 
; 0000 01A0     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 01A1 /*
; 0000 01A2     for(K = 0; K<32; K++)
; 0000 01A3     {
; 0000 01A4         Sinus[K] = Tab_sin[K];
; 0000 01A5 //        'Okno(k + 1) = 255
; 0000 01A6 //        'Okno(k + 1) = Lookup(k , Okno_blackman)
; 0000 01A7 //        'Okno(k + 1) = Lookup(k , Okno_hamming)
; 0000 01A8         Okno[K] = Okno_hanning[K];
; 0000 01A9     }
; 0000 01AA 
; 0000 01AB     Sinus[32] = Tab_sin[0];
; 0000 01AC     Sinus[33] = Tab_sin[1];
; 0000 01AD     Sinus[34] = Tab_sin[2];
; 0000 01AE     Sinus[35] = Tab_sin[3];
; 0000 01AF     Sinus[36] = Tab_sin[4];
; 0000 01B0     Sinus[37] = Tab_sin[5];
; 0000 01B1     Sinus[38] = Tab_sin[6];
; 0000 01B2     Sinus[39] = Tab_sin[7];
; 0000 01B3   */
; 0000 01B4     init_lcd();
	RCALL _init_lcd
; 0000 01B5 
; 0000 01B6     clear();
	RCALL _clear
; 0000 01B7 
; 0000 01B8 
; 0000 01B9     ADCSRA=0b10000010;
	LDI  R30,LOW(130)
	OUT  0x6,R30
; 0000 01BA     ADMUX=0b01000000;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 01BB 
; 0000 01BC 
; 0000 01BD     #asm("sei");
	sei
; 0000 01BE 
; 0000 01BF     ADCSRA|=0x40;//    Start Adc
	SBI  0x6,6
; 0000 01C0 
; 0000 01C1     while(1)
_0x66:
; 0000 01C2     {
; 0000 01C3         Sample_h_();
	RCALL _Sample_h_
; 0000 01C4         while(Sampling == 1);
_0x69:
	SBRC R2,0
	RJMP _0x69
; 0000 01C5 
; 0000 01C6         ARU_h();
	RCALL _ARU_h
; 0000 01C7 
; 0000 01C8         Sample_l_();
	RCALL _Sample_l_
; 0000 01C9         while(Sampling == 1);
_0x6C:
	SBRC R2,0
	RJMP _0x6C
; 0000 01CA 
; 0000 01CB         ARU_l();
	RCALL _ARU_l
; 0000 01CC 
; 0000 01CD         Copy_low();
	RCALL _Copy_low
; 0000 01CE 
; 0000 01CF         DFT();
	RCALL _DFT
; 0000 01D0 
; 0000 01D1         Calculate_low();
	RCALL _Calculate_low
; 0000 01D2         Copy_high();
	RCALL _Copy_high
; 0000 01D3         DFT();
	RCALL _DFT
; 0000 01D4         Calculate_high();
	RCALL _Calculate_high
; 0000 01D5 
; 0000 01D6         Save();
	RCALL _Save
; 0000 01D7     }
	RJMP _0x66
; 0000 01D8 }
_0x6F:
	RJMP _0x6F

	.CSEG
_isqrt:
    ld   r26,y+
    ld   r27,y+
    clr	 r30
	clr	 r0
	ldi	 r22,0x80
	clt
__isqrt0:
	mov	 r1,r22
	lsr	 r1
	ror	 r0
	or	 r1,r30
	brts __isqrt1
	cp	 r26,r0
	cpc	 r27,r1
	brcs __isqrt2
__isqrt1:
	sub	 r26,r0
	sbc	 r27,r1
	or	 r30,r22
__isqrt2:
	bst	 r27,7
	lsl	 r26
	rol	 r27
	lsr	 r22
	brcc __isqrt0
	ret
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x34
	CALL __CPD02
	BRLT _0x200000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2080002
_0x200000C:
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x36
	CALL SUBOPT_0x34
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x200000D
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	CALL __ADDF12
	CALL SUBOPT_0x36
	__SUBWRN 16,17,1
_0x200000D:
	CALL SUBOPT_0x37
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	CALL __MULF12
	__PUTD1S 2
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x34
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 2
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_log10:
	CALL __GETD2S0
	CALL __CPD02
	BRLT _0x200000E
	__GETD1N 0xFF7FFFFF
	RJMP _0x2080001
_0x200000E:
	CALL __GETD1S0
	CALL __PUTPARD1
	RCALL _log
	__GETD2N 0x3EDE5BD9
	CALL __MULF12
_0x2080001:
	ADIW R28,4
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_ch:
	.BYTE 0x6
_Beta:
	.BYTE 0x2
_Suma:
	.BYTE 0x2
_Sam:
	.BYTE 0x1
_Rex_t:
	.BYTE 0x2
_Imx_t:
	.BYTE 0x2
_Data:
	.BYTE 0x40
_Sample_h:
	.BYTE 0x40
_Sample_l:
	.BYTE 0x40
_Rex:
	.BYTE 0x20
_Result:
	.BYTE 0x10
_Result_o:
	.BYTE 0x10
_Sing:
	.BYTE 0x4
_Level:
	.BYTE 0x2
_Line1d:
	.BYTE 0x10
_Line2d:
	.BYTE 0x10
_Falloff_count:
	.BYTE 0x10
_maxl:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	MOV  R30,R8
	LDI  R26,LOW(_Sample_h)
	LDI  R27,HIGH(_Sample_h)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	ADD  R26,R30
	ADC  R27,R31
	LD   R22,X+
	LD   R23,X
	LDS  R30,_maxl
	LDS  R31,_maxl+1
	LDI  R26,LOW(1024)
	LDI  R27,HIGH(1024)
	CALL __DIVW21U
	MOVW R26,R22
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOV  R30,R8
	LDI  R26,LOW(_Sample_l)
	LDI  R27,HIGH(_Sample_l)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__DELAY_USB 27
	SBI  0x6,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
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
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	LDS  R30,_Sam
	SUBI R30,-LOW(1)
	STS  _Sam,R30
	IN   R30,0x39
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	OUT  0x39,R30
	LDS  R30,_Sam
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_Sample_h)
	LDI  R27,HIGH(_Sample_h)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   X+,R30
	ST   X,R31
	LDS  R30,_Sam
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x8:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	MOVW R26,R30
	LDS  R30,_maxl
	LDS  R31,_maxl+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDS  R30,_Sam
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_Sample_l)
	LDI  R27,HIGH(_Sample_l)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	STS  _Level,R30
	STS  _Level+1,R30
	LDI  R30,LOW(1)
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	MOV  R30,R9
	LDI  R31,0
	SBIW R30,1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R26,_Level
	LDS  R27,_Level+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ADD  R30,R26
	ADC  R31,R27
	STS  _Level,R30
	STS  _Level+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xE
	LDI  R30,LOW(5)
	CALL __ASRW12
	STS  _Level,R30
	STS  _Level+1,R31
	LDI  R30,LOW(1)
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x11:
	MOV  R30,R9
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	MOVW R22,R30
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0xE
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	SUBI R30,LOW(-_Okno*2)
	SBCI R31,HIGH(-_Okno*2)
	LPM  R30,Z
	LDI  R31,0
	CALL __MULW12
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	CALL __ASRW8
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(65409)
	LDI  R31,HIGH(65409)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	STS  _Beta,R30
	STS  _Beta+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	CALL __GETW1PF
	MOVW R0,R30
	MOV  R30,R8
	LDI  R26,LOW(_Data)
	LDI  R27,HIGH(_Data)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	STS  _Rex_t,R30
	STS  _Rex_t+1,R31
	LDS  R30,_Imx_t
	LDS  R31,_Imx_t+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETW1MN _Rex,4
	STS  _Suma,R30
	STS  _Suma+1,R31
	LDS  R30,_Suma
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETW1MN _Rex,6
	STS  _Suma,R30
	STS  _Suma+1,R31
	LDS  R30,_Suma
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	__GETW1MN _Rex,8
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	__GETW1MN _Rex,10
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x21:
	__GETW1MN _Rex,12
	STS  _Suma,R30
	STS  _Suma+1,R31
	__GETW2MN _Rex,14
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	__GETW1MN _Rex,14
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x23:
	__GETW1MN _Rex,16
	STS  _Suma,R30
	STS  _Suma+1,R31
	__GETW2MN _Rex,18
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__GETW1MN _Rex,18
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	__GETW1MN _Rex,20
	STS  _Suma,R30
	STS  _Suma+1,R31
	__GETW2MN _Rex,22
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETW1MN _Rex,22
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETW2MN _Rex,24
	LDS  R30,_Suma
	LDS  R31,_Suma+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	__GETW1MN _Rex,24
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x29:
	__GETW1MN _Rex,26
	STS  _Suma,R30
	STS  _Suma+1,R31
	__GETW2MN _Rex,28
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	__GETW1MN _Rex,28
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__GETW2MN _Rex,30
	LDS  R30,_Suma
	LDS  R31,_Suma+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETW1MN _Rex,30
	STS  _Suma,R30
	STS  _Suma+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	CALL __MULF12
	STS  _Sing,R30
	STS  _Sing+1,R31
	STS  _Sing+2,R22
	STS  _Sing+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_Result_o)
	SBCI R31,HIGH(-_Result_o)
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _WriteXY
	CLR  R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_Line1d)
	SBCI R31,HIGH(-_Line1d)
	LD   R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _WriteXY
	LDI  R30,LOW(8)
	MOV  R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_Line2d)
	SBCI R31,HIGH(-_Line2d)
	LD   R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x35
	__GETD2N 0x3F800000
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

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
