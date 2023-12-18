#include "idt.h"
#include "kernel/std.h"
#include "kernel/string.h"
#include "drivers/screen.h"
#include "drivers/port_io.h"

#define KERNEL_CS 0x08

extern "C" void isr0();
extern "C" void isr1();
extern "C" void isr2();
extern "C" void isr3();
extern "C" void isr4();
extern "C" void isr5();
extern "C" void isr6();
extern "C" void isr7();
extern "C" void isr8();
extern "C" void isr9();
extern "C" void isr10();
extern "C" void isr11();
extern "C" void isr12();
extern "C" void isr13();
extern "C" void isr14();
extern "C" void isr15();
extern "C" void isr16();
extern "C" void isr17();
extern "C" void isr18();
extern "C" void isr19();
extern "C" void isr20();
extern "C" void isr21();
extern "C" void isr22();
extern "C" void isr23();
extern "C" void isr24();
extern "C" void isr25();
extern "C" void isr26();
extern "C" void isr27();
extern "C" void isr28();
extern "C" void isr29();
extern "C" void isr30();
extern "C" void isr31();

extern "C" void irq0();
extern "C" void irq1();
extern "C" void irq2();
extern "C" void irq3();
extern "C" void irq4();
extern "C" void irq5();
extern "C" void irq6();
extern "C" void irq7();
extern "C" void irq8();
extern "C" void irq9();
extern "C" void irq10();
extern "C" void irq11();
extern "C" void irq12();
extern "C" void irq13();
extern "C" void irq14();
extern "C" void irq15();
extern "C" void irq16();

