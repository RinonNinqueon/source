#include "delay.h"
#include "ks0108_1.h"

void drawbar_l(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char max)
{
    unsigned char i=x1;   
    unsigned char j=x2;
    max += x1-1;                      
                              
    WriteXY(x1-2, y1/8 - 1, LCD_CS1);
    WriteData(0b11000000,LCD_CS1);
    WriteData(0b01000000,LCD_CS1);
    WriteXY(x1-2, y1/8, LCD_CS1);
    WriteData(0xFF,LCD_CS1);
    WriteXY(x1-2, y1/8 + 1, LCD_CS1);
    WriteData(0b00000011,LCD_CS1);
    WriteData(0b00000010,LCD_CS1);
    WriteXY(x1, y1/8, LCD_CS1);             
             
    if (x2 >= 64)
        j=64;    
    else
    {   
        WriteXY(x1, y1/8, LCD_CS1);             
        i = x1;   
        while (i < 64)
        {
            WriteData(0x00,LCD_CS1);
            i++;            
        }
    } 
    
    i = x1;        
    
    WriteXY(i, y1/8, LCD_CS1);   
        
    while (i < j)
    {
        WriteData(0xFF,LCD_CS1);
        i++;
    }            
                     
    if (x2 >= 64)
    {
        i-=64;    
        j=x2-64;
        WriteXY(i, y1/8, LCD_CS2);
        while (i < j)
        {            
            WriteData(0xFF,LCD_CS2);
            i++;
        }         
    } 
    else
        i = 0;            

    WriteXY(i, y1/8, LCD_CS2);    
    while (i < max-64)
    {
        WriteData(0x00,LCD_CS2);
        i++;            
    }
    
    if (max+2 < 64)
    {
        WriteXY(max+1, y1/8 - 1, LCD_CS1);
        WriteData(0b01000000,LCD_CS1);
        WriteData(0b11000000,LCD_CS1);
        WriteXY(max+2, y1/8, LCD_CS1);
        WriteData(0xFF,LCD_CS1);
        WriteXY(max+1, y1/8 + 1, LCD_CS1);
        WriteData(0b00000010,LCD_CS1);
        WriteData(0b00000011,LCD_CS1);    
    }            
    else
    {
        WriteXY(max+1-64, y1/8 - 1, LCD_CS2);
        WriteData(0b01000000,LCD_CS2);
        WriteData(0b11000000,LCD_CS2);
        WriteXY(max+2-64, y1/8, LCD_CS2);
        WriteData(0xFF,LCD_CS2);
        WriteXY(max+1-64, y1/8 + 1, LCD_CS2);
        WriteData(0b00000010,LCD_CS2);
        WriteData(0b00000011,LCD_CS2);    
    }
}

void drawbar_c(unsigned int x1, unsigned char y1, unsigned int x2, unsigned int max, unsigned char offset)
{
    unsigned char k=x1+max/2-offset, i=x1;                     
                              
    WriteXY(x1-2, y1/8 - 1, LCD_CS1);
    WriteData(0b11000000,LCD_CS1);
    WriteData(0b01000000,LCD_CS1);
    WriteXY(x1-2, y1/8, LCD_CS1);
    WriteData(0xFF,LCD_CS1);
    WriteXY(x1-2, y1/8 + 1, LCD_CS1);
    WriteData(0b00000011,LCD_CS1);
    WriteData(0b00000010,LCD_CS1);   
    
    WriteXY(x1, y1/8, LCD_CS1);         
    while (i < 64)
    {
        WriteData(0x00,LCD_CS1);
        i++;            
    }                                
    
    WriteXY(0, y1/8, LCD_CS2);         
    while (i < 128)
    {
        WriteData(0x00,LCD_CS2);
        i++;            
    } 
    
    if (k<64)
    {                                     
        WriteXY(k, y1/8, LCD_CS1);
        WriteData(0xFF,LCD_CS1);                       
    }                 
    else                        
    {           
        WriteXY(k-64, y1/8, LCD_CS2);
        WriteData(0xFF,LCD_CS2); 
    }    
    
    //draw                  
    if (x2<64)
    {
        WriteXY(x2, y1/8, LCD_CS1);
        WriteData(0xFF,LCD_CS1);
    }                 
    else                        
    {
        WriteXY(x2-64, y1/8, LCD_CS2);
        WriteData(0xFF,LCD_CS2);
    }
    
    if (max+2+x1 < 64)
    {
        WriteXY(max+1+x1, y1/8 - 1, LCD_CS1);
        WriteData(0b01000000,LCD_CS1);
        WriteData(0b11000000,LCD_CS1);
        WriteXY(max+2+x1, y1/8, LCD_CS1);
        WriteData(0xFF,LCD_CS1);
        WriteXY(max+1+x1, y1/8 + 1, LCD_CS1);
        WriteData(0b00000010,LCD_CS1);
        WriteData(0b00000011,LCD_CS1);    
    }            
    else
    {
        WriteXY(max+1-64+x1, y1/8 - 1, LCD_CS2);
        WriteData(0b01000000,LCD_CS2);
        WriteData(0b11000000,LCD_CS2);
        WriteXY(max+2-64+x1, y1/8, LCD_CS2);
        WriteData(0xFF,LCD_CS2);
        WriteXY(max+1-64+x1, y1/8 + 1, LCD_CS2);
        WriteData(0b00000010,LCD_CS2);
        WriteData(0b00000011,LCD_CS2);    
    }
}

