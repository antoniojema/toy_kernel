#pragma once

#include <stdint.h>

namespace IDT {
    struct Registers {
        uint32_t ds; /* Data segment selector */
        uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax; /* Pushed by pusha. */
        uint32_t int_no, err_code; /* Interrupt number and error code (if applicable) */
        uint32_t eip, cs, eflags, useresp, ss; /* Pushed by the processor automatically */
    };
    
    enum IRQ_Number {
        IRQ0 = 32, IRQ1, IRQ2, IRQ3, IRQ4, IRQ5, IRQ6, IRQ7, IRQ8, IRQ9, IRQ10, IRQ11, IRQ12, IRQ13, IRQ14, IRQ15
    };
    
    using isr_t = void (*)(Registers);
    
    void set_idt();
    void register_isr(uint8_t n, isr_t handler);

    extern "C" void call_interrupt(uint8_t n); 

} // namespace IDT
