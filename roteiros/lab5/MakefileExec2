# Build para 32 bits com NASM + GCC (com suporte a debug no GDB)
# Obs: pode ser necessário instalar libs 32-bit:
# Debian/Ubuntu: sudo apt-get install gcc-multilib libc6-dev-i386

TARGET := exec2
SRC    := exec2.asm
OBJ    := $(TARGET).o

NASM   := nasm
CC     := gcc
NASMFLAGS := -f elf32 -g -F dwarf   # gera info de debug para NASM
CFLAGS := -m32 -no-pie -g           # gera info de debug para C/ASM
LDFLAGS := -m32 -no-pie -g

.PHONY: all run debug clean

all: $(TARGET)

$(OBJ): $(SRC)
	$(NASM) $(NASMFLAGS) $< -o $@

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) $< -o $@

run: $(TARGET)
	./$(TARGET)

debug: $(TARGET)
	gdb ./$(TARGET)

clean:
	$(RM) $(OBJ) $(TARGET)
