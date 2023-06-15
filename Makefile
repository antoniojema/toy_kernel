SRC_FILES := $(wildcard src/**/*.cpp)
OBJ_FILES := $(patsubst src/%.cpp,out/%.o,$(SRC_FILES))

############
#   Basic
############
all: out/os_image.bin

dbg:
	@echo $(SRC_FILES)
	@echo $(OBJ_FILES)

clean:
	rm -rf out

rebuild: clean all

run: all
	qemu-system-x86_64.exe -fda out\os_image.bin

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

${OBJ_FILES}: out/%.o: src/%.cpp
	mkdir -p $(dir $@)
	i686-elf-g++ -ffreestanding -m32 -c -std=c++20 -static-libgcc -lgcc -Wall -Wextra -fno-exceptions -fno-rtti $< -o $@ -I src

out/kernel/kernel.bin: out/kernel/kernel_entry.o ${OBJ_FILES}
	i686-elf-ld -o out/kernel/kernel.bin -Ttext 0x1000 out/kernel/kernel_entry.o ${OBJ_FILES} --oformat binary

################
#   OS Image
################
out/os_image.bin: out/bootloader/bootloader.bin out/kernel/kernel.bin
	cat out/bootloader/bootloader.bin out/kernel/kernel.bin > out/os_image.bin
