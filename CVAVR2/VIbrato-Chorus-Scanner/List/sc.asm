
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 12,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int
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
	.DEF _val1=R4
	.DEF _val2=R3
	.DEF _val3=R6
	.DEF _val4=R5
	.DEF _val5=R8
	.DEF _current_pattern=R7
	.DEF _block=R9
	.DEF _addr=R11
	.DEF __e_read=R14
	.DEF _i=R13

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
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

_v1:
	.DB  0xE,0x10,0x11,0x12,0x13,0x14,0x15,0x16
	.DB  0x17,0x16,0x15,0x14,0x13,0x12,0x11,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_v2:
	.DB  0xE,0x10,0x12,0x13,0x14,0x17,0x9,0xA
	.DB  0xB,0xA,0x9,0x17,0x14,0x13,0x12,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_v3:
	.DB  0xE,0x11,0x13,0x15,0x8,0xA,0xB,0xC
	.DB  0xD,0xC,0xB,0xA,0x8,0x15,0x13,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_arrow_left:
	.DB  0x0,0x0,0x2,0x6,0xE,0x6,0x2,0x0
_arrow_right:
	.DB  0x0,0x0,0x8,0xC,0xE,0xC,0x8,0x0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0010

_0x27:
	.DB  0x50,0x72,0x65,0x73,0x65,0x74
_0x28:
	.DB  0x49,0x74,0x65,0x6D
_0x3C:
	.DB  0x1
_0x3D:
	.DB  0x1
_0x3E:
	.DB  0x4
_0x3F:
	.DB  0x4
_0x40:
	.DB  0x1
_0x41:
	.DB  0x1
_0x42:
	.DB  0x1
_0x43:
	.DB  0x1
_0x7A:
	.DB  0x1
_0x7B:
	.DB  0x58,0x1B
_0x16C:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x4D,0x65,0x6D,0x6F,0x72,0x79,0x20,0x77
	.DB  0x72,0x69,0x74,0x65,0x0,0x4D,0x65,0x6D
	.DB  0x6F,0x72,0x79,0x20,0x72,0x65,0x61,0x64
	.DB  0x0,0x4D,0x65,0x6D,0x6F,0x72,0x79,0x20
	.DB  0x69,0x6E,0x69,0x74,0x0,0x4D,0x6F,0x64
	.DB  0x65,0x0,0x53,0x70,0x65,0x65,0x64,0x0
	.DB  0x4F,0x66,0x66,0x0,0x45,0x64,0x69,0x74
	.DB  0x20,0x0,0x4F,0x75,0x74,0x0,0x4F,0x46
	.DB  0x46,0x0,0x20,0x48,0x61,0x6D,0x6D,0x6F
	.DB  0x6E,0x64,0x20,0x4F,0x72,0x67,0x61,0x6E
	.DB  0x20,0x20,0x0,0x20,0x56,0x69,0x62,0x72
	.DB  0x61,0x74,0x6F,0x2F,0x43,0x68,0x6F,0x72
	.DB  0x75,0x73,0x20,0x0,0x44,0x69,0x67,0x69
	.DB  0x74,0x61,0x6C,0x20,0x53,0x63,0x61,0x6E
	.DB  0x6E,0x65,0x72,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x62,0x79,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x52
	.DB  0x69,0x6E,0x6F,0x6E,0x20,0x4E,0x69,0x6E
	.DB  0x71,0x75,0x65,0x6F,0x6E,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  _t_preset
	.DW  _0x27*2

	.DW  0x04
	.DW  _t_item
	.DW  _0x28*2

	.DW  0x0D
	.DW  _0x2A
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x2E
	.DW  _0x0*2+13

	.DW  0x0C
	.DW  _0x35
	.DW  _0x0*2+25

	.DW  0x01
	.DW  _dir1
	.DW  _0x3C*2

	.DW  0x01
	.DW  _dir2
	.DW  _0x3D*2

	.DW  0x01
	.DW  _dir_cnt1
	.DW  _0x3E*2

	.DW  0x01
	.DW  _dir_cnt2
	.DW  _0x3F*2

	.DW  0x01
	.DW  _e11
	.DW  _0x40*2

	.DW  0x01
	.DW  _e12
	.DW  _0x41*2

	.DW  0x01
	.DW  _e21
	.DW  _0x42*2

	.DW  0x01
	.DW  _e22
	.DW  _0x43*2

	.DW  0x01
	.DW  _scan_mode
	.DW  _0x7A*2

	.DW  0x02
	.DW  _scan_speed
	.DW  _0x7B*2

	.DW  0x05
	.DW  _0x82
	.DW  _0x0*2+37

	.DW  0x06
	.DW  _0x82+5
	.DW  _0x0*2+42

	.DW  0x04
	.DW  _0x82+11
	.DW  _0x0*2+48

	.DW  0x06
	.DW  _0x82+15
	.DW  _0x0*2+52

	.DW  0x04
	.DW  _0x82+21
	.DW  _0x0*2+58

	.DW  0x04
	.DW  _0x82+25
	.DW  _0x0*2+62

	.DW  0x11
	.DW  _0x13A
	.DW  _0x0*2+66

	.DW  0x11
	.DW  _0x13A+17
	.DW  _0x0*2+83

	.DW  0x11
	.DW  _0x13A+34
	.DW  _0x0*2+100

	.DW  0x11
	.DW  _0x13A+51
	.DW  _0x0*2+117

	.DW  0x11
	.DW  _0x13A+68
	.DW  _0x0*2+134

	.DW  0x06
	.DW  0x07
	.DW  _0x16C*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10.01.2013
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
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
;
;#define SetBit(x,y) (x|=y)
;#define ClrBit(x,y) (x&=~y)
;#define TestBit(x,y) (x&y)
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=0
   .equ __scl_bit=1
; 0000 0023 #endasm
;#include <i2c.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 0029 #endasm
;#include <lcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <24LC16.h>

	.CSEG
_write_var:
	ST   -Y,R17
;	block -> Y+3
;	addr -> Y+2
;	data -> Y+1
;	res -> R17
	LDI  R17,0
	LDD  R30,Y+3
	LSL  R30
	STD  Y+3,R30
	ORI  R30,LOW(0xA0)
	STD  Y+3,R30
	ANDI R30,0xFE
	STD  Y+3,R30
_0x3:
	CPI  R17,0
	BRNE _0x5
	CALL _i2c_start
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0x3
_0x5:
	LDI  R17,LOW(0)
_0x6:
	CPI  R17,0
	BRNE _0x8
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0x6
_0x8:
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,0
	BRNE _0xB
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0x9
_0xB:
	CALL _i2c_stop
	LDD  R17,Y+0
	ADIW R28,4
	RET
_read_var:
	ST   -Y,R17
;	block -> Y+2
;	addr -> Y+1
;	res -> R17
	LDI  R17,0
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
	ORI  R30,LOW(0xA0)
	STD  Y+2,R30
	ANDI R30,0xFE
	STD  Y+2,R30
_0xC:
	CPI  R17,0
	BRNE _0xE
	CALL _i2c_start
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0xC
_0xE:
	LDI  R17,LOW(0)
_0xF:
	CPI  R17,0
	BRNE _0x11
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0xF
_0x11:
	LDI  R17,LOW(0)
	LDD  R30,Y+2
	ORI  R30,1
	STD  Y+2,R30
_0x12:
	CPI  R17,0
	BRNE _0x14
	CALL _i2c_start
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	MOV  R17,R30
	RJMP _0x12
_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2080004
;
;unsigned char val1, val2, val3, val4, val5;
;void LCDWriteInt(unsigned int val, unsigned char move)
; 0000 0031 {
_LCDWriteInt:
; 0000 0032     /***************************************************************
; 0000 0033     This function writes a integer type value to LCD module
; 0000 0034 
; 0000 0035     Arguments:
; 0000 0036 	1)unsigned char val	: Value to print
; 0000 0037 
; 0000 0038 	2)unsigned char field_length :total length of field in which the value is printed
; 0000 0039 	must be between 1-3 if it is -1 the field length is no of digits in the val
; 0000 003A 
; 0000 003B 	****************************************************************/
; 0000 003C 
; 0000 003D     val1 = val % 10;
;	val -> Y+1
;	move -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R4,R30
; 0000 003E     val2 = (val / 10) % 10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R3,R30
; 0000 003F     val3 = (val / 100) % 10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R6,R30
; 0000 0040     val4 = (val / 1000) % 10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R5,R30
; 0000 0041     val5 = (val / 10000) % 10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R8,R30
; 0000 0042 
; 0000 0043     if (val5 != 0)
	TST  R8
	BREQ _0x15
; 0000 0044         lcd_putchar(48 + val5);
	MOV  R30,R8
	SUBI R30,-LOW(48)
	RJMP _0x14E
; 0000 0045     else
_0x15:
; 0000 0046     if (move > 4)
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRLO _0x17
; 0000 0047         lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x14E:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0048     if (val4 != 0 || val5 != 0)
_0x17:
	LDI  R30,LOW(0)
	CP   R30,R5
	BRNE _0x19
	CP   R30,R8
	BREQ _0x18
_0x19:
; 0000 0049         lcd_putchar(48 + val4);
	MOV  R30,R5
	SUBI R30,-LOW(48)
	RJMP _0x14F
; 0000 004A     else
_0x18:
; 0000 004B     if (move > 3)
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRLO _0x1C
; 0000 004C         lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x14F:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 004D     if (val3 != 0 || val4 != 0 || val5 != 0)
_0x1C:
	LDI  R30,LOW(0)
	CP   R30,R6
	BRNE _0x1E
	CP   R30,R5
	BRNE _0x1E
	CP   R30,R8
	BREQ _0x1D
_0x1E:
; 0000 004E         lcd_putchar(48 + val3);
	MOV  R30,R6
	SUBI R30,-LOW(48)
	RJMP _0x150
; 0000 004F     else
_0x1D:
; 0000 0050     if (move > 2)
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRLO _0x21
; 0000 0051         lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x150:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0052     if (val2 != 0 || val3 != 0 || val4 != 0 || val5 != 0)
_0x21:
	LDI  R30,LOW(0)
	CP   R30,R3
	BRNE _0x23
	CP   R30,R6
	BRNE _0x23
	CP   R30,R5
	BRNE _0x23
	CP   R30,R8
	BREQ _0x22
_0x23:
; 0000 0053         lcd_putchar(48 + val2);
	MOV  R30,R3
	SUBI R30,-LOW(48)
	RJMP _0x151
; 0000 0054     else
_0x22:
; 0000 0055     if (move > 1)
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRLO _0x26
; 0000 0056         lcd_putchar(' ');
	LDI  R30,LOW(32)
_0x151:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0057     lcd_putchar(48 + val1);
_0x26:
	MOV  R30,R4
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0058 }
_0x2080004:
	ADIW R28,3
	RET
