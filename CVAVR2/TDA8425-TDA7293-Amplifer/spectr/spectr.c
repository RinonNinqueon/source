#include <mega16.h>
#include <math.h>
//#include <delay.h>
                     
flash int /*Tab_sin*/Sinus[40]={0 , 50 , 98 , 142 , 181 , 213 , 237 , 251, 255 , 251 , 237 , 213 , 181 , 142 , 98 , 50, 0 , -50 , -98 , -142 , -181 , -213 , -237 , -251, -255 , -251 , -237 , -213 , -181 , -142 , -98 , -50, 0 , 50 , 98 , 142 , 181 , 213 , 237 , 251};
//flash int Tab_sin[128]={0, 12, 24, 37, 49, 61, 74, 85, 97, 109, 120, 131, 141, 151, 161, 171, 180, 188, 197, 204, 212, 218, 224, 230, 235, 240, 244, 247, 250, 252, 253, 254, 255, 254, 253, 252, 250, 247, 244, 240, 235, 230, 224, 218, 212, 204, 197, 188, 180, 171, 161, 151, 141, 131, 120, 109, 97, 85, 74, 61, 49, 37, 24, 12, 0, -12, -24, -37, -49, -61, -74, -85, -97, -109, -120, -131, -141, -151, -161, -171, -180, -188, -197, -204, -212, -218, -224, -230, -235, -240, -244, -247, -250, -252, -253, -254, -255, -254, -253, -252, -250, -247, -244, -240, -235, -230, -224, -218, -212, -204, -197, -188, -180, -171, -161, -151, -141, -131, -120, -109, -97, -85, -74, -61, -49, -37, -24, -12};

flash unsigned char /*Okno_hanning*/Okno[32]={0 , 3 , 10 , 23 , 40 , 60 , 84 , 109 , 134 , 160 , 184 , 206 , 225 , 240 , 250 , 255 , 255 , 250 , 240 , 225 , 206 , 184 , 160 , 134 , 109 , 84 , 60 , 40 , 23 , 10 , 3 , 0};

//flash char Okno_hamming[32]={20 , 23 , 30 , 42 , 57 , 76 , 97 , 120 , 144 , 168 , 190 , 210 , 228 , 241 , 251 , 255 , 255 , 251 , 241 , 228 , 210 , 190 , 168 , 144 , 120 , 97 , 76 , 57 , 42 , 30 , 23 , 20};

//flash char Okno_blackman[32]={0 , 1 , 4 , 10 , 18 , 31 , 48 , 69 , 94 , 122 , 151 , 181 , 208 , 230 , 246 , 255 , 255 , 246 , 230 , 208 , 181 , 151 , 122 , 94 , 69 , 48 , 31 , 18 , 10 , 4 , 1 , 0};

//flash char L1[17]={32 , 32 , 32 , 32 , 32 , 32 , 32 , 32 , 32 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 255};
flash unsigned char L1[17]={0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF};

//flash char L2[17]={32 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255};
flash unsigned char L2[17]={0 , 0x80 , 0xC0 , 0xE0 , 0xF0 , 0xF8 , 0xFC , 0xFE , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF , 0xFF};
                      
#define _xtal 8000000

#define Falloff 1
//#define Lcd_offset 1
#define Sensitivity 40

#define Timer1_h _xtal / 44000
#define Timer1_l _xtal / 200

#define Level_a 8 -(Sensitivity * 0.4)

/*
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
#define LCD_COM PORTB */

//#include "ks0108_1.h"   
                    
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
//unsigned char Okno[32];
int Rex[16];
//int Sinus[40];
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
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);   
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;              
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    TCNT1 = 0;       
//    if ((ADCSRA & 0x10)==0){
    Sam++;                            
//    WriteXY(Sam, 4, LCD_CS1);WriteData(0xFF,LCD_CS1);
    ClrBit(TIMSK,0b00010000);
    Sample_h[Sam-1] = Getadc(0);                       //            'WY¯SZE PASMO    
    if (Sample_h[Sam-1] > maxl)
        maxl = Sample_h[Sam-1];    
/*    WriteXY(0, 4, LCD_CS1);
    WriteData(Sample_h[Sam-1],LCD_CS1);   */
//    ADCW=0;
    SetBit(TIMSK,0b00010000);
    if (Sam == 32)
    {
        ClrBit(TIMSK,0b00010000);   //Disable Compare1a
        Sampling = 0;
    }    //           }
}

// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
    TCNT1 = 0;   
//    if ((ADCSRA & 0x10)==0){
    Sam++;            
//    WriteXY(Sam, 5, LCD_CS1);WriteData(0xFF,LCD_CS1);
    ClrBit(TIMSK,0b00001000);
    Sample_l[Sam-1] = Getadc(1); 
     if (Sample_l[Sam-1] > maxl)
        maxl = Sample_l[Sam-1];                       //           'NI¯SZE PASMO
    SetBit(TIMSK,0b00001000);
    if (Sam == 32)
    {
        ClrBit(TIMSK,0b00001000);  //Disable Compare1b
        Sampling = 0;
    }         //          }
}

void Sample_h_()
{
//'pobiera 32 próbki z czêstotliwoœci¹ 44kHz
//Config Adc = Single , Prescaler = 4 , Reference = Avcc
//'ADC dzia³a ju¿ doœæ niestabilnie na preskalerze 2 ale na 4 ju¿ sie nie wyrobi i prubkuje z f=37kHz
//' przez du¿e f pojawiaja sie szumy jak podajemy sygna³ z generatora
    ADCSRA=0b10000010;        
    delay_us(10);
//    ADMUX=0b01000000;
    ADCSRA|=0x40;//Start Adc

    TCNT1 = 0;
    SetBit(TIMSK,0b00010000);     //Enable Compare1a
    Sam = 0;
    Sampling = 1;
}

void Sample_l_()
{
//'pobiera 32 próbki z czêstotliwoœci¹ 2kHz
//    Config Adc = Single , Prescaler = Auto , Reference = Avcc
    ADCSRA=0b10000010;     
    delay_us(10);
//    ADMUX=0b01000001;
    ADCSRA|=0x40;//    Start Adc

    TCNT1 = 0;
    SetBit(TIMSK,0b00001000);    //Enable Compare1b
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

void DFT()   //Discrete Fourier Transform  //Äèñêðåòíîå ïðåîáðàçîâàíèå ôóðüå
{            //X(k) = SUMM from n=0 to N-1 (x(n) * exp(-2*pi*i*k*n/N))
    for (K = 1; K<= 15; K++)
    {        //ðàñêëàäûâàåì íà:
        Rex_t = 0;            //Re äåéñòâèòåëüíóþ (cos(x) = sin(x + pi/2)) è
        Imx_t = 0;            //Im ìíèìóþ ÷àñòè (sin(x))

        for (I = 0; I<=31; I++)
        {
            Beta = I * K;
            Beta = Beta & 31;  //Beta < 32
            Tmp_s = Sinus[Beta] * Data[I];      //im = sin(ki)*x(i)  //2pi = 32  =>  2pi/32 = 1
            Tmp_c = Sinus[Beta + 7] * Data[I];  //+pi/2  =  cos
                         
            Tmp_s = Tmp_s >> 8;  //äëÿ íîðìèðîâêè [-255; 255] ý sin(x)
            
            Tmp_c = Tmp_c >> 8;
      
            Rex_t = Rex_t + Tmp_c; //SUMM
            Imx_t = Imx_t - Tmp_s;
       }
                    
       Rex_t = Rex_t >> 3;

       Imx_t = Imx_t >> 3;            

       Tmp_c = Rex_t * Rex_t;      //Re^2
       Tmp_s = Imx_t * Imx_t;      //Im^2

       Tmp_c = Tmp_c + Tmp_s;      //z^2 = Re^2 + Im^2
       Rex[K] = isqrt(Tmp_c);      //z
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
    for (K = 1; K<=16; K++)//                                             'w ci¹gu jednej pêtli obliczany i wyœwietlany 1 s³upek 1/10;
    {
        Sing = Result[K-1] * 0.1;

//      'If K = 1 Then Sing = Sing * 0.5                             ' umnie jakos zawysoko skacz¹, byæ moze przez brak filtrów mozna usunaæ
//    ' If K = 2 Then Sing = Sing * 0.75

        Sing = log10(Sing);

        Sing = Sensitivity * Sing;
        Tmp_c = Sing+ Level_a;   
    
        if (Tmp_c < 0)
            Tmp_c = 0;
        if (Tmp_c > 16)
            Tmp_c = 16;

        Result[K-1] = Tmp_c;//                                            'przeniesienie Resultu z TMP_C do zmiennej Result


        if (Result[K-1] > Result_o[K-1])
            Result_o[K-1] = Result[K-1];
        else
        {
            if (Falloff_count[K-1] == Falloff)
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
    //OUT LCD           
//    clear();

    WriteXY(0, 6, LCD_CS1);
    for(I=0; I<8; I++)
        for(K=0; K<8; K++)
            WriteData(Line1d[I],LCD_CS1); 
              
    WriteXY(0, 6, LCD_CS2);
    for(I=8; I<16; I++)
        for(K=0; K<8; K++)
            WriteData(Line1d[I],LCD_CS2);  
            
    WriteXY(0, 7, LCD_CS1);
    for(I=0; I<8; I++)
        for(K=0; K<8; K++)
            WriteData(Line2d[I],LCD_CS1);
    WriteXY(0, 7, LCD_CS2);
    for(I=8; I<16; I++)
        for(K=0; K<8; K++)
            WriteData(Line2d[I],LCD_CS2);  
}                              
/*
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
                   
    OCR1A=Timer1_h;
    OCR1B=Timer1_l; 
    
    TIMSK=0x00; */       
/* 
    for(K = 0; K<32; K++)                   
    {
        Sinus[K] = Tab_sin[K];  
//        'Okno(k + 1) = 255
//        'Okno(k + 1) = Lookup(k , Okno_blackman)
//        'Okno(k + 1) = Lookup(k , Okno_hamming)
        Okno[K] = Okno_hanning[K];
    }
  
    Sinus[32] = Tab_sin[0];
    Sinus[33] = Tab_sin[1];
    Sinus[34] = Tab_sin[2];
    Sinus[35] = Tab_sin[3];
    Sinus[36] = Tab_sin[4];
    Sinus[37] = Tab_sin[5];
    Sinus[38] = Tab_sin[6];
    Sinus[39] = Tab_sin[7];    
  */               
/*    init_lcd(); 

    clear(); 


    ADCSRA=0b10000010;
    ADMUX=0b01000000;   
     
    
    #asm("sei");
    
    ADCSRA|=0x40;//    Start Adc

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
}*/