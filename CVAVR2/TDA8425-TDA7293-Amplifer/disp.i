
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
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
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#asm
    .equ __i2c_port=0x15
    .equ __sda_bit=1
    .equ __scl_bit=0
#endasm

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

flash unsigned char s_mute[8] = {0x1C, 0x14, 0x5D, 0x22, 0x7F, 0x14, 0x22, 0x41};
flash unsigned char s_in[10] = {0x00, 0x7F, 0x7B, 0x41, 0x7F,
0x7F, 0x4D, 0x55, 0x53, 0x7F};
flash unsigned char s_inc[10] = {0x7F, 0x41, 0x6D, 0x41, 0x7F,
0x7F, 0x41, 0x55, 0x45, 0x7F};
flash unsigned char s_out[28] = {0x7F, 0x41, 0x7B, 0x77, 0x7B, 0x41, 0x7F,
0x7F, 0x63, 0x5D, 0x5D, 0x5D, 0x7F, 0x00,
0x00, 0x7F, 0x41, 0x75, 0x75, 0x7B, 0x7F,
0x00, 0x7F, 0x41, 0x7D, 0x7D, 0x41, 0x7F};  
flash unsigned char s_clip[6] = {0x7F, 0x3F, 0x57, 0x6B, 0x7D, 0x7F};
flash unsigned char s_chbox[12] = {0x7E, 0x42, 0x42, 0x42, 0x42, 0x7E,
0x7E, 0x52, 0x62, 0x52, 0x4A, 0x7E};

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

