/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10.06.2016
Author  : NeVaDa
Company : SBE Software
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

//FUSES: 0xDE 0xD9 0xFF  
//-U lfuse:w:0xde:m -U hfuse:w:0xd9:m -U efuse:w:0xff:m

#include <tiny2313.h>
#include <delay.h>

//#define _display_err_
//#include <Math.h>


// 1 Wire Bus functions
#asm
   .equ __w1_port=0x18 ;PORTB
   .equ __w1_bit=0
#endasm
#include <1wire.h>

// DS1820 Temperature Sensor functions
#include <ds18b20_cli.h>

// maximum number of DS1820 devices
// connected to the 1 Wire bus
#define MAX_DS1820 2
// number of DS1820 devices
// connected to the 1 Wire bus
unsigned char ds1820_devices;
// DS1820 devices ROM code storage area,
// 9 bytes are used for each device
// (see the w1_search function description in the help)
unsigned char ds1820_rom_codes[MAX_DS1820][9];

#define SetBit(x,y) (x|=y)
#define ClrBit(x,y) (x&=~y)
#define TestBit(x,y) (x&y)

#define port_sh PORTB
#define pin_sh  0x02
#define pin_st  0x04
#define pin_d   0x08

#define port_ds PORTD
#define led1    0x10
#define led2    0x20
#define led3    0x40
#define button  0x02
#define jumper  0x01
#define led_rd  0x04
#define led_gr  0x08

//Массив для 74HC595 -> Семисегментник || 0-7 = A-G+DP
flash unsigned char leds[12] = {
 0b11011011,        //0
 0b00001010,        //1
 0b11000111,        //2
 0b01001111,        //3
 0b00011110,        //4
 0b01011101,        //5
 0b11011101,        //6
 0b00001011,        //7
 0b11011111,        //8
 0b01011111,         //9
 0b11010101,        //E
 0b10000100};       //r                         
//unsigned char rom[8];
 
unsigned int temp = 19, t_old;    //Температура
bit term = 0;           //Текущий датчик (из двух)
bit pause = 0;          //1 -- уже нажали кнопку, таймер установлен чуть больше  
bit minus = 0;
unsigned char out = 0;    //Переменная для вывода одного числа на семисегментник
unsigned char i = 0;    //Инкремент
unsigned char j = led1;    //Инкремент
//unsigned char o1 = 0;   //out для знаков

//Функция работы со сдвиговым регистром 74HC595
void inline shift_out(unsigned char data)
{          
    ClrBit(port_sh, pin_st);           
    ClrBit(port_sh, pin_sh);
    
	for(i = 0; i < 8; i++)
	{
		if(data & 0x80)
			SetBit(port_sh, pin_d);
		else
			ClrBit(port_sh, pin_d);
			
		SetBit(port_sh, pin_sh);

		ClrBit(port_sh, pin_sh);
		data <<= 1;
	}         
    
    SetBit(port_sh, pin_st);
}


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    ClrBit(port_ds, 0b01110000);     //ВЫКЛ все
  
    switch (j)
    {
    case led1:          
        #ifdef _display_err_       
        if (temp == 0xFFF)
        {
            out = leds[10];
            break;
        }
        #endif
            
        out = 0x04 * minus;
            
        if (term)
        {
            ClrBit(port_ds, led_gr);
            SetBit(port_ds, led_rd);
        }
        else
        {
            ClrBit(port_ds, led_rd);
            SetBit(port_ds, led_gr);
        }   
                
        break;
        
    case led2:         
        #ifdef _display_err_ 
        if (temp == 0xFFF)
        {
            out = leds[11];
            break;
        }
        #endif    
        
        out = t_old / 10;        //Десятки                     
            
        out = leds[out];        //Вывод числа через массив
        break;
    
    case led3:
        #ifdef _display_err_                                       
        if (temp == 0xFFF)
        {
            out = leds[11];
            break;
        }
        #endif    
        
        out = t_old % 10;        //Единицы
        
        out = leds[out];        //Вывод числа через массив
        break; 
    }
            
    shift_out(out);         //выводим на индикатор
    SetBit(port_ds, j);     //ВКЛ    
      
    j <<= 1;                //меняем индикатор
    if (j > led3)
        j = led1;
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
    //Если была нажата кнопка, уже подождали много
    if (pause)     
    {
        TCCR1B=0x02;        //Таймер побыстрее
        pause = 0;
    }
    
    //Кнопарь
    if (!TestBit(PIND, button)) 
    {
        term = ~term;       //Меняем датчик
        TCCR1B=0x03;        //Таймер помедленнее    
        pause = 1;          //Нажали
    }         
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here
// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=T 
PORTB=0x00;
DDRB=0xFE;

// Port D initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T 
PORTD=0x00;
DDRD=0x7C;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
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
// Clock value: 7,813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x82;
//TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Determine the number of DS1820 devices
// connected to the 1 Wire bus

ds1820_devices=w1_search(0xf0, ds1820_rom_codes);

//Инициализация двух датчиков
ds18b20_init( &ds1820_rom_codes[0][0], -30, 60, DS18B20_9BIT_RES);
ds18b20_init( &ds1820_rom_codes[1][0], -30, 60, DS18B20_9BIT_RES);

// Global enable interrupts
#asm("sei")

while (1)
      {                    
        if (TestBit(PIND, jumper))
            temp = ds18b20_temperature1(&ds1820_rom_codes[~term][0]);
        else
            temp = ds18b20_temperature1(&ds1820_rom_codes[term][0]); 
                                
        #asm("cli")
                   
        if (temp != 0xFFF)
        {          
            if ((temp & 0x8000) == 0)
                minus = 0;
            else
            {
                minus = 1;
                temp = ~temp + 1;
            }
            
            temp = (unsigned char)(temp >> 4);
            t_old = temp;
        }
        
        #asm("sei")
      };
}