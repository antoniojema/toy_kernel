#include "keyboard.h"

#include "../cpu/idt.h"
#include "../drivers/screen.h"


void keyboard_callback(IDT::Registers registers) {
    Screen::print_string("Keyboard interrupt called.");
}


void register_keyboard() {
    register_isr(IDT::IRQ1, keyboard_callback);
}