flash char sym[][5] = 
{

{0x00,0x00,0x00,0x00,0x00},                    
{0x00,0x00,0x4f,0x00,0x00},                    
{0x00,0x07,0x00,0x07,0x00},                    
{0x14,0x7f,0x14,0x7f,0x14},                    
{0x24,0x2a,0x7f,0x2a,0x12},                    
{0x23,0x13,0x08,0x64,0x62},                    
{0x36,0x49,0x55,0x22,0x40},                    
{0x00,0x05,0x03,0x00,0x00},                    
{0x00,0x1c,0x22,0x41,0x00},                    
{0x00,0x41,0x22,0x1c,0x00},                    
{0x14,0x08,0x3E,0x08,0x14},                    
{0x08,0x08,0x3E,0x08,0x08},                    
{0x00,0x50,0x30,0x00,0x00},                    
{0x08,0x08,0x08,0x08,0x08},                    
{0x00,0x60,0x60,0x00,0x00},                    
{0x20,0x10,0x08,0x04,0x02},                    

{0x3e,0x51,0x49,0x45,0x3e},                    
{0x00,0x42,0x7f,0x40,0x00},                    
{0x42,0x61,0x51,0x49,0x46},                    
{0x21,0x41,0x45,0x4b,0x31},                    
{0x18,0x14,0x12,0x7f,0x10},                    
{0x27,0x45,0x45,0x45,0x39},                    
{0x3c,0x4a,0x49,0x49,0x30},                    
{0x01,0x71,0x09,0x05,0x03},                    
{0x36,0x49,0x49,0x49,0x36},                    
{0x06,0x49,0x49,0x29,0x1e},                    
{0x00,0x36,0x36,0x00,0x00},                    
{0x00,0x56,0x36,0x00,0x00},                    
{0x08,0x14,0x22,0x41,0x00},                    
{0x14,0x14,0x14,0x14,0x14},                    
{0x00,0x41,0x22,0x14,0x08},                    
{0x02,0x01,0x51,0x09,0x06},                    

{0x32,0x49,0x71,0x41,0x3e},                    
{0x7e,0x11,0x11,0x11,0x7e},                    
{0x7f,0x49,0x49,0x49,0x36},                    
{0x3e,0x41,0x41,0x41,0x22},                    
{0x7f,0x41,0x41,0x22,0x1c},                    
{0x7f,0x49,0x49,0x49,0x41},                    
{0x7f,0x09,0x09,0x09,0x01},                    
{0x3e,0x41,0x49,0x49,0x3a},                    
{0x7f,0x08,0x08,0x08,0x7f},                    
{0x00,0x41,0x7f,0x41,0x00},                    
{0x20,0x40,0x41,0x3f,0x01},                    
{0x7f,0x08,0x14,0x22,0x41},                    
{0x7f,0x40,0x40,0x40,0x40},                    
{0x7f,0x02,0x0c,0x02,0x7f},                    
{0x7f,0x04,0x08,0x10,0x7f},                    
{0x3e,0x41,0x41,0x41,0x3e},                    

{0x7f,0x09,0x09,0x09,0x06},                    
{0x3e,0x41,0x51,0x21,0x5e},                    
{0x7f,0x09,0x19,0x29,0x46},                    
{0x46,0x49,0x49,0x49,0x31},                    
{0x01,0x01,0x7f,0x01,0x01},                    
{0x3f,0x40,0x40,0x40,0x3f},                    
{0x1f,0x20,0x40,0x20,0x1f},                    
{0x3f,0x40,0x70,0x40,0x3f},                    
{0x63,0x14,0x08,0x14,0x63},                    
{0x07,0x08,0x70,0x08,0x07},                    
{0x61,0x51,0x49,0x45,0x43},                    
{0x00,0x7F,0x41,0x41,0x00},                    
{0x02,0x04,0x08,0x10,0x20},                    
{0x00,0x41,0x41,0x7F,0x00},                    
{0x04,0x02,0x01,0x02,0x04},                    
{0x40,0x40,0x40,0x40,0x40},                    

{0x00,0x01,0x02,0x04,0x00},                    
{0x20,0x54,0x54,0x54,0x78},                    
{0x7F,0x48,0x44,0x44,0x38},                    
{0x38,0x44,0x44,0x44,0x20},                    
{0x38,0x44,0x44,0x48,0x7F},                    
{0x38,0x54,0x54,0x54,0x18},                    
{0x08,0x7E,0x09,0x01,0x02},                    
{0x0C,0x52,0x52,0x52,0x3E},                    
{0x7F,0x08,0x04,0x04,0x78},                    
{0x00,0x44,0x7D,0x40,0x00},                    
{0x20,0x40,0x44,0x3D,0x00},                    
{0x7F,0x10,0x28,0x44,0x00},                    
{0x00,0x41,0x7F,0x40,0x00},                    
{0x7C,0x04,0x18,0x04,0x78},                    
{0x7C,0x08,0x04,0x04,0x78},                    
{0x38,0x44,0x44,0x44,0x38},                    

{0x7C,0x14,0x14,0x14,0x08},                    
{0x08,0x14,0x14,0x18,0x7C},                    
{0x7C,0x08,0x04,0x04,0x08},                    
{0x48,0x54,0x54,0x54,0x20},                    
{0x04,0x3F,0x44,0x40,0x20},                    
{0x3C,0x40,0x40,0x20,0x7C},                    
{0x1C,0x20,0x40,0x20,0x1C},                    
{0x3C,0x40,0x30,0x40,0x3C},                    
{0x44,0x28,0x10,0x28,0x44},                    
{0x0C,0x50,0x50,0x50,0x3C},                    
{0x44,0x64,0x54,0x4C,0x44},                    
{0x00,0x08,0x36,0x41,0x00},                    
{0x00,0x00,0x7f,0x00,0x00},                    
{0x00,0x41,0x36,0x08,0x00},                    
{0x02,0x01,0x02,0x02,0x01},                    
{0x00,0x00,0x00,0x00,0x00},                    

{0x7e,0x11,0x11,0x11,0x7e},                    
{0x7f,0x49,0x49,0x49,0x33},                    
{0x7f,0x49,0x49,0x49,0x36},                    
{0x7f,0x01,0x01,0x01,0x03},                    
{0xe0,0x51,0x4f,0x41,0xff},                    
{0x7f,0x49,0x49,0x49,0x41},                    
{0x77,0x08,0x7f,0x08,0x77},                    
{0x41,0x49,0x49,0x49,0x36},                    
{0x7f,0x10,0x08,0x04,0x7f},                    
{0x7c,0x21,0x12,0x09,0x7c},                    
{0x7f,0x08,0x14,0x22,0x41},                    
{0x20,0x41,0x3f,0x01,0x7f},                    
{0x7f,0x02,0x0c,0x02,0x7f},                    
{0x7f,0x08,0x08,0x08,0x7f},                    
{0x3e,0x41,0x41,0x41,0x3e},                    
{0x7f,0x01,0x01,0x01,0x7f},                    

{0x7f,0x09,0x09,0x09,0x06},                    
{0x3e,0x41,0x41,0x41,0x22},                    
{0x01,0x01,0x7f,0x01,0x01},                    
{0x47,0x28,0x10,0x08,0x07},                    
{0x1c,0x22,0x7f,0x22,0x1c},                    
{0x63,0x14,0x08,0x14,0x63},                    
{0x7f,0x40,0x40,0x40,0xff},                    
{0x07,0x08,0x08,0x08,0x7f},                    
{0x7f,0x40,0x7f,0x40,0x7f},                    
{0x7f,0x40,0x7f,0x40,0xff},                    
{0x01,0x7f,0x48,0x48,0x30},                    
{0x7f,0x48,0x30,0x00,0x7f},                    
{0x00,0x7f,0x48,0x48,0x30},                    
{0x22,0x41,0x49,0x49,0x3e},                    
{0x7f,0x08,0x3e,0x41,0x3e},                    
{0x46,0x29,0x19,0x09,0x7f},                    

{0x20,0x54,0x54,0x54,0x78},                    
{0x3c,0x4a,0x4a,0x49,0x31},                    
{0x7c,0x54,0x54,0x28,0x00},                    
{0x7c,0x04,0x04,0x04,0x0c},                    
{0xe0,0x54,0x4c,0x44,0xfc},                    
{0x38,0x54,0x54,0x54,0x18},                    
{0x6c,0x10,0x7c,0x10,0x6c},                    
{0x44,0x44,0x54,0x54,0x28},                    
{0x7c,0x20,0x10,0x08,0x7c},                    
{0x7c,0x41,0x22,0x11,0x7c},                    
{0x7c,0x10,0x28,0x44,0x00},                    
{0x20,0x44,0x3c,0x04,0x7c},                    
{0x7c,0x08,0x10,0x08,0x7c},                    
{0x7c,0x10,0x10,0x10,0x7c},                    
{0x38,0x44,0x44,0x44,0x38},                    
{0x7c,0x04,0x04,0x04,0x7c},                    

{0x7C,0x14,0x14,0x14,0x08},                    
{0x38,0x44,0x44,0x44,0x20},                    
{0x04,0x04,0x7c,0x04,0x04},                    
{0x0C,0x50,0x50,0x50,0x3C},                    
{0x30,0x48,0xfc,0x48,0x30},                    
{0x44,0x28,0x10,0x28,0x44},                    
{0x7c,0x40,0x40,0x40,0xfc},                    
{0x0c,0x10,0x10,0x10,0x7c},                    
{0x7c,0x40,0x7c,0x40,0x7c},                    
{0x7c,0x40,0x7c,0x40,0xfc},                    
{0x04,0x7c,0x50,0x50,0x20},                    
{0x7c,0x50,0x50,0x20,0x7c},                    
{0x7c,0x50,0x50,0x20,0x00},                    
{0x28,0x44,0x54,0x54,0x38},                    
{0x7c,0x10,0x38,0x44,0x38},                    
{0x08,0x54,0x34,0x14,0x7c},                    

};

unsigned char 
textx, 
texty,		 
curx,
cury,
ch[6];		 			

void WriteCom(unsigned char Com,unsigned char CS)
{ 
(PORTB|=CS); 
(PORTB&=~0b00000001);
(PORTB&=~0b00000010);
#asm("NOP"); 
#asm("NOP");
PORTD=Com;
(PORTB|=0b00000100);
#asm("NOP");
#asm("NOP"); 
(PORTB&=~0b00000100);
delay_us(4); 
(PORTB&=~(0b00100000+0b00010000));
(PORTB|=0b00000100);
}

