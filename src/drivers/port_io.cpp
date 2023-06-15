#ifdef _INTELLISENSE
#define __asm__(ARGS)
#endif

#include "port_io.h"

unsigned char port_byte_in(unsigned short port) {
    unsigned char result ;
    __asm__(
        "in %%dx , %%al"
        : "=a" ( result )
        : "d" ( port )
    );
    return result ;
}

unsigned short port_word_in(unsigned short port) {
    unsigned short result ;
    __asm__(
        "in %%dx , %%ax"
        : "=a" ( result )
        : "d" ( port )
    );
    return result ;
}

void port_byte_out(unsigned short port, unsigned char data) {
    __asm__(
        "out %%al, %%dx"
        :
        : "d" ( port ), "a" (data)
    );
}

void port_word_out(unsigned short port, unsigned short data) {
    __asm__(
        "out %%ax, %%dx"
        :
        : "d" ( port ), "a" (data)
    );
}
