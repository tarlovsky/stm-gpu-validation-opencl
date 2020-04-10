LIB := ../lib

STM := ../tl2

CC       := g++
CPP      := g++
LD       := g++

CFLAGS   += -std=c++11 -g -w -pthread -fpermissive
CFLAGS   += -O2
CFLAGS   += -DSTM -I$(STM) -I$(LIB) -I../rapl-power/

CPPFLAGS += $(CFLAGS)
LDFLAGS  += $(CFLAGS) -L$(STM) -L../rapl-power