void WriteData(unsigned char data,unsigned char CS)
{ 
(PORTB|=CS); 
(PORTB|=0b00000001);
(PORTB&=~0b00000010); 
#asm("NOP"); 
#asm("NOP");
PORTD=data;
(PORTB|=0b00000100);
#asm("NOP");
#asm("NOP");  
(PORTB&=~0b00000100);
delay_us(4);
(PORTB&=~(0b00100000+0b00010000));
(PORTB|=0b00000100);
}

void WriteXY(unsigned char x,unsigned char y,const unsigned char CS)
{ 
WriteCom(0xb8+y,CS);
WriteCom(0x40+x,CS);
}

void init_lcd(void)
{ 
(PORTB|=0b00001000);
delay_ms(5);  
WriteXY(0,0,(0b00100000+0b00010000));
WriteCom(0xc0,(0b00100000+0b00010000));
WriteCom(0x3f,(0b00100000+0b00010000));  
}

void clear(void)
{
unsigned char x,y;
for(x=0;x<64;x++)
{
for(y=0;y<8;y++)
{
WriteXY(x,y,(0b00100000+0b00010000));   
WriteData(0,(0b00100000+0b00010000));   
} 
}
}

unsigned char gotoxy(unsigned char x, unsigned y)
{
unsigned char CS, textCS;

if(x < 10)
{
CS=0b00100000;
textCS=0;
}
else
{
CS=0b00010000;
textCS=64;
}  
WriteXY(x*6-textCS+4,y,CS);

return CS;
}

void putc (unsigned char data, unsigned char inv)
{
unsigned char textL, CS=gotoxy(textx,texty);

if(data < 0x90)
{
textL=0x20;
}
else
{
textL=0x60;
}

WriteData((sym[data-textL][0])^inv,CS);
WriteData((sym[data-textL][1])^inv,CS);
WriteData((sym[data-textL][2])^inv,CS);
WriteData((sym[data-textL][3])^inv,CS);
WriteData((sym[data-textL][4])^inv,CS);
WriteData(0^inv,CS);

if(textx < 19)
{
textx++;
}
else
{
textx=0;
if(texty < 8)texty++;
}
}

void puts (unsigned char str[],unsigned char n,unsigned char inv)
{
unsigned char a;
for(a=0;(a<n);a++)
{
putc(str[a],inv);
}
}

unsigned char ReadData(unsigned char CS)
{
unsigned char data=0;
DDRD=0; 
(PORTB|=CS); 
(PORTB|=0b00000001);
(PORTB|=0b00000010);  
#asm("NOP"); 
#asm("NOP");  
(PORTB|=0b00000100);
#asm("NOP"); 
#asm("NOP"); 
data=PIND; 
(PORTB&=~0b00000100); 
delay_us(4);
(PORTB&=~(0b00100000+0b00010000));
(PORTB|=0b00000100);
DDRD=0xff;
delay_us(4); 
return data;
}             

void getc (unsigned char data[],unsigned char readx,unsigned ready)
{
unsigned char CS=gotoxy(readx,ready); 

ReadData(CS);
data[0]=ReadData(CS);
data[1]=ReadData(CS);
data[2]=ReadData(CS);
data[3]=ReadData(CS);
data[4]=ReadData(CS);
data[5]=ReadData(CS);
}                    

void DelCur(void)
{
unsigned char CS=gotoxy(curx,cury);

WriteData(ch[0],CS);
WriteData(ch[1],CS);
WriteData(ch[2],CS);
WriteData(ch[3],CS);
WriteData(ch[4],CS); 
}

void SetCur(unsigned char x, unsigned char y)
{
unsigned char CS;

DelCur();
curx=x;
cury=y;

CS=gotoxy(curx,cury);

getc(ch,x,y);

gotoxy(curx,cury);

WriteData(ch[0]|0x80,CS);
WriteData(ch[1]|0x80,CS);
WriteData(ch[2]|0x80,CS);
WriteData(ch[3]|0x80,CS);
WriteData(ch[4]|0x80,CS); 
}

void drawbar_l(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char max)
{
unsigned char i=x1;   
unsigned char j=x2;
max += x1-1;                      

WriteXY(x1-2, y1/8 - 1, 0b00100000);
WriteData(0b11000000,0b00100000);
WriteData(0b01000000,0b00100000);
WriteXY(x1-2, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);
WriteXY(x1-2, y1/8 + 1, 0b00100000);
WriteData(0b00000011,0b00100000);
WriteData(0b00000010,0b00100000);
WriteXY(x1, y1/8, 0b00100000);             

if (x2 >= 64)
j=64;    
else
{   
WriteXY(x1, y1/8, 0b00100000);             
i = x1;   
while (i < 64)
{
WriteData(0x00,0b00100000);
i++;            
}
} 

i = x1;        

WriteXY(i, y1/8, 0b00100000);   

while (i < j)
{
WriteData(0xFF,0b00100000);
i++;
}            

if (x2 >= 64)
{
i-=64;    
j=x2-64;
WriteXY(i, y1/8, 0b00010000);
while (i < j)
{            
WriteData(0xFF,0b00010000);
i++;
}         
} 
else
i = 0;            

WriteXY(i, y1/8, 0b00010000);    
while (i < max-64)
{
WriteData(0x00,0b00010000);
i++;            
}

if (max+2 < 64)
{
WriteXY(max+1, y1/8 - 1, 0b00100000);
WriteData(0b01000000,0b00100000);
WriteData(0b11000000,0b00100000);
WriteXY(max+2, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);
WriteXY(max+1, y1/8 + 1, 0b00100000);
WriteData(0b00000010,0b00100000);
WriteData(0b00000011,0b00100000);    
}            
else
{
WriteXY(max+1-64, y1/8 - 1, 0b00010000);
WriteData(0b01000000,0b00010000);
WriteData(0b11000000,0b00010000);
WriteXY(max+2-64, y1/8, 0b00010000);
WriteData(0xFF,0b00010000);
WriteXY(max+1-64, y1/8 + 1, 0b00010000);
WriteData(0b00000010,0b00010000);
WriteData(0b00000011,0b00010000);    
}
}

