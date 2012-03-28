cls
setlocal

REM Configuration Section ====================================================

set LIB=%LIB%;.
set INCLUDE=%INCLUDE%;.
set OCAMLLIB=%OCAMLLIB%
set ZLIB=C:\zlib\lib
set INSTALLDIR="%OCAMLLIB%"
set INSTALLDIR_DOC="%OCAMLLIB%"\..\doc\cryptokit
set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib

REM End of Configuration Section ==============================================

del *.obj *.lib *.cm* *.exe *.dll dllcryptokit.dll.manifest

:opt ==========================================================================

set FLAGS=/I"%OCAMLLIB%" /DHAVE_ZLIB

cl %FLAGS% /nologo /Ox /MT   -c rijndael-alg-fst.c
mv rijndael-alg-fst.obj rijndael-alg-fst.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-aes.c
mv stubs-aes.obj stubs-aes.d.obj
cl %FLAGS% /nologo /Ox /MT   -c d3des.c
mv d3des.obj d3des.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-des.c
mv stubs-des.obj stubs-des.d.obj
cl %FLAGS% /nologo /Ox /MT   -c arcfour.c
mv arcfour.obj arcfour.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-arcfour.c
mv stubs-arcfour.obj stubs-arcfour.d.obj
cl %FLAGS% /nologo /Ox /MT   -c sha1.c
mv sha1.obj sha1.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-sha1.c
mv stubs-sha1.obj stubs-sha1.d.obj
cl %FLAGS% /nologo /Ox /MT   -c sha256.c
mv sha256.obj sha256.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-sha256.c
mv stubs-sha256.obj stubs-sha256.d.obj
cl %FLAGS% /nologo /Ox /MT   -c ripemd160.c
mv ripemd160.obj ripemd160.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-ripemd160.c
mv stubs-ripemd160.obj stubs-ripemd160.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-md5.c
mv stubs-md5.obj stubs-md5.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-zlib.c
mv stubs-zlib.obj stubs-zlib.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-misc.c
mv stubs-misc.obj stubs-misc.d.obj
cl %FLAGS% /Ox /MT   -c stubs-rng.c
mv stubs-rng.obj stubs-rng.d.obj

lib /nologo /out:libcryptokit.lib /libpath:%ZLIB% zlib.lib rijndael-alg-fst.d.obj stubs-aes.d.obj d3des.d.obj stubs-des.d.obj arcfour.d.obj stubs-arcfour.d.obj sha1.d.obj stubs-sha1.d.obj sha256.d.obj stubs-sha256.d.obj ripemd160.d.obj stubs-ripemd160.d.obj stubs-md5.d.obj stubs-zlib.d.obj stubs-misc.d.obj stubs-rng.d.obj

flexlink -o dllcryptokit.dll rijndael-alg-fst.d.obj stubs-aes.d.obj d3des.d.obj stubs-des.d.obj arcfour.d.obj stubs-arcfour.d.obj sha1.d.obj stubs-sha1.d.obj sha256.d.obj stubs-sha256.d.obj ripemd160.d.obj stubs-ripemd160.d.obj stubs-md5.d.obj stubs-zlib.d.obj stubs-misc.d.obj stubs-rng.d.obj advapi32.lib %CCOPT% -default-manifest

ocamlopt.opt -g -c  cryptokit.mli
ocamlopt.opt -c  cryptokit.ml
ocamlopt.opt -verbose -ccopt "%CCOPT%" -a -o cryptokit.cmxa cryptokit.cmx -cclib -lcryptokit

:test =========================================================================
ocamlopt.opt -verbose -o test.opt.exe unix.cmxa nums.cmxa cryptokit.cmxa test.ml
ocamlopt.opt -o speedtest.exe unix.cmxa nums.cmxa cryptokit.cmxa speedtest.ml
test.opt.exe
speedtest.exe

: doc ==========================================================================
mkdir doc
ocamldoc -html -d doc *.mli

:install ======================================================================
copy cryptokit.cmxa cryptokit.cmx cryptokit.lib "%OCAMLLIB%"

mkdir %INSTALLDIR%
copy *.cmi %INSTALLDIR%
copy *.cmxa %INSTALLDIR%
copy *.mli %INSTALLDIR%
copy cryptokit.lib %INSTALLDIR%
copy libcryptokit.lib "%OCAMLLIB%"
copy dllcryptokit.dll "%OCAMLLIB%"\stublibs
mkdir %INSTALLDIR_DOC%
copy doc\* %INSTALLDIR_DOC%
rmdir /S /Q doc
del *.obj *.lib *.cm* *.exe *.dll dllcryptokit.dll.manifest


REM if "%1" == "opt" goto :opt

REM :byt
REM echo BYTE===============================================================================================

REM set STATICOPTS=/nologo /Ox /MT /I"%OCAMLLIB%" /DHAVE_ZLIB

