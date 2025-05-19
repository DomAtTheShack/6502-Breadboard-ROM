#include <stdint.h>
#include <stdio.h>
#include <conio.h>

// External functions from io.c
extern void custom_hardware_init(void);
extern void set_led(uint8_t pattern);
extern uint8_t read_switches(void);

// Simple delay function - adjust based on CPU speed
void delay(uint16_t ms) {
    uint16_t i, j;
    for (i = 0; i < ms; i++) {
        for (j = 0; j < 50; j++) {
            asm("nop");
        }
    }
}

int main(void) {
    uint8_t count = 0;

    // Initialize hardware
    custom_hardware_init();

    // Print welcome message
    printf("Custom 6502 System\n");
    printf("-----------------\n");

    // Main loop
    while (1) {
        // Update LED pattern
        set_led(count);
        count++;

        // Read switches and display
        printf("Switches: %02X\n", read_switches());

        // Delay
        delay(250);

        // Check for keypress to exit loop
        if (kbhit()) {
            char c = cgetc();
            if (c == 'q') {
                break;
            }
            printf("Key pressed: %c\n", c);
        }
    }

    printf("Program terminated.\n");
    return 0;
}