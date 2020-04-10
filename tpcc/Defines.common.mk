PROG := tpcc

LIBS += -lboost_system

SRCS += \
	memory.cc \
	pair.cc \
	list.cc \
	hashtable.cc \
	tpcc.cc \
	tpccclient.cc \
	tpccgenerator.cc \
	tpcctables.cc \
	tpccdb.cc \
	clock.cc \
	randomgenerator.cc \
	stupidunit.cc \
	mt19937ar.c \
	random.c \
	$(LIB)/thread.c

OBJS := ${SRCS:.c=.o}
