
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;   
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;   
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

void lcd_control (unsigned char control);

#pragma used-
#pragma library lcd.lib

flash unsigned int times[256]= {   0,    0,    1,    2,    3,    4,    5,    6,    7,    8,    8,    9,    9,   10,   10,   11,              
11,   12,   12,   13,   13,   14,   14,   15,   15,   16,   16,   17,   17,   18,   18,   19,              
19,   20,   20,   21,   21,   22,   22,   23,   23,   24,   24,   25,   25,   26,   26,   27,              
27,   28,   28,   29,   29,   30,   31,   32,   33,   34,   35,   36,   37,   38,   39,   40,              
41,   42,   43,   44,   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,   55,   56,              
57,   58,   59,   60,   61,   62,   63,   64,   65,   66,   67,   68,   69,   70,   71,   72,              
73,   75,   77,   79,   81,   83,   85,   87,   89,   91,   93,   95,   97,   99,  101,  103,              
105,  107,  109,  111,  113,  115,  117,  119,  122,  125,  127,  130,  133,  136,  139,  142,              
145,  148,  149,  150,  155,  157,  159,  164,  166,  170,  174,  177,  180,  184,  188,  193,              
200,  204,  208,  212,  216,  220,  225,  230,  235,  240,  245,  250,  255,  260,  265,  270,              
276,  282,  288,  294,  300,  306,  312,  318,  324,  331,  339,  347,  355,  364,  372,  380,              
390,  398,  406,  414,  422,  430,  438,  446,  454,  462,  470,  480,  490,  500,  510,  520,              
530,  540,  553,  566,  579,  592,  605,  618,  631,  644,  657,  670,  685,  698,  711,  724,              
740,  750,  767,  783,  800,  817,  834,  851,  868,  885,  902,  919,  934,  953,  970,  987,              
1000, 1033, 1066, 1100, 1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300, 1330, 1350, 1380, 1400,              
1440, 1450, 1500, 1533, 1563, 1600, 1633, 1669, 1700, 1733, 1766, 1800, 1833, 1866, 1900, 2000};             

unsigned char time = 0, time_c = 0;
unsigned char lock0 = 0;
unsigned char cmd1 = 0b00010001;
unsigned char i;
unsigned char val1, val2, val3, val4;
unsigned char e1 = 0, e2 = 0;
unsigned char dir = 2, dir_cnt = 4;
volatile unsigned char v_time[5];

void setRes(unsigned char cmd2)
{
cmd1 = 0b00010001;
PORTD &= ~(1<<(6));
delay_us(1);
PORTB &= ~0b00001000;
delay_us(1);

for(i = 0; i < 8; i++)
{
if(cmd1 & 0x80)
PORTD |= 0b00100000; 
else
PORTD &= ~0b00100000;

delay_us(1);
PORTD |= 0b01000000;

delay_us(1);
PORTD &= ~0b01000000;
cmd1 <<= 1;
}

for(i = 0; i < 8; i++)
{
if(cmd2 & 0x80)
PORTD |= 0b00100000; 
else
PORTD &= ~0b00100000;

delay_us(1);
PORTD |= 0b01000000;

delay_us(1);
PORTD &= ~0b01000000;
cmd2 <<= 1;
}

delay_us(1);
PORTB |= 0b00001000; 
}

void LCDWriteInt(unsigned int val)
{

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

if (time > 0)	lcd_putchar('<');	else	lcd_putchar(' ');
LCDWriteInt(time+1);
if (time < 5 - 1)	lcd_putchar('>');	else	lcd_putchar(' ');

lcd_gotoxy(3, 1);

if (time_c > 0)			lcd_putchar('<');	else	lcd_putchar(' ');
LCDWriteInt(times[time_c]);
if (time_c < 0xFF)	lcd_putchar('>');	else	lcd_putchar(' ');

lcd_puts(" ms");
}

interrupt [7] void timer0_ovf_isr(void)
{

if ((PIND&0b00000100) && (PIND&0b00001000))
e1 = 0;
if (!(PIND&0b00000100) && (PIND&0b00001000))
e1 = 1;
if (!(PIND&0b00000100) && !(PIND&0b00001000))
e1 = 2;
if ((PIND&0b00000100) && !(PIND&0b00001000))
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

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTA=0x00;
DDRA=0x00;

PORTB=0x08;
DDRB=0xFF;

PORTD=0x00;
DDRD=0x60;

TCCR0A=0x00;
TCCR0B=0x02;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

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

GIMSK=0x00;
MCUCR=0x00;
EIFR=0x00;

TIMSK=0x02;

USICR=0x00;

ACSR=0x80;

lcd_init(16);

lcd_clear();
lcd_puts("Electro-Harmonix");
delay_ms(1000);
lcd_gotoxy(0, 1);
lcd_puts("  #1 Echo by");
delay_ms(1000);
lcd_gotoxy(0, 1);

lcd_puts(" Rinon Ninqueon");
delay_ms(1000);

lcd_out();

#asm("sei")

i = 0;
while (i < 5)
v_time[i++] = 175;

time_c = v_time[0];

setRes(time_c);

while (1)
{
if (dir != 1)               
{
if (dir == 0)           
{             
if (dir_cnt == 0)
{
if (time_c > 0)
time_c--;
dir_cnt = 4;
}
dir_cnt--;
}
else
{
if (dir_cnt == 8)
{
if (time_c < 0xFF)
time_c++;      
dir_cnt = 4;
}
dir_cnt++;
}

setRes(time_c);

dir = 1;
lcd_out();
}    

if (!(PIND&0b00000001))     
{
if (!(lock0&0x01))
{
(lock0|=0x01);

v_time[time] = time_c;          

if (time > 0)
time--;  

time_c = v_time[time];
setRes(time_c);
lcd_out();
}
}
else
(lock0&=~0x01);

if (!(PIND&0b00000010))     
{
if (!(lock0&0x02))
{
(lock0|=0x02);  
v_time[time] = time_c; 

if (time < 5-1)
time++;
time_c = v_time[time];
setRes(time_c);
lcd_out();
}
}
else
(lock0&=~0x02);
}
}
