#pragma once

#include <stdint.h>

namespace IDT {
    struct Registers {
        uint32_t ds; /* Data segment selector */
        uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax; /* Pushed by pusha. */
        uint32_t int_no, err_code; /* Interrupt number and error code (if applicable) */
        uint32_t eip, cs, eflags, useresp, ss; /* Pushed by the processor automatically */
    };

    
    using isr_t = void (*)(Registers);
    
    void isr_install();

    void register_isr(uint8_t n, isr_t handler);  

} // namespace IDT
