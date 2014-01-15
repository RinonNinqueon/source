
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _i=R11
	.DEF _j=R10
	.DEF _k=R13
	.DEF _okt=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x14:
	.DB  0x55,0x70,0x70,0x65,0x72,0x20,0x6D,0x61
	.DB  0x6E,0x75,0x61,0x6C
_0x27:
	.DB  0x1,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x0A
	.DW  _0x27*2

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
;Date    : 27.06.2013
;Author  : NeVaDa
;Company : SBE Software
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#define SetBit(x,y) (x|=y)
;#define ClrBit(x,y) (x&=~y)
;#define TestBit(x,y) (x&y)
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
;#include <delay.h>
;#include "midi.c"
;#define SYSEX        0xf0
;#define SYSCOMUNDEF     0xf1
;#define SYSCOMSONGPOS   0xf2
;#define SYSCOMSONGSEL   0xf3
;#define SYSCOMUNDEF1 0xf4
;#define SYSCOMUNDEF2 0xf5
;#define SYSCOMTUNEREQ   0xf6
;#define SYSEXEND     0xf7
;#define SYSRTCLOCK      0xf8
;#define SYSRTUNDEF      0xf9
;#define SYSRTSTART      0xfa
;#define SYSRTCONTINUE   0xfb
;#define SYSRTSTOP    0xfc
;#define SYSRTUNDEF1     0xfd
;#define SYSRTACTIVESEN  0xfe
;#define SYSRTRESET      0xff
;#define NOTEON 0x90
;#define NOTEOFF   0x80
;#define NOTEPRES  0xa0     //note pressure
;#define CHANPRES  0xb0     //channel pressure
;#define CONTROL   0xd0        //control change
;#define WHEEL  0xe0        //pitch wheel change
;#define PATCH  0xc0        //patch change
;#define MIDI_CLOCK   0x80
;#define MIDI_START   0x40
;#define MIDI_RESET   0x20
;#define MIDI_GATE 0x01
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 001E {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;char status,data;
;status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
;data=UDR;
	IN   R16,12
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;   {
;   rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;   if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
;      {
;      rx_counter=0;
	CLR  R7
;      rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      };
_0x5:
;   };
_0x3:
;}
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
_getchar:
;char data;
;while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
;data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
;if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
;#asm("cli")
_0x9:
	cli
;--rx_counter;
	DEC  R7
;#asm("sei")
	sei
