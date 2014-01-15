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

#define _dir_cnt 4
#define _dir_cnt2 8

/*-------SPI------*/

#define nSS			3
#define SDI 		5
#define	SCK			6
			
#define	SPI_PORT	PORTD

#define HI(x) SPI_PORT |= (1<<(x))
#define LO(x) SPI_PORT &= ~(1<<(x))

#define max_time  0xFF
#define max_ee 5

flash unsigned int times[256]= {   0,    0,    1,    2,    3,    4,    5,    6,    7,    8,    8,    9,    9,   10,   10,   11,              //   0 -  15
                                  11,   12,   12,   13,   13,   14,   14,   15,   15,   16,   16,   17,   17,   18,   18,   19,              //  16 -  31
                                  19,   20,   20,   21,   21,   22,   22,   23,   23,   24,   24,   25,   25,   26,   26,   27,              //  32 -  47
                                  27,   28,   28,   29,   29,   30,   31,   32,   33,   34,   35,   36,   37,   38,   39,   40,              //  48 -  63
                                  41,   42,   43,   44,   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,   55,   56,              //  64 -  79
                                  57,   58,   59,   60,   61,   62,   63,   64,   65,   66,   67,   68,   69,   70,   71,   72,              //  80 -  95
                                  73,   75,   77,   79,   81,   83,   85,   87,   89,   91,   93,   95,   97,   99,  101,  103,              //  96 - 111 
                                 105,  107,  109,  111,  113,  115,  117,  119,  122,  125,  127,  130,  133,  136,  139,  142,              // 112 - 127
                                 145,  148,  149,  150,  155,  157,  159,  164,  166,  170,  174,  177,  180,  184,  188,  193,              // 128 - 143
                                 200,  204,  208,  212,  216,  220,  225,  230,  235,  240,  245,  250,  255,  260,  265,  270,              // 144 - 159
                                 276,  282,  288,  294,  300,  306,  312,  318,  324,  331,  339,  347,  355,  364,  372,  380,              // 160 - 175
                                 390,  398,  406,  414,  422,  430,  438,  446,  454,  462,  470,  480,  490,  500,  510,  520,              // 176 - 191
                                 530,  540,  553,  566,  579,  592,  605,  618,  631,  644,  657,  670,  685,  698,  711,  724,              // 192 - 207
                                 740,  750,  767,  783,  800,  817,  834,  851,  868,  885,  902,  919,  934,  953,  970,  987,              // 208 - 223
                                1000, 1033, 1066, 1100, 1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300, 1330, 1350, 1380, 1400,              // 224 - 239 
                                1440, 1450, 1500, 1533, 1563, 1600, 1633, 1669, 1700, 1733, 1766, 1800, 1833, 1866, 1900, 2000};             // 240 - 255        
                                                                                
unsigned char time = 0, time_c = 0;
unsigned char lock0 = 0;
unsigned char cmd1 = 0b00010001;
unsigned char i;
unsigned char val1, val2, val3, val4;
unsigned char e1 = 0, e2 = 0;
unsigned char dir = 2, dir_cnt = _dir_cnt;
volatile unsigned char v_time[max_ee];


void setRes(unsigned char cmd2)
{
    cmd1 = 0b00010001;
	LO(SCK);
	delay_us(1);
	PORTB &= ~0b00001000;
	delay_us(1);

	for(i = 0; i < 8; i++)
	{
		if(cmd1 & 0x80)
			SPI_PORT |= 0b00100000; //HI(SDI);
		else
			SPI_PORT &= ~0b00100000;//LO(SDI);
			
		delay_us(1);
		SPI_PORT |= 0b01000000;//HI(SCK);

		delay_us(1);
		SPI_PORT &= ~0b01000000;//LO(SCK);
		cmd1 <<= 1;
	}

	
	for(i = 0; i < 8; i++)
	{
		if(cmd2 & 0x80)
			SPI_PORT |= 0b00100000; //HI(SDI);
		else
			SPI_PORT &= ~0b00100000;//LO(SDI);
			
		delay_us(1);
		SPI_PORT |= 0b01000000;//HI(SCK);

		delay_us(1);
		SPI_PORT &= ~0b01000000;//LO(SCK);
		cmd2 <<= 1;
	}

	delay_us(1);
	PORTB |= 0b00001000; //(1<<(nSS));
}

