
LIBS += -lstm -lrapl -lpthread -lrt -lOpenCL

.PHONY: default
default: $(PROG)

.PHONY: clean
clean:
	$(RM) $(OBJS) $(PROG) $(OUTPUT)

$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) $^ $(LIBS) -o $(PROG)

include ../common/Makefile.common
