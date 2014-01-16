#define MAX_ITEMS       30
#define MAX_PATTERNS    8
#define MAX_OUT         16

unsigned char current_pattern = 0;

typedef struct type_pattern
{
    unsigned char length;
    unsigned char out[MAX_ITEMS];
} t_pattern;

flash t_pattern v1 = {14, 
                                {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11,
                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
                                 
flash t_pattern v2 = {14, 
                                {0x10, 0x12, 0x13, 0x14, 0x17, 0x09, 0x0A, 0x0B, 0x0A, 0x09, 0x17, 0x14, 0x13, 0x12,
                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
                                 
flash t_pattern v3 = {14, 
                                {0x11, 0x13, 0x15, 0x08, 0x0A, 0x0B, 0x0C, 0x0D, 0x0C, 0x0B, 0x0A, 0x08, 0x15, 0x13,
                                 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
unsigned int block = 0, addr = 0;
unsigned char _e_read, i, j;
unsigned char t_preset[] = "Preset";
unsigned char t_item[] = "Item";

void inline check_ab()
{
    if (addr > 255)
    {
        addr = 0;
        block++;
    }
}

void write_pattern(t_pattern patt, unsigned char num)
{
    #asm("cli")
    lcd_clear();
    lcd_puts("Memory write");
    addr = 3 + num * (MAX_ITEMS + 1);
    block = addr / 256;
    addr = addr % 256;
 
    write_var(block, addr, patt.length);

    addr++;
    check_ab();
    
    lcd_gotoxy(0, 1);
    
    lcd_puts(t_preset);
    lcd_putchar(' ');
    
    LCDWriteInt(num, 0);
    
    lcd_putchar(' ');
    lcd_puts(t_item);
    lcd_putchar(' ');

    for(j = 0; j < MAX_ITEMS; j++)                
    {                         
        lcd_gotoxy(14, 1);             
        LCDWriteInt(j, 0);
        lcd_putchar(' ');
        write_var(block, addr, patt.out[j]);
        addr++;
        check_ab();
    }
    #asm("sei")
}

t_pattern read_pattern(unsigned char num)
{
    t_pattern patt;

    #asm("cli")
    lcd_clear();
    lcd_puts("Memory read");
    addr = 3 + num * (MAX_ITEMS + 1);
    block = addr / 256;
    addr = addr % 256;
    
    patt.length = read_var(block, addr);
    
    addr++;
    check_ab();
    
    lcd_gotoxy(0, 1);
    lcd_puts(t_preset);
    lcd_putchar(' ');
    LCDWriteInt(num, 0);
    lcd_putchar(' ');
    lcd_puts(t_item);
    lcd_putchar(' ');

    for(j = 0; j < MAX_ITEMS; j++)                
    {                          
        lcd_gotoxy(14, 1);
        LCDWriteInt(j, 0);
        lcd_putchar(' ');
        patt.out[j] = read_var(block, addr);
        addr++;
        check_ab();
    }          
    #asm("sei")
    return patt;
}

unsigned char init_check()
{
    _e_read = read_var(0, 0);
    if (_e_read != 0x19)
        return 1;
    _e_read = read_var(0, 1);
    if (_e_read != 0x08)
        return 1;
    _e_read = read_var(0, 2);
    if (_e_read != 0x1E)
        return 1;
    return 0;
}

void zero_init()
{
    lcd_clear();
    lcd_puts("Memory init");
    write_var(0, 0, 0x19);
    write_var(0, 1, 0x08);
    write_var(0, 2, 0x1E);  //30
           
    block = 0;            
    addr = 3;
    for(i = 0; i < MAX_PATTERNS; i++)
    {
        write_var(block, addr, v1.length);
        addr++;
            check_ab();
        for(j = 0; j < MAX_ITEMS; j++)                
        {                   
            lcd_gotoxy(0, 1);  
            
            lcd_puts(t_preset);
            lcd_putchar(' ');
            
            LCDWriteInt(i, 0);
            
            lcd_putchar(' ');
            lcd_puts(t_item);
            lcd_putchar(' ');
            
            LCDWriteInt(j, 0);
            lcd_putchar(' ');
            
            write_var(block, addr, v1.out[j]);
            addr++;
            check_ab();
        }
    }
}