namespace IDT {

namespace {

#pragma pack(1)

struct IDT_Entry {
    uint16_t offset_low;
    uint16_t segment_selector;
    uint8_t zero;
    // Flags:
    // 0-3: Gate type
    // 4: Zero
    // 5-6: DPL
    // 7: Present (1)
    uint8_t flags;
    uint16_t offset_high;
};
static_assert(sizeof(IDT_Entry) == 8);

struct IDT_Register {
    uint16_t limit;
    uint32_t base;
};
static_assert(sizeof(IDT_Register) == 6);

#pragma pack()


#define IDT_ENTRIES 256
#define IDT_SIZE (IDT_ENTRIES * sizeof(IDT_Entry))
inline IDT_Entry idt[IDT_ENTRIES];
inline IDT_Register idt_reg;

void set_idt_entry(int n, uint32_t handler) {
    idt[n].offset_low  = low_16 (handler);
    idt[n].offset_high = high_16(handler);
    idt[n].segment_selector = KERNEL_CS;
    idt[n].zero = 0;
    idt[n].flags = 0b10001110;
}

void isr_install() {
    set_idt_entry( 0, (uint32_t)&isr0 );
    set_idt_entry( 1, (uint32_t)&isr1 );
    set_idt_entry( 2, (uint32_t)&isr2 );
    set_idt_entry( 3, (uint32_t)&isr3 );
    set_idt_entry( 4, (uint32_t)&isr4 );
    set_idt_entry( 5, (uint32_t)&isr5 );
    set_idt_entry( 6, (uint32_t)&isr6 );
    set_idt_entry( 7, (uint32_t)&isr7 );
    set_idt_entry( 8, (uint32_t)&isr8 );
    set_idt_entry( 9, (uint32_t)&isr9 );
    set_idt_entry(10, (uint32_t)&isr10);
    set_idt_entry(11, (uint32_t)&isr11);
    set_idt_entry(12, (uint32_t)&isr12);
    set_idt_entry(13, (uint32_t)&isr13);
    set_idt_entry(14, (uint32_t)&isr14);
    set_idt_entry(15, (uint32_t)&isr15);
    set_idt_entry(16, (uint32_t)&isr16);
    set_idt_entry(17, (uint32_t)&isr17);
    set_idt_entry(18, (uint32_t)&isr18);
    set_idt_entry(19, (uint32_t)&isr19);
    set_idt_entry(20, (uint32_t)&isr20);
    set_idt_entry(21, (uint32_t)&isr21);
    set_idt_entry(22, (uint32_t)&isr22);
    set_idt_entry(23, (uint32_t)&isr23);
    set_idt_entry(24, (uint32_t)&isr24);
    set_idt_entry(25, (uint32_t)&isr25);
    set_idt_entry(26, (uint32_t)&isr26);
    set_idt_entry(27, (uint32_t)&isr27);
    set_idt_entry(28, (uint32_t)&isr28);
    set_idt_entry(29, (uint32_t)&isr29);
    set_idt_entry(30, (uint32_t)&isr30);
    set_idt_entry(31, (uint32_t)&isr31);

    // Remap the PIC
    port_byte_out(0x20, 0x11);
    port_byte_out(0xA0, 0x11);
    port_byte_out(0x21, 0x20);
    port_byte_out(0xA1, 0x28);
    port_byte_out(0x21, 0x04);
    port_byte_out(0xA1, 0x02);
    port_byte_out(0x21, 0x01);
    port_byte_out(0xA1, 0x01);
    port_byte_out(0x21, 0x0);
    port_byte_out(0xA1, 0x0); 
    
    set_idt_entry(IRQ0 , (uint32_t)&irq0 );
    set_idt_entry(IRQ1 , (uint32_t)&irq1 );
    set_idt_entry(IRQ2 , (uint32_t)&irq2 );
    set_idt_entry(IRQ3 , (uint32_t)&irq3 );
    set_idt_entry(IRQ4 , (uint32_t)&irq4 );
    set_idt_entry(IRQ5 , (uint32_t)&irq5 );
    set_idt_entry(IRQ6 , (uint32_t)&irq6 );
    set_idt_entry(IRQ7 , (uint32_t)&irq7 );
    set_idt_entry(IRQ8 , (uint32_t)&irq8 );
    set_idt_entry(IRQ9 , (uint32_t)&irq9 );
    set_idt_entry(IRQ10, (uint32_t)&irq10);
    set_idt_entry(IRQ11, (uint32_t)&irq11);
    set_idt_entry(IRQ12, (uint32_t)&irq12);
    set_idt_entry(IRQ13, (uint32_t)&irq13);
    set_idt_entry(IRQ14, (uint32_t)&irq14);
    set_idt_entry(IRQ15, (uint32_t)&irq15);
}

const char*const exception_messages[] = {
    "Division By Zero",
    "Debug",
    "Non Maskable Interrupt",
    "Breakpoint",
    "Into Detected Overflow",
    "Out of Bounds",
    "Invalid Opcode",
    "No Coprocessor",

    "Double Fault",
    "Coprocessor Segment Overrun",
    "Bad TSS",
    "Segment Not Present",
    "Stack Fault",
    "General Protection Fault",
    "Page Fault",
    "Unknown Interrupt",

    "Coprocessor Fault",
    "Alignment Check",
    "Machine Check",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",

    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved"
};

isr_t interrupt_handlers[256];

} // namespace

void set_idt() {
    idt_reg.base = (uint32_t) &idt;
    idt_reg.limit = IDT_SIZE - 1;

    memset(&idt, 0, IDT_SIZE);

    isr_install();
    
    __asm__ __volatile__("lidtl (%0)" : : "r" (&idt_reg));
}

void register_isr(uint8_t n, isr_t handler) {
    interrupt_handlers[n] = handler;
}

} // namespace IDT

extern "C" void isr_handler(IDT::Registers r) {
    Screen::print_string("Received interrupt: ", false);
    Screen::print_unsigned(r.int_no);
    Screen::print_string(IDT::exception_messages[r.int_no]);

    if (r.int_no == 0) {
        r.eip += 1;
    }
}

extern "C" void irq_handler(IDT::Registers r) {
    /* After every interrupt we need to send an EOI to the PICs
     * or they will not send another interrupt again */
    if (r.int_no >= 40) port_byte_out(0xA0, 0x20); /* slave */
    port_byte_out(0x20, 0x20); /* master */

    Screen::print_string("Received interrupt: ", false);
    Screen::print_unsigned(r.int_no);

    /* Handle the interrupt in a more modular way */
    if (IDT::interrupt_handlers[r.int_no] != nullptr) {
        IDT::isr_t handler = IDT::interrupt_handlers[r.int_no];
        handler(r);
    }
}