void LCDWriteInt(unsigned int val)
{
	/***************************************************************
	This function writes a integer type value to LCD module

	Arguments:
	1)unsigned char val	: Value to print

	2)unsigned char field_length :total length of field in which the value is printed
	must be between 1-3 if it is -1 the field length is no of digits in the val

	****************************************************************/         
    
    val1 = val % 10;
    val2 = (val / 10) % 10;
    val3 = (val / 100) % 10;
    val4 = (val / 1000) % 10; 
                             
    if (val4 != 0)
    lcd_putchar(48 + val4);
    if (val3 != 0 || val4 != 0)
    lcd_putchar(48 + val3);
    if (val2 != 0 || val3 != 0 || val4 != 0)
    lcd_putchar(48 + val2);
    lcd_putchar(48 + val1);	
}

void lcd_out(void)
{
    lcd_clear();
	
	lcd_puts("  Preset #");
//    lcd_putchar(' ');
    
    if (time > 0)	lcd_putchar('<');	else	lcd_putchar(' ');
	LCDWriteInt(time+1);
	if (time < max_ee - 1)	lcd_putchar('>');	else	lcd_putchar(' ');
	
	lcd_gotoxy(3, 1);
	
	if (time_c > 0)			lcd_putchar('<');	else	lcd_putchar(' ');
	LCDWriteInt(times[time_c]);
	if (time_c < max_time)	lcd_putchar('>');	else	lcd_putchar(' ');
	
	lcd_puts(" ms");
}

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
OCR1AH=0x00;
OCR1AL=0x00;
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
TIMSK=0x02;

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

lcd_clear();
lcd_puts("Electro-Harmonix");
delay_ms(1000);
lcd_gotoxy(0, 1);
lcd_puts("  #1 Echo by");
delay_ms(1000);
lcd_gotoxy(0, 1);
//lcd_puts("  Digital Delay");
lcd_puts(" Rinon Ninqueon");
delay_ms(1000);

//lcd_clear();
//lcd_gotoxy(0, 0);
//lcd_puts("  Digital Delay ");
//lcd_gotoxy(0, 1);
//lcd_puts(" Rinon Ninqueon ");

//delay_ms(1000);


lcd_out();
// Global enable interrupts
#asm("sei")

i = 0;
while (i < max_ee)
    v_time[i++] = 175;

time_c = v_time[0];

setRes(time_c);

while (1)
{
    if (dir != 1)               //обработка энкодера
    {
        if (dir == 0)           
        {             
            if (dir_cnt == 0)
		    {
                if (time_c > 0)
    	    	    time_c--;
                dir_cnt = _dir_cnt;
            }
            dir_cnt--;
        }
        else
        {
            if (dir_cnt == _dir_cnt2)
            {
                if (time_c < max_time)
        		    time_c++;      
                dir_cnt = _dir_cnt;
            }
            dir_cnt++;
        }
        
    	setRes(time_c);

        dir = 1;
		lcd_out();
    }    
    
		
	if (!TestBit(enc, p_c))     //предыдущий пресет
	{
		if (!TestBit(lock0, 0x01))
		{
			SetBit(lock0, 0x01);
            
            v_time[time] = time_c;          
            
            if (time > 0)
                time--;  
            
            time_c = v_time[time];
            setRes(time_c);
			lcd_out();
		}
	}
	else
		ClrBit(lock0, 0x01);
    
    if (!TestBit(enc, p_d))     //следующий пресет
	{
		if (!TestBit(lock0, 0x02))
		{
			SetBit(lock0, 0x02);  
            v_time[time] = time_c; 

            if (time < max_ee-1)
                time++;
            time_c = v_time[time];
            setRes(time_c);
			lcd_out();
		}
	}
	else
		ClrBit(lock0, 0x02);
}
}