void rectangle(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
    unsigned char i=0;
                    
    WriteXY(x1, y1, LCD_CS1);
    WriteData(0xFF,LCD_CS1);
    for(i=x1+1; i<64; i++)    
        WriteData(1,LCD_CS1);
                             
    WriteXY(0, y1, LCD_CS2);
    for(i=64; i<x2-1; i++)    
        WriteData(1,LCD_CS2);
    WriteData(0xFF,LCD_CS2); 
                                
    WriteXY(x1, y2-1, LCD_CS1);
    WriteData(0xFF,LCD_CS1);
    for(i=x1+1; i<64; i++)    
        WriteData(0x80,LCD_CS1);
    
    WriteXY(0, y2-1, LCD_CS2);
    for(i=64; i<x2-1; i++)    
        WriteData(0x80,LCD_CS2);
    WriteData(0xFF,LCD_CS2);
                             
    for(i=y1; i<y2; i++)
    {                          
         WriteXY(x1, i, LCD_CS1);
         WriteData(0xFF,LCD_CS1);
         WriteXY(x2-1-64, i, LCD_CS2); 
         WriteData(0xFF,LCD_CS2);       
    }                            
}          

void clear_status(void)
{
 unsigned char x;
 for(x=0;x<64;x++)
 {
   WriteXY(x,0,(LCD_CS1+LCD_CS2));   
   WriteData(0,(LCD_CS1+LCD_CS2));   
 }
}

void clear_rec(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
 unsigned char x,y;
 for(x=x1;x<x2;x++)
 {
  for(y=y1;y<y2;y++)
  {
   WriteXY(x,y,(LCD_CS1+LCD_CS2));   
   WriteData(0,(LCD_CS1+LCD_CS2));   
  } 
 }
}

void splash()
{
    clear();                 
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(0, 0, 128, 8);
    delay_ms(50);      
    rectangle(16, 1, 112, 7);
    delay_ms(50);
    
    clear();     
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(16, 1, 112, 7);
    delay_ms(50); 
    rectangle(32, 2, 96, 6);
    delay_ms(50);
    
    clear();    
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(32, 2, 96, 6);
    delay_ms(50);
    rectangle(48, 3, 80, 5);
    delay_ms(50);  
    
    
    clear();                 
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(48, 3, 80, 5);
    delay_ms(50);     
    rectangle(63, 4, 64, 4);
    delay_ms(50);    
    
    clear();
    rectangle(63, 4, 64, 4);
    delay_ms(50);            
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(48, 3, 80, 5);
    delay_ms(50);       
    
 
    clear();        
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(48, 3, 80, 5);
    delay_ms(50);      
    rectangle(32, 2, 96, 6);
    delay_ms(50);             
    
    clear();            
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(32, 2, 96, 6);
    delay_ms(50);      
    rectangle(16, 1, 112, 7);
    delay_ms(50);        
    
    clear();   
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(16, 1, 112, 7);
    delay_ms(50);   
    rectangle(0, 0, 128, 8);
    delay_ms(50);    
    
    clear();
//    textx=6; texty=4;puts(l_ld, 8, 0);
    rectangle(0, 0, 128, 8);
    delay_ms(100);
    
    clear();
//    textx=6; texty=4;puts(l_ld, 8, 0xFF);   
    delay_ms(500);    
}