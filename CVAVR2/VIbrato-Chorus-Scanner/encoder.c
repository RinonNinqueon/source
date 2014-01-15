#define _dir_cnt 4
#define _dir_cnt2 8

unsigned char dir1 = 1, dir2 = 1, dir_cnt1 = _dir_cnt, dir_cnt2 = _dir_cnt, e11 = 1, e12 = 1, e21 = 1, e22 = 1, enc1 = 0, enc2 = 0;

void inline encoder_main(unsigned char port1, unsigned char pin11, unsigned char pin12, unsigned char port2, unsigned char pin21, unsigned char pin22)
{
    if (TestBit(port1, pin11) && TestBit(port1, pin12))
        e11 = 0;
    if (!TestBit(port1, pin11) && TestBit(port1, pin12))
        e11 = 1;
    if (!TestBit(port1, pin11) && !TestBit(port1, pin12))
        e11 = 2;
    if (TestBit(port1, pin11) && !TestBit(port1, pin12))
        e11 = 3;
    
    if (TestBit(port2, pin21) && TestBit(port2, pin22))
        e21 = 0;
    if (!TestBit(port2, pin21) && TestBit(port2, pin22))
        e21 = 1;
    if (!TestBit(port2, pin21) && !TestBit(port2, pin22))
        e21 = 2;
    if (TestBit(port2, pin21) && !TestBit(port2, pin22))
        e21 = 3;
    
    switch (e12)
    {
        case 0: if (e11 == 1)
                    dir1 = 0;
                if (e11 == 3)
                    dir1 = 2;
                break;
        case 1: if (e11 == 2)
                    dir1 = 0;
                if (e11 == 0)
                    dir1 = 2;
                break;
        case 2: if (e11 == 3)
                    dir1 = 0;
                if (e11 == 1)
                    dir1 = 2;
                break;
        case 3: if (e11 == 0)
                    dir1 = 0;
                if (e11 == 2)
                    dir1 = 2;
                break;
    }
    
    switch (e22)
    {
        case 0: if (e21 == 1)
                    dir2 = 0;
                if (e21 == 3)
                    dir2 = 2;
                break;
        case 1: if (e21 == 2)
                    dir2 = 0;
                if (e21 == 0)
                    dir2 = 2;
                break;
        case 2: if (e21 == 3)
                    dir2 = 0;
                if (e21 == 1)
                    dir2 = 2;
                break;
        case 3: if (e21 == 0)
                    dir2 = 0;
                if (e21 == 2)
                    dir2 = 2;
                break;
    }
    
    e12 = e11;
    e22 = e21;
} 