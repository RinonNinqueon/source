
void WriteCom(unsigned char Com,unsigned char CS)
{ 
 SetBit(LCD_COM,CS); 
 ClrBit(LCD_COM,LCD_RS);
 ClrBit(LCD_COM,LCD_RW);
 //NOP(); 
 //NOP();
 LCD_DB=Com;
 SetBit(LCD_COM,LCD_E);
// NOP();
// NOP(); 
 ClrBit(LCD_COM,LCD_E);
 delay_us(4); 
 ClrBit(LCD_COM,(LCD_CS1+LCD_CS2));
 //SetBit(LCD_COM,LCD_E);
}

void WriteData(unsigned char data,unsigned char CS)
{ 
 SetBit(LCD_COM,CS); 
 SetBit(LCD_COM,LCD_RS);
 ClrBit(LCD_COM,LCD_RW); 
 //NOP(); 
 //NOP();
 LCD_DB=data;
 SetBit(LCD_COM,LCD_E);
 //NOP();
 //NOP();  
 ClrBit(LCD_COM,LCD_E);
 delay_us(4);
 ClrBit(LCD_COM,(LCD_CS1+LCD_CS2));
 //SetBit(LCD_COM,LCD_E);
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
