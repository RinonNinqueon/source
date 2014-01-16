//#include <stdlib.h>
#include <mega16.h>
 
#asm
    .equ __i2c_port=0x15
    .equ __sda_bit=1
    .equ __scl_bit=0
#endasm
#include <i2c.h>    

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

#define SetBit(x,y) (x|=y)
#define ClrBit(x,y) (x&=~y)
#define TestBit(x,y) (x&y)

//LCD
#define LCD_RST 0b00001000
#define LCD_E   0b00000100
#define LCD_RW  0b00000010
#define LCD_RS  0b00000001
#define LCD_CS2 0b00010000
#define LCD_CS1 0b00100000

#define LCD_DB PORTD
#define LCD_DBI PIND
#define LCD_IO DDRD
#define LCD_COM PORTB

//encoder
#define pn1 0b01000000
#define pn2 0b10000000
#define encoder PINA

//keyboard
#define keys PINC
#define k_up   /* 0b10000000*/ 0b00100000
#define k_down /* 0b01000000*/ 0b10000000
#define k_enter/* 0b00100000*/ 0b00000100
#define k_exit /* 0b00010000*/ 0b00001000
#define k_menu /* 0b00001000*/ 0b01000000
#define k_mute /* 0b00000100*/ 0b00010000

//switch
#define ctrl PORTA
#define k_stby 0b00100000
#define o_ac   0b10000000
#define o_clip 0b00010000
#define o_mute 0b00001000
#define o_stby 0b00000100
#define pwr PORTB
#define o_poff 0b01000000

//max parameters
#define vol_down 63
#define tmb_down 15
  
#define Freq 8000000

#include "graphics.h"    
#include "TDA8425.h"

#include "spectr\spectr.c"
 /*
#pragma warn-
eeprom unsigned char e_vol;//=0;
eeprom unsigned char e_tre;//=tmb_down/2;
eeprom unsigned char e_bas;//=tmb_down/2;
eeprom unsigned char e_in;//=IN1;
eeprom unsigned char e_out;//=STEREO;
eeprom unsigned char e_prot_stat;//=0b00000111;
eeprom unsigned char eeprom_enable;
#pragma warn+
*/   
unsigned char vol=60;
unsigned int bas=tmb_down/2;
unsigned int tre=tmb_down/2;           
unsigned char mode=0;
unsigned char in=IN1;
unsigned char out=STEREO;  
//char *l_load="Загрузка";   
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
#define prot_poff 0b00000001
#define prot_ac   0b00000010
#define prot_clip 0b00000100
#define prot_SA   0b00001000
bit dir = 0;
bit up = 0;
bit down = 0; 
bit lock=0;  
bit lock_k=0;
bit mn = 0;
bit mute = 0;
#define clip !TestBit(PINA, o_clip)
#define stby !TestBit(PINA, o_stby)
#define poff !TestBit(PINB, o_poff)
bit lock_d = 0;

