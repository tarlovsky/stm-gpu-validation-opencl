LIB := ../lib

STM := ../TinySTM

CC       := g++
CPP      := g++
LD       := g++

CFLAGS   += -std=c++11 -w -pthread -fpermissive
CFLAGS   += -O2
CFLAGS   += -DSTM -I$(LIB) -I$(STM)/include -I../rapl-power/

CPPFLAGS += $(CFLAGS)
LDFLAGS  += $(CFLAGS) -L$(STM)/lib -L../rapl-power

