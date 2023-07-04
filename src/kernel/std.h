#pragma once

#include <stddef.h>

template<typename T>
inline void swap(T& x1, T& x2) {
    T tmp = (T&&)x1;
    x1 = (T&&)x2;
    x2 = (T&&)tmp;
}

inline void memset(void* ptr, char value, size_t size) {
    char* char_ptr = (char*)ptr;
    for (size_t i = 0; i < size; ++i) {
        *char_ptr = value;
        char_ptr++;
    }
}

inline void memcpy(void* destination, void* source, size_t num) {
    for (size_t i = 0; i < num; ++i) {
        *((char*)destination + i) = *((char*)source + i);
    }
}

#define low_16(address) (uint16_t)((address) & 0xFFFF)
#define high_16(address) (uint16_t)(((address) >> 16) & 0xFFFF)