void draw_stby()
{
    unsigned char i=0;
    //on                           
    clear_status(); 
    if (mn && mode != 255)
    {
        clear_rec(0, 1, 64, 8);
        mn = 0;
    }
    if (!stby && !poff)
    {   
        textx=0;
        texty=0;
        puts(l_on,3,0);
    }
    if (stby && !poff)
    {                     
        clear();
        textx=0;
        texty=0;
        puts(l_stby,8,0);
    }
    if (poff)
    {
        clear();
        textx=0;
        texty=0;
        puts(l_poff,4,0);
    }
    
   //out
   if (mode != 0x86)
    {                    
        if (out)
        {                                  
            if (out == P_STEREO)
            {                              
                WriteXY(119-64-32, 0, LCD_CS2);
                for(i=21; i<28; i++)    
                    WriteData(s_out[i],LCD_CS2);
            }                    
            
            if (out == S_STEREO)
            {                              
                WriteXY(119-64-32, 0, LCD_CS2);
                for(i=14; i<21; i++)    
                    WriteData(s_out[i],LCD_CS2);
            }
            
            WriteXY(119-64-24, 0, LCD_CS2);
            for(i=7; i<14; i++)    
                WriteData(s_out[i],LCD_CS2);
        }
        else
        {
            WriteXY(119-64-24, 0, LCD_CS2);
            for(i=0; i<7; i++)    
                WriteData(s_out[i],LCD_CS2);
        }
   }  
   //in
   if (mode != 0x85)
    {               
        WriteXY(119-64-16, 0, LCD_CS2);
        for(i=((in%2)*5); i<(5+(in%2)*5); i++)    
            WriteData(s_in[i],LCD_CS2);
        if (in<6 && in>3)
        { 
            WriteXY(119-64-8, 0, LCD_CS2);
            for(i=0; i<5; i++)    
                WriteData(s_inc[i],LCD_CS2);
        }        
        if (in<4 && in>1)
        { 
            WriteXY(119-64-8, 0, LCD_CS2);
            for(i=5; i<10; i++)    
                WriteData(s_inc[i],LCD_CS2);
        }
   }        
   //mute
    if (mute)
    {               
        WriteXY(119-64, 0, LCD_CS2);
        for(i=0; i<8; i++)    
            WriteData(s_mute[i],LCD_CS2);        
    }
                     
    if (clip)
    {
        WriteXY(63-6, 0, LCD_CS1);
        for(i=0; i<6; i++)    
            WriteData(s_clip[i],LCD_CS1);
    }            
    
    WriteXY(0, 1, LCD_CS1);
    for(i=0; i<64; i++)    
        WriteData(1,LCD_CS1);       
    WriteXY(0, 1, LCD_CS2);
    for(i=0; i<64; i++)    
        WriteData(1,LCD_CS2);
}

void call(unsigned char dir)
{
    draw_stby(); 
    //menu
    if (!TestBit(mode, 0x80) && mode) 
    {                    
        //clear cursor
        WriteXY(0, mode, LCD_CS1);           
        delay_ms(1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
            
        if (dir == 1)
            mode++;
        if (dir == 0)
            mode--;  
            
        if (mode > 7)
            mode = 7;
        if (mode < 2)
            mode = 2;               
                                    
//        clear();
//        textx=8;texty=1;puts(l_menu, 10, 0);
        textx=1;texty=2;puts(l_vol, 9, 0);
        textx=1;texty=3;puts(l_bas, 6, 0);
        textx=1;texty=4;puts(l_tre, 7, 0);
        textx=1;texty=5;puts(l_in, 4, 0);
        textx=1;texty=6;puts(l_out, 5, 0);
        textx=1;texty=7;puts(l_prot, 9, 0);
        
        WriteXY(0, mode, LCD_CS1);           
        delay_ms(1);
        WriteData(0x81, LCD_CS1);
        WriteData(0x42, LCD_CS1);
        WriteData(0x24, LCD_CS1);
        WriteData(0x18, LCD_CS1);        
    }        
       
    if (mode==0x82 || !mode || dir > 9)
    {
        if (dir == 1 || dir == 11)
            vol++;
        if (dir == 0 || dir == 10)
            vol--;        
            
        if (vol > vol_down)
            vol = vol_down;
        else
            if (vol < 1)
                vol = 1;
            else
                SetBit(rewrite, 0x01);        
            
//        volume_inc(vol);
        SetAll(vol, bas, tre, mute, out, in);                                
            
//        clear();
        if (dir <= 3)
        {
            textx=5;
            texty=2;
            puts(l_vol,9,0);     
                                 
            drawbar_l(17, 32, 17+(vol-1)*3/2, (vol_down-1)*3/2); 
        }
    }                
    
    if (mode == 0x83)
    {                
        if (dir == 1)
            bas++;
        if (dir == 0)
            bas--;  
            
        if (bas > tmb_down)
            bas = tmb_down;
        else
        if (bas < 1)
            bas = 1;
        else     
            SetBit(rewrite, 0x02);     
//       bass_inc(bas);
        SetAll(vol, bas, tre, mute, out, in);
     
//        clear();
        textx=5;
        texty=2;
        puts(l_bas,6,0);     
                             
        drawbar_c(17, 32, 17+(bas)*3*vol_down/2/tmb_down, (vol_down)*3/2, 3);     
    }
    
    if (mode == 0x84)
    {           
        if (dir == 1)
            tre++;
        if (dir == 0)
            tre--;   
            
        if (tre > tmb_down)
            tre = tmb_down;
        else
        if (tre < 1)
            tre = 1;     
        else                                 
            SetBit(rewrite, 0x04);
//        treble_inc(tre);
        SetAll(vol, bas, tre, mute, out, in);
//        clear();
        textx=5;
        texty=2;
        puts(l_tre,7,0);     
                             
        drawbar_c(17, 32, 17+(tre)*3*vol_down/2/tmb_down, (vol_down)*3/2, 3);          
    } 
    
    if (mode == 0x85)
    {                       
        //clear cursor
        WriteXY(0, in, LCD_CS1);           
        delay_ms(1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        
        if (dir == 1)
            in++;
        if (dir == 0)
            in--;   
            
        if (in > IN2)
            in = IN2;
        else
        if (in < IN1A)
            in = IN1A;
        else
            SetBit(rewrite, 0x08); 
            
//       set(mute, out, in);
        SetAll(vol, bas, tre, mute, out, in);          
//        clear();
//        textx=8;texty=1;puts(l_in,10,0);
        textx=1;texty=2;puts(l_chanel1,7,0);textx=9;texty=2;puts(l_chanelA,1,0);
        textx=1;texty=3;puts(l_chanel2,7,0);textx=9;texty=3;puts(l_chanelA,1,0);
        textx=1;texty=4;puts(l_chanel1,7,0);textx=9;texty=4;puts(l_chanelB,1,0);
        textx=1;texty=5;puts(l_chanel2,7,0);textx=9;texty=5;puts(l_chanelB,1,0);
        textx=1;texty=6;puts(l_chanel1,7,0);                                     
        textx=1;texty=7;puts(l_chanel2,7,0);

        WriteXY(0, in, LCD_CS1);           
        delay_ms(1);
        WriteData(0x81, LCD_CS1);
        WriteData(0x42, LCD_CS1);
        WriteData(0x24, LCD_CS1);
        WriteData(0x18, LCD_CS1);                  
    }

    if (mode == 0x86)
    {                
        //clear cursor
        WriteXY(0, out+2, LCD_CS1);           
        delay_ms(1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        
        if (dir == 1)
        {
            SetBit(rewrite, 0x10);
            out++;
        }
        if (dir == 0 && out)
        {   
            SetBit(rewrite, 0x10);
            out--;   
        }
            
        if (out > S_STEREO)
        {
            out = S_STEREO;                       
            ClrBit(rewrite, 0x10);
        }   
//        set(mute, out, in);
        SetAll(vol, bas, tre, mute, out, in);             
//        clear();
//        textx=8;texty=1;puts(l_out,10,0);
        textx=1;texty=2;puts(l_mono,4,0);
        textx=1;texty=3;puts(l_stereo,6,0);
        textx=1;texty=4;puts(l_p_stereo,13,0);
        textx=1;texty=5;puts(l_s_stereo,15,0);
                               
        
        WriteXY(0, out+2, LCD_CS1);           
        delay_ms(1);
        WriteData(0x81, LCD_CS1);
        WriteData(0x42, LCD_CS1);
        WriteData(0x24, LCD_CS1);
        WriteData(0x18, LCD_CS1);      
    }   
    
    if (mode >= 0x87)
    {                 
        unsigned char i=0;
        bit j=0; 
        //clear cursor
        WriteXY(0, (mode << 1 >> 5) + 2, LCD_CS1);           
        delay_ms(1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
        WriteData(0x00, LCD_CS1);
                      
        if (dir == 1 && mode < 0xB7)
            mode += 0x10;
        if (dir == 0 && mode > 0x87)
            mode -= 0x10;
    
        if (dir == 5)
        {                 
//            unsigned char k = ;
            unsigned char z = 1 << (mode << 1 >> 5);
            SetBit(rewrite, 0x20); 
            if (TestBit(prot_stat, z))
                ClrBit(prot_stat, z);
            else
                SetBit(prot_stat, z);
        }                
        
        //checkbox                                     
        //poff       
        if (TestBit(prot_stat, prot_poff))
            j = 1;
        else
            j = 0;   
        
        WriteXY(7, 2, LCD_CS1); 
        for(i = j*6; i < 6+j*6; i++)
            WriteData(s_chbox[i], LCD_CS1);
                            
        //ac                  
        if (TestBit(prot_stat, prot_ac))
            j = 1;
        else
            j = 0;   
        
        WriteXY(7, 3, LCD_CS1); 
        for(i = j*6; i < 6+j*6; i++)
            WriteData(s_chbox[i], LCD_CS1);   
                         
        //clip                       
        if (TestBit(prot_stat, prot_clip))
            j = 1;
        else
            j = 0;   
        
        WriteXY(7, 4, LCD_CS1); 
        for(i = j*6; i < 6+j*6; i++)
            WriteData(s_chbox[i], LCD_CS1);
            
        //Spectrum analiser                      
        if (TestBit(prot_stat, prot_SA))
            j = 1;
        else
            j = 0;   
        
        WriteXY(7, 5, LCD_CS1); 
        for(i = j*6; i < 6+j*6; i++)
            WriteData(s_chbox[i], LCD_CS1);                

        textx=2;texty=2;puts(l_prot_poff,8,0);
        textx=2;texty=3;puts(l_prot_ac,8,0);
        textx=2;texty=4;puts(l_prot_clip,13,0);
        textx=2;texty=5;puts(l_prot_SA,14,0);
                               
        
        WriteXY(0, (mode << 1 >> 5) + 2, LCD_CS1);           
        delay_ms(1);
        WriteData(0x81, LCD_CS1);
        WriteData(0x42, LCD_CS1);
        WriteData(0x24, LCD_CS1);
        WriteData(0x18, LCD_CS1);      
    }    
}

void scroll()
{
    bit p1 = TestBit(encoder, pn1);
    bit p2 = TestBit(encoder, pn2);                    

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
{       /*
    if(TestBit(rewrite, 0x01))
        e_vol = vol;
    if(TestBit(rewrite, 0x02))
        e_bas = bas;
    if(TestBit(rewrite, 0x04))
        e_tre = tre;
    if(TestBit(rewrite, 0x08))
        e_in = in;
    if(TestBit(rewrite, 0x10))
        e_out = out;
    if(TestBit(rewrite, 0x20))
        e_prot_stat = prot_stat;*/       
    rewrite = 0;
}
 
void key_hook()
{
    if (!TestBit(keys, k_up) && !lock_k) 
    {
        call(1);   
        TIMSK = 0;            
        lock_k=1;
    }            
    if (!TestBit(keys, k_down) && !lock_k)
    {
        call(0); 
        TIMSK = 0;              
        lock_k=1;
    }
        
    if(!TestBit(keys, k_enter) && mode && !lock_k)
    {                           
        if (mode < 0x87)
        {
            mn = 1;
            SetBit(mode, 0b10000000);
            call(3);
        }           
        else
            call(5);    
        lock_k=1;
    }            
    
    if (!TestBit(keys, k_menu) && !mode && !lock_k)
    {         
        clear();
        mn = 1;        
        mode = 2;
        call(4);               
        lock_k=1;
    }                                   
    if (!TestBit(keys, k_exit) && !TestBit(mode, 0b10000000) && !lock_k)
    {       
        mn = 1;
        mode = 0;
        draw_stby();               
        lock_k=1;
        write_eeprom();
    }
    if (!TestBit(keys, k_exit) && TestBit(mode, 0b10000000) && !lock_k)
    {          
        mn = 1;     
        ClrBit(mode, 0b10110000);
        call(4);               
        lock_k=1;
    }             
    if (!TestBit(keys, k_mute) && !lock_k)
    {
        mute = !mute;
        if (!mode)
            draw_stby();
        else
            call(4);
        SetAll(vol, bas, tre, mute, out, in);
        
        if (mute)
            ClrBit(ctrl, o_mute);
        else
            SetBit(ctrl, o_mute);
                           
        lock_k=1;  
    }                 
    
    if(!TestBit(PINA, k_stby) && !lock_k)
    {               
        if (!stby)                  
        {
            ClrBit(ctrl, o_stby);
            SetBit(rewrite, 0x01);
            if(!mode)
                write_eeprom();
        }
        else
            SetBit(ctrl, o_stby);
            
        if (!mode)
            draw_stby();
        else
            call(4);
                           
        lock_k=1;   
    }
    
    if ((keys>>2 << 2) == 0b11111100 && TestBit(PINA, k_stby))
    {
        lock_k=0;
    }        
    
    if (clip && TestBit(prot_stat, prot_clip))
    {
        if (vol > 1)
            call(10);
        else         
            if (!mute)          
            {
                mute = 1;
                ClrBit(ctrl, o_mute);                
            }
            else
                if  (!stby)  
                {
                    ClrBit(ctrl, o_stby);
                }                        
                else
                {       
                    if(TestBit(prot_stat, prot_ac) && !TestBit(PINB, o_ac))
                    {
                        SetBit(PORTB, o_ac);    
                    }
                    if (!poff && TestBit(prot_stat, prot_poff)) 
                    {          
                        ClrBit(PORTB, o_poff);
                    }
//                    else
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
                        
 ctrl = 0b11110000; //pn1 | pn2 | o_clip | o_ac | k_stby; 

 PORTB=0x00;        
 PORTC=0xFF;
 PORTD=0;      
 
 TCCR1A=0x00;
 TCCR1B=0x01;
 TCNT1=0x00;     
                   
 OCR1A=Timer1_h;
 OCR1B=Timer1_l; 
    
 TIMSK=0x00;
 
 /*for(K = 0; K<32; K++)                   
    {
        Sinus[K] = Tab_sin[K];  
//        'Okno(k + 1) = 255
//        'Okno(k + 1) = Lookup(k , Okno_blackman)
//        'Okno(k + 1) = Lookup(k , Okno_hamming)
        Okno[K] = Okno_hanning[K];
    }*/
    /*       
 if (eeprom_enable == 107)
 {
    vol = e_vol;
    bas = e_bas;
    tre = e_tre;
    in = e_in;
    out = e_out;
    prot_stat = e_prot_stat;
 }                          
 else
 {
    eeprom_enable = 107;
    e_vol = vol;
    e_bas = bas;
    e_tre = tre;
    e_in = in;
    e_out= out;
    e_prot_stat = prot_stat;    
 }           */

 init_lcd(); 
 delay_ms(10);      
 
 power_on(); 
 
 i2c_init();              
 
 SetAll(vol, bas, tre, mute, out, in);
 
 draw_stby(); 
 
 ADCSRA=0b10000010;
 ADMUX=0b01000000;        
 
 #asm("sei");       
 
 SetBit(pwr, o_poff);
 delay_ms(1000);
 ClrBit(PORTB, o_ac);
 delay_ms(100);
 SetBit(ctrl, o_stby);
 delay_ms(100);
 SetBit(ctrl, o_mute);
 
 ADCSRA|=0x40;//    Start Adc 
 
 while(1)
 {             
    if(TestBit(prot_stat, prot_SA))
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