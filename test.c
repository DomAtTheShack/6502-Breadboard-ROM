#define PORTB (*(volatile unsigned char*)0x6000)
#define PORTA (*(volatile unsigned char*)0x6001)
#define DDRB  (*(volatile unsigned char*)0x6002)
#define DDRA  (*(volatile unsigned char*)0x6003)

#define E   0x80  // %10000000
#define RW  0x40  // %01000000
#define RS  0x20  // %00100000

void lcd_wait(void) {
    unsigned char temp;

    // Set PORTB as input
    DDRB = 0x00;

    // Check the busy flag
    PORTA = RW;
    PORTA = RW | E;
    temp = PORTB;

    while (temp & 0x80) {  // Check if the busy flag is set
        PORTA = RW;
        PORTA = RW | E;
        temp = PORTB;
    }

    // Set PORTB as output again
    DDRB = 0xFF;
}

void lcd_instruction(unsigned char instruction) {
    lcd_wait();
    PORTB = instruction;

    PORTA = 0x00;  // Clear RS/RW/E bits
    PORTA = E;     // Set E bit to send instruction
    PORTA = 0x00;  // Clear E bit
}

void print_char(unsigned char c) {
    lcd_wait();
    PORTB = c;

    PORTA = RS;    // Set RS; Clear RW/E bits
    PORTA = RS | E; // Set E bit to send data
    PORTA = RS;    // Clear E bit
}

void lcd_init(void) {
    // Set all pins on PORTB to output
    DDRB = 0xFF;

    // Set top 3 pins on PORTA to output
    DDRA = 0xE0;

    // Initialize LCD in 8-bit mode, 2-line display, 5x8 font
    lcd_instruction(0x38);
    // Display on, cursor on, blink off
    lcd_instruction(0x0E);
    // Increment cursor, no shift of display
    lcd_instruction(0x06);
    // Clear display
    lcd_instruction(0x01);
}

void print_message(const char* message) {
    while (*message) {
        print_char(*message++);
    }
}

int main(void) {
    lcd_init();          // Initialize LCD
    print_message("Hello, world!");  // Print message to LCD

    while(1) {
        // Main loop
    }

    return 0;
}