;return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
;}
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
;{
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;if (tx_counter)
	TST  R8
	BREQ _0xA
;   {
;   --tx_counter;
	DEC  R8
;   UDR=tx_buffer[tx_rd_index];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
;   };
_0xB:
_0xA:
;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
;{
;while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
;#asm("cli")
;if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
;   {
;   tx_buffer[tx_wr_index]=c;
;   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
;   ++tx_counter;
;   }
;else
;   UDR=c;
;#asm("sei")
;}
;#pragma used-
;#endif
;
;//3,4,5
;#define port_sh PORTA
;#define pin_sh  0x02
;#define pin_st  0x04
;#define pin_d   0x01
;
;unsigned char i = 0, j = 1, k = 0;
;char okt = 0;
;unsigned char chn = 0;
;//unsigned char split = 0;
;//unsigned char split_is = 0;
;unsigned char str_okt[16];
;unsigned char str_manual[] = "Upper manual";

	.DSEG
;unsigned char last = 0;
;unsigned char _ports[6];
;
;void shift_out(unsigned char data, unsigned char channel)
; 0000 0031 {

	.CSEG
_shift_out:
; 0000 0032 	ClrBit(port_sh, pin_st << channel);
;	data -> Y+1
;	channel -> Y+0
	IN   R1,27
	LD   R30,Y
	LDI  R26,LOW(251)
	CALL __LSLB12
	AND  R30,R1
	OUT  0x1B,R30
; 0000 0033     ClrBit(port_sh, pin_sh);
	CBI  0x1B,1
; 0000 0034 
; 0000 0035     delay_us(1000);
	__DELAY_USW 4000
; 0000 0036 
; 0000 0037 	for(i = 0; i < 8; i++)
	CLR  R11
_0x16:
	LDI  R30,LOW(8)
	CP   R11,R30
	BRSH _0x17
; 0000 0038 	{
; 0000 0039 		if(data & 0x80)
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x18
; 0000 003A 			SetBit(port_sh, pin_d);
	SBI  0x1B,0
; 0000 003B 		else
	RJMP _0x19
_0x18:
; 0000 003C 			ClrBit(port_sh, pin_d);
	CBI  0x1B,0
; 0000 003D 
; 0000 003E 		delay_us(1000);
_0x19:
	__DELAY_USW 4000
; 0000 003F 		SetBit(port_sh, pin_sh);
	SBI  0x1B,1
; 0000 0040 
; 0000 0041 		delay_us(1000);
	__DELAY_USW 4000
; 0000 0042 		ClrBit(port_sh, pin_sh);
	CBI  0x1B,1
; 0000 0043 		data <<= 1;
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0000 0044 	}
	INC  R11
	RJMP _0x16
_0x17:
; 0000 0045     SetBit(port_sh, pin_st << channel);
	IN   R1,27
	LD   R30,Y
	LDI  R26,LOW(4)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x1B,R30
; 0000 0046 }
	ADIW R28,2
	RET
;
;// Declare your global variables here
;
;void main(void)
; 0000 004B {
_main:
; 0000 004C // Declare your local variables here
; 0000 004D     char c;
; 0000 004E    char cmd;
; 0000 004F    char chan;
; 0000 0050    unsigned char n_addr = 0b01000000;
; 0000 0051    unsigned char n_bit =  0b00001001;
; 0000 0052    unsigned char n_on = 0, n_off = 0;
; 0000 0053    _ports[0] = 0x00;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	c -> R17
;	cmd -> R16
;	chan -> R19
;	n_addr -> R18
;	n_bit -> R21
;	n_on -> R20
;	n_off -> Y+0
	LDI  R18,64
	LDI  R21,9
	LDI  R20,0
	STS  __ports,R30
; 0000 0054    _ports[1] = 0x00;
	__PUTB1MN __ports,1
; 0000 0055    _ports[2] = 0x00;
	__PUTB1MN __ports,2
; 0000 0056    _ports[3] = 0x00;
	__PUTB1MN __ports,3
; 0000 0057    _ports[4] = 0x00;
	__PUTB1MN __ports,4
; 0000 0058    _ports[5] = 0x00;
	__PUTB1MN __ports,5
; 0000 0059 
; 0000 005A // Input/Output Ports initialization
; 0000 005B // Port A initialization
; 0000 005C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 005D // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 005E PORTA=0x00;
	OUT  0x1B,R30
; 0000 005F DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0060 
; 0000 0061 // Port B initialization
; 0000 0062 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0063 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0064 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0065 DDRB=0x00;
	OUT  0x17,R30
; 0000 0066 
; 0000 0067 // Port C initialization
; 0000 0068 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0069 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006A PORTC=0x00;
	OUT  0x15,R30
; 0000 006B DDRC=0x00;
	OUT  0x14,R30
; 0000 006C 
; 0000 006D // Port D initialization
; 0000 006E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 006F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0070 PORTD=0x00;
	OUT  0x12,R30
; 0000 0071 DDRD=0x00;
	OUT  0x11,R30
; 0000 0072 
; 0000 0073 // Timer/Counter 0 initialization
; 0000 0074 // Clock source: System Clock
; 0000 0075 // Clock value: Timer 0 Stopped
; 0000 0076 // Mode: Normal top=FFh
; 0000 0077 // OC0 output: Disconnected
; 0000 0078 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0079 TCNT0=0x00;
	OUT  0x32,R30
; 0000 007A OCR0=0x00;
	OUT  0x3C,R30
; 0000 007B 
; 0000 007C // Timer/Counter 1 initialization
; 0000 007D // Clock source: System Clock
; 0000 007E // Clock value: Timer1 Stopped
; 0000 007F // Mode: Normal top=FFFFh
; 0000 0080 // OC1A output: Discon.
; 0000 0081 // OC1B output: Discon.
; 0000 0082 // Noise Canceler: Off
; 0000 0083 // Input Capture on Falling Edge
; 0000 0084 // Timer1 Overflow Interrupt: Off
; 0000 0085 // Input Capture Interrupt: Off
; 0000 0086 // Compare A Match Interrupt: Off
; 0000 0087 // Compare B Match Interrupt: Off
; 0000 0088 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0089 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 008A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 008B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008C ICR1H=0x00;
	OUT  0x27,R30
; 0000 008D ICR1L=0x00;
	OUT  0x26,R30
; 0000 008E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0090 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0091 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0092 
; 0000 0093 // Timer/Counter 2 initialization
; 0000 0094 // Clock source: System Clock
; 0000 0095 // Clock value: Timer2 Stopped
; 0000 0096 // Mode: Normal top=FFh
; 0000 0097 // OC2 output: Disconnected
; 0000 0098 ASSR=0x00;
	OUT  0x22,R30
; 0000 0099 TCCR2=0x00;
	OUT  0x25,R30
; 0000 009A TCNT2=0x00;
	OUT  0x24,R30
; 0000 009B OCR2=0x00;
	OUT  0x23,R30
; 0000 009C 
; 0000 009D // External Interrupt(s) initialization
; 0000 009E // INT0: Off
; 0000 009F // INT1: Off
; 0000 00A0 // INT2: Off
; 0000 00A1 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00A2 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00A3 
; 0000 00A4 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A5 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00A6 
; 0000 00A7 // USART initialization
; 0000 00A8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00A9 // USART Receiver: On
; 0000 00AA // USART Transmitter: On
; 0000 00AB // USART Mode: Asynchronous
; 0000 00AC // USART Baud Rate: 38400
; 0000 00AD UCSRA=0x00;
	OUT  0xB,R30
; 0000 00AE UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 00AF UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00B0 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00B1 //UBRRL=0x1F;
; 0000 00B2 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
; 0000 00B3 
; 0000 00B4 // Analog Comparator initialization
; 0000 00B5 // Analog Comparator: Off
; 0000 00B6 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B8 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B9 
; 0000 00BA #asm("sei")
	sei
; 0000 00BB 
; 0000 00BC while (1)
_0x1A:
; 0000 00BD       {
; 0000 00BE         c = getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 00BF //        n_bit = 0;
; 0000 00C0         if(c & 0x80)  //is it a command?
	SBRS R17,7
	RJMP _0x1D
; 0000 00C1         {
; 0000 00C2             if(c < 0xf0)
	CPI  R17,240
	BRSH _0x1E
; 0000 00C3              {
; 0000 00C4                 //process this stuff, dispose of everything else
; 0000 00C5                 cmd = (char)(c & 0xf0);
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	MOV  R16,R30
; 0000 00C6                 chan = (char)(c & 0x0f);
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R19,R30
; 0000 00C7              }
; 0000 00C8         }
_0x1E:
; 0000 00C9         else
	RJMP _0x1F
_0x1D:
; 0000 00CA         {
; 0000 00CB /*            if (split_is && c < split)
; 0000 00CC             {
; 0000 00CD                 if (last != cmd | chan)
; 0000 00CE                     putchar(cmd | chan);
; 0000 00CF                 putchar(c);
; 0000 00D0                 c = getchar();
; 0000 00D1                 putchar(c);
; 0000 00D2                 last = cmd | chan;
; 0000 00D3                 continue;
; 0000 00D4             }
; 0000 00D5 */
; 0000 00D6 //            if (chan == chn)
; 0000 00D7             {
; 0000 00D8 //                char diff = (okt - 2) * 12;
; 0000 00D9 //                if (c + diff >= 0)
; 0000 00DA                 {
; 0000 00DB //                    c += (okt - 2) * 12;
; 0000 00DC                     n_addr = (c - 0x18) / 8;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,24
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	MOV  R18,R30
; 0000 00DD 
; 0000 00DE                     n_bit = 1 << ((c-0x18) % 8);
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,24
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R21,R30
; 0000 00DF                     if (n_addr < 6)
	CPI  R18,6
	BRSH _0x20
; 0000 00E0                      switch (cmd)
	MOV  R30,R16
	LDI  R31,0
; 0000 00E1                      {
; 0000 00E2                         case NOTEOFF:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x24
; 0000 00E3                             ClrBit(_ports[n_addr], n_bit);
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-__ports)
	SBCI R31,HIGH(-__ports)
	MOVW R0,R30
	LD   R26,Z
	MOV  R30,R21
	COM  R30
	AND  R30,R26
	MOVW R26,R0
	ST   X,R30
; 0000 00E4                             shift_out(_ports[n_addr], n_addr);
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-__ports)
	SBCI R31,HIGH(-__ports)
	LD   R30,Z
	ST   -Y,R30
	ST   -Y,R18
	RCALL _shift_out
; 0000 00E5                             n_off = c;
	__PUTBSR 17,0
; 0000 00E6                             break;
	RJMP _0x23
; 0000 00E7 
; 0000 00E8                         case NOTEON:
_0x24:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0x23
; 0000 00E9                             SetBit(_ports[n_addr], n_bit);
	MOV  R26,R18
	LDI  R27,0
	SUBI R26,LOW(-__ports)
	SBCI R27,HIGH(-__ports)
	LD   R30,X
	OR   R30,R21
	ST   X,R30
; 0000 00EA                             shift_out(_ports[n_addr], n_addr);
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-__ports)
	SBCI R31,HIGH(-__ports)
	LD   R30,Z
	ST   -Y,R30
	ST   -Y,R18
	RCALL _shift_out
; 0000 00EB                             n_on = c;
	MOV  R20,R17
; 0000 00EC                             break;
; 0000 00ED 
; 0000 00EE /*                        case CHANPRES:
; 0000 00EF                             write_reg(0b01000000, OLAT, all_notes_off);
; 0000 00F0                             write_reg(0b01000010, OLAT, all_notes_off);
; 0000 00F1                             write_reg(0b01000100, OLAT, all_notes_off);
; 0000 00F2                             write_reg(0b01000110, OLAT, all_notes_off);
; 0000 00F3                             write_reg(0b01001000, OLAT, all_notes_off);
; 0000 00F4                             write_reg(0b01001010, OLAT, all_notes_off);
; 0000 00F5                             write_reg(0b01001100, OLAT, all_notes_off);
; 0000 00F6                             write_reg(0b01001110, OLAT, all_notes_off);
; 0000 00F7                             break;*/
; 0000 00F8                      }
_0x23:
; 0000 00F9         //             sprintf(str_on, "Note on:\t%i\n", n_on);
; 0000 00FA         //             sprintf(str_off, "Note off:\t%i\n", n_off);
; 0000 00FB         //
; 0000 00FC         //             lcd_clear();
; 0000 00FD         //             lcd_puts(str_on);
; 0000 00FE         //             lcd_puts(str_off);
; 0000 00FF                      c = getchar();
_0x20:
	RCALL _getchar
	MOV  R17,R30
; 0000 0100                   }
; 0000 0101             }
; 0000 0102           }
_0x1F:
; 0000 0103       // Place your code here
; 0000 0104 /*        shift_out(j, k);
; 0000 0105 
; 0000 0106         if (j == 0x80)
; 0000 0107         {
; 0000 0108             delay_ms(100);
; 0000 0109             shift_out(0, k);
; 0000 010A             j = 1;
; 0000 010B             k++;
; 0000 010C             if (k > 5)
; 0000 010D                 k = 0;
; 0000 010E         }
; 0000 010F         else
; 0000 0110         {
; 0000 0111             j <<= 1;
; 0000 0112             delay_ms(100);
; 0000 0113         }     */
; 0000 0114       };
	RJMP _0x1A
; 0000 0115 }
_0x26:
	RJMP _0x26

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
__ports:
	.BYTE 0x6

	.CSEG

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

;END OF CODE MARKER
__END_OF_CODE:
