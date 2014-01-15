/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10.01.2013
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#define SetBit(x,y) (x|=y)
#define ClrBit(x,y) (x&=~y)
#define TestBit(x,y) (x&y)

// I2C Bus functions
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm
#include <i2c.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>
#include <delay.h>
#include <stdio.h>
#include <24LC16.h>

unsigned char val1, val2, val3, val4, val5;
void LCDWriteInt(unsigned int val, unsigned char move)
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
    val5 = (val / 10000) % 10; 
                             
    if (val5 != 0)
        lcd_putchar(48 + val5);   
    else
    if (move > 4)
        lcd_putchar(' ');
    if (val4 != 0 || val5 != 0)
        lcd_putchar(48 + val4);
    else
    if (move > 3)
        lcd_putchar(' ');
    if (val3 != 0 || val4 != 0 || val5 != 0)
        lcd_putchar(48 + val3);
    else
    if (move > 2)
        lcd_putchar(' ');
    if (val2 != 0 || val3 != 0 || val4 != 0 || val5 != 0)
        lcd_putchar(48 + val2);
    else
    if (move > 1)
        lcd_putchar(' ');
    lcd_putchar(48 + val1);	
}


#include "patterns.c"
#include "encoder.c"

#define max_speed 40000
#define min_speed   500
#define dividor_speed 500

//3,4,5
#define port_sh PORTD
#define pin_sh  0x08
#define pin_st  0x10
#define pin_d   0x20

#define pin_pwm 0x40

#define PWM_step 0xFF

#define scan_speed1 7000
#define scan_speed2 7000

unsigned char pwm_cnt = 0;

unsigned char scan_mode = 1, last_mode = 0;
bit edit_mode = 0;
unsigned char scan_cnt = 0;
bit chorus = 0;
bit multiplexor = 0;
bit ch_speed = 0;
bit ch_on = 1;
unsigned int scan_speed = 7000, tmp_speed = 0;
unsigned char out = 0, out2 = 0;

unsigned char e_preset = 0, e_item = 0, e_out = 0, e_mode = 0;
bit e_save = 0;
bit e_preview = 0;
t_pattern e_patt;

t_pattern patt;

void shift_out(unsigned char data)
{
	ClrBit(port_sh, pin_st);
    ClrBit(port_sh, pin_sh);
	
    delay_us(1000);

	for(i = 0; i < 8; i++)
	{
		if(data & 0x80)
			SetBit(port_sh, pin_d);
		else
			ClrBit(port_sh, pin_d);
			
		delay_us(1000);
		SetBit(port_sh, pin_sh);

		delay_us(1000);
		ClrBit(port_sh, pin_sh);
		data <<= 1;
	}
    delay_us(1000);
    SetBit(port_sh, pin_st);
}


void lcd_out()
{
    lcd_clear();              
    
    if (!edit_mode)
    {
        lcd_puts("Mode");
        lcd_gotoxy(11, 0);
        lcd_puts("Speed");   
        
        if (scan_mode < 4)
        {                          
            lcd_gotoxy(0, 1);
            if (scan_mode > 1)  lcd_putchar(0); else    lcd_putchar(' ');
            if (chorus) lcd_putchar('C');   else    lcd_putchar('V');
            LCDWriteInt(scan_mode, 0);
            if (ch_on)
            {
                if (scan_mode < 3)  lcd_putchar(1); else    lcd_putchar(' ');
                lcd_gotoxy(11, 1);
            }
            else
                lcd_puts("Off");
        }
        else
        {                    
            lcd_gotoxy(0, 1);                                                  
            lcd_puts(t_preset);
            if (current_pattern > 0)  lcd_putchar(0); else    lcd_putchar(' ');
            if (chorus) lcd_putchar('C');   else    lcd_putchar('V');
            LCDWriteInt(current_pattern+1, 0);
            if (current_pattern < MAX_PATTERNS-1)  lcd_putchar(1); else    lcd_putchar(' ');
            lcd_gotoxy(11, 1);
        }
        
        if (scan_speed < max_speed)  lcd_putchar(0); else    lcd_putchar(' ');
        LCDWriteInt((max_speed - scan_speed)/dividor_speed, 0);
        if (scan_speed > min_speed)  lcd_putchar(1); else    lcd_putchar(' ');  
    }
    else
    {    
        lcd_puts("Edit ");
        lcd_puts(t_preset);
        if (e_preset > 0 && e_mode==0)  lcd_putchar(0); else    lcd_putchar(' ');
        LCDWriteInt(e_preset+1, 0);
        if (e_preset < MAX_PATTERNS-1 && e_mode==0)  lcd_putchar(1); else    lcd_putchar(' ');
        lcd_putchar(' ');
        if (e_save) lcd_putchar('*');
        
        lcd_gotoxy(0, 1);
        lcd_puts(t_item);
        if (e_item > 0 && e_mode==1)  lcd_putchar(0); else    lcd_putchar(' ');
        LCDWriteInt(e_item+1, 2);
        if (e_item < MAX_ITEMS-1 && e_mode==1 && e_out > 0)  lcd_putchar(1); else    lcd_putchar(' ');
        if (e_out > 0) lcd_putchar(' '); 
        
        lcd_puts("Out");
        if (e_out > 0 && e_mode==2)  lcd_putchar(0); else  lcd_putchar(' ');
        if (e_out > 0) LCDWriteInt(e_out, 2);   else    lcd_puts("OFF");
        if (e_out < MAX_OUT && e_mode==2)  lcd_putchar(1); else    lcd_putchar(' ');
    }
}

#include "keys.c"

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
    encoder_main(PINA, 0b00000001, 0b00000010, PINA, 0b00000100, 0b00001000);
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
    if (multiplexor)
        pwm_cnt--;
    else
        pwm_cnt++;
        
    OCR2 = pwm_cnt;
        
    if (pwm_cnt > 0 && pwm_cnt < 0xFF)
        return;
    
    if (!edit_mode) 
    {     
    if (ch_speed)
    {
        if (!ch_on)
            if (scan_speed <= max_speed)    scan_speed += dividor_speed;
            else
            {
                out = 0xFF;
                shift_out(out);
                TCCR1B=0x00;  
                ch_speed = 0;
                return;
            }
        if (ch_on)
            if (scan_speed >= tmp_speed)    scan_speed -= dividor_speed;
            else
            {              
                scan_speed = tmp_speed;
                ch_speed = 0;
//                out = 0x10;
            }
    }
    switch (scan_mode)
    { 
        case 1:   
            out = v1.out[scan_cnt]; 
            scan_cnt++;
            if (scan_cnt >= v1.length)
                scan_cnt = 0;
            break;
        case 2:              
            out = v2.out[scan_cnt];
            scan_cnt++;
            if (scan_cnt >= v2.length)
                scan_cnt = 0;
            break;
        case 3:
            out = v3.out[scan_cnt];
            scan_cnt++;
            if (scan_cnt >= v3.length)
                scan_cnt = 0;
            break;
        case 4:            
            out = patt.out[scan_cnt];
            scan_cnt++;
            if (scan_cnt >= patt.length)
                scan_cnt = 0;
            break;
    }
    }
    else     
    if (e_preview)
    {
        out = e_patt.out[scan_cnt];
        scan_cnt++;
        if (scan_cnt >= e_patt.length)
            scan_cnt = 0;
    }             
    else
        out = 0x10; 
        
    out  = out  & 0x0F;
//    out2 = out2 & 0x0F;
           
    PORTB = 0b00000011 + (out << 4);
    if (multiplexor)   
    {
        shift_out((out << 4) + out2);
        multiplexor = 0;
    }
    else
    {
        shift_out((out2 << 4) + out);
        multiplexor = 1;
    }
//    PORTD = out << 3;
    out2 = out;           
        
    TCNT1 = 0;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here
unsigned char i = 0;

// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0xC0;
DDRA=0xC0;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x03;
DDRB=0xF0;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x07;
DDRD=0xFB;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 187,500 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x02;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 46,875 kHz
// Mode: CTC top=ICR1
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
//OCR1AH=0xFF;
//OCR1AL=0xFF;
OCR1A = scan_speed;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1500,000 kHz
// Mode: Phase correct PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x61;
TCNT2=0x00;
OCR2=0xFF;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x11;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

for (i = 0; i < 8; i++)
{
    lcd_write_byte(0x40 + i, arrow_left[i]);
}

for (i = 0; i < 8; i++)
{
    lcd_write_byte(0x40 + 0x08 + i, arrow_right[i]);
}

// I2C Bus initialization
i2c_init();

lcd_clear();
lcd_puts(" Hammond Organ  ");
delay_ms(1000);

lcd_gotoxy(0, 1);
lcd_puts(" Vibrato/Chorus ");
delay_ms(1000);

lcd_gotoxy(0, 1);
lcd_puts("Digital Scanner ");
delay_ms(1000);

lcd_gotoxy(0, 1);
lcd_puts("      by        ");
delay_ms(700);

lcd_gotoxy(0, 1);
lcd_puts(" Rinon Ninqueon ");
delay_ms(1000);

delay_ms(100);

if (init_check())
    zero_init();

#asm("sei")

patt = read_pattern(current_pattern);

lcd_out();

while (1)
    {     
        if (dir1 != 1)               //обработка энкодера 1
        {
            if (dir1 == 0)           
            {             
                if (dir_cnt1 == 0)
                {
                    dir_cnt1 = _dir_cnt;
                    ClrBit(PORTA, 0b01000000);
                    enc1 = 0;
                }
                dir_cnt1--;
            }
            else
            {
                if (dir_cnt1 == _dir_cnt2)
                {
                    dir_cnt1 = _dir_cnt;
                    ClrBit(PORTA, 0b01000000);
                    enc1 = 1;
                }
                dir_cnt1++;
            }
            
            dir1 = 1;
        }   
        
        if (dir2 != 1)               //обработка энкодера 2
        {
            if (dir2 == 0)           
            {             
                if (dir_cnt2 == 0)
                {
                    dir_cnt2 = _dir_cnt;
                    ClrBit(PORTA, 0b10000000);
                    enc2 = 0;
                }
                dir_cnt2--;
            }
            else
            {
                if (dir_cnt2 == _dir_cnt2)
                {
                    dir_cnt2 = _dir_cnt;
                    ClrBit(PORTA, 0b10000000);
                    enc2 = 1;
                }
                dir_cnt2++;
            }
            
            dir2 = 1;
        }
        if (TestBit(PINC, 0x08))
        {
            if (!chorus)
            {
                chorus = 1;
                lcd_out();
            }
        }
        else
            if (chorus)
            {
                chorus = 0;
                lcd_out();
            }
    };
}
