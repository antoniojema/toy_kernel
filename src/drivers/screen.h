#pragma once

#include <stddef.h>
#include <stdint.h>

namespace Screen {
    constexpr uint8_t WHITE_ON_BLACK = 0x0F;

    void clear_screen();
    void clear_row(uint8_t row);

    void print_string(const char* str, bool endl = true, uint8_t attr = WHITE_ON_BLACK);
    void print_signed(size_t number, bool endl = true, uint8_t attr = WHITE_ON_BLACK);
    void print_unsigned(size_t number, bool endl = true, uint8_t attr = WHITE_ON_BLACK);
}