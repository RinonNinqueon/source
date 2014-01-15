//стрелки
flash unsigned char arrow_left[8] =  {0x00, 0x00, 0x02, 0x06, 0x0E, 0x06, 0x02, 0x00};
flash unsigned char arrow_right[8] = {0x00, 0x00, 0x08, 0x0C, 0x0E, 0x0C, 0x08, 0x00};

// External Interrupt 1 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
    if (ch_speed)
        return;
//---------------------Rotate left---------------------------
    if (!TestBit(PINA, 0b01000000))
    {
        if (!edit_mode)
        {
            if (enc1 && scan_mode > 1 && scan_mode < 4)
                scan_mode--;
            if (!enc1 && scan_mode < 3)
                scan_mode++;
                
            if (!enc1 && scan_mode == 4 && current_pattern > 0)
            {
                current_pattern--;
                patt = read_pattern(current_pattern);
            }                
            if (enc1 && scan_mode == 4 && current_pattern < MAX_PATTERNS-1)
            {
                current_pattern++;
                patt = read_pattern(current_pattern);
            }
        }
        else
        {
            if (!enc1)
            {
                switch (e_mode)
                {
                    case 0: if (e_preset > 0 && !e_save)
                            {
                                e_preset--;
                                e_patt = read_pattern(e_preset);
                                
                                e_item = 0;
                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
                                if (e_out)  e_out++;
                            }
                            break;
                    case 1: if (e_item > 0)
                            {      
                                if (e_out)
                                {                        
                                    e_out--;
                                    e_patt.out[e_item] = e_out & 0x07;
                                    if (e_out > 7)
                                        e_patt.out[e_item] += 0x08;
                                    else          
                                        e_patt.out[e_item] += 0x10;
                                }
                                else
                                    e_patt.out[e_item] = 0;
                                e_item--;
                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
                                if (e_out)  e_out++;
                            }
                            break;
                    case 2: if (e_out > 0 && e_item + 1 == e_patt.length)
                            {
                                e_out--; 
                                e_save = 1;
                            }
                            break;
                }
                if (!e_out)
                {
                    e_patt.length = e_item;
                }
            }
            else
            {
                switch (e_mode)
                {
                    case 0: if (e_preset < MAX_PATTERNS-1 && !e_save)
                            {
                                e_preset++;
                                e_patt = read_pattern(e_preset);
                                
                                e_item = 0;
                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
                                if (e_out)  e_out++;
                            }
                            break;
                    case 1: if (e_item < MAX_ITEMS-1 && e_out > 0)
                            {
                                if (e_out)
                                {                        
                                    e_out--;
                                    e_patt.out[e_item] = e_out & 0x07;
                                    if (e_out > 7)
                                        e_patt.out[e_item] += 0x08;
                                    else          
                                        e_patt.out[e_item] += 0x10;
                                }
                                else
                                    e_patt.out[e_item] = 0;
                                e_item++;
                                e_out = (e_patt.out[e_item] & 0x07) + (e_patt.out[e_item] & 0x08);
                                if (e_out) e_out++; 
                                if (e_item > e_patt.length)
                                    e_patt.length++;
                            }
                            break;
                    case 2: if (e_out < MAX_OUT)
                            {
                                e_out++;
                                e_save = 1;
                            }
                            break;
                }
            }
        }       
        SetBit(PORTA, 0b01000000);
//        return;
    }
//---------------------Rotate right--------------------------    
    if (!TestBit(PINA, 0b10000000))
    {
        if (!edit_mode)
        {                
            if (enc2 && scan_speed < max_speed)
                scan_speed += dividor_speed;
            if (!enc2 && scan_speed > min_speed)
                scan_speed -= dividor_speed;
            OCR1A = scan_speed;
        }
        else
        {
            if (!enc2)
            {
                if (e_mode > 0) e_mode--;
                else e_mode = 2;
            }
            else
            {
                if (e_mode < 2) e_mode++;
                else e_mode = 0;
            }
        }              
        SetBit(PORTA, 0b10000000);
//        return;
    }                      
//------------------------Stop start-------------------------    
//    if (!TestBit(PINA, 0b00010000))
//    {                  
//        if (!edit_mode)
//        {
//            if (ch_on)    
//            {
//                ch_on = 0;
//                ch_speed = 1;
//                tmp_speed = scan_speed;
//            }
//            else           
//            {
//                ch_on = 1;
//                ch_speed = 1;
//                TCCR1B=0x09;
//            }
//        }
////        return;
//    }
    
//---------------------User presets--------------------------
    if (!TestBit(PINB, 0b00000001) && TestBit(PINA, 0b00010000))
    {
        if (!edit_mode)
        {
            if (scan_mode == 4)
                scan_mode = last_mode;
            else              
            {
                last_mode = scan_mode;
                scan_mode = 4;
            }
        }      
//        return;
    }
//--------------------Edit mode------------------------------
    if (!TestBit(PINB, 0b00000001) && !TestBit(PINA, 0b00010000))
    {           
        if (edit_mode)    
        {
            e_preview = 0;
            edit_mode = 0;
        }
        else           
            edit_mode = 1;
//        return;
    }         
//-----------------------Preview-----------------------------    
    if (!TestBit(PINA, 0b00100000))
    {              
        if (!edit_mode)
        {
            if (ch_on)    
            {
                ch_on = 0;
                ch_speed = 1;
                tmp_speed = scan_speed;
            }
            else           
            {
                ch_on = 1;
                ch_speed = 1;
                TCCR1B=0x09;
            }
        }    
        else
        {
            if (e_preview)    
                e_preview = 0;
            else           
                e_preview = 1;
        }
//        return;
    }           
//-------------------------Save------------------------------    
    if (!TestBit(PINB, 0b00000010) && e_save && edit_mode)
    {       
        //сохраняем текущий OUT, т.к. он сокраняется только при изменении ITEM                                             
        if (e_out)
        {                        
            e_out--;
            e_patt.out[e_item] = e_out & 0x07;
            if (e_out > 7)
                e_patt.out[e_item] += 0x08;
            else          
            e_patt.out[e_item] += 0x10;
        }
        else
            e_patt.out[e_item] = 0;
        //запись в EEPROM
        write_pattern(e_patt, e_preset);    
        e_save = 0;
//        return;
    }    
    
    lcd_out();
}