void drawbar_c(unsigned int x1, unsigned char y1, unsigned int x2, unsigned int max, unsigned char offset)
{
unsigned char k=x1+max/2-offset, i=x1;                     

WriteXY(x1-2, y1/8 - 1, 0b00100000);
WriteData(0b11000000,0b00100000);
WriteData(0b01000000,0b00100000);
WriteXY(x1-2, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);
WriteXY(x1-2, y1/8 + 1, 0b00100000);
WriteData(0b00000011,0b00100000);
WriteData(0b00000010,0b00100000);   

WriteXY(x1, y1/8, 0b00100000);         
while (i < 64)
{
WriteData(0x00,0b00100000);
i++;            
}                                

WriteXY(0, y1/8, 0b00010000);         
while (i < 128)
{
WriteData(0x00,0b00010000);
i++;            
} 

if (k<64)
{                                     
WriteXY(k, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);                       
}                 
else                        
{           
WriteXY(k-64, y1/8, 0b00010000);
WriteData(0xFF,0b00010000); 
}    

if (x2<64)
{
WriteXY(x2, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);
}                 
else                        
{
WriteXY(x2-64, y1/8, 0b00010000);
WriteData(0xFF,0b00010000);
}

if (max+2+x1 < 64)
{
WriteXY(max+1+x1, y1/8 - 1, 0b00100000);
WriteData(0b01000000,0b00100000);
WriteData(0b11000000,0b00100000);
WriteXY(max+2+x1, y1/8, 0b00100000);
WriteData(0xFF,0b00100000);
WriteXY(max+1+x1, y1/8 + 1, 0b00100000);
WriteData(0b00000010,0b00100000);
WriteData(0b00000011,0b00100000);    
}            
else
{
WriteXY(max+1-64+x1, y1/8 - 1, 0b00010000);
WriteData(0b01000000,0b00010000);
WriteData(0b11000000,0b00010000);
WriteXY(max+2-64+x1, y1/8, 0b00010000);
WriteData(0xFF,0b00010000);
WriteXY(max+1-64+x1, y1/8 + 1, 0b00010000);
WriteData(0b00000010,0b00010000);
WriteData(0b00000011,0b00010000);    
}
}

void rectangle(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
unsigned char i=0;

WriteXY(x1, y1, 0b00100000);
WriteData(0xFF,0b00100000);
for(i=x1+1; i<64; i++)    
WriteData(1,0b00100000);

WriteXY(0, y1, 0b00010000);
for(i=64; i<x2-1; i++)    
WriteData(1,0b00010000);
WriteData(0xFF,0b00010000); 

WriteXY(x1, y2-1, 0b00100000);
WriteData(0xFF,0b00100000);
for(i=x1+1; i<64; i++)    
WriteData(0x80,0b00100000);

WriteXY(0, y2-1, 0b00010000);
for(i=64; i<x2-1; i++)    
WriteData(0x80,0b00010000);
WriteData(0xFF,0b00010000);

for(i=y1; i<y2; i++)
{                          
WriteXY(x1, i, 0b00100000);
WriteData(0xFF,0b00100000);
WriteXY(x2-1-64, i, 0b00010000); 
WriteData(0xFF,0b00010000);       
}                            
}          

void clear_status(void)
{
unsigned char x;
for(x=0;x<64;x++)
{
WriteXY(x,0,(0b00100000+0b00010000));   
WriteData(0,(0b00100000+0b00010000));   
}
}

void clear_rec(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
unsigned char x,y;
for(x=x1;x<x2;x++)
{
for(y=y1;y<y2;y++)
{
WriteXY(x,y,(0b00100000+0b00010000));   
WriteData(0,(0b00100000+0b00010000));   
} 
}
}

void splash()
{
clear();                 

rectangle(0, 0, 128, 8);
delay_ms(50);      
rectangle(16, 1, 112, 7);
delay_ms(50);

clear();     

rectangle(16, 1, 112, 7);
delay_ms(50); 
rectangle(32, 2, 96, 6);
delay_ms(50);

clear();    

rectangle(32, 2, 96, 6);
delay_ms(50);
rectangle(48, 3, 80, 5);
delay_ms(50);  

clear();                 

rectangle(48, 3, 80, 5);
delay_ms(50);     
rectangle(63, 4, 64, 4);
delay_ms(50);    

clear();
rectangle(63, 4, 64, 4);
delay_ms(50);            

rectangle(48, 3, 80, 5);
delay_ms(50);       

clear();        

rectangle(48, 3, 80, 5);
delay_ms(50);      
rectangle(32, 2, 96, 6);
delay_ms(50);             

clear();            

rectangle(32, 2, 96, 6);
delay_ms(50);      
rectangle(16, 1, 112, 7);
delay_ms(50);        

clear();   

rectangle(16, 1, 112, 7);
delay_ms(50);   
rectangle(0, 0, 128, 8);
delay_ms(50);    

clear();

rectangle(0, 0, 128, 8);
delay_ms(100);

clear();

delay_ms(500);    
}

