# ftplibpp makefile

SONAME = 2
SOVERSION = $(SONAME).0

TARGETS = libftp++.a libftp++.so
OBJECTS = ftplib.o
SOURCES = ftplib.cpp

CFLAGS = -Wall $(DEBUG) -I. $(INCLUDES) $(DEFINES)
LDFLAGS = -L.
DEPFLAGS =
INSTALL_PREFIX=/usr

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SOFLAG=install_name
	ifdef SSL
		LIBS = -lssl -lcrypto
	else
		LIBS =
	endif
endif
ifeq ($(UNAME), Linux)
	SOFLAG=soname
	ifdef SSL
		LIBS = -lssl
	else
		LIBS =
	endif
endif

all : $(TARGETS)

clean :
	rm -f $(OBJECTS) core *.bak
	rm -rf unshared
	rm -f $(TARGETS) .depend
	rm -f libftp.so.*

uninstall :
	rm -f $(INSTALL_PREFIX)/lib/libftp.so.*
	rm -f $(INSTALL_PREFIX)/include/libftp.h

install : all
	install -m 644 libftp.so.$(SOVERSION) $(INSTALL_PREFIX)/lib
	install -m 644 ftplib.h $(INSTALL_PREFIX)/include
	(cd $(INSTALL_PREFIX)/lib && \
	 ln -sf libftp.so.$(SOVERSION) libftp.so.$(SONAME) && \
	 ln -sf libftp.so.$(SONAME) libftp.so)

depend :
	$(CC) $(CFLAGS) -M $(SOURCES) > .depend

ftplib.o: ftplib.cpp ftplib.h
	$(CC) -c $(CFLAGS) -fPIC -D_REENTRANT -DNOSSL $< -o $@

libftp++.a: ftplib.o
	ar -rcs $@ $<

libftp.so.$(SOVERSION): ftplib.o
	$(CC) -shared -Wl,-$(SOFLAG),libftp.so.$(SONAME) $(LIBS) -lc -o $@ $<

libftp++.so: libftp.so.$(SOVERSION)
	ln -sf $< libftp.so.$(SONAME)
	ln -sf $< $@

ifeq (.depend,$(wildcard .depend))
include .depend
endif
