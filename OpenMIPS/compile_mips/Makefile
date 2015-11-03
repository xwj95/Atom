ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

TARGET = $(out)
OBJECTS = $(TARGET).o

export	CROSS_COMPILE

# ********************
# Rules of Compilation
# ********************

all: $(TARGET).om $(TARGET).bin $(TARGET).data

%.o: %.s
	$(CC) -mips32 $< -o $@
$(TARGET).om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@
$(TARGET).bin: $(TARGET).om
	$(OBJCOPY) -O binary $<  $@
$(TARGET).data: $(TARGET).bin
	./Bin2Mem -f $< -o $@
clean:
	rm -f *.o *.om *.bin *.data
