##############
## Binaries ##
##############
CC = arm-none-eabi-gcc

#################
## Directories ##
#################
SRC_DIR = src
OBJ_DIR = obj
INC_DIR = inc
DEB_DIR = debug
SUP_DIR = startup

###########
## Files ##
###########
SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(SUP_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(SRC))
OBJ := $(patsubst $(SUP_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(OBJ))
LD := $(wildcard $(SUP_DIR)/*.ld)

###########
## FLAGS ##
###########
MARCH = cortex-m4
CFLAGS = -g -Wall -Wextra -mcpu=$(MARCH) -mthumb -I./inc
LFLAGS = -nostdlib -T $(LD) -Wl,-Map=$(DEB_DIR)/main.map 

#############
## TARGETS ##
#############
TARGET = $(DEB_DIR)/main.elf

all: $(OBJ) $(TARGET)

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | mk_objdir
	$(CC) $(CFLAGS) -c -o $@ $^

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SUP_DIR)/%.c | mk_objdir
	$(CC) $(CFLAGS) -c -o $@ $^

$(TARGET) : $(OBJ) | mk_debdir
	$(CC) $(LFLAGS) -o $@ $^

flash:
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg &
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/init.gdb
	pkill openocd

mk_objdir:
	mkdir -p $(SRC_DIR)/$(OBJ_DIR)

mk_debdir:
	mkdir -p $(DEB_DIR)

update_doc:
	cd doxy && doxygen Doxyfile

debug: FORCE
	openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg &
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/debug.gdb

clean:
	rm -rf $(SRC_DIR)/$(OBJ_DIR) $(DEB_DIR)

FORCE:

.PHONY = flash mk_debdir mk_objdir clean update_doc debug FORCE