void SetAll(unsigned char vol,unsigned char bas,unsigned char tre,unsigned char mute,unsigned char out,unsigned char in)
{

unsigned char c=0b11000000;
(c|=vol);
i2c_start();
i2c_write(0b10000010);         
i2c_write(0b00000000);
i2c_write(c);
i2c_write(0b10000010);         
i2c_write(0b00000001);
i2c_write(c);  
i2c_stop();

c=0b11110000;
(c|=bas); 
i2c_start();
i2c_write(0b10000010);         
i2c_write(0b00000010);
i2c_write(c);
i2c_stop();

c=0b11110000;
(c|=tre);  
i2c_start();
i2c_write(0b10000010);         
i2c_write(0b00000011);
i2c_write(c);   
i2c_stop();

c = 0b11000000;
if (mute) (c|=0b00100000);
(c|=out<<3);
(c|=in);    
i2c_start();
i2c_write(0b10000010);         
i2c_write(0b00001000);
i2c_write(c);
i2c_stop();       
}

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float ftrunc(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

flash int Sinus[40]={0 , 50 , 98 , 142 , 181 , 213 , 237 , 251, 255 , 251 , 237 , 213 , 181 , 142 , 98 , 50, 0 , -50 , -98 , -142 , -181 , -213 , -237 , -251, -255 , -251 , -237 , -213 , -181 , -142 , -98 , -50, 0 , 50 , 98 , 142 , 181 , 213 , 237 , 251};

flash unsigned char Okno[32]={0 , 3 , 10 , 23 , 40 , 60 , 84 , 109 , 134 , 160 , 184 , 206 , 225 , 240 , 250 , 255 , 255 , 250 , 240 , 225 , 206 , 184 , 160 , 134 , 109 , 84 , 60 , 40 , 23 , 10 , 3 , 0};

flash unsigned char L1[17]={0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF};

flash unsigned char L2[17]={0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF};

unsigned char K;
unsigned char I;
int Tmp_s;
int Tmp_c;
unsigned int Beta;
unsigned int Suma;
unsigned char Sam;
bit Sampling;
int Rex_t, Imx_t;
int Data[32];
unsigned int Sample_h[32];
unsigned int Sample_l[32];

int Rex[16];

unsigned char Result[16], Result_o[16];
float Sing;
int Level;
unsigned char Line1d[16];
unsigned char Line2d[16];
unsigned char Falloff_count[16];     
unsigned int maxl = 0;

void ARU()
{
for(I = 0; I < 32; I++)
{
Sample_h[I] = Sample_h[I]*(1024/maxl);
Sample_l[I] = Sample_l[I]*(1024/maxl);
}
}

unsigned int Getadc(unsigned char adc_input)
{                                       
ADMUX=adc_input | (0b01000000 & 0xff);

delay_us(10);   

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;              
}

interrupt [7] void timer1_compa_isr(void)
{
TCNT1 = 0;       

Sam++;                            

(TIMSK&=~0b00010000);
Sample_h[Sam-1] = Getadc(0);                       
if (Sample_h[Sam-1] > maxl)
maxl = Sample_h[Sam-1];    

(TIMSK|=0b00010000);
if (Sam == 32)
{
(TIMSK&=~0b00010000);   
Sampling = 0;
}    
}

interrupt [8] void timer1_compb_isr(void)
{
TCNT1 = 0;   

Sam++;            

(TIMSK&=~0b00001000);
Sample_l[Sam-1] = Getadc(1); 
if (Sample_l[Sam-1] > maxl)
maxl = Sample_l[Sam-1];                       
(TIMSK|=0b00001000);
if (Sam == 32)
{
(TIMSK&=~0b00001000);  
Sampling = 0;
}         
}

void Sample_h_()
{

ADCSRA=0b10000010;        
delay_us(10);

ADCSRA|=0x40;

TCNT1 = 0;
(TIMSK|=0b00010000);     
Sam = 0;
Sampling = 1;
}

void Sample_l_()
{

ADCSRA=0b10000010;     
delay_us(10);

ADCSRA|=0x40;

TCNT1 = 0;
(TIMSK|=0b00001000);    
Sam = 0;
Sampling = 1;
}

void Copy_high()
{
Level = 0;

for (K = 1; K<=32; K++)         
{
Sample_h[K-1] = Sample_h[K-1] >> 2;
Level = Level + Sample_h[K-1];
}

Level = Level >> 5;

for (K = 1; K<=32; K++) 
{
Data[K-1] = Sample_h[K-1] - Level;
Data[K-1] = Data[K-1] * Okno[K-1];
Data[K-1] = Data[K-1] >> 8;

if (Data[K-1] > 127) 
Data[K-1] = 127;
if (Data[K-1] < -127)
Data[K-1] = -127;
}
}

void Copy_low()
{
Level = 0;

for (K = 1; K<=32; K++)         
{
Sample_l[K-1] = Sample_l[K-1] >> 2;
Level = Level + Sample_l[K-1];
}

Level = Level >> 5;

for (K = 1; K<=32; K++) 
{
Data[K-1] = Sample_l[K-1] - Level;
Data[K-1] = Data[K-1] * Okno[K-1];
Data[K-1] = Data[K-1] >> 8;

if (Data[K-1] > 127) 
Data[K-1] = 127;
if (Data[K-1] < -127)
Data[K-1] = -127;
}
}

void DFT()   
{            
for (K = 1; K<= 15; K++)
{        
Rex_t = 0;            
Imx_t = 0;            

for (I = 0; I<=31; I++)
{
Beta = I * K;
Beta = Beta & 31;  
Tmp_s = Sinus[Beta] * Data[I];      
Tmp_c = Sinus[Beta + 7] * Data[I];  

Tmp_s = Tmp_s >> 8;  

Tmp_c = Tmp_c >> 8;

Rex_t = Rex_t + Tmp_c; 
Imx_t = Imx_t - Tmp_s;
}

Rex_t = Rex_t >> 3;

Imx_t = Imx_t >> 3;            

Tmp_c = Rex_t * Rex_t;      
Tmp_s = Imx_t * Imx_t;      

Tmp_c = Tmp_c + Tmp_s;      
Rex[K] = isqrt(Tmp_c);      
}
}

void Calculate_high()          
{
Suma = Rex[3-1];
Result[9-1] = Suma;

Suma = Rex[4-1];
Result[10-1] = Suma;

Suma = Rex[5-1];
Result[11-1] = Suma;

Suma = Rex[6-1];
Result[12-1] = Suma;

Suma = Rex[7-1];
if (Rex[8-1] > Suma)
Suma = Rex[8-1];
Result[13-1] = Suma;

Suma = Rex[9-1];
if (Rex[10-1] > Suma)
Suma = Rex[10-1];
Result[14-1] = Suma;

Suma = Rex[11-1];
if (Rex[12-1] > Suma)
Suma = Rex[12-1];
if (Rex[13-1] > Suma)
Suma = Rex[13-1];
Result[15-1] = Suma;

Suma = Rex[14-1];
if (Rex[15-1] > Suma)
Suma = Rex[15-1];
if (Rex[16-1] > Suma)
Suma = Rex[16-1];
Result[16-1] = Suma;
}

void Calculate_low()         
{
Suma = Rex[2-1];
Result[1-1] = Suma;

Suma = Rex[3-1];
Result[2-1] = Suma;

Suma = Rex[4-1];
Result[3-1] = Suma;

Suma = Rex[5-1];
if (Rex[6-1] > Suma)
Suma = Rex[6-1];
Result[4-1] = Suma;

Suma = Rex[7-1];
if (Rex[8-1] > Suma)
Suma = Rex[8-1];
Result[5-1] = Suma;

Suma = Rex[9-1];
if (Rex[10-1] > Suma)
Suma = Rex[10-1];
Result[6-1] = Suma;

Suma = Rex[11-1];
if (Rex[12-1] > Suma)
Suma = Rex[12-1];
if (Rex[13-1] > Suma)
Suma = Rex[13-1];
Result[7-1] = Suma;

Suma = Rex[14-1];
if (Rex[15-1] > Suma)
Suma = Rex[15-1];
if (Rex[16-1] > Suma)
Suma = Rex[16-1];
Result[8-1] = Suma;
}

void Save()
{
for (K = 1; K<=16; K++)
{
Sing = Result[K-1] * 0.1;

Sing = log10(Sing);

Sing = 40 * Sing;
Tmp_c = Sing+ 8 -(40 * 0.4);   

if (Tmp_c < 0)
Tmp_c = 0;
if (Tmp_c > 16)
Tmp_c = 16;

Result[K-1] = Tmp_c;

if (Result[K-1] > Result_o[K-1])
Result_o[K-1] = Result[K-1];
else
{
if (Falloff_count[K-1] == 1)
{
if (Result_o[K-1] > 0)
Result_o[K-1]--;
Falloff_count[K-1] = 0;
}
Falloff_count[K-1]++;
}

Line1d[K-1] = L1[Result_o[K-1]];
Line2d[K-1] = L2[Result_o[K-1]];

}              

WriteXY(0, 6, 0b00100000);
for(I=0; I<8; I++)
for(K=0; K<8; K++)
WriteData(Line1d[I],0b00100000); 

WriteXY(0, 6, 0b00010000);
for(I=8; I<16; I++)
for(K=0; K<8; K++)
WriteData(Line1d[I],0b00010000);  

WriteXY(0, 7, 0b00100000);
for(I=0; I<8; I++)
for(K=0; K<8; K++)
WriteData(Line2d[I],0b00100000);
WriteXY(0, 7, 0b00010000);
for(I=8; I<16; I++)
for(K=0; K<8; K++)
WriteData(Line2d[I],0b00010000);  
}                              

unsigned char vol=60;
unsigned int bas=15/2;
unsigned int tre=15/2;           
unsigned char mode=0;
unsigned char in=0b00000110;
unsigned char out=0b00000001;  

char *l_on="Вкл";
char *l_stby="Ожидание";
char *l_poff="Выкл";
char *l_vol="Громкость";
char *l_bas="Низкие";
char *l_tre="Высокие";
char *l_out="Выход";
char *l_in= "Вход";
char *l_chanel1="Канал 1";
char *l_chanel2="Канал 2";
char *l_chanelA="А";
char *l_chanelB="Б";
char *l_p_stereo="Псевдо стерео";
char *l_mono="Моно";
char *l_stereo="Стерео";
char *l_s_stereo="Расширен.стерео";
char *l_clip = "ПЕРЕГРУЗ!!!";   
char *l_prot = "Настройки";
char *l_prot_poff = "Откл. УМ";
char *l_prot_ac = "Откл. АС";
char *l_prot_clip = "Clip детектор";
char *l_prot_SA = "Анализ.спектра";
unsigned char prot_stat = 0b00000000;
unsigned char rewrite = 0;
bit dir = 0;
bit up = 0;
bit down = 0; 
bit lock=0;  
bit lock_k=0;
bit mn = 0;
bit mute = 0;
bit lock_d = 0;

void draw_stby()
{
unsigned char i=0;

clear_status(); 
if (mn && mode != 255)
{
clear_rec(0, 1, 64, 8);
mn = 0;
}
if (!!(PINA&0b00000100) && !!(PINB&0b01000000))
{   
textx=0;
texty=0;
puts(l_on,3,0);
}
if (!(PINA&0b00000100) && !!(PINB&0b01000000))
{                     
clear();
textx=0;
texty=0;
puts(l_stby,8,0);
}
if (!(PINB&0b01000000))
{
clear();
textx=0;
texty=0;
puts(l_poff,4,0);
}

if (mode != 0x86)
{                    
if (out)
{                                  
if (out == 0b00000010)
{                              
WriteXY(119-64-32, 0, 0b00010000);
for(i=21; i<28; i++)    
WriteData(s_out[i],0b00010000);
}                    

if (out == 0b00000011)
{                              
WriteXY(119-64-32, 0, 0b00010000);
for(i=14; i<21; i++)    
WriteData(s_out[i],0b00010000);
}

WriteXY(119-64-24, 0, 0b00010000);
for(i=7; i<14; i++)    
WriteData(s_out[i],0b00010000);
}
else
{
WriteXY(119-64-24, 0, 0b00010000);
for(i=0; i<7; i++)    
WriteData(s_out[i],0b00010000);
}
}  

if (mode != 0x85)
{               
WriteXY(119-64-16, 0, 0b00010000);
for(i=((in%2)*5); i<(5+(in%2)*5); i++)    
WriteData(s_in[i],0b00010000);
if (in<6 && in>3)
{ 
WriteXY(119-64-8, 0, 0b00010000);
for(i=0; i<5; i++)    
WriteData(s_inc[i],0b00010000);
}        
if (in<4 && in>1)
{ 
WriteXY(119-64-8, 0, 0b00010000);
for(i=5; i<10; i++)    
WriteData(s_inc[i],0b00010000);
}
}        

if (mute)
{               
WriteXY(119-64, 0, 0b00010000);
for(i=0; i<8; i++)    
WriteData(s_mute[i],0b00010000);        
}

if (!(PINA&0b00010000))
{
WriteXY(63-6, 0, 0b00100000);
for(i=0; i<6; i++)    
WriteData(s_clip[i],0b00100000);
}            

WriteXY(0, 1, 0b00100000);
for(i=0; i<64; i++)    
WriteData(1,0b00100000);       
WriteXY(0, 1, 0b00010000);
for(i=0; i<64; i++)    
WriteData(1,0b00010000);
}

void call(unsigned char dir)
{
draw_stby(); 

if (!(mode&0x80) && mode) 
{                    

WriteXY(0, mode, 0b00100000);           
delay_ms(1);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);

if (dir == 1)
mode++;
if (dir == 0)
mode--;  

if (mode > 7)
mode = 7;
if (mode < 2)
mode = 2;               

textx=1;texty=2;puts(l_vol, 9, 0);
textx=1;texty=3;puts(l_bas, 6, 0);
textx=1;texty=4;puts(l_tre, 7, 0);
textx=1;texty=5;puts(l_in, 4, 0);
textx=1;texty=6;puts(l_out, 5, 0);
textx=1;texty=7;puts(l_prot, 9, 0);

WriteXY(0, mode, 0b00100000);           
delay_ms(1);
WriteData(0x81, 0b00100000);
WriteData(0x42, 0b00100000);
WriteData(0x24, 0b00100000);
WriteData(0x18, 0b00100000);        
}        

if (mode==0x82 || !mode || dir > 9)
{
if (dir == 1 || dir == 11)
vol++;
if (dir == 0 || dir == 10)
vol--;        

if (vol > 63)
vol = 63;
else
if (vol < 1)
vol = 1;
else
(rewrite|=0x01);        

SetAll(vol, bas, tre, mute, out, in);                                

if (dir <= 3)
{
textx=5;
texty=2;
puts(l_vol,9,0);     

drawbar_l(17, 32, 17+(vol-1)*3/2, (63-1)*3/2); 
}
}                

if (mode == 0x83)
{                
if (dir == 1)
bas++;
if (dir == 0)
bas--;  

if (bas > 15)
bas = 15;
else
if (bas < 1)
bas = 1;
else     
(rewrite|=0x02);     

SetAll(vol, bas, tre, mute, out, in);

textx=5;
texty=2;
puts(l_bas,6,0);     

drawbar_c(17, 32, 17+(bas)*3*63/2/15, (63)*3/2, 3);     
}

if (mode == 0x84)
{           
if (dir == 1)
tre++;
if (dir == 0)
tre--;   

if (tre > 15)
tre = 15;
else
if (tre < 1)
tre = 1;     
else                                 
(rewrite|=0x04);

SetAll(vol, bas, tre, mute, out, in);

textx=5;
texty=2;
puts(l_tre,7,0);     

drawbar_c(17, 32, 17+(tre)*3*63/2/15, (63)*3/2, 3);          
} 

if (mode == 0x85)
{                       

WriteXY(0, in, 0b00100000);           
delay_ms(1);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);

if (dir == 1)
in++;
if (dir == 0)
in--;   

if (in > 0b00000111)
in = 0b00000111;
else
if (in < 0b00000010)
in = 0b00000010;
else
(rewrite|=0x08); 

SetAll(vol, bas, tre, mute, out, in);          

textx=1;texty=2;puts(l_chanel1,7,0);textx=9;texty=2;puts(l_chanelA,1,0);
textx=1;texty=3;puts(l_chanel2,7,0);textx=9;texty=3;puts(l_chanelA,1,0);
textx=1;texty=4;puts(l_chanel1,7,0);textx=9;texty=4;puts(l_chanelB,1,0);
textx=1;texty=5;puts(l_chanel2,7,0);textx=9;texty=5;puts(l_chanelB,1,0);
textx=1;texty=6;puts(l_chanel1,7,0);                                     
textx=1;texty=7;puts(l_chanel2,7,0);

WriteXY(0, in, 0b00100000);           
delay_ms(1);
WriteData(0x81, 0b00100000);
WriteData(0x42, 0b00100000);
WriteData(0x24, 0b00100000);
WriteData(0x18, 0b00100000);                  
}

