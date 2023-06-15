#pragma once

#include <stddef.h>
#include <stdint.h>

namespace Screen {
    void clear_screen();
    void clear_row(uint8_t row);

    void print_string(const char* str, bool endl = true, uint8_t attr = 0);
    void print_signed(size_t number, bool endl = true, uint8_t attr = 0);
    void print_unsigned(size_t number, bool endl = true, uint8_t attr = 0);
}