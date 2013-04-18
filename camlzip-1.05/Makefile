### Configuration section

# The name of the Zlib library.  Usually -lz
ZLIB_LIB=-lz

# The directory containing the Zlib library (libz.a or libz.so)
ZLIB_LIBDIR=/cygdrive/c/zlib/lib

# The directory containing the Zlib header file (zlib.h)
ZLIB_INCLUDE=/cygdrive/c/zlib/include

# Where to install the library.  By default: sub-directory 'zip' of
# OCaml's standard library directory.
INSTALLDIR=`$(OCAMLC) -where`/zip

### End of configuration section

OCAMLC=ocamlc -g
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
OCAMLMKLIB=ocamlmklib

OBJS=zlib.cmo zip.cmo gzip.cmo
C_OBJS=zlibstubs.o

all: libcamlzlib.a zlib.cma libcamlzip.a zip.cma

allopt: libcamlzlib.a zlib.cmxa libcamlzip.a zip.cmxa

zip.cma: $(OBJS)
	$(OCAMLMKLIB) -o zip -oc camlzip $(OBJS) \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

zip.cmxa: $(OBJS:.cmo=.cmx)
	$(OCAMLMKLIB) -o zip -oc camlzip $(OBJS:.cmo=.cmx) \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

libcamlzip.a: $(C_OBJS)
	$(OCAMLMKLIB) -oc camlzip $(C_OBJS) \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

zlib.cma: $(OBJS)
	$(OCAMLMKLIB) -o zlib -oc camlzlib zlib.cmo \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

zlib.cmxa: zlib.cmx
	$(OCAMLMKLIB) -o zlib -oc camlzlib zlib.cmx \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

libcamlzlib.a: $(C_OBJS)
	$(OCAMLMKLIB) -oc camlzlib $(C_OBJS) \
            -L$(ZLIB_LIBDIR) $(ZLIB_LIB)

.SUFFIXES: .mli .ml .cmo .cmi .cmx

.mli.cmi:
	$(OCAMLC) -c $<
.ml.cmo:
	$(OCAMLC) -c $<
.ml.cmx:
	$(OCAMLOPT) -c $<
.c.o:
	$(OCAMLC) -c -ccopt -g -ccopt -I$(ZLIB_INCLUDE) $<

clean:
	rm -f *.cm*
	rm -f *.o *.a

install:
	mkdir -p $(INSTALLDIR)
	cp zlib.cma zlib.cmi zlib.mli libcamlzlib.a zip.cma zip.cmi gzip.cmi zip.mli gzip.mli libcamlzip.a $(INSTALLDIR)
	if test -f dllcamlzip.so; then \
	  cp dllcamlzip.so $(INSTALLDIR); \
          ldconf=`$(OCAMLC) -where`/ld.conf; \
          installdir=$(INSTALLDIR); \
          if test `grep -s -c $$installdir'$$' $$ldconf || :` = 0; \
          then echo $$installdir >> $$ldconf; fi \
        fi
	if test -f dllcamlzlib.so; then \
	  cp dllcamlzlib.so $(INSTALLDIR); \
          ldconf=`$(OCAMLC) -where`/ld.conf; \
          installdir=$(INSTALLDIR); \
          if test `grep -s -c $$installdir'$$' $$ldconf || :` = 0; \
          then echo $$installdir >> $$ldconf; fi \
        fi

installopt:
	cp zlib.a zlib.cmxa zip.cmxa zip.a zip.cmx gzip.cmx $(INSTALLDIR)

depend:
	gcc -MM -I$(ZLIB_INCLUDE) *.c > .depend
	ocamldep *.mli *.ml >> .depend

include .depend
