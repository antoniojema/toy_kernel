#pragma once

#include "std.h"

inline bool write_in_string(char c, size_t pos, char* str, size_t max_size) {
    if (pos >= max_size) return false;
    str[pos] = c;
    return true;
}

inline void invert_string(char* str, size_t size) {
    size_t n1 = 0;
    size_t n2 = size-1;
    while (n1 < n2) swap(str[n1++], str[n2--]);
}

inline bool unsigned_to_string(size_t n, char* buff, size_t max_size) {
    size_t pos = 0;
    if (n == 0) {
        if (!write_in_string('0', pos++, buff, max_size)) return false;
        if (!write_in_string(0, pos, buff, max_size)) return false;
    }
    while (n > 0) {
        size_t digit = n % 10;
        n = (n-digit) / 10;
        if (!write_in_string('0' + (char)digit, pos++, buff, max_size)) return false;
    }
    if (!write_in_string(0, pos, buff, max_size)) return false;
    invert_string(buff, pos);
    return true;
}

inline bool signed_to_string(ptrdiff_t n, char* buff, size_t max_size) {
    if (n >= 0) {
        return unsigned_to_string((unsigned long long int)n, buff, max_size);
    }
    else {
        if (!unsigned_to_string((unsigned long long int)(-n), buff+1, max_size-1)) {
            return false;
        }
        buff[0] = '-';
        return true;
    }
}
