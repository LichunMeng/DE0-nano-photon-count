#
TARGET = my_FIFO

#
ALT_DEVICE_FAMILY       = soc_cv_av
SOCEDS_DEST_ROOT       = /home/lm/intelFPGA/20.1/embedded/
HWLIBS_ROOT             = ${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabi-
#CFLAGS = -static -g -Wall  -I /home/lm/intelFPGA/20.1/embedded/ip/altera/hps/altera_hps/hwlib/include -I /home/lm/intelFPGA/20.1/embedded/ip/altera/hps/altera_hps/hwlib/include/soc_a10 -I /home/lm/intelFPGA_lite/20.1/ip/altera/sopc_builder_ip/altera_avalon_fifo/HAL/inc -I /home/lm/intelFPGA_lite/20.1/ip/altera/sopc_builder_ip/altera_avalon_fifo/inc

CFLAGS                  = -static -g -Wall -I $(HWLIBS_ROOT)/include -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)  -D$(ALT_DEVICE_FAMILY)
CFLAGS+= -I /home/lm/intelFPGA_lite/20.1/ip/altera/sopc_builder_ip/altera_avalon_fifo/HAL/inc 
CFLAGS+= -I /home/lm/intelFPGA_lite/20.1/ip/altera/sopc_builder_ip/altera_avalon_fifo/inc
CFLAGS+= -I /home/lm/intelFPGA_lite/20.1/ip/altera/alt_mem_if/altera_mem_if_qseq/software_110/sequencer_hps
CFLAGS+= -I /home/lm/intelFPGA_lite/20.1/ip/altera/nios2_ip/altera_nios2/HAL/inc
CFLAGS+= -I /home/lm/intelFPGA_lite/20.1/ip/altera/alt_mem_if/altera_mem_if_qseq/software_110/sequencer_bfm


LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc
ARCH= arm


build: $(TARGET)
$(TARGET): main.o 
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
