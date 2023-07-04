#include "drivers/screen.h"
#include "cpu/idt.h"

void print_fibonacci(size_t n) {
    if (n == 0) return;
    
    size_t n1 = 1;
    size_t n2 = 1;
    
    Screen::print_string("1", true, 0);
    if (n == 1) return;
    
    Screen::print_string("1", true, 1);

    for (size_t n_ = 2; n_ < n; ++n_) {
        size_t n3 = n1 + n2;
        n1 = n2;
        n2 = n3;
        
        Screen::print_unsigned(n3, true, (uint8_t)n_);
    }
}

void main() {
    // bool cont = false;
    // while (!cont) {
    //     Screen::print_string("...");
    // }
    Screen::clear_screen();
    print_fibonacci(27);
    
    IDT::isr_install();

    print_fibonacci(5);
    
    __asm__ __volatile__("int $2");
    __asm__ __volatile__("int $3");
    
    print_fibonacci(5);
}
