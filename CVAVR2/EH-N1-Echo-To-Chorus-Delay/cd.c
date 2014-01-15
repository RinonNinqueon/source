/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 07.04.2013
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#define SetBit(x,y) (x|=y)
#define ClrBit(x,y) (x&=~y)
#define TestBit(x,y) (x&y)

#define D_LEFT	0
#define D_NONE	1
#define D_RIGHT	2

#define p_c 0b00000001
#define p_d 0b00000010
#define p_r	0b00000100
#define p_l	0b00001000
#define p_e 0b00010000
#define enc	PIND

/*-------SPI------*/

#define nSS			3
#define SDI 		5
#define	SCK			6
			
#define	SPI_PORT	PORTD

#define HI(x) SPI_PORT |= (1<<(x))
#define LO(x) SPI_PORT &= ~(1<<(x))

#define max_depth 0x0F
#define max_speed 0xFF
#define min_speed 0x05
#define max_time  0xFF

//unsigned char ch_dir = 1;
unsigned char dp_cnt = 0;
unsigned char time = 0x7F;
unsigned char ch_depth = 0x19, ch_speed = 0xFF;
unsigned char lock0 = 0;
unsigned char main_menu = 0;
unsigned char max_menu = 0;
unsigned char i, j, val1, val2, val3, e1 = 0, e2 = 0, dir = 1, ch_on = 0;

//unsigned char text_speed[]  = "Ch.Speed";

void inline chorus_on(void)
{
	dp_cnt = ch_depth;
	SetBit(lock0, 0x04);
	SetBit(TCCR1B, 0x0B);
//	TCCR0B=0x09;
	max_menu = 2;               
    ch_on = 1;
}

void inline chorus_off(void)
{
	ClrBit(TCCR1B, 0x0B);
    ch_on = 0;
	if (main_menu > max_menu)
	{
		max_menu = 0;
		main_menu = 0;
	}
}

void setRes(unsigned char cmd2)
{
	unsigned char cmd1 = 0b00010001;

	LO(SCK);
	delay_us(1);
	PORTB &= ~(1<<(nSS));
	delay_us(1);

	for(i = 0; i < 8; i++)
	{
		if(cmd1 & 0x80)
			HI(SDI);
		else
			LO(SDI);
			
		delay_us(1);
		HI(SCK);

		delay_us(1);
		LO(SCK);
		cmd1 <<= 1;
	}

	
	for(i = 0; i < 8; i++)
	{
		if(cmd2 & 0x80)
			HI(SDI);
		else
			LO(SDI);
			
		delay_us(1);
		HI(SCK);

		delay_us(1);
		LO(SCK);
		cmd2 <<= 1;
	}

	delay_us(1);
	PORTB |= (1<<(nSS));
}

void LCDWriteInt(unsigned char val)
{
	/***************************************************************
	This function writes a integer type value to LCD module

	Arguments:
	1)unsigned char val	: Value to print

	2)unsigned char field_length :total length of field in which the value is printed
	must be between 1-3 if it is -1 the field length is no of digits in the val

	****************************************************************/
//	unsigned char str[3];
    
    j = 0;    
    i = 2;          
    
    val1 = val % 10;
    val2 = (val / 10) % 10;
    val3 = (val / 100) % 10; 
    
//	while(val1)
//	{
//		str[i] = val1 % 10;
//		val1 = val1 / 10;
//		i--;
//	}
	
//	j = 3 - field_length;

//    if (val > 100)
        lcd_putchar(48 + val3);
//    if (val > 10)
        lcd_putchar(48 + val2);
    lcd_putchar(48 + val1);	
	
//    for(i = j; i < 3; i++)
//		lcd_putchar(48 + str[i]);
}

void lcd_out(void)
{
    lcd_clear();
	
	lcd_puts("Time");
	if (main_menu == 0)
		lcd_putchar('>');
	if (main_menu == 1)
		lcd_putchar('<');
	if (main_menu == 2)
		lcd_putchar(' ');
		
	
	if (ch_on)
	{
		lcd_puts("Speed");
		
		if (main_menu == 0)
			lcd_putchar(' ');
		if (main_menu == 1)
			lcd_putchar('>');
		if (main_menu == 2)
			lcd_putchar('<');
		
		lcd_puts("Depth");
		
	}
	
	lcd_gotoxy(0, 1);
	
	if (time > 0 && TestBit(lock0, 0x08) && main_menu == 0)			lcd_putchar('<');	else	lcd_putchar(' ');
	LCDWriteInt(time);
	if (time < max_time && TestBit(lock0, 0x08) && main_menu == 0)	lcd_putchar('>');	else	lcd_putchar(' ');
	
	lcd_putchar(' ');
	
	if (ch_on)
	{
		if (ch_speed > 0 && TestBit(lock0, 0x08) && main_menu == 1)			lcd_putchar('<');	else	lcd_putchar(' ');
		LCDWriteInt(ch_speed);
		if (ch_speed < max_speed && TestBit(lock0, 0x08) && main_menu == 1)	lcd_putchar('>');	else	lcd_putchar(' ');
		
		lcd_putchar(' ');
		
		if (ch_depth > 0 && TestBit(lock0, 0x08) && main_menu == 2)			lcd_putchar('<');	else	lcd_putchar(' ');
		LCDWriteInt(ch_depth);
		if (ch_depth < max_depth && TestBit(lock0, 0x08) && main_menu == 2)	lcd_putchar('>');	else	lcd_putchar(' ');
	}
}