if (mode == 0x86)
{                

WriteXY(0, out+2, 0b00100000);           
delay_ms(1);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);

if (dir == 1)
{
(rewrite|=0x10);
out++;
}
if (dir == 0 && out)
{   
(rewrite|=0x10);
out--;   
}

if (out > 0b00000011)
{
out = 0b00000011;                       
(rewrite&=~0x10);
}   

SetAll(vol, bas, tre, mute, out, in);             

textx=1;texty=2;puts(l_mono,4,0);
textx=1;texty=3;puts(l_stereo,6,0);
textx=1;texty=4;puts(l_p_stereo,13,0);
textx=1;texty=5;puts(l_s_stereo,15,0);

WriteXY(0, out+2, 0b00100000);           
delay_ms(1);
WriteData(0x81, 0b00100000);
WriteData(0x42, 0b00100000);
WriteData(0x24, 0b00100000);
WriteData(0x18, 0b00100000);      
}   

if (mode >= 0x87)
{                 
unsigned char i=0;
bit j=0; 

WriteXY(0, (mode << 1 >> 5) + 2, 0b00100000);           
delay_ms(1);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);
WriteData(0x00, 0b00100000);

if (dir == 1 && mode < 0xB7)
mode += 0x10;
if (dir == 0 && mode > 0x87)
mode -= 0x10;

