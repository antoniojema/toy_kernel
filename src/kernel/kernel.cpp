// #include "drivers/screen.h"
// #include "cpu/idt.h"
// #include "cpu/timer.h"

// void print_fibonacci(size_t n) {
//     if (n == 0) return;
    
//     size_t n1 = 1;
//     size_t n2 = 1;
    
//     Screen::print_string("1", true, 0);
//     if (n == 1) return;
    
//     Screen::print_string("1", true, 1);

//     for (size_t n_ = 2; n_ < n; ++n_) {
//         size_t n3 = n1 + n2;
//         n1 = n2;
//         n2 = n3;
        
//         Screen::print_unsigned(n3, true, (uint8_t)n_);
//     }
// }

// void main() {
    // Screen::clear_screen();
    // print_fibonacci(27);
    
    // IDT::set_idt();

    // print_fibonacci(5);

    // Screen::print_signed(5);
    // Screen::print_string("Done");

    // asm volatile("sti");

    // while (true);
    // // set_timer(1);
// }

#include "../drivers/screen.h"
#include "../day01/day01.h"

void main() {
    Screen::clear_screen();
    solve();
}