// External Interrupt 0 service routine
//interrupt [EXT_INT0] void ext_int0_isr(void)
//{
// Place your code here
//    if (TestBit(enc, p_l))
//        dir = 2;
//    else
//        dir = 0;
//    if (e2 < 2)
//        e1++;
//    else        
//    {
//        dir = 2;
//        e1 = 0;
//        e2 = 0;
//    }
//}

// External Interrupt 1 service routine
//interrupt [EXT_INT1] void ext_int1_isr(void)
//{
// Place your code here
//	if (e1 < 2)
//        e2++;
//    else        
//    {
//        dir = 0;
//        e1 = 0;
//        e2 = 0;
//    }
//}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    if (TestBit(enc, p_r) && TestBit(enc, p_l))
        e1 = 0;
    if (!TestBit(enc, p_r) && TestBit(enc, p_l))
        e1 = 1;
    if (!TestBit(enc, p_r) && !TestBit(enc, p_l))
        e1 = 2;
    if (TestBit(enc, p_r) && !TestBit(enc, p_l))
        e1 = 3;
    
    switch (e2)
    {
        case 0: if (e1 == 1)
                    dir = 0;
                if (e1 == 3)
                    dir = 2;
                break;
        case 1: if (e1 == 2)
                    dir = 0;
                if (e1 == 0)
                    dir = 2;
                break;
        case 2: if (e1 == 3)
                    dir = 0;
                if (e1 == 1)
                    dir = 2;
                break;
        case 3: if (e1 == 0)
                    dir = 0;
                if (e1 == 2)
                    dir = 2;
                break;
    }
    
    e2 = e1;
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
	if (TestBit(lock0, 0x04))
		dp_cnt++;
	else
		dp_cnt--;
	
	if (dp_cnt == ch_depth * 2)
			ClrBit(lock0, 0x04);
	if (dp_cnt == 0)
			SetBit(lock0, 0x04);
			
	setRes(time + dp_cnt - ch_depth);
	
//	if (!TestBit(PINB, 8))
//		SetBit(PORTB, 8);
//	else
//		ClrBit(PORTB, 8);
}

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=1 State2=0 State1=0 State0=0 
PORTB=0x08;
DDRB=0xFF;

// Port D initialization
// Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=0 State5=0 State4=P State3=P State2=P State1=P State0=P 
PORTD=0x00;
DDRD=0x60;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x02;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1A=0x0FF0;
//OCR1AL=0xFF;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
//GIMSK=0x40;
//MCUCR=0x02;
//EIFR=0x40;

GIMSK=0x00;
MCUCR=0x00;
EIFR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x42;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// LCD module initialization
lcd_init(16);

delay_ms(100);

lcd_out();
// Global enable interrupts
#asm("sei")

setRes(time);

while (1)
{
    if (dir != 1)
    {
        if (TestBit(lock0, 0x08))
		{
			switch (main_menu)
			{
				case 0:      
                    if (dir == 0)           
                    {
					    if (time > ch_depth)
    						time--;
                    }
                    else
                        if (time < 0xFF - ch_depth)
						    time++;
    				setRes(time);
					break;
				case 1:
                    if (dir == 0)           
                    {
					    if (ch_speed > min_speed)
    						ch_speed--;   
                    }
                    else
                        if (ch_speed < max_speed)
						    ch_speed++;   
                    OCR1A = (unsigned int)ch_speed << 4;
					break;
				case 2:
                    if (dir == 0)           
                    {
					    if (ch_depth > 0)
    						ch_depth--;
                    }
                    else
                        if (ch_depth < max_depth)
						    ch_depth++;
					break;
			};
		}
		else  
        {
            if (dir == 0)           
            {
    			if (main_menu > 0)
    				main_menu--;
    			else
    				main_menu = max_menu;
            }
            else
				if (main_menu < max_menu)
					main_menu++;
				else
					main_menu = 0;
        }  
        dir = 1;
		lcd_out();
    }    
    
	if (!TestBit(enc, p_c))
	{
		if (!TestBit(lock0, 0x01))
		{
			SetBit(lock0, 0x01);
			if (ch_on)
                chorus_off();
			else
                chorus_on();
			lcd_out();
		}
	}
	else
		ClrBit(lock0, 0x01);
		
	if (!TestBit(enc, p_e))
	{
		if (!TestBit(lock0, 0x02))
		{
			SetBit(lock0, 0x02);
			if (!TestBit(lock0, 0x08))
				SetBit(lock0, 0x08);
			else
				ClrBit(lock0, 0x08);
			lcd_out();
		}
	}
	else
		ClrBit(lock0, 0x02);
}	  
}