if (dir == 5)
{                 

unsigned char z = 1 << (mode << 1 >> 5);
(rewrite|=0x20); 
if ((prot_stat&z))
(prot_stat&=~z);
else
(prot_stat|=z);
}                

if ((prot_stat&0b00000001))
j = 1;
else
j = 0;   

WriteXY(7, 2, 0b00100000); 
for(i = j*6; i < 6+j*6; i++)
WriteData(s_chbox[i], 0b00100000);

if ((prot_stat&0b00000010))
j = 1;
else
j = 0;   

WriteXY(7, 3, 0b00100000); 
for(i = j*6; i < 6+j*6; i++)
WriteData(s_chbox[i], 0b00100000);   

if ((prot_stat&0b00000100))
j = 1;
else
j = 0;   

WriteXY(7, 4, 0b00100000); 
for(i = j*6; i < 6+j*6; i++)
WriteData(s_chbox[i], 0b00100000);

if ((prot_stat&0b00001000))
j = 1;
else
j = 0;   

WriteXY(7, 5, 0b00100000); 
for(i = j*6; i < 6+j*6; i++)
WriteData(s_chbox[i], 0b00100000);                

textx=2;texty=2;puts(l_prot_poff,8,0);
textx=2;texty=3;puts(l_prot_ac,8,0);
textx=2;texty=4;puts(l_prot_clip,13,0);
textx=2;texty=5;puts(l_prot_SA,14,0);