REM cl %STATICOPTS% -c rijndael-alg-fst.c
REM mv rijndael-alg-fst.obj rijndael-alg-fst.s.obj
REM cl %STATICOPTS% -c stubs-aes.c
REM mv stubs-aes.obj stubs-aes.s.obj
REM cl %STATICOPTS% -c d3des.c
REM mv d3des.obj d3des.s.obj
REM cl %STATICOPTS% -c stubs-des.c
REM mv stubs-des.obj stubs-des.s.obj
REM cl %STATICOPTS% -c arcfour.c
REM mv arcfour.obj arcfour.s.obj
REM cl %STATICOPTS% -c stubs-arcfour.c
REM mv stubs-arcfour.obj stubs-arcfour.s.obj
REM cl %STATICOPTS% -c sha1.c
REM mv sha1.obj sha1.s.obj
REM cl %STATICOPTS% -c stubs-sha1.c
REM mv stubs-sha1.obj stubs-sha1.s.obj
REM cl %STATICOPTS% -c sha256.c
REM mv sha256.obj sha256.s.obj
REM cl %STATICOPTS% -c stubs-sha256.c
REM mv stubs-sha256.obj stubs-sha256.s.obj
REM cl %STATICOPTS% -c ripemd160.c
REM mv ripemd160.obj ripemd160.s.obj
REM cl %STATICOPTS% -c stubs-ripemd160.c
REM mv stubs-ripemd160.obj stubs-ripemd160.s.obj
REM cl %STATICOPTS% -c stubs-md5.c
REM mv stubs-md5.obj stubs-md5.s.obj
REM cl %STATICOPTS% -c stubs-zlib.c
REM mv stubs-zlib.obj stubs-zlib.s.obj
REM cl %STATICOPTS% -c stubs-misc.c
REM mv stubs-misc.obj stubs-misc.s.obj
REM cl %STATICOPTS% -c stubs-rng.c
REM mv stubs-rng.obj stubs-rng.s.obj

REM lib /nologo /debugtype:CV /out:libcryptokit.lib zlib.lib rijndael-alg-fst.s.obj stubs-aes.s.obj d3des.s.obj stubs-des.s.obj arcfour.s.obj stubs-arcfour.s.obj sha1.s.obj stubs-sha1.s.obj sha256.s.obj stubs-sha256.s.obj ripemd160.s.obj stubs-ripemd160.s.obj stubs-md5.s.obj stubs-zlib.s.obj stubs-misc.s.obj stubs-rng.s.obj

REM ocamlc -c  cryptokit.mli
REM ocamlc -c  cryptokit.ml
REM ocamlc -a -o cryptokit.cma cryptokit.cmo -dllib -lcryptokit -cclib -lcryptokit

REM set DLLOPTS=/nologo /Ox /MD /DCAML_DLL -I"%OCAMLLIB%" /DHAVE_ZLIB

REM cl %DLLOPTS% -c rijndael-alg-fst.c -Forijndael-alg-fst.d.obj
REM cl %DLLOPTS% -c stubs-aes.c -Fostubs-aes.d.obj
REM cl %DLLOPTS% -c d3des.c -Fod3des.d.obj
REM cl %DLLOPTS% -c stubs-des.c -Fostubs-des.d.obj
REM cl %DLLOPTS% -c arcfour.c -Foarcfour.d.obj
REM cl %DLLOPTS% -c stubs-arcfour.c -Fostubs-arcfour.d.obj
REM cl %DLLOPTS% -c sha1.c -Fosha1.d.obj
REM cl %DLLOPTS% -c stubs-sha1.c -Fostubs-sha1.d.obj
REM cl %DLLOPTS% -c sha256.c -Fosha256.d.obj
REM cl %DLLOPTS% -c stubs-sha256.c -Fostubs-sha256.d.obj
REM cl %DLLOPTS% -c ripemd160.c -Foripemd160.d.obj
REM cl %DLLOPTS% -c stubs-ripemd160.c -Fostubs-ripemd160.d.obj
REM cl %DLLOPTS% -c stubs-md5.c -Fostubs-md5.d.obj
REM cl %DLLOPTS% -c stubs-zlib.c -Fostubs-zlib.d.obj
REM cl %DLLOPTS% -c stubs-misc.c -Fostubs-misc.d.obj
REM cl %DLLOPTS% -c stubs-rng.c -Fostubs-rng.d.obj

REM flexlink -o dllcryptokit.dll rijndael-alg-fst.d.obj stubs-aes.d.obj d3des.d.obj stubs-des.d.obj arcfour.d.obj stubs-arcfour.d.obj sha1.d.obj stubs-sha1.d.obj sha256.d.obj stubs-sha256.d.obj ripemd160.d.obj stubs-ripemd160.d.obj stubs-md5.d.obj stubs-zlib.d.obj stubs-misc.d.obj stubs-rng.d.obj advapi32.lib -LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -default-manifest

REM rem "C:\Programmi\Microsoft Visual Studio 8\VC\bin\link" /nologo /dll /out:dllcryptokit.dll /implib:tmp.lib rijndael-alg-fst.d.obj stubs-aes.d.obj d3des.d.obj stubs-des.d.obj arcfour.d.obj stubs-arcfour.d.obj sha1.d.obj stubs-sha1.d.obj sha256.d.obj stubs-sha256.d.obj ripemd160.d.obj stubs-ripemd160.d.obj stubs-md5.d.obj stubs-zlib.d.obj stubs-misc.d.obj stubs-rng.d.obj "%OCAMLLIB%\ocamlrun.lib" advapi32.lib


REM cp cryptokit.cmi cryptokit.cma cryptokit.mli "%OCAMLLIB%"
REM cp libcryptokit.lib "%OCAMLLIB%"
REM cp dllcryptokit.dll "%OCAMLLIB%\stublibs"

REM rem goto :exit



:exit
endlocal







