
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

unsigned char dp_cnt = 0;
unsigned char time = 0x7F;
unsigned char ch_depth = 0x19, ch_speed = 0xFF;
unsigned char lock0 = 0;
unsigned char main_menu = 0;
unsigned char max_menu = 0;
unsigned char i, j, val1, val2, val3, e1 = 0, e2 = 0, dir = 1, ch_on = 0;

void inline chorus_on(void)
{
dp_cnt = ch_depth;
(lock0|=0x04);
(TCCR1B|=0x0B);

max_menu = 2;               
ch_on = 1;
}

void inline chorus_off(void)
{
(TCCR1B&=~0x0B);
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

PORTD &= ~(1<<(6));
delay_us(1);
PORTB &= ~(1<<(3));
delay_us(1);

for(i = 0; i < 8; i++)
{
if(cmd1 & 0x80)
PORTD |= (1<<(5));
else
PORTD &= ~(1<<(5));

delay_us(1);
PORTD |= (1<<(6));

delay_us(1);
PORTD &= ~(1<<(6));
cmd1 <<= 1;
}

for(i = 0; i < 8; i++)
{
if(cmd2 & 0x80)
PORTD |= (1<<(5));
else
PORTD &= ~(1<<(5));

delay_us(1);
PORTD |= (1<<(6));

delay_us(1);
PORTD &= ~(1<<(6));
cmd2 <<= 1;
}

delay_us(1);
PORTB |= (1<<(3));
}

void LCDWriteInt(unsigned char val)
{

j = 0;    
i = 2;          

val1 = val % 10;
val2 = (val / 10) % 10;
val3 = (val / 100) % 10; 

lcd_putchar(48 + val3);

lcd_putchar(48 + val2);
lcd_putchar(48 + val1);	

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

if (time > 0 && (lock0&0x08) && main_menu == 0)			lcd_putchar('<');	else	lcd_putchar(' ');
LCDWriteInt(time);
if (time < 0xFF && (lock0&0x08) && main_menu == 0)	lcd_putchar('>');	else	lcd_putchar(' ');

lcd_putchar(' ');

if (ch_on)
{
if (ch_speed > 0 && (lock0&0x08) && main_menu == 1)			lcd_putchar('<');	else	lcd_putchar(' ');
LCDWriteInt(ch_speed);
if (ch_speed < 0xFF && (lock0&0x08) && main_menu == 1)	lcd_putchar('>');	else	lcd_putchar(' ');

lcd_putchar(' ');

if (ch_depth > 0 && (lock0&0x08) && main_menu == 2)			lcd_putchar('<');	else	lcd_putchar(' ');
LCDWriteInt(ch_depth);
if (ch_depth < 0x0F && (lock0&0x08) && main_menu == 2)	lcd_putchar('>');	else	lcd_putchar(' ');
}
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

interrupt [5] void timer1_compa_isr(void)
{
if ((lock0&0x04))
dp_cnt++;
else
dp_cnt--;

if (dp_cnt == ch_depth * 2)
(lock0&=~0x04);
if (dp_cnt == 0)
(lock0|=0x04);

setRes(time + dp_cnt - ch_depth);

}

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;

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
OCR1A=0x0FF0;

OCR1BH=0x00;
OCR1BL=0x00;

GIMSK=0x00;
MCUCR=0x00;
EIFR=0x00;

TIMSK=0x42;

USICR=0x00;

ACSR=0x80;

lcd_init(16);

delay_ms(100);

lcd_out();

#asm("sei")

setRes(time);

while (1)
{
if (dir != 1)
{
if ((lock0&0x08))
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
if (ch_speed > 0x05)
ch_speed--;   
}
else
if (ch_speed < 0xFF)
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
if (ch_depth < 0x0F)
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

if (!(PIND&0b00000001))
{
if (!(lock0&0x01))
{
(lock0|=0x01);
if (ch_on)
chorus_off();
else
chorus_on();
lcd_out();
}
}
else
(lock0&=~0x01);

if (!(PIND&0b00010000))
{
if (!(lock0&0x02))
{
(lock0|=0x02);
if (!(lock0&0x08))
(lock0|=0x08);
else
(lock0&=~0x08);
lcd_out();
}
}
else
(lock0&=~0x02);
}	  
}