WriteXY(0, (mode << 1 >> 5) + 2, 0b00100000);           
delay_ms(1);
WriteData(0x81, 0b00100000);
WriteData(0x42, 0b00100000);
WriteData(0x24, 0b00100000);
WriteData(0x18, 0b00100000);      
}    
}

void scroll()
{
bit p1 = (PINA&0b01000000);
bit p2 = (PINA&0b10000000);                    

if (p1 > p2 && !lock)
{           
if (!dir)
{
up = 1;   
down = 0; 
call(1);
}
else
{
down = 1;
up=0;   
call(0);
} 
lock = 1;   
}       

if (p1 < p2 && !lock)
{           
if (dir)
{
up = 1;
down = 0;  
call(1);
}
else
{
down = 1;
up = 0; 
call(0);
}      
lock = 1;   
}

if (p1 == p2)
{
dir = p1;
up = 0;
down = 0;   
lock  =0;   
}  
}

void power_on()
{  
splash();
}

void write_eeprom()
{              
rewrite = 0;
}

void key_hook()
{
if (!(PINC&0b00100000) && !lock_k) 
{
call(1);   
TIMSK = 0;            
lock_k=1;
}            
if (!(PINC&0b10000000) && !lock_k)
{
call(0); 
TIMSK = 0;              
lock_k=1;
}

if(!(PINC&0b00000100) && mode && !lock_k)
{                           
if (mode < 0x87)
{
mn = 1;
(mode|=0b10000000);
call(3);
}           
else
call(5);    
lock_k=1;
}            

if (!(PINC&0b01000000) && !mode && !lock_k)
{         
clear();
mn = 1;        
mode = 2;
call(4);               
lock_k=1;
}                                   
if (!(PINC&0b00001000) && !(mode&0b10000000) && !lock_k)
{       
mn = 1;
mode = 0;
draw_stby();               
lock_k=1;
write_eeprom();
}
if (!(PINC&0b00001000) && (mode&0b10000000) && !lock_k)
{          
mn = 1;     
(mode&=~0b10110000);
call(4);               
lock_k=1;
}             
if (!(PINC&0b00010000) && !lock_k)
{
mute = !mute;
if (!mode)
draw_stby();
else
call(4);
SetAll(vol, bas, tre, mute, out, in);

if (mute)
(PORTA&=~0b00001000);
else
(PORTA|=0b00001000);

lock_k=1;  
}                 

if(!(PINA&0b00100000) && !lock_k)
{               
if (!!(PINA&0b00000100))                  
{
(PORTA&=~0b00000100);
(rewrite|=0x01);
if(!mode)
write_eeprom();
}
else
(PORTA|=0b00000100);

if (!mode)
draw_stby();
else
call(4);

lock_k=1;   
}

if ((PINC>>2 << 2) == 0b11111100 && (PINA&0b00100000))
{
lock_k=0;
}        

if (!(PINA&0b00010000) && (prot_stat&0b00000100))
{
if (vol > 1)
call(10);
else         
if (!mute)          
{
mute = 1;
(PORTA&=~0b00001000);                
}
else
if  (!!(PINA&0b00000100))  
{
(PORTA&=~0b00000100);
}                        
else
{       
if((prot_stat&0b00000010) && !(PINB&0b10000000))
{
(PORTB|=0b10000000);    
}
if (!!(PINB&0b01000000) && (prot_stat&0b00000001)) 
{          
(PORTB&=~0b01000000);
}

{              
mn = 1;
draw_stby();
mode = 255;
textx = 5;
texty = 4;
puts(l_clip, 11, 0);                        
}
}    
lock_d = 0; 
}            
else    
if (!lock_d)
{        
if (mode == 255)
{
mode = 0;
mn = 1;
}
call(4);
lock_d = 1;
}
}

void main(void)
{

DDRA=0b00001111;
DDRB=0xFF;
DDRC=0b00000011;
DDRD=0xFF;

PORTA = 0b11110000; 

PORTB=0x00;        
PORTC=0xFF;
PORTD=0;      

TCCR1A=0x00;
TCCR1B=0x01;
TCNT1=0x00;     

OCR1A=8000000 / 44000;
OCR1B=8000000 / 200; 

TIMSK=0x00;

init_lcd(); 
delay_ms(10);      

power_on(); 

i2c_init();              

SetAll(vol, bas, tre, mute, out, in);

draw_stby(); 

ADCSRA=0b10000010;
ADMUX=0b01000000;        

#asm("sei");       

(PORTB|=0b01000000);
delay_ms(1000);
(PORTB&=~0b10000000);
delay_ms(100);
(PORTA|=0b00000100);
delay_ms(100);
(PORTA|=0b00001000);

ADCSRA|=0x40;

while(1)
{             
if((prot_stat&0b00001000))
{      
maxl=0;
if(!mode)
{
Sample_h_();
while(Sampling == 1);

scroll();   
key_hook();  
delay_ms(20);
}
if(!mode)
{                    
Sample_l_();  
while(Sampling == 1);

scroll();   
key_hook();  
delay_ms(20);
}
if(!mode)
{
ARU();       

scroll();   
key_hook();    
delay_ms(20);
}
if(!mode)
{
Copy_low();

scroll();   
key_hook();    
delay_ms(20);
}
if(!mode)
{         
DFT();

scroll();   
key_hook();      
delay_ms(20);            
}
if(!mode)
{
Calculate_low(); 

scroll();   
key_hook();   
delay_ms(20);
}
if(!mode)
{    
Copy_high();

scroll();   
key_hook();       
delay_ms(20);
}
if(!mode)
{    
DFT();

scroll();   
key_hook();    
delay_ms(20);
}
if(!mode)
{       
Calculate_high();

scroll();   
key_hook();   
delay_ms(20);      
}
if(!mode)
{          
Save();

scroll();   
key_hook();  
delay_ms(20);
}
else
{
scroll();   
key_hook();
delay_ms(20);
}      
}      
else
{
scroll();   
key_hook();
delay_ms(20);
}
}
}
