#pragma once

#include "std.h"

inline void append_strings(const char* buff_1, const char* buff_2, size_t len1, size_t len2, char* buff_3) {
    for (size_t i = 0; i < len1; ++i) {
        buff_3[i] = buff_1[i];
    }
    for (size_t i = 0; i < len2; ++i) {
        buff_3[len1 + i] = buff_2[i];
    }
}

inline size_t strlen(const char* str) {
    size_t len = 0;
    while (str[len] != 0) ++len;
    return len;
}

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