;
;
;#include "patterns.c"
;#define MAX_ITEMS       30
;#define MAX_PATTERNS    8
;#define MAX_OUT         16
;
;unsigned char current_pattern = 0;
;
;typedef struct type_pattern
;{
;    unsigned char length;
;    unsigned char out[MAX_ITEMS];
;} t_pattern;
;
;flash t_pattern v1 = {14,
;                                {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11,
;                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
;
;flash t_pattern v2 = {14,
;                                {0x10, 0x12, 0x13, 0x14, 0x17, 0x09, 0x0A, 0x0B, 0x0A, 0x09, 0x17, 0x14, 0x13, 0x12,
;                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
;
;flash t_pattern v3 = {14,
;                                {0x11, 0x13, 0x15, 0x08, 0x0A, 0x0B, 0x0C, 0x0D, 0x0C, 0x0B, 0x0A, 0x08, 0x15, 0x13,
;                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
;unsigned int block = 0, addr = 0;
;unsigned char _e_read, i, j;
;unsigned char t_preset[] = "Preset";

	.DSEG
;unsigned char t_item[] = "Item";
;
;void inline check_ab()
; 0000 005B {

	.CSEG
_check_ab:
;    if (addr > 255)
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R11
	CPC  R31,R12
	BRSH _0x29
;    {
;        addr = 0;
	CLR  R11
	CLR  R12
;        block++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
;    }
;}
_0x29:
	RET
;
;void write_pattern(t_pattern patt, unsigned char num)
;{
_write_pattern:
;    #asm("cli")
;	patt -> Y+1
;	num -> Y+0
	cli
;    lcd_clear();
	CALL _lcd_clear
;    lcd_puts("Memory write");
	__POINTW1MN _0x2A,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    addr = 3 + num * (MAX_ITEMS + 1);
	LD   R26,Y
	LDI  R30,LOW(31)
	MULS R30,R26
	MOVW R30,R0
	ADIW R30,3
	__PUTW1R 11,12
;    block = addr / 256;
	MOV  R30,R12
	ANDI R31,HIGH(0x0)
	__PUTW1R 9,10
;    addr = addr % 256;
	__GETW1R 11,12
	ANDI R31,HIGH(0xFF)
	__PUTW1R 11,12
;
;    write_var(block, addr, patt.length);
	ST   -Y,R9
	ST   -Y,R11
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _write_var
;
;    addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;    check_ab();
	RCALL _check_ab
;
;    lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;
;    lcd_puts(t_preset);
	LDI  R30,LOW(_t_preset)
	LDI  R31,HIGH(_t_preset)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;    LCDWriteInt(num, 0);
	LD   R30,Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;    lcd_puts(t_item);
	LDI  R30,LOW(_t_item)
	LDI  R31,HIGH(_t_item)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;    for(j = 0; j < MAX_ITEMS; j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x2C:
	LDS  R26,_j
	CPI  R26,LOW(0x1E)
	BRSH _0x2D
;    {
;        lcd_gotoxy(14, 1);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;        LCDWriteInt(j, 0);
	LDS  R30,_j
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;        lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;        write_var(block, addr, patt.out[j]);
	ST   -Y,R9
	ST   -Y,R11
	LDS  R30,_j
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _write_var
;        addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;        check_ab();
	RCALL _check_ab
;    }
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x2C
_0x2D:
;    #asm("sei")
	sei
;}
	ADIW R28,32
	RET

	.DSEG
_0x2A:
	.BYTE 0xD
;
;t_pattern read_pattern(unsigned char num)
;{

	.CSEG
_read_pattern:
;    t_pattern patt;
;
;    #asm("cli")
	SBIW R28,62
;	num -> Y+62
;	patt -> Y+0
	cli
;    lcd_clear();
	CALL _lcd_clear
;    lcd_puts("Memory read");
	__POINTW1MN _0x2E,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    addr = 3 + num * (MAX_ITEMS + 1);
	LDD  R26,Y+62
	LDI  R30,LOW(31)
	MULS R30,R26
	MOVW R30,R0
	ADIW R30,3
	__PUTW1R 11,12
;    block = addr / 256;
	MOV  R30,R12
	ANDI R31,HIGH(0x0)
	__PUTW1R 9,10
;    addr = addr % 256;
	__GETW1R 11,12
	ANDI R31,HIGH(0xFF)
	__PUTW1R 11,12
;
;    patt.length = read_var(block, addr);
	ST   -Y,R9
	ST   -Y,R11
	RCALL _read_var
	ST   Y,R30
;
;    addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;    check_ab();
	RCALL _check_ab
;
;    lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;    lcd_puts(t_preset);
	LDI  R30,LOW(_t_preset)
	LDI  R31,HIGH(_t_preset)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;    LCDWriteInt(num, 0);
	LDD  R30,Y+62
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;    lcd_puts(t_item);
	LDI  R30,LOW(_t_item)
	LDI  R31,HIGH(_t_item)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;    for(j = 0; j < MAX_ITEMS; j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x30:
	LDS  R26,_j
	CPI  R26,LOW(0x1E)
	BRSH _0x31
;    {
;        lcd_gotoxy(14, 1);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;        LCDWriteInt(j, 0);
	LDS  R30,_j
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;        lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;        patt.out[j] = read_var(block, addr);
	LDS  R30,_j
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	ST   -Y,R9
	ST   -Y,R11
	RCALL _read_var
	POP  R26
	POP  R27
	ST   X,R30
;        addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;        check_ab();
	RCALL _check_ab
;    }
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x30
_0x31:
;    #asm("sei")
	sei
;    return patt;
	MOVW R30,R28
	MOVW R26,R28
	ADIW R26,31
	LDI  R24,31
	CALL __COPYMML
	MOVW R30,R28
	ADIW R30,31
	LDI  R24,31
	IN   R1,SREG
	CLI
	ADIW R28,63
	RET
;}

	.DSEG
_0x2E:
	.BYTE 0xC
;
;unsigned char init_check()
;{

	.CSEG
_init_check:
;    _e_read = read_var(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _read_var
	MOV  R14,R30
;    if (_e_read != 0x19)
	LDI  R30,LOW(25)
	CP   R30,R14
	BRNE _0x2080003
;        return 1;
;    _e_read = read_var(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_var
	MOV  R14,R30
;    if (_e_read != 0x08)
	LDI  R30,LOW(8)
	CP   R30,R14
	BRNE _0x2080003
;        return 1;
;    _e_read = read_var(0, 2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_var
	MOV  R14,R30
;    if (_e_read != 0x1E)
	LDI  R30,LOW(30)
	CP   R30,R14
	BREQ _0x34
;        return 1;
_0x2080003:
	LDI  R30,LOW(1)
	RET
;    return 0;
_0x34:
	LDI  R30,LOW(0)
	RET
;}
;
;void zero_init()
;{
_zero_init:
;    lcd_clear();
	CALL _lcd_clear
;    lcd_puts("Memory init");
	__POINTW1MN _0x35,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    write_var(0, 0, 0x19);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	RCALL _write_var
;    write_var(0, 1, 0x08);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _write_var
;    write_var(0, 2, 0x1E);  //30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _write_var
;
;    block = 0;
	CLR  R9
	CLR  R10
;    addr = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	__PUTW1R 11,12
;    for(i = 0; i < MAX_PATTERNS; i++)
	CLR  R13
_0x37:
	LDI  R30,LOW(8)
	CP   R13,R30
	BRLO PC+3
	JMP _0x38
;    {
;        write_var(block, addr, v1.length);
	ST   -Y,R9
	ST   -Y,R11
	LDI  R30,LOW(_v1*2)
	LDI  R31,HIGH(_v1*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _write_var
;        addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;            check_ab();
	RCALL _check_ab
;        for(j = 0; j < MAX_ITEMS; j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x3A:
	LDS  R26,_j
	CPI  R26,LOW(0x1E)
	BRLO PC+3
	JMP _0x3B
;        {
;            lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
;
;            lcd_puts(t_preset);
	LDI  R30,LOW(_t_preset)
	LDI  R31,HIGH(_t_preset)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;            lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;            LCDWriteInt(i, 0);
	MOV  R30,R13
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;
;            lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;            lcd_puts(t_item);
	LDI  R30,LOW(_t_item)
	LDI  R31,HIGH(_t_item)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;            lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;            LCDWriteInt(j, 0);
	LDS  R30,_j
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
;            lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
;
;            write_var(block, addr, v1.out[j]);
	ST   -Y,R9
	ST   -Y,R11
	__POINTW1FN _v1,1
	MOVW R26,R30
	LDS  R30,_j
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	ST   -Y,R30
	RCALL _write_var
;            addr++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
;            check_ab();
	RCALL _check_ab
;        }
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x3A
_0x3B:
;    }
	INC  R13
	RJMP _0x37
_0x38:
;}
	RET

	.DSEG
_0x35:
	.BYTE 0xC
;#include "encoder.c"
;#define _dir_cnt 4
;#define _dir_cnt2 8
;
;unsigned char dir1 = 1, dir2 = 1, dir_cnt1 = _dir_cnt, dir_cnt2 = _dir_cnt, e11 = 1, e12 = 1, e21 = 1, e22 = 1, enc1 = 0, enc2 = 0;
;
;void inline encoder_main(unsigned char port1, unsigned char pin11, unsigned char pin12, unsigned char port2, unsigned char pin21, unsigned char pin22)
; 0000 005C {

	.CSEG
_encoder_main:
;    if (TestBit(port1, pin11) && TestBit(port1, pin12))
;	port1 -> Y+5
;	pin11 -> Y+4
;	pin12 -> Y+3
;	port2 -> Y+2
;	pin21 -> Y+1
;	pin22 -> Y+0
	LDD  R30,Y+4
	LDD  R26,Y+5
	AND  R30,R26
	BREQ _0x45
	LDD  R30,Y+3
	AND  R30,R26
	BRNE _0x46
_0x45:
	RJMP _0x44
_0x46:
;        e11 = 0;
	LDI  R30,LOW(0)
	STS  _e11,R30
;    if (!TestBit(port1, pin11) && TestBit(port1, pin12))
_0x44:
	LDD  R30,Y+4
	LDD  R26,Y+5
	AND  R30,R26
	BRNE _0x48
	LDD  R30,Y+3
	AND  R30,R26
	BRNE _0x49
_0x48:
	RJMP _0x47
_0x49:
;        e11 = 1;
	LDI  R30,LOW(1)
	STS  _e11,R30
;    if (!TestBit(port1, pin11) && !TestBit(port1, pin12))
_0x47:
	LDD  R30,Y+4
	LDD  R26,Y+5
	AND  R30,R26
	BRNE _0x4B
	LDD  R30,Y+3
	AND  R30,R26
	BREQ _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
;        e11 = 2;
	LDI  R30,LOW(2)
	STS  _e11,R30
;    if (TestBit(port1, pin11) && !TestBit(port1, pin12))
_0x4A:
	LDD  R30,Y+4
	LDD  R26,Y+5
	AND  R30,R26
	BREQ _0x4E
	LDD  R30,Y+3
	AND  R30,R26
	BREQ _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
;        e11 = 3;
	LDI  R30,LOW(3)
	STS  _e11,R30
;
;    if (TestBit(port2, pin21) && TestBit(port2, pin22))
_0x4D:
	LDD  R30,Y+1
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x51
	LD   R30,Y
	AND  R30,R26
	BRNE _0x52
_0x51:
	RJMP _0x50
_0x52:
;        e21 = 0;
	LDI  R30,LOW(0)
	STS  _e21,R30
;    if (!TestBit(port2, pin21) && TestBit(port2, pin22))
_0x50:
	LDD  R30,Y+1
	LDD  R26,Y+2
	AND  R30,R26
	BRNE _0x54
	LD   R30,Y
	AND  R30,R26
	BRNE _0x55
_0x54:
	RJMP _0x53
_0x55:
;        e21 = 1;
	LDI  R30,LOW(1)
	STS  _e21,R30
;    if (!TestBit(port2, pin21) && !TestBit(port2, pin22))
_0x53:
	LDD  R30,Y+1
	LDD  R26,Y+2
	AND  R30,R26
	BRNE _0x57
	LD   R30,Y
	AND  R30,R26
	BREQ _0x58
_0x57:
	RJMP _0x56
_0x58:
;        e21 = 2;
	LDI  R30,LOW(2)
	STS  _e21,R30
;    if (TestBit(port2, pin21) && !TestBit(port2, pin22))
_0x56:
	LDD  R30,Y+1
	LDD  R26,Y+2
	AND  R30,R26
	BREQ _0x5A
	LD   R30,Y
	AND  R30,R26
	BREQ _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
;        e21 = 3;
	LDI  R30,LOW(3)
	STS  _e21,R30
;
;    switch (e12)
_0x59:
	LDS  R30,_e12
	LDI  R31,0
;    {
;        case 0: if (e11 == 1)
	SBIW R30,0
	BRNE _0x5F
	LDS  R26,_e11
	CPI  R26,LOW(0x1)
	BRNE _0x60
;                    dir1 = 0;
	LDI  R30,LOW(0)
	STS  _dir1,R30
;                if (e11 == 3)
_0x60:
	LDS  R26,_e11
	CPI  R26,LOW(0x3)
	BRNE _0x61
;                    dir1 = 2;
	LDI  R30,LOW(2)
	STS  _dir1,R30
;                break;
_0x61:
	RJMP _0x5E
;        case 1: if (e11 == 2)
_0x5F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x62
	LDS  R26,_e11
	CPI  R26,LOW(0x2)
	BRNE _0x63
;                    dir1 = 0;
	LDI  R30,LOW(0)
	STS  _dir1,R30
;                if (e11 == 0)
_0x63:
	LDS  R30,_e11
	CPI  R30,0
	BRNE _0x64
;                    dir1 = 2;
	LDI  R30,LOW(2)
	STS  _dir1,R30
;                break;
_0x64:
	RJMP _0x5E
;        case 2: if (e11 == 3)
_0x62:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x65
	LDS  R26,_e11
	CPI  R26,LOW(0x3)
	BRNE _0x66
;                    dir1 = 0;
	LDI  R30,LOW(0)
	STS  _dir1,R30
;                if (e11 == 1)
_0x66:
	LDS  R26,_e11
	CPI  R26,LOW(0x1)
	BRNE _0x67
;                    dir1 = 2;
	LDI  R30,LOW(2)
	STS  _dir1,R30
;                break;
_0x67:
	RJMP _0x5E
;        case 3: if (e11 == 0)
_0x65:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5E
	LDS  R30,_e11
	CPI  R30,0
	BRNE _0x69
;                    dir1 = 0;
	LDI  R30,LOW(0)
	STS  _dir1,R30
;                if (e11 == 2)
_0x69:
	LDS  R26,_e11
	CPI  R26,LOW(0x2)
	BRNE _0x6A
;                    dir1 = 2;
	LDI  R30,LOW(2)
	STS  _dir1,R30
;                break;
_0x6A:
;    }
_0x5E:
;
;    switch (e22)
	LDS  R30,_e22
	LDI  R31,0
;    {
;        case 0: if (e21 == 1)
	SBIW R30,0
	BRNE _0x6E
	LDS  R26,_e21
	CPI  R26,LOW(0x1)
	BRNE _0x6F
;                    dir2 = 0;
	LDI  R30,LOW(0)
	STS  _dir2,R30
;                if (e21 == 3)
_0x6F:
	LDS  R26,_e21
	CPI  R26,LOW(0x3)
	BRNE _0x70
;                    dir2 = 2;
	LDI  R30,LOW(2)
	STS  _dir2,R30
;                break;
_0x70:
	RJMP _0x6D
;        case 1: if (e21 == 2)
_0x6E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x71
	LDS  R26,_e21
	CPI  R26,LOW(0x2)
	BRNE _0x72
;                    dir2 = 0;
	LDI  R30,LOW(0)
	STS  _dir2,R30
;                if (e21 == 0)
_0x72:
	LDS  R30,_e21
	CPI  R30,0
	BRNE _0x73
;                    dir2 = 2;
	LDI  R30,LOW(2)
	STS  _dir2,R30
;                break;
_0x73:
	RJMP _0x6D
;        case 2: if (e21 == 3)
_0x71:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x74
	LDS  R26,_e21
	CPI  R26,LOW(0x3)
	BRNE _0x75
;                    dir2 = 0;
	LDI  R30,LOW(0)
	STS  _dir2,R30
;                if (e21 == 1)
_0x75:
	LDS  R26,_e21
	CPI  R26,LOW(0x1)
	BRNE _0x76
;                    dir2 = 2;
	LDI  R30,LOW(2)
	STS  _dir2,R30
;                break;
_0x76:
	RJMP _0x6D
;        case 3: if (e21 == 0)
_0x74:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6D
	LDS  R30,_e21
	CPI  R30,0
	BRNE _0x78
;                    dir2 = 0;
	LDI  R30,LOW(0)
	STS  _dir2,R30
;                if (e21 == 2)
_0x78:
	LDS  R26,_e21
	CPI  R26,LOW(0x2)
	BRNE _0x79
;                    dir2 = 2;
	LDI  R30,LOW(2)
	STS  _dir2,R30
;                break;
_0x79:
;    }
_0x6D:
;
;    e12 = e11;
	LDS  R30,_e11
	STS  _e12,R30
;    e22 = e21;
	LDS  R30,_e21
	STS  _e22,R30
;}
	ADIW R28,6
	RET
;
;#define max_speed 40000
;#define min_speed   500
;#define dividor_speed 500
;
;//3,4,5
;#define port_sh PORTD
;#define pin_sh  0x08
;#define pin_st  0x10
;#define pin_d   0x20
;
;#define pin_pwm 0x40
;
;#define PWM_step 0xFF
;
;#define scan_speed1 7000
;#define scan_speed2 7000
;
;unsigned char pwm_cnt = 0;
;
;unsigned char scan_mode = 1, last_mode = 0;

	.DSEG
;bit edit_mode = 0;
;unsigned char scan_cnt = 0;
;bit chorus = 0;
;bit multiplexor = 0;
;bit ch_speed = 0;
;bit ch_on = 1;
;unsigned int scan_speed = 7000, tmp_speed = 0;
;unsigned char out = 0, out2 = 0;
;
;unsigned char e_preset = 0, e_item = 0, e_out = 0, e_mode = 0;
;bit e_save = 0;
;bit e_preview = 0;
;t_pattern e_patt;
;
;t_pattern patt;
;
;void shift_out(unsigned char data)
; 0000 0083 {

	.CSEG
_shift_out:
; 0000 0084 	ClrBit(port_sh, pin_st);
;	data -> Y+0
	CBI  0x12,4
; 0000 0085     ClrBit(port_sh, pin_sh);
	CBI  0x12,3
; 0000 0086 
; 0000 0087     delay_us(1000);
	__DELAY_USW 3000
; 0000 0088 
; 0000 0089 	for(i = 0; i < 8; i++)
	CLR  R13
_0x7D:
	LDI  R30,LOW(8)
	CP   R13,R30
	BRSH _0x7E
; 0000 008A 	{
; 0000 008B 		if(data & 0x80)
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x7F
; 0000 008C 			SetBit(port_sh, pin_d);
	SBI  0x12,5
; 0000 008D 		else
	RJMP _0x80
_0x7F:
; 0000 008E 			ClrBit(port_sh, pin_d);
	CBI  0x12,5
; 0000 008F 
; 0000 0090 		delay_us(1000);
_0x80:
	__DELAY_USW 3000
; 0000 0091 		SetBit(port_sh, pin_sh);
	SBI  0x12,3
; 0000 0092 
; 0000 0093 		delay_us(1000);
	__DELAY_USW 3000
; 0000 0094 		ClrBit(port_sh, pin_sh);
	CBI  0x12,3
; 0000 0095 		data <<= 1;
	LD   R30,Y
	LSL  R30
	ST   Y,R30
; 0000 0096 	}
	INC  R13
	RJMP _0x7D
_0x7E:
; 0000 0097     delay_us(1000);
	__DELAY_USW 3000
; 0000 0098     SetBit(port_sh, pin_st);
	SBI  0x12,4
; 0000 0099 }
	ADIW R28,1
	RET
;
;
;void lcd_out()
; 0000 009D {
_lcd_out:
; 0000 009E     lcd_clear();
	CALL _lcd_clear
; 0000 009F 
; 0000 00A0     if (!edit_mode)
	SBRC R2,0
	RJMP _0x81
; 0000 00A1     {
; 0000 00A2         lcd_puts("Mode");
	__POINTW1MN _0x82,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00A3         lcd_gotoxy(11, 0);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00A4         lcd_puts("Speed");
	__POINTW1MN _0x82,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00A5 
; 0000 00A6         if (scan_mode < 4)
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x4)
	BRSH _0x83
; 0000 00A7         {
; 0000 00A8             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00A9             if (scan_mode > 1)  lcd_putchar(0); else    lcd_putchar(' ');
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x2)
	BRLO _0x84
	LDI  R30,LOW(0)
	RJMP _0x152
_0x84:
	LDI  R30,LOW(32)
_0x152:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00AA             if (chorus) lcd_putchar('C');   else    lcd_putchar('V');
	SBRS R2,1
	RJMP _0x86
	LDI  R30,LOW(67)
	RJMP _0x153
_0x86:
	LDI  R30,LOW(86)
_0x153:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00AB             LCDWriteInt(scan_mode, 0);
	LDS  R30,_scan_mode
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00AC             if (ch_on)
	SBRS R2,4
	RJMP _0x88
; 0000 00AD             {
; 0000 00AE                 if (scan_mode < 3)  lcd_putchar(1); else    lcd_putchar(' ');
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x3)
	BRSH _0x89
	LDI  R30,LOW(1)
	RJMP _0x154
_0x89:
	LDI  R30,LOW(32)
_0x154:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00AF                 lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00B0             }
; 0000 00B1             else
	RJMP _0x8B
_0x88:
; 0000 00B2                 lcd_puts("Off");
	__POINTW1MN _0x82,11
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00B3         }
_0x8B:
; 0000 00B4         else
	RJMP _0x8C
_0x83:
; 0000 00B5         {
; 0000 00B6             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00B7             lcd_puts(t_preset);
	LDI  R30,LOW(_t_preset)
	LDI  R31,HIGH(_t_preset)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00B8             if (current_pattern > 0)  lcd_putchar(0); else    lcd_putchar(' ');
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x8D
	RJMP _0x155
_0x8D:
	LDI  R30,LOW(32)
_0x155:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00B9             if (chorus) lcd_putchar('C');   else    lcd_putchar('V');
	SBRS R2,1
	RJMP _0x8F
	LDI  R30,LOW(67)
	RJMP _0x156
_0x8F:
	LDI  R30,LOW(86)
_0x156:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00BA             LCDWriteInt(current_pattern+1, 0);
	MOV  R30,R7
	LDI  R31,0
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00BB             if (current_pattern < MAX_PATTERNS-1)  lcd_putchar(1); else    lcd_putchar(' ');
	LDI  R30,LOW(7)
	CP   R7,R30
	BRSH _0x91
	LDI  R30,LOW(1)
	RJMP _0x157
_0x91:
	LDI  R30,LOW(32)
_0x157:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00BC             lcd_gotoxy(11, 1);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00BD         }
_0x8C:
; 0000 00BE 
; 0000 00BF         if (scan_speed < max_speed)  lcd_putchar(0); else    lcd_putchar(' ');
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CPI  R26,LOW(0x9C40)
	LDI  R30,HIGH(0x9C40)
	CPC  R27,R30
	BRSH _0x93
	LDI  R30,LOW(0)
	RJMP _0x158
_0x93:
	LDI  R30,LOW(32)
_0x158:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00C0         LCDWriteInt((max_speed - scan_speed)/dividor_speed, 0);
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	LDI  R30,LOW(40000)
	LDI  R31,HIGH(40000)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL __DIVW21U
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00C1         if (scan_speed > min_speed)  lcd_putchar(1); else    lcd_putchar(' ');
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRLO _0x95
	LDI  R30,LOW(1)
	RJMP _0x159
_0x95:
	LDI  R30,LOW(32)
_0x159:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00C2     }
; 0000 00C3     else
	RJMP _0x97
_0x81:
; 0000 00C4     {
; 0000 00C5         lcd_puts("Edit ");
	__POINTW1MN _0x82,15
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00C6         lcd_puts(t_preset);
	LDI  R30,LOW(_t_preset)
	LDI  R31,HIGH(_t_preset)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00C7         if (e_preset > 0 && e_mode==0)  lcd_putchar(0); else    lcd_putchar(' ');
	LDS  R26,_e_preset
	CPI  R26,LOW(0x1)
	BRLO _0x99
	LDS  R26,_e_mode
	CPI  R26,LOW(0x0)
	BREQ _0x9A
_0x99:
	RJMP _0x98
_0x9A:
	LDI  R30,LOW(0)
	RJMP _0x15A
_0x98:
	LDI  R30,LOW(32)
_0x15A:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00C8         LCDWriteInt(e_preset+1, 0);
	LDS  R30,_e_preset
	LDI  R31,0
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00C9         if (e_preset < MAX_PATTERNS-1 && e_mode==0)  lcd_putchar(1); else    lcd_putchar(' ');
	LDS  R26,_e_preset
	CPI  R26,LOW(0x7)
	BRSH _0x9D
	LDS  R26,_e_mode
	CPI  R26,LOW(0x0)
	BREQ _0x9E
_0x9D:
	RJMP _0x9C
_0x9E:
	LDI  R30,LOW(1)
	RJMP _0x15B
_0x9C:
	LDI  R30,LOW(32)
_0x15B:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00CA         lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00CB         if (e_save) lcd_putchar('*');
	SBRS R2,5
	RJMP _0xA0
	LDI  R30,LOW(42)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00CC 
; 0000 00CD         lcd_gotoxy(0, 1);
_0xA0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00CE         lcd_puts(t_item);
	LDI  R30,LOW(_t_item)
	LDI  R31,HIGH(_t_item)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00CF         if (e_item > 0 && e_mode==1)  lcd_putchar(0); else    lcd_putchar(' ');
	LDS  R26,_e_item
	CPI  R26,LOW(0x1)
	BRLO _0xA2
	LDS  R26,_e_mode
	CPI  R26,LOW(0x1)
	BREQ _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
	LDI  R30,LOW(0)
	RJMP _0x15C
_0xA1:
	LDI  R30,LOW(32)
_0x15C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D0         LCDWriteInt(e_item+1, 2);
	LDS  R30,_e_item
	LDI  R31,0
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCDWriteInt
; 0000 00D1         if (e_item < MAX_ITEMS-1 && e_mode==1 && e_out > 0)  lcd_putchar(1); else    lcd_putchar(' ');
	LDS  R26,_e_item
	CPI  R26,LOW(0x1D)
	BRSH _0xA6
	LDS  R26,_e_mode
	CPI  R26,LOW(0x1)
	BRNE _0xA6
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRSH _0xA7
_0xA6:
	RJMP _0xA5
_0xA7:
	LDI  R30,LOW(1)
	RJMP _0x15D
_0xA5:
	LDI  R30,LOW(32)
_0x15D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D2         if (e_out > 0) lcd_putchar(' ');
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRLO _0xA9
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D3 
; 0000 00D4         lcd_puts("Out");
_0xA9:
	__POINTW1MN _0x82,21
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00D5         if (e_out > 0 && e_mode==2)  lcd_putchar(0); else  lcd_putchar(' ');
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRLO _0xAB
	LDS  R26,_e_mode
	CPI  R26,LOW(0x2)
	BREQ _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
	LDI  R30,LOW(0)
	RJMP _0x15E
_0xAA:
	LDI  R30,LOW(32)
_0x15E:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D6         if (e_out > 0) LCDWriteInt(e_out, 2);   else    lcd_puts("OFF");
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRLO _0xAE
	LDS  R30,_e_out
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LCDWriteInt
	RJMP _0xAF
_0xAE:
	__POINTW1MN _0x82,25
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00D7         if (e_out < MAX_OUT && e_mode==2)  lcd_putchar(1); else    lcd_putchar(' ');
_0xAF:
	LDS  R26,_e_out
	CPI  R26,LOW(0x10)
	BRSH _0xB1
	LDS  R26,_e_mode
	CPI  R26,LOW(0x2)
	BREQ _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
	LDI  R30,LOW(1)
	RJMP _0x15F
_0xB0:
	LDI  R30,LOW(32)
_0x15F:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00D8     }
_0x97:
; 0000 00D9 }
	RET

	.DSEG
_0x82:
	.BYTE 0x1D
;
;#include "keys.c"
;//стрелки
;flash unsigned char arrow_left[8] =  {0x00, 0x00, 0x02, 0x06, 0x0E, 0x06, 0x02, 0x00};
;flash unsigned char arrow_right[8] = {0x00, 0x00, 0x08, 0x0C, 0x0E, 0x0C, 0x08, 0x00};
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00DB {

	.CSEG
_ext_int0_isr:
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
;// Place your code here
;    if (ch_speed)
	SBRS R2,3
	RJMP _0xB4
;        return;
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
;//---------------------Rotate left---------------------------
;    if (!TestBit(PINA, 0b01000000))
_0xB4:
	SBIC 0x19,6
	RJMP _0xB5
;    {
;        if (!edit_mode)
	SBRC R2,0
	RJMP _0xB6
;        {
;            if (enc1 && scan_mode > 1 && scan_mode < 4)
	LDS  R30,_enc1
	CPI  R30,0
	BREQ _0xB8
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x2)
	BRLO _0xB8
	CPI  R26,LOW(0x4)
	BRLO _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
;                scan_mode--;
	LDS  R30,_scan_mode
	SUBI R30,LOW(1)
	STS  _scan_mode,R30
;            if (!enc1 && scan_mode < 3)
_0xB7:
	LDS  R30,_enc1
	CPI  R30,0
	BRNE _0xBB
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x3)
	BRLO _0xBC
_0xBB:
	RJMP _0xBA
_0xBC:
;                scan_mode++;
	LDS  R30,_scan_mode
	SUBI R30,-LOW(1)
	STS  _scan_mode,R30
;
;            if (!enc1 && scan_mode == 4 && current_pattern > 0)
_0xBA:
	LDS  R30,_enc1
	CPI  R30,0
	BRNE _0xBE
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x4)
	BRNE _0xBE
	LDI  R30,LOW(0)
	CP   R30,R7
	BRLO _0xBF
_0xBE:
	RJMP _0xBD
_0xBF:
;            {
;                current_pattern--;
	DEC  R7
;                patt = read_pattern(current_pattern);
	ST   -Y,R7
	RCALL _read_pattern
	LDI  R26,LOW(_patt)
	LDI  R27,HIGH(_patt)
	CALL __COPYMML
	OUT  SREG,R1
;            }
;            if (enc1 && scan_mode == 4 && current_pattern < MAX_PATTERNS-1)
_0xBD:
	LDS  R30,_enc1
	CPI  R30,0
	BREQ _0xC1
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x4)
	BRNE _0xC1
	LDI  R30,LOW(7)
	CP   R7,R30
	BRLO _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
;            {
;                current_pattern++;
	INC  R7
;                patt = read_pattern(current_pattern);
	ST   -Y,R7
	RCALL _read_pattern
	LDI  R26,LOW(_patt)
	LDI  R27,HIGH(_patt)
	CALL __COPYMML
	OUT  SREG,R1
;            }
;        }
_0xC0:
;        else
	RJMP _0xC3
_0xB6:
;        {
;            if (!enc1)
	LDS  R30,_enc1
	CPI  R30,0
	BREQ PC+3
	JMP _0xC4
;            {
;                switch (e_mode)
	LDS  R30,_e_mode
	LDI  R31,0
;                {
;                    case 0: if (e_preset > 0 && !e_save)
	SBIW R30,0
	BRNE _0xC8
	LDS  R26,_e_preset
	CPI  R26,LOW(0x1)
	BRLO _0xCA
	SBRS R2,5
	RJMP _0xCB
_0xCA:
	RJMP _0xC9
_0xCB:
;                            {
;                                e_preset--;
	LDS  R30,_e_preset
	SUBI R30,LOW(1)
	STS  _e_preset,R30
;                                e_patt = read_pattern(e_preset);
	ST   -Y,R30
	RCALL _read_pattern
	LDI  R26,LOW(_e_patt)
	LDI  R27,HIGH(_e_patt)
	CALL __COPYMML
	OUT  SREG,R1
;
;                                e_item = 0;
	LDI  R30,LOW(0)
	STS  _e_item,R30
;                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
	__POINTW2MN _e_patt,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R26,R30
	ANDI R30,LOW(0x7)
	MOV  R0,R30
	MOV  R30,R26
	ANDI R30,LOW(0x8)
	ADD  R30,R0
	STS  _e_out,R30
;                                if (e_out)  e_out++;
	CPI  R30,0
	BREQ _0xCC
	SUBI R30,-LOW(1)
	STS  _e_out,R30
;                            }
_0xCC:
;                            break;
_0xC9:
	RJMP _0xC7
;                    case 1: if (e_item > 0)
_0xC8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xCD
	LDS  R26,_e_item
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0xCE
;                            {
;                                if (e_out)
	LDS  R30,_e_out
	CPI  R30,0
	BREQ _0xCF
;                                {
;                                    e_out--;
	SUBI R30,LOW(1)
	STS  _e_out,R30
;                                    e_patt.out[e_item] = e_out & 0x07;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_e_out
	ANDI R30,LOW(0x7)
	ST   X,R30
;                                    if (e_out > 7)
	LDS  R26,_e_out
	CPI  R26,LOW(0x8)
	BRLO _0xD0
;                                        e_patt.out[e_item] += 0x08;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(8)
	RJMP _0x160
;                                    else
_0xD0:
;                                        e_patt.out[e_item] += 0x10;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(16)
_0x160:
	ST   X,R30
;                                }
;                                else
	RJMP _0xD2
_0xCF:
;                                    e_patt.out[e_item] = 0;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
;                                e_item--;
_0xD2:
	LDS  R30,_e_item
	SUBI R30,LOW(1)
	STS  _e_item,R30
;                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
	__POINTW2MN _e_patt,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R26,R30
	ANDI R30,LOW(0x7)
	MOV  R0,R30
	MOV  R30,R26
	ANDI R30,LOW(0x8)
	ADD  R30,R0
	STS  _e_out,R30
;                                if (e_out)  e_out++;
	CPI  R30,0
	BREQ _0xD3
	SUBI R30,-LOW(1)
	STS  _e_out,R30
;                            }
_0xD3:
;                            break;
_0xCE:
	RJMP _0xC7
;                    case 2: if (e_out > 0 && e_item + 1 == e_patt.length)
_0xCD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC7
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRLO _0xD6
	LDS  R30,_e_item
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDS  R30,_e_patt
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xD7
_0xD6:
	RJMP _0xD5
_0xD7:
;                            {
;                                e_out--;
	LDS  R30,_e_out
	SUBI R30,LOW(1)
	STS  _e_out,R30
;                                e_save = 1;
	SET
	BLD  R2,5
;                            }
;                            break;
_0xD5:
;                }
_0xC7:
;                if (!e_out)
	LDS  R30,_e_out
	CPI  R30,0
	BRNE _0xD8
;                {
;                    e_patt.length = e_item;
	LDS  R30,_e_item
	STS  _e_patt,R30
;                }
;            }
_0xD8:
;            else
	RJMP _0xD9
_0xC4:
;            {
;                switch (e_mode)
	LDS  R30,_e_mode
	LDI  R31,0
;                {
;                    case 0: if (e_preset < MAX_PATTERNS-1 && !e_save)
	SBIW R30,0
	BRNE _0xDD
	LDS  R26,_e_preset
	CPI  R26,LOW(0x7)
	BRSH _0xDF
	SBRS R2,5
	RJMP _0xE0
_0xDF:
	RJMP _0xDE
_0xE0:
;                            {
;                                e_preset++;
	LDS  R30,_e_preset
	SUBI R30,-LOW(1)
	STS  _e_preset,R30
;                                e_patt = read_pattern(e_preset);
	ST   -Y,R30
	RCALL _read_pattern
	LDI  R26,LOW(_e_patt)
	LDI  R27,HIGH(_e_patt)
	CALL __COPYMML
	OUT  SREG,R1
;
;                                e_item = 0;
	LDI  R30,LOW(0)
	STS  _e_item,R30
;                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
	__POINTW2MN _e_patt,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R26,R30
	ANDI R30,LOW(0x7)
	MOV  R0,R30
	MOV  R30,R26
	ANDI R30,LOW(0x8)
	ADD  R30,R0
	STS  _e_out,R30
;                                if (e_out)  e_out++;
	CPI  R30,0
	BREQ _0xE1
	SUBI R30,-LOW(1)
	STS  _e_out,R30
;                            }
_0xE1:
;                            break;
_0xDE:
	RJMP _0xDC
;                    case 1: if (e_item < MAX_ITEMS-1 && e_out > 0)
_0xDD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xE2
	LDS  R26,_e_item
	CPI  R26,LOW(0x1D)
	BRSH _0xE4
	LDS  R26,_e_out
	CPI  R26,LOW(0x1)
	BRSH _0xE5
_0xE4:
	RJMP _0xE3
_0xE5:
;                            {
;                                if (e_out)
	LDS  R30,_e_out
	CPI  R30,0
	BREQ _0xE6
;                                {
;                                    e_out--;
	SUBI R30,LOW(1)
	STS  _e_out,R30
;                                    e_patt.out[e_item] = e_out & 0x07;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_e_out
	ANDI R30,LOW(0x7)
	ST   X,R30
;                                    if (e_out > 7)
	LDS  R26,_e_out
	CPI  R26,LOW(0x8)
	BRLO _0xE7
;                                        e_patt.out[e_item] += 0x08;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(8)
	RJMP _0x161
;                                    else
_0xE7:
;                                        e_patt.out[e_item] += 0x10;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(16)
_0x161:
	ST   X,R30
;                                }
;                                else
	RJMP _0xE9
_0xE6:
;                                    e_patt.out[e_item] = 0;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
;                                e_item++;
_0xE9:
	LDS  R30,_e_item
	SUBI R30,-LOW(1)
	STS  _e_item,R30
;                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
	__POINTW2MN _e_patt,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R26,R30
	ANDI R30,LOW(0x7)
	MOV  R0,R30
	MOV  R30,R26
	ANDI R30,LOW(0x8)
	ADD  R30,R0
	STS  _e_out,R30
;                                if (e_out) e_out++;
	CPI  R30,0
	BREQ _0xEA
	SUBI R30,-LOW(1)
	STS  _e_out,R30
;                                if (e_item > e_patt.length)
_0xEA:
	LDS  R30,_e_patt
	LDS  R26,_e_item
	CP   R30,R26
	BRSH _0xEB
;                                    e_patt.length++;
	SUBI R30,-LOW(1)
	STS  _e_patt,R30
;                            }
_0xEB:
;                            break;
_0xE3:
	RJMP _0xDC
;                    case 2: if (e_out < MAX_OUT)
_0xE2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xDC
	LDS  R26,_e_out
	CPI  R26,LOW(0x10)
	BRSH _0xED
;                            {
;                                e_out++;
	LDS  R30,_e_out
	SUBI R30,-LOW(1)
	STS  _e_out,R30
;                                e_save = 1;
	SET
	BLD  R2,5
;                            }
;                            break;
_0xED:
;                }
_0xDC:
;            }
_0xD9:
;        }
_0xC3:
;        SetBit(PORTA, 0b01000000);
	SBI  0x1B,6
;//        return;
;    }
;//---------------------Rotate right--------------------------
;    if (!TestBit(PINA, 0b10000000))
_0xB5:
	SBIC 0x19,7
	RJMP _0xEE
;    {
;        if (!edit_mode)
	SBRC R2,0
	RJMP _0xEF
;        {
;            if (enc2 && scan_speed < max_speed)
	LDS  R30,_enc2
	CPI  R30,0
	BREQ _0xF1
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CPI  R26,LOW(0x9C40)
	LDI  R30,HIGH(0x9C40)
	CPC  R27,R30
	BRLO _0xF2
_0xF1:
	RJMP _0xF0
_0xF2:
;                scan_speed += dividor_speed;
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	SUBI R30,LOW(-500)
	SBCI R31,HIGH(-500)
	STS  _scan_speed,R30
	STS  _scan_speed+1,R31
;            if (!enc2 && scan_speed > min_speed)
_0xF0:
	LDS  R30,_enc2
	CPI  R30,0
	BRNE _0xF4
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CPI  R26,LOW(0x1F5)
	LDI  R30,HIGH(0x1F5)
	CPC  R27,R30
	BRSH _0xF5
_0xF4:
	RJMP _0xF3
_0xF5:
;                scan_speed -= dividor_speed;
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	SUBI R30,LOW(500)
	SBCI R31,HIGH(500)
	STS  _scan_speed,R30
	STS  _scan_speed+1,R31
;            OCR1A = scan_speed;
_0xF3:
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;        }
;        else
	RJMP _0xF6
_0xEF:
;        {
;            if (!enc2)
	LDS  R30,_enc2
	CPI  R30,0
	BRNE _0xF7
;            {
;                if (e_mode > 0) e_mode--;
	LDS  R26,_e_mode
	CPI  R26,LOW(0x1)
	BRLO _0xF8
	LDS  R30,_e_mode
	SUBI R30,LOW(1)
	RJMP _0x162
;                else e_mode = 2;
_0xF8:
	LDI  R30,LOW(2)
_0x162:
	STS  _e_mode,R30
;            }
;            else
	RJMP _0xFA
_0xF7:
;            {
;                if (e_mode < 2) e_mode++;
	LDS  R26,_e_mode
	CPI  R26,LOW(0x2)
	BRSH _0xFB
	LDS  R30,_e_mode
	SUBI R30,-LOW(1)
	RJMP _0x163
;                else e_mode = 0;
_0xFB:
	LDI  R30,LOW(0)
_0x163:
	STS  _e_mode,R30
;            }
_0xFA:
;        }
_0xF6:
;        SetBit(PORTA, 0b10000000);
	SBI  0x1B,7
;//        return;
;    }
;//------------------------Stop start-------------------------
;//    if (!TestBit(PINA, 0b00010000))
;//    {
;//        if (!edit_mode)
;//        {
;//            if (ch_on)
;//            {
;//                ch_on = 0;
;//                ch_speed = 1;
;//                tmp_speed = scan_speed;
;//            }
;//            else
;//            {
;//                ch_on = 1;
;//                ch_speed = 1;
;//                TCCR1B=0x09;
;//            }
;//        }
;////        return;
;//    }
;
;//---------------------User presets--------------------------
;    if (!TestBit(PINB, 0b00000001) && TestBit(PINA, 0b00010000))
_0xEE:
	SBIC 0x16,0
	RJMP _0xFE
	SBIC 0x19,4
	RJMP _0xFF
_0xFE:
	RJMP _0xFD
_0xFF:
;    {
;        if (!edit_mode)
	SBRC R2,0
	RJMP _0x100
;        {
;            if (scan_mode == 4)
	LDS  R26,_scan_mode
	CPI  R26,LOW(0x4)
	BRNE _0x101
;                scan_mode = last_mode;
	LDS  R30,_last_mode
	RJMP _0x164
;            else
_0x101:
;            {
;                last_mode = scan_mode;
	LDS  R30,_scan_mode
	STS  _last_mode,R30
;                scan_mode = 4;
	LDI  R30,LOW(4)
_0x164:
	STS  _scan_mode,R30
;            }
;        }
;//        return;
;    }
_0x100:
;//--------------------Edit mode------------------------------
;    if (!TestBit(PINB, 0b00000001) && !TestBit(PINA, 0b00010000))
_0xFD:
	SBIC 0x16,0
	RJMP _0x104
	SBIS 0x19,4
	RJMP _0x105
_0x104:
	RJMP _0x103
_0x105:
;    {
;        if (edit_mode)
	SBRS R2,0
	RJMP _0x106
;        {
;            e_preview = 0;
	CLT
	BLD  R2,6
;            edit_mode = 0;
	RJMP _0x165
;        }
;        else
_0x106:
;            edit_mode = 1;
	SET
_0x165:
	BLD  R2,0
;//        return;
;    }
;//-----------------------Preview-----------------------------
;    if (!TestBit(PINA, 0b00100000))
_0x103:
	SBIC 0x19,5
	RJMP _0x108
;    {
;        if (!edit_mode)
	SBRC R2,0
	RJMP _0x109
;        {
;            if (ch_on)
	SBRS R2,4
	RJMP _0x10A
;            {
;                ch_on = 0;
	CLT
	BLD  R2,4
;                ch_speed = 1;
	SET
	BLD  R2,3
;                tmp_speed = scan_speed;
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	STS  _tmp_speed,R30
	STS  _tmp_speed+1,R31
;            }
;            else
	RJMP _0x10B
_0x10A:
;            {
;                ch_on = 1;
	SET
	BLD  R2,4
;                ch_speed = 1;
	BLD  R2,3
;                TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
;            }
_0x10B:
;        }
;        else
	RJMP _0x10C
_0x109:
;        {
;            if (e_preview)
	SBRS R2,6
	RJMP _0x10D
;                e_preview = 0;
	CLT
	RJMP _0x166
;            else
_0x10D:
;                e_preview = 1;
	SET
_0x166:
	BLD  R2,6
;        }
_0x10C:
;//        return;
;    }
;//-------------------------Save------------------------------
;    if (!TestBit(PINB, 0b00000010) && e_save && edit_mode)
_0x108:
	SBIC 0x16,1
	RJMP _0x110
	SBRS R2,5
	RJMP _0x110
	SBRC R2,0
	RJMP _0x111
_0x110:
	RJMP _0x10F
_0x111:
;    {
;        //сохраняем текущий OUT, т.к. он сокраняется только при изменении ITEM
;        if (e_out)
	LDS  R30,_e_out
	CPI  R30,0
	BREQ _0x112
;        {
;            e_out--;
	SUBI R30,LOW(1)
	STS  _e_out,R30
;            e_patt.out[e_item] = e_out & 0x07;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_e_out
	ANDI R30,LOW(0x7)
	ST   X,R30
;            if (e_out > 7)
	LDS  R26,_e_out
	CPI  R26,LOW(0x8)
	BRLO _0x113
;                e_patt.out[e_item] += 0x08;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(8)
	RJMP _0x167
;            else
_0x113:
;            e_patt.out[e_item] += 0x10;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(16)
_0x167:
	ST   X,R30
;        }
;        else
	RJMP _0x115
_0x112:
;            e_patt.out[e_item] = 0;
	__POINTW2MN _e_patt,1
	LDS  R30,_e_item
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
;        //запись в EEPROM
;        write_pattern(e_patt, e_preset);
_0x115:
	LDI  R30,LOW(_e_patt)
	LDI  R31,HIGH(_e_patt)
	LDI  R26,31
	CALL __PUTPARL
	LDS  R30,_e_preset
	ST   -Y,R30
	CALL _write_pattern
;        e_save = 0;
	CLT
	BLD  R2,5
;//        return;
;    }
;
;    lcd_out();
_0x10F:
	RCALL _lcd_out
;}
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
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00DF {
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
; 0000 00E0 // Place your code here
; 0000 00E1     encoder_main(PINA, 0b00000001, 0b00000010, PINA, 0b00000100, 0b00001000);
	IN   R30,0x19
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	IN   R30,0x19
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _encoder_main
; 0000 00E2 }
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
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00E6 {
_timer1_compa_isr:
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
; 0000 00E7 // Place your code here
; 0000 00E8     if (multiplexor)
	SBRS R2,2
	RJMP _0x116
; 0000 00E9         pwm_cnt--;
	LDS  R30,_pwm_cnt
	SUBI R30,LOW(1)
	RJMP _0x168
; 0000 00EA     else
_0x116:
; 0000 00EB         pwm_cnt++;
	LDS  R30,_pwm_cnt
	SUBI R30,-LOW(1)
_0x168:
	STS  _pwm_cnt,R30
; 0000 00EC 
; 0000 00ED     OCR2 = pwm_cnt;
	OUT  0x23,R30
; 0000 00EE 
; 0000 00EF     if (pwm_cnt > 0 && pwm_cnt < 0xFF)
	LDS  R26,_pwm_cnt
	CPI  R26,LOW(0x1)
	BRLO _0x119
	CPI  R26,LOW(0xFF)
	BRLO _0x11A
_0x119:
	RJMP _0x118
_0x11A:
; 0000 00F0         return;
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
; 0000 00F1 
; 0000 00F2     if (!edit_mode)
_0x118:
	SBRC R2,0
	RJMP _0x11B
; 0000 00F3     {
; 0000 00F4     if (ch_speed)
	SBRS R2,3
	RJMP _0x11C
; 0000 00F5     {
; 0000 00F6         if (!ch_on)
	SBRC R2,4
	RJMP _0x11D
; 0000 00F7             if (scan_speed <= max_speed)    scan_speed += dividor_speed;
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CPI  R26,LOW(0x9C41)
	LDI  R30,HIGH(0x9C41)
	CPC  R27,R30
	BRSH _0x11E
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	SUBI R30,LOW(-500)
	SBCI R31,HIGH(-500)
	STS  _scan_speed,R30
	STS  _scan_speed+1,R31
; 0000 00F8             else
	RJMP _0x11F
_0x11E:
; 0000 00F9             {
; 0000 00FA                 out = 0xFF;
	LDI  R30,LOW(255)
	STS  _out,R30
; 0000 00FB                 shift_out(out);
	ST   -Y,R30
	RCALL _shift_out
; 0000 00FC                 TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 00FD                 ch_speed = 0;
	CLT
	BLD  R2,3
; 0000 00FE                 return;
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
; 0000 00FF             }
_0x11F:
; 0000 0100         if (ch_on)
_0x11D:
	SBRS R2,4
	RJMP _0x120
; 0000 0101             if (scan_speed >= tmp_speed)    scan_speed -= dividor_speed;
	LDS  R30,_tmp_speed
	LDS  R31,_tmp_speed+1
	LDS  R26,_scan_speed
	LDS  R27,_scan_speed+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x121
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	SUBI R30,LOW(500)
	SBCI R31,HIGH(500)
	STS  _scan_speed,R30
	STS  _scan_speed+1,R31
; 0000 0102             else
	RJMP _0x122
_0x121:
; 0000 0103             {
; 0000 0104                 scan_speed = tmp_speed;
	LDS  R30,_tmp_speed
	LDS  R31,_tmp_speed+1
	STS  _scan_speed,R30
	STS  _scan_speed+1,R31
; 0000 0105                 ch_speed = 0;
	CLT
	BLD  R2,3
; 0000 0106 //                out = 0x10;
; 0000 0107             }
_0x122:
; 0000 0108     }
_0x120:
; 0000 0109     switch (scan_mode)
_0x11C:
	LDS  R30,_scan_mode
	LDI  R31,0
; 0000 010A     {
; 0000 010B         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x126
; 0000 010C             out = v1.out[scan_cnt];
	__POINTW1FN _v1,1
	MOVW R26,R30
	LDS  R30,_scan_cnt
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STS  _out,R0
; 0000 010D             scan_cnt++;
	LDS  R30,_scan_cnt
	SUBI R30,-LOW(1)
	STS  _scan_cnt,R30
; 0000 010E             if (scan_cnt >= v1.length)
	LDI  R30,LOW(_v1*2)
	LDI  R31,HIGH(_v1*2)
	LPM  R30,Z
	LDS  R26,_scan_cnt
	CP   R26,R30
	BRLO _0x127
; 0000 010F                 scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _scan_cnt,R30
; 0000 0110             break;
_0x127:
	RJMP _0x125
; 0000 0111         case 2:
_0x126:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x128
; 0000 0112             out = v2.out[scan_cnt];
	__POINTW1FN _v2,1
	MOVW R26,R30
	LDS  R30,_scan_cnt
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STS  _out,R0
; 0000 0113             scan_cnt++;
	LDS  R30,_scan_cnt
	SUBI R30,-LOW(1)
	STS  _scan_cnt,R30
; 0000 0114             if (scan_cnt >= v2.length)
	LDI  R30,LOW(_v2*2)
	LDI  R31,HIGH(_v2*2)
	LPM  R30,Z
	LDS  R26,_scan_cnt
	CP   R26,R30
	BRLO _0x129
; 0000 0115                 scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _scan_cnt,R30
; 0000 0116             break;
_0x129:
	RJMP _0x125
; 0000 0117         case 3:
_0x128:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0118             out = v3.out[scan_cnt];
	__POINTW1FN _v3,1
	MOVW R26,R30
	LDS  R30,_scan_cnt
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STS  _out,R0
; 0000 0119             scan_cnt++;
	LDS  R30,_scan_cnt
	SUBI R30,-LOW(1)
	STS  _scan_cnt,R30
; 0000 011A             if (scan_cnt >= v3.length)
	LDI  R30,LOW(_v3*2)
	LDI  R31,HIGH(_v3*2)
	LPM  R30,Z
	LDS  R26,_scan_cnt
	CP   R26,R30
	BRLO _0x12B
; 0000 011B                 scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _scan_cnt,R30
; 0000 011C             break;
_0x12B:
	RJMP _0x125
; 0000 011D         case 4:
_0x12A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x125
; 0000 011E             out = patt.out[scan_cnt];
	__POINTW2MN _patt,1
	LDS  R30,_scan_cnt
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  _out,R30
; 0000 011F             scan_cnt++;
	LDS  R30,_scan_cnt
	SUBI R30,-LOW(1)
	STS  _scan_cnt,R30
; 0000 0120             if (scan_cnt >= patt.length)
	LDS  R30,_patt
	LDS  R26,_scan_cnt
	CP   R26,R30
	BRLO _0x12D
; 0000 0121                 scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _scan_cnt,R30
; 0000 0122             break;
_0x12D:
; 0000 0123     }
_0x125:
; 0000 0124     }
; 0000 0125     else
	RJMP _0x12E
_0x11B:
; 0000 0126     if (e_preview)
	SBRS R2,6
	RJMP _0x12F
; 0000 0127     {
; 0000 0128         out = e_patt.out[scan_cnt];
	__POINTW2MN _e_patt,1
	LDS  R30,_scan_cnt
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  _out,R30
; 0000 0129         scan_cnt++;
	LDS  R30,_scan_cnt
	SUBI R30,-LOW(1)
	STS  _scan_cnt,R30
; 0000 012A         if (scan_cnt >= e_patt.length)
	LDS  R30,_e_patt
	LDS  R26,_scan_cnt
	CP   R26,R30
	BRLO _0x130
; 0000 012B             scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _scan_cnt,R30
; 0000 012C     }
_0x130:
; 0000 012D     else
	RJMP _0x131
_0x12F:
; 0000 012E         out = 0x10;
	LDI  R30,LOW(16)
	STS  _out,R30
; 0000 012F 
; 0000 0130     out  = out  & 0x0F;
_0x131:
_0x12E:
	LDS  R30,_out
	ANDI R30,LOW(0xF)
	STS  _out,R30
; 0000 0131 //    out2 = out2 & 0x0F;
; 0000 0132 
; 0000 0133     PORTB = 0b00000011 + (out << 4);
	SWAP R30
	ANDI R30,0xF0
	SUBI R30,-LOW(3)
	OUT  0x18,R30
; 0000 0134     if (multiplexor)
	SBRS R2,2
	RJMP _0x132
; 0000 0135     {
; 0000 0136         shift_out((out << 4) + out2);
	LDS  R30,_out
	SWAP R30
	ANDI R30,0xF0
	LDS  R26,_out2
	ADD  R30,R26
	ST   -Y,R30
	RCALL _shift_out
; 0000 0137         multiplexor = 0;
	CLT
	RJMP _0x169
; 0000 0138     }
; 0000 0139     else
_0x132:
; 0000 013A     {
; 0000 013B         shift_out((out2 << 4) + out);
	LDS  R30,_out2
	SWAP R30
	ANDI R30,0xF0
	LDS  R26,_out
	ADD  R30,R26
	ST   -Y,R30
	RCALL _shift_out
; 0000 013C         multiplexor = 1;
	SET
_0x169:
	BLD  R2,2
; 0000 013D     }
; 0000 013E //    PORTD = out << 3;
; 0000 013F     out2 = out;
	LDS  R30,_out
	STS  _out2,R30
; 0000 0140 
; 0000 0141     TCNT1 = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 0142 }
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
;// Declare your global variables here
;
;void main(void)
; 0000 0147 {
_main:
; 0000 0148 // Declare your local variables here
; 0000 0149 unsigned char i = 0;
; 0000 014A 
; 0000 014B // Declare your local variables here
; 0000 014C 
; 0000 014D // Input/Output Ports initialization
; 0000 014E // Port A initialization
; 0000 014F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0150 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0151 PORTA=0xC0;
;	i -> R17
	LDI  R17,0
	LDI  R30,LOW(192)
	OUT  0x1B,R30
; 0000 0152 DDRA=0xC0;
	OUT  0x1A,R30
; 0000 0153 
; 0000 0154 // Port B initialization
; 0000 0155 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0156 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0157 PORTB=0x03;
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 0158 DDRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0159 
; 0000 015A // Port C initialization
; 0000 015B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 015C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 015D PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 015E DDRC=0x00;
	OUT  0x14,R30
; 0000 015F 
; 0000 0160 // Port D initialization
; 0000 0161 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0162 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0163 PORTD=0x07;
	LDI  R30,LOW(7)
	OUT  0x12,R30
; 0000 0164 DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
; 0000 0165 
; 0000 0166 // Timer/Counter 0 initialization
; 0000 0167 // Clock source: System Clock
; 0000 0168 // Clock value: 187,500 kHz
; 0000 0169 // Mode: Normal top=FFh
; 0000 016A // OC0 output: Disconnected
; 0000 016B TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 016C TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 016D OCR0=0x00;
	OUT  0x3C,R30
; 0000 016E 
; 0000 016F // Timer/Counter 1 initialization
; 0000 0170 // Clock source: System Clock
; 0000 0171 // Clock value: 46,875 kHz
; 0000 0172 // Mode: CTC top=ICR1
; 0000 0173 // OC1A output: Discon.
; 0000 0174 // OC1B output: Discon.
; 0000 0175 // Noise Canceler: Off
; 0000 0176 // Input Capture on Falling Edge
; 0000 0177 // Timer1 Overflow Interrupt: On
; 0000 0178 // Input Capture Interrupt: Off
; 0000 0179 // Compare A Match Interrupt: Off
; 0000 017A // Compare B Match Interrupt: Off
; 0000 017B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 017C TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 017D TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 017E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 017F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0180 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0181 //OCR1AH=0xFF;
; 0000 0182 //OCR1AL=0xFF;
; 0000 0183 OCR1A = scan_speed;
	LDS  R30,_scan_speed
	LDS  R31,_scan_speed+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0184 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0185 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0186 
; 0000 0187 // Timer/Counter 2 initialization
; 0000 0188 // Clock source: System Clock
; 0000 0189 // Clock value: 1500,000 kHz
; 0000 018A // Mode: Phase correct PWM top=FFh
; 0000 018B // OC2 output: Non-Inverted PWM
; 0000 018C ASSR=0x00;
	OUT  0x22,R30
; 0000 018D TCCR2=0x61;
	LDI  R30,LOW(97)
	OUT  0x25,R30
; 0000 018E TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 018F OCR2=0xFF;
	LDI  R30,LOW(255)
	OUT  0x23,R30
; 0000 0190 
; 0000 0191 // External Interrupt(s) initialization
; 0000 0192 // INT0: On
; 0000 0193 // INT0 Mode: Falling Edge
; 0000 0194 // INT1: Off
; 0000 0195 // INT2: Off
; 0000 0196 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0197 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 0198 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0199 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 019A 
; 0000 019B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 019C TIMSK=0x11;
	LDI  R30,LOW(17)
	OUT  0x39,R30
; 0000 019D 
; 0000 019E // Analog Comparator initialization
; 0000 019F // Analog Comparator: Off
; 0000 01A0 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01A1 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01A2 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01A3 
; 0000 01A4 // LCD module initialization
; 0000 01A5 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01A6 
; 0000 01A7 for (i = 0; i < 8; i++)
	LDI  R17,LOW(0)
_0x135:
	CPI  R17,8
	BRSH _0x136
; 0000 01A8 {
; 0000 01A9     lcd_write_byte(0x40 + i, arrow_left[i]);
	MOV  R30,R17
	SUBI R30,-LOW(64)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrow_left*2)
	SBCI R31,HIGH(-_arrow_left*2)
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
; 0000 01AA }
	SUBI R17,-1
	RJMP _0x135
_0x136:
; 0000 01AB 
; 0000 01AC for (i = 0; i < 8; i++)
	LDI  R17,LOW(0)
_0x138:
	CPI  R17,8
	BRSH _0x139
; 0000 01AD {
; 0000 01AE     lcd_write_byte(0x40 + 0x08 + i, arrow_right[i]);
	MOV  R30,R17
	SUBI R30,-LOW(72)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_arrow_right*2)
	SBCI R31,HIGH(-_arrow_right*2)
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
; 0000 01AF }
	SUBI R17,-1
	RJMP _0x138
_0x139:
; 0000 01B0 
; 0000 01B1 // I2C Bus initialization
; 0000 01B2 i2c_init();
	CALL _i2c_init
; 0000 01B3 
; 0000 01B4 lcd_clear();
	CALL _lcd_clear
; 0000 01B5 lcd_puts(" Hammond Organ  ");
	__POINTW1MN _0x13A,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01B6 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01B7 
; 0000 01B8 lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01B9 lcd_puts(" Vibrato/Chorus ");
	__POINTW1MN _0x13A,17
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01BA delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01BB 
; 0000 01BC lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01BD lcd_puts("Digital Scanner ");
	__POINTW1MN _0x13A,34
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01BE delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01BF 
; 0000 01C0 lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01C1 lcd_puts("      by        ");
	__POINTW1MN _0x13A,51
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01C2 delay_ms(700);
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01C3 
; 0000 01C4 lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01C5 lcd_puts(" Rinon Ninqueon ");
	__POINTW1MN _0x13A,68
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01C6 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01C7 
; 0000 01C8 delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01C9 
; 0000 01CA if (init_check())
	CALL _init_check
	CPI  R30,0
	BREQ _0x13B
; 0000 01CB     zero_init();
	CALL _zero_init
; 0000 01CC 
; 0000 01CD #asm("sei")
_0x13B:
	sei
; 0000 01CE 
; 0000 01CF patt = read_pattern(current_pattern);
	ST   -Y,R7
	CALL _read_pattern
	LDI  R26,LOW(_patt)
	LDI  R27,HIGH(_patt)
	CALL __COPYMML
	OUT  SREG,R1
; 0000 01D0 
; 0000 01D1 lcd_out();
	RCALL _lcd_out
; 0000 01D2 
; 0000 01D3 while (1)
_0x13C:
; 0000 01D4     {
; 0000 01D5         if (dir1 != 1)               //обработка энкодера 1
	LDS  R26,_dir1
	CPI  R26,LOW(0x1)
	BREQ _0x13F
; 0000 01D6         {
; 0000 01D7             if (dir1 == 0)
	LDS  R30,_dir1
	CPI  R30,0
	BRNE _0x140
; 0000 01D8             {
; 0000 01D9                 if (dir_cnt1 == 0)
	LDS  R30,_dir_cnt1
	CPI  R30,0
	BRNE _0x141
; 0000 01DA                 {
; 0000 01DB                     dir_cnt1 = _dir_cnt;
	LDI  R30,LOW(4)
	STS  _dir_cnt1,R30
; 0000 01DC                     ClrBit(PORTA, 0b01000000);
	CBI  0x1B,6
; 0000 01DD                     enc1 = 0;
	LDI  R30,LOW(0)
	STS  _enc1,R30
; 0000 01DE                 }
; 0000 01DF                 dir_cnt1--;
_0x141:
	LDS  R30,_dir_cnt1
	SUBI R30,LOW(1)
	RJMP _0x16A
; 0000 01E0             }
; 0000 01E1             else
_0x140:
; 0000 01E2             {
; 0000 01E3                 if (dir_cnt1 == _dir_cnt2)
	LDS  R26,_dir_cnt1
	CPI  R26,LOW(0x8)
	BRNE _0x143
; 0000 01E4                 {
; 0000 01E5                     dir_cnt1 = _dir_cnt;
	LDI  R30,LOW(4)
	STS  _dir_cnt1,R30
; 0000 01E6                     ClrBit(PORTA, 0b01000000);
	CBI  0x1B,6
; 0000 01E7                     enc1 = 1;
	LDI  R30,LOW(1)
	STS  _enc1,R30
; 0000 01E8                 }
; 0000 01E9                 dir_cnt1++;
_0x143:
	LDS  R30,_dir_cnt1
	SUBI R30,-LOW(1)
_0x16A:
	STS  _dir_cnt1,R30
; 0000 01EA             }
; 0000 01EB 
; 0000 01EC             dir1 = 1;
	LDI  R30,LOW(1)
	STS  _dir1,R30
; 0000 01ED         }
; 0000 01EE 
; 0000 01EF         if (dir2 != 1)               //обработка энкодера 2
_0x13F:
	LDS  R26,_dir2
	CPI  R26,LOW(0x1)
	BREQ _0x144
; 0000 01F0         {
; 0000 01F1             if (dir2 == 0)
	LDS  R30,_dir2
	CPI  R30,0
	BRNE _0x145
; 0000 01F2             {
; 0000 01F3                 if (dir_cnt2 == 0)
	LDS  R30,_dir_cnt2
	CPI  R30,0
	BRNE _0x146
; 0000 01F4                 {
; 0000 01F5                     dir_cnt2 = _dir_cnt;
	LDI  R30,LOW(4)
	STS  _dir_cnt2,R30
; 0000 01F6                     ClrBit(PORTA, 0b10000000);
	CBI  0x1B,7
; 0000 01F7                     enc2 = 0;
	LDI  R30,LOW(0)
	STS  _enc2,R30
; 0000 01F8                 }
; 0000 01F9                 dir_cnt2--;
_0x146:
	LDS  R30,_dir_cnt2
	SUBI R30,LOW(1)
	RJMP _0x16B
; 0000 01FA             }
; 0000 01FB             else
_0x145:
; 0000 01FC             {
; 0000 01FD                 if (dir_cnt2 == _dir_cnt2)
	LDS  R26,_dir_cnt2
	CPI  R26,LOW(0x8)
	BRNE _0x148
; 0000 01FE                 {
; 0000 01FF                     dir_cnt2 = _dir_cnt;
	LDI  R30,LOW(4)
	STS  _dir_cnt2,R30
; 0000 0200                     ClrBit(PORTA, 0b10000000);
	CBI  0x1B,7
; 0000 0201                     enc2 = 1;
	LDI  R30,LOW(1)
	STS  _enc2,R30
; 0000 0202                 }
; 0000 0203                 dir_cnt2++;
_0x148:
	LDS  R30,_dir_cnt2
	SUBI R30,-LOW(1)
_0x16B:
	STS  _dir_cnt2,R30
; 0000 0204             }
; 0000 0205 
; 0000 0206             dir2 = 1;
	LDI  R30,LOW(1)
	STS  _dir2,R30
; 0000 0207         }
; 0000 0208         if (TestBit(PINC, 0x08))
_0x144:
	SBIS 0x13,3
	RJMP _0x149
; 0000 0209         {
; 0000 020A             if (!chorus)
	SBRC R2,1
	RJMP _0x14A
; 0000 020B             {
; 0000 020C                 chorus = 1;
	SET
	BLD  R2,1
; 0000 020D                 lcd_out();
	RCALL _lcd_out
; 0000 020E             }
; 0000 020F         }
_0x14A:
; 0000 0210         else
	RJMP _0x14B
_0x149:
; 0000 0211             if (chorus)
	SBRS R2,1
	RJMP _0x14C
; 0000 0212             {
; 0000 0213                 chorus = 0;
	CLT
	BLD  R2,1
; 0000 0214                 lcd_out();
	RCALL _lcd_out
; 0000 0215             }
; 0000 0216     };
_0x14C:
_0x14B:
	RJMP _0x13C
; 0000 0217 }
_0x14D:
	RJMP _0x14D

	.DSEG
_0x13A:
	.BYTE 0x55
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
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
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
	JMP  _0x2080001
_lcd_write_byte:
	CALL __lcd_ready
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL __lcd_write_data
	CALL __lcd_ready
    sbi   __lcd_port,__lcd_rs     ;RS=1
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	RJMP _0x2080002
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080002:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
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
	JMP  _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
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
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
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
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
	LDI  R30,LOW(133)
	ST   -Y,R30
	CALL __lcd_write_data
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2080001:
	ADIW R28,1
	RET
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_j:
	.BYTE 0x1
_t_preset:
	.BYTE 0x7
_t_item:
	.BYTE 0x5
_dir1:
	.BYTE 0x1
_dir2:
	.BYTE 0x1
_dir_cnt1:
	.BYTE 0x1
_dir_cnt2:
	.BYTE 0x1
_e11:
	.BYTE 0x1
_e12:
	.BYTE 0x1
_e21:
	.BYTE 0x1
_e22:
	.BYTE 0x1
_enc1:
	.BYTE 0x1
_enc2:
	.BYTE 0x1
_pwm_cnt:
	.BYTE 0x1
_scan_mode:
	.BYTE 0x1
_last_mode:
	.BYTE 0x1
_scan_cnt:
	.BYTE 0x1
_scan_speed:
	.BYTE 0x2
_tmp_speed:
	.BYTE 0x2
_out:
	.BYTE 0x1
_out2:
	.BYTE 0x1
_e_preset:
	.BYTE 0x1
_e_item:
	.BYTE 0x1
_e_out:
	.BYTE 0x1
_e_mode:
	.BYTE 0x1
_e_patt:
	.BYTE 0x1F
_patt:
	.BYTE 0x1F
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG

	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,20
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,40
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
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

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
	RET

;END OF CODE MARKER
__END_OF_CODE:
