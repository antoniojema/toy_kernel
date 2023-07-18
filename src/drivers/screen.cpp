#include "screen.h"

#include <stddef.h>
#include <stdint.h>
#include "kernel/string.h"
#include "port_io.h"

namespace Screen {
    namespace {
        constexpr uint8_t N_ROWS = 25;
        constexpr uint8_t N_COLS = 80;
        constexpr size_t MEMORY_BEGIN = 0xB8000;
        constexpr size_t MEMORY_END = 0xB8FA0;

        constexpr size_t REG_SCREEN_CTRL = 0x3D4;
        constexpr size_t REG_SCREEN_DATA = 0x3D5;
        
        size_t get_cell_addr(uint8_t row, uint8_t col) {
            return MEMORY_BEGIN + 2 * (row * N_COLS + col);
        }

        // uint16_t get_cursor_offset () {
        //     port_byte_out (REG_SCREEN_CTRL, 14);
        //     uint16_t offset = port_byte_in(REG_SCREEN_DATA) << 8;
        //     port_byte_out (REG_SCREEN_CTRL, 15);
        //     offset += port_byte_in(REG_SCREEN_DATA);
        //     return offset;
        // }

        struct Cursor {
            void update(uint8_t new_row, uint8_t new_col) {
                this->r = new_row;
                this->c = new_col;
                update_screen_cursor();
            }
            void inc_col() {this->c++; update_screen_cursor();}
            void inc_row() {this->r++; this->c = 0; update_screen_cursor();}
            void zero_col() {this->c = 0; update_screen_cursor();}

            uint8_t row() {return this->r;}
            uint8_t col() {return this->c;}

            size_t get_cell_addr() {
                return ::Screen::get_cell_addr(this->r, this->c);
            }

            Cursor() {
                this->update_screen_cursor();
            }

            private:
                uint8_t r {0};
                uint8_t c {0};
            
            void update_screen_cursor() {
                uint16_t offset = (uint16_t)this->r * N_COLS + (uint16_t)this->c;

                uint8_t byte_high = (uint8_t)(offset >> 8);
                uint8_t byte_low  = (uint8_t)(offset & 0x00FF);
                
                port_byte_out(REG_SCREEN_CTRL, 14);
                port_byte_out(REG_SCREEN_DATA, byte_high);
                port_byte_out(REG_SCREEN_CTRL, 15);
                port_byte_out(REG_SCREEN_DATA, byte_low);
            }
        } cursor;

        void scroll(uint8_t n_rows) {
            if (n_rows >= N_ROWS) {
                clear_screen();
                return;
            }
            for (uint8_t n_row = 0; n_row < N_ROWS; ++n_row) {
                uint8_t n_row_copy = n_row + n_rows;
                if (n_row_copy >= N_ROWS) {
                    clear_row(n_row);
                }
                else {
                    void* mem1 = (void*)(get_cell_addr(n_row, 0));
                    void* mem2 = (void*)(get_cell_addr(n_row_copy, 0));
                    memcpy(mem1, mem2, 2 * N_COLS);
                }
            }
            cursor.update(N_ROWS - n_rows, 0);
        }

        void print_char(char c, uint8_t attr) {
            if (attr == 0) attr = WHITE_ON_BLACK;

            if (c != '\n') {
                char* mem = (char*)cursor.get_cell_addr();
                *mem = c;
                *(mem + 1) = (char)attr;
                cursor.inc_col();
            }

            if (c == '\n' || cursor.col() == N_COLS) {
                if (cursor.row() != N_ROWS-1) {
                    cursor.inc_row();
                }
                else {
                    scroll(1);
                }
            }
        }
    } // namespace

    void clear_screen() {
        for (char* mem = (char*)MEMORY_BEGIN; mem < (char*)MEMORY_END; mem += 2) {
            *mem = ' ';
            *(mem + 1) = (char)WHITE_ON_BLACK;
        }
        cursor.update(0,0);
    }

    void clear_row(uint8_t row) {
        char* begin = (char*)(get_cell_addr(row, 0));
        char* end = begin + 2 * N_COLS;
        for (char* mem = begin; mem < end; mem += 2) {
            *mem = ' ';
            *(mem + 1) = (char)WHITE_ON_BLACK;
        }
        cursor.update(row, 0);
    }

    void print_string(const char* str, bool endl, uint8_t attr) {
        const char* char_ptr = str;
        while(*char_ptr != 0) {
            print_char(*char_ptr, attr);
            char_ptr++;
        }

        if (endl) {
            print_char('\n', attr);
        }
    }

    void print_signed(size_t number, bool endl, uint8_t attr) {
        char buff[N_COLS+1];
        if (!signed_to_string(number, buff, N_COLS+1)) {
            print_string("Number too large\n", endl, attr);
            return;
        }
        print_string(buff, endl, attr);
    }

    void print_unsigned(size_t number, bool endl, uint8_t attr) {
        char buff[N_COLS+1];
        if (!unsigned_to_string(number, buff, N_COLS+1)) {
            print_string("Number too large", endl, attr);
            return;
        }
        print_string(buff, endl, attr);
    }
}