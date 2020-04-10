
LIB := ../lib

STM := ../swissTM

CC       := g++
CPP      := g++
LD       := g++

CFLAGS   += -std=c++11 -g -w -pthread -fpermissive
CFLAGS   += -O2
CFLAGS   += -DSTM -DSTM_WLPDSTM -I$(LIB) -I../rapl-power/ -I$(STM)/include

CPPFLAGS += $(CFLAGS)
LDFLAGS  += $(CFLAGS) -L$(STM)/lib -static -L../rapl-power

