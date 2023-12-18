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

inline size_t unsigned_to_string(size_t n, char* buff, size_t max_size) {
    size_t pos = 0;
    if (n == 0) {
        if (!write_in_string('0', pos++, buff, max_size)) return 0;
    }
    else {
        while (n > 0) {
            size_t digit = n % 10;
            n = (n-digit) / 10;
            if (!write_in_string('0' + (char)digit, pos++, buff, max_size)) return 0;
        }
    }
    if (!write_in_string(0, pos, buff, max_size)) return 0;
    invert_string(buff, pos);
    return pos;
}

inline size_t signed_to_string(ptrdiff_t n, char* buff, size_t max_size) { 
    if (n >= 0) {
        return unsigned_to_string((size_t)n, buff, max_size);
    }
    else {
        size_t pos_size = unsigned_to_string((size_t)(-n), buff+1, max_size-1);
        if (pos_size == 0) {
            return 0;
        }
        buff[0] = '-';
        return pos_size + 1;
    }
}

class StringView {
public:
    StringView(char const * str, size_t size) :
        _str(str), _size(size) {}
    
    const char& operator[](size_t n) const {return this->_str[n];}

    size_t size() const {return this->_size;}

    bool isNull() const {return this->_str == nullptr;}

private:
    char const * _str;
    size_t _size;
};

class StringParser {
public:
    StringParser(char const * str) : _str(str) {}

    StringView getLine() {
        while (this->_str[this->_pos] == '\n') { this->_pos++; }
        if (this->_str[this->_pos] == '\0') return StringView(nullptr, 0);

        size_t ini = this->_pos;
        while (this->_str[this->_pos] != '\n' && this->_str[this->_pos] != '\0') {
            this->_pos++;
        }
        size_t size = this->_pos - ini;
        return StringView(this->_str + ini, size);
    };

private:
    char const * _str;
    size_t _pos = 0;
};
