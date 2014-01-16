/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 27.06.2013
Author  : NeVaDa
Company : SBE Software
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#define SetBit(x,y) (x|=y)
#define ClrBit(x,y) (x&=~y)
#define TestBit(x,y) (x&y)

#include <mega16.h>
#include <delay.h>
#include "midi.c"

//3,4,5
#define port_sh PORTA
#define pin_sh  0x02
#define pin_st  0x04
#define pin_d   0x01

unsigned char i = 0, j = 1, k = 0;
char okt = 0;
unsigned char chn = 0;
//unsigned char split = 0;
//unsigned char split_is = 0;
unsigned char str_okt[16];
unsigned char str_manual[] = "Upper manual";
unsigned char last = 0;
unsigned char _ports[6];

void shift_out(unsigned char data, unsigned char channel)
{
	ClrBit(port_sh, pin_st << channel);
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
    SetBit(port_sh, pin_st << channel);
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here
    char c;
   char cmd;
   char chan;       
   unsigned char n_addr = 0b01000000;
   unsigned char n_bit =  0b00001001;
   unsigned char n_on = 0, n_off = 0;                 
   _ports[0] = 0x00;
   _ports[1] = 0x00;
   _ports[2] = 0x00;
   _ports[3] = 0x00;
   _ports[4] = 0x00;
   _ports[5] = 0x00;

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0xFF;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
//UBRRL=0x1F;
UBRRL=0x19;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

#asm("sei")

while (1)
      {                   
        c = getchar();
//        n_bit = 0;
        if(c & 0x80)  //is it a command?
        {                                   
            if(c < 0xf0)
             {
                //process this stuff, dispose of everything else
                cmd = (char)(c & 0xf0);                         
                chan = (char)(c & 0x0f);
             }
        }
        else
        {
/*            if (split_is && c < split)
            {                       
                if (last != cmd | chan)
                    putchar(cmd | chan);
                putchar(c);
                c = getchar();
                putchar(c);
                last = cmd | chan;
                continue;
            }
*/            
//            if (chan == chn)
            {
//                char diff = (okt - 2) * 12;
//                if (c + diff >= 0)  
                {
//                    c += (okt - 2) * 12;
                    n_addr = (c - 0x18) / 8;
                    
                    n_bit = 1 << ((c-0x18) % 8);
                    if (n_addr < 6)
                     switch (cmd)
                     {                
                        case NOTEOFF:
                            ClrBit(_ports[n_addr], n_bit);
                            shift_out(_ports[n_addr], n_addr);    
                            n_off = c;
                            break;       
                           
                        case NOTEON:
                            SetBit(_ports[n_addr], n_bit); 
                            shift_out(_ports[n_addr], n_addr);
                            n_on = c;      
                            break;    
                            
/*                        case CHANPRES:
                            write_reg(0b01000000, OLAT, all_notes_off);
                            write_reg(0b01000010, OLAT, all_notes_off);
                            write_reg(0b01000100, OLAT, all_notes_off);
                            write_reg(0b01000110, OLAT, all_notes_off);
                            write_reg(0b01001000, OLAT, all_notes_off);
                            write_reg(0b01001010, OLAT, all_notes_off);
                            write_reg(0b01001100, OLAT, all_notes_off);
                            write_reg(0b01001110, OLAT, all_notes_off);
                            break;*/
                     }
        //             sprintf(str_on, "Note on:\t%i\n", n_on);
        //             sprintf(str_off, "Note off:\t%i\n", n_off);
        //             
        //             lcd_clear();
        //             lcd_puts(str_on);
        //             lcd_puts(str_off);
                     c = getchar();
                  }
            }
          }
      // Place your code here  
/*        shift_out(j, k);
        
        if (j == 0x80)
        {                   
            delay_ms(100);
            shift_out(0, k);
            j = 1;
            k++;
            if (k > 5)
                k = 0;
        }
        else           
        {
            j <<= 1;
            delay_ms(100);
        }     */
      };
}
