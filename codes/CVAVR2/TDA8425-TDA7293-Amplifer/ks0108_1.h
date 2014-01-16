//#include <string.h>
#include "symvol1.h"

unsigned char 
		 textx, 
		 texty,		 
		 curx,
		 cury,
		 ch[6];		 			

void WriteCom(unsigned char Com,unsigned char CS)
{ 
 SetBit(LCD_COM,CS); 
 ClrBit(LCD_COM,LCD_RS);
 ClrBit(LCD_COM,LCD_RW);
 #asm("NOP"); 
 #asm("NOP");
 LCD_DB=Com;
 SetBit(LCD_COM,LCD_E);
#asm("NOP");
#asm("NOP"); 
 ClrBit(LCD_COM,LCD_E);
 delay_us(4); 
 ClrBit(LCD_COM,(LCD_CS1+LCD_CS2));
 SetBit(LCD_COM,LCD_E);
}

void WriteData(unsigned char data,unsigned char CS)
{ 
 SetBit(LCD_COM,CS); 
 SetBit(LCD_COM,LCD_RS);
 ClrBit(LCD_COM,LCD_RW); 
 #asm("NOP"); 
 #asm("NOP");
 LCD_DB=data;
 SetBit(LCD_COM,LCD_E);
 #asm("NOP");
 #asm("NOP");  
 ClrBit(LCD_COM,LCD_E);
 delay_us(4);
 ClrBit(LCD_COM,(LCD_CS1+LCD_CS2));
 SetBit(LCD_COM,LCD_E);
}

void WriteXY(unsigned char x,unsigned char y,const unsigned char CS)
{ 
 WriteCom(0xb8+y,CS);
 WriteCom(0x40+x,CS);
}

void init_lcd(void)
{ 
 SetBit(LCD_COM,LCD_RST);
 delay_ms(5);  
 WriteXY(0,0,(LCD_CS1+LCD_CS2));
 WriteCom(0xc0,(LCD_CS1+LCD_CS2));
 WriteCom(0x3f,(LCD_CS1+LCD_CS2));  
}

void clear(void)
{
 unsigned char x,y;
 for(x=0;x<64;x++)
 {
  for(y=0;y<8;y++)
  {
   WriteXY(x,y,(LCD_CS1+LCD_CS2));   
   WriteData(0,(LCD_CS1+LCD_CS2));   
  } 
 }
}

unsigned char gotoxy(unsigned char x, unsigned y)
{
 unsigned char CS, textCS;
 
 if(x < 10)
 {
  CS=LCD_CS1;
  textCS=0;
 }
 else
 {
  CS=LCD_CS2;
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
 for(a=0;(a<n)/*&&(a<strlen(str))*/;a++)
 {
  putc(str[a],inv);
 }
}
     
unsigned char ReadData(unsigned char CS)
{
 unsigned char data=0;
 LCD_IO=0; 
 SetBit(LCD_COM,CS); 
 SetBit(LCD_COM,LCD_RS);
 SetBit(LCD_COM,LCD_RW);  
 #asm("NOP"); 
 #asm("NOP");  
 SetBit(LCD_COM,LCD_E);
 #asm("NOP"); 
 #asm("NOP"); 
 data=LCD_DBI; 
 ClrBit(LCD_COM,LCD_E); 
 delay_us(4);
 ClrBit(LCD_COM,(LCD_CS1+LCD_CS2));
 SetBit(LCD_COM,LCD_E);
 LCD_IO=0xff;
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