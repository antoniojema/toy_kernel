SRC_FILES := $(wildcard src/**/*.cpp)
OBJ_FILES := $(patsubst src/%.cpp,out/%.o,$(SRC_FILES))
MAX_SECTORS := 50

# gcc_compiler := i686-elf-g++
gcc_compiler := g++

# gdb := i686-elf-g++
gdb := gdb

# linker := i686-elf-ld
linker := ld

qemu := qemu-system-x86_64

cxx_flags := -g -ffreestanding -m32 -c -std=c++20 -static-libgcc -lgcc -Wall -Wextra -fno-exceptions -fno-rtti -I src -fno-pie

############
#   Basic
############
all: out/os_image.bin out/kernel/kernel.elf

asm: out/kernel/kernel.asm

# dbg:
# 	@echo $(SRC_FILES)
# 	@echo $(OBJ_FILES)

clean:
	rm -rf out

rebuild: clean all

run: all
	${qemu} -fda out/os_image.bin

run_dbg: all
	${qemu} -s -fda out/os_image.bin

debug: all
	${qemu} -s -fda out/os_image.bin &
	${gdb} -ex "target remote localhost:1234" -ex "symbol-file out/kernel/kernel.elf"

#################
#   Bootloader
#################
out/bootloader/bootloader.bin: src/bootloader/bootloader.asm
	mkdir -p $(dir $@)
	nasm -f bin src/bootloader/bootloader.asm -o out/bootloader/bootloader.bin


#############
#   Kernel
#############
out/kernel/kernel_entry.o: src/kernel/kernel_entry.asm
	mkdir -p $(dir $@)
	nasm -f elf src/kernel/kernel_entry.asm -o out/kernel/kernel_entry.o

out/cpu/interrupts.o: src/cpu/interrupts.asm
	mkdir -p $(dir $@)
	nasm -f elf src/cpu/interrupts.asm -o out/cpu/interrupts.o

${OBJ_FILES}: out/%.o: src/%.cpp
	mkdir -p $(dir $@)
	${gcc_compiler} ${cxx_flags} $< -o $@ 

out/kernel/kernel.bin: out/kernel/kernel_entry.o out/cpu/interrupts.o ${OBJ_FILES}
	${linker} -o out/kernel/kernel.bin -Ttext 0x1000 out/kernel/kernel_entry.o out/cpu/interrupts.o ${OBJ_FILES} --oformat binary -m elf_i386

out/kernel/kernel.elf: out/kernel/kernel_entry.o out/cpu/interrupts.o ${OBJ_FILES}
	${linker} -o out/kernel/kernel.elf -Ttext 0x1000 out/kernel/kernel_entry.o out/cpu/interrupts.o ${OBJ_FILES} -m elf_i386

out/kernel/kernel.asm: out/kernel/kernel.elf
	objdump -S out/kernel/kernel.elf > out/kernel/kernel.asm

################
#   OS Image
################
out/os_image.bin: out/bootloader/bootloader.bin out/kernel/kernel.bin
	cat out/bootloader/bootloader.bin out/kernel/kernel.bin > out/os_image.bin
	
	OS_SIZE=$$(stat --format="%s" out/os_image.bin);\
	MAX_SIZE=$$(($(MAX_SECTORS)*512));\
	if [ $$OS_SIZE -gt $$MAX_SIZE ]; then\
		echo "OS image is too large: $$OS_SIZE bytes > $$MAX_SIZE";\
		rm out/os_image.bin;\
		exit 1;\
	fi

