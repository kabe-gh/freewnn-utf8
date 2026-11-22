all: testmain

CPPFLAGS += -DHAVE_CONFIG_H -DSTDC_HEADERS -DJAPANESE
CPPFLAGS += -I.. -I../Wnn/etc -I../Wnn/include
CFLAGS += -g -O

testmain: testmain.c xucstab.h xutoj.o
	$(CC) -g $(CPPFLAGS) $(CFLAGS) -o $@ testmain.c xutoj.o

SRC_XUTOJ_C = ../Wnn/etc/xutoj.c
#SRC_XUTOJ_C = xutoj.c
xutoj.o: $(SRC_XUTOJ_C)
	$(CC) -g $(CPPFLAGS) $(CFLAGS) -c -o $@ $(SRC_XUTOJ_C)

xucstab.h: gen.pl
	perl gen.pl > $@

clean::
	rm -f testmain *.o xucstab.h
