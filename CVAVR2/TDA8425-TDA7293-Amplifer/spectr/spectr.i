
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

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

flash int Sinus[40]={0 , 50 , 98 , 142 , 181 , 213 , 237 , 251, 255 , 251 , 237 , 213 , 181 , 142 , 98 , 50, 0 , -50 , -98 , -142 , -181 , -213 , -237 , -251, -255 , -251 , -237 , -213 , -181 , -142 , -98 , -50, 0 , 50 , 98 , 142 , 181 , 213 , 237 , 251};

flash unsigned char Okno[32]={0 , 3 , 10 , 23 , 40 , 60 , 84 , 109 , 134 , 160 , 184 , 206 , 225 , 240 , 250 , 255 , 255 , 250 , 240 , 225 , 206 , 184 , 160 , 134 , 109 , 84 , 60 , 40 , 23 , 10 , 3 , 0};

flash unsigned char L1[17]={0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF};

flash unsigned char L2[17]={0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF};

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

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
for(a=0;(a<n)&&(a<strlen(str));a++)
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

void ARU_h()
{
for(I = 0; I < 32; I++)
Sample_h[I] = Sample_h[I]*(1024/maxl);
}

void ARU_l()
{
for(I = 0; I < 32; I++)
Sample_l[I] = Sample_l[I]*(1024/maxl);
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

void main()
{
DDRA=0x00;
DDRB=0xFF;
DDRC=0b00000011;
DDRD=0xFF;

PORTA=0b11000000;
PORTB=0;        
PORTC=0xFF;
PORTD=0;

TCCR1A=0x00;
TCCR1B=0x01;
TCNT1=0x00;     

OCR1A=8000000 / 44000;
OCR1B=8000000 / 200; 

TIMSK=0x00;        

init_lcd(); 

clear(); 

ADCSRA=0b10000010;
ADMUX=0b01000000;   

#asm("sei");

ADCSRA|=0x40;

while(1)
{                              
Sample_h_();
while(Sampling == 1); 

ARU_h();

Sample_l_();  
while(Sampling == 1);

ARU_l();       

Copy_low();             

DFT();                  

Calculate_low();
Copy_high();
DFT();   
Calculate_high();         

Save();       
}
}
