#include "timer.h"

#include "idt.h"
#include "../kernel/string.h"
#include "../drivers/screen.h"
#include "../drivers/port_io.h"

uint32_t tick = 0;

void timer_callback(IDT::Registers regs) {
    Screen::print_string("Tick ", false);
    Screen::print_unsigned(tick++);
}

void set_timer(uint32_t freq) {
    IDT::register_isr(IDT::IRQ0, timer_callback);

    /* Get the PIT value: hardware clock at 1193180 Hz */
    uint32_t divisor = 1193180 / freq;
    uint8_t low  = low_8 (divisor);
    uint8_t high = high_8(divisor);

    /* Send the command */
    port_byte_out(0x43, 0x34); /* Command port */
    port_byte_out(0x40, low);
    port_byte_out(0x40, high);
}
