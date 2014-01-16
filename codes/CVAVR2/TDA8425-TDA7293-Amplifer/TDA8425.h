#include <i2c.h>

#define S_STEREO 0b00000011
#define P_STEREO 0b00000010
#define STEREO   0b00000001
#define MONO     0b00000000  

#define IN2      0b00000111
#define IN1      0b00000110
#define IN2B     0b00000101
#define IN1B     0b00000100
#define IN2A     0b00000011
#define IN1A     0b00000010

void SetAll(unsigned char vol,unsigned char bas,unsigned char tre,unsigned char mute,unsigned char out,unsigned char in)
{
    //vol
    unsigned char c=0b11000000;
    SetBit(c, vol);
    i2c_start();
    i2c_write(0b10000010);         
    i2c_write(0b00000000);
    i2c_write(c);
    i2c_write(0b10000010);         
    i2c_write(0b00000001);
    i2c_write(c);  
    i2c_stop();
                   
    //bass
    c=0b11110000;
    SetBit(c, bas); 
    i2c_start();
    i2c_write(0b10000010);         
    i2c_write(0b00000010);
    i2c_write(c);
    i2c_stop();
   
    //treble 
    c=0b11110000;
    SetBit(c, tre);  
    i2c_start();
    i2c_write(0b10000010);         
    i2c_write(0b00000011);
    i2c_write(c);   
    i2c_stop();
               
    //mute, in, out
    c = 0b11000000;
    if (mute) SetBit(c, 0b00100000);
    SetBit(c, out<<3);
    SetBit(c, in);    
    i2c_start();
    i2c_write(0b10000010);         
    i2c_write(0b00001000);
    i2c_write(c);
    i2c_stop();       
}