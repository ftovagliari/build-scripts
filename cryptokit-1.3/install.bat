@cls
@for %%F in (%cd%) do @set name=%%~nF%%~xF
@title "Installing %name%"
@setlocal
@set cwd=%cd%
@call "%ProgramFiles(x86)%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat"
@call ..\build-scripts\setenv.bat
@cd %cwd%
@echo Current working directory: %cd%

@set OCAMLLIB=
@for /f %%x in ('ocamlc -where') do @set OCAMLLIB=%%x
@set OCAMLLIB=%OCAMLLIB:/=\%
@echo OCAMLLIB=%OCAMLLIB%

@REM Configuration Section ====================================================

set LIB=%LIB%;.
set INCLUDE=%INCLUDE%;.
set OCAMLLIB=%OCAMLLIB%
set ZLIB=C:\zlib
set INSTALLDIR="%OCAMLLIB%"
set INSTALLDIR_DOC="%OCAMLLIB%"\..\doc\cryptokit
@rem set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -L%ZLIB%\lib
set CCOPT=-LC:\PROGRA~1\MICROS~3\v7.0\lib -LC:\PROGRA~2\MICROS~1.0\VC\lib -LC:\PROGRA~2\MICROS~1.0\VC\ATLFMC\lib -L%ZLIB%\lib

@REM End of Configuration Section ==============================================

pushd src

@del *.obj *.lib *.cm* *.exe *.dll dllcryptokit.dll.manifest

:opt ==========================================================================

@set FLAGS=/I"%OCAMLLIB%" /D HAVE_ZLIB 

cl %FLAGS% /nologo /Ox /MT   -c rijndael-alg-fst.c
move rijndael-alg-fst.obj rijndael-alg-fst.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-aes.c
move stubs-aes.obj stubs-aes.d.obj
cl %FLAGS% /nologo /Ox /MT   -c d3des.c
move d3des.obj d3des.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-des.c
move stubs-des.obj stubs-des.d.obj
cl %FLAGS% /nologo /Ox /MT   -c arcfour.c
move arcfour.obj arcfour.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-arcfour.c
move stubs-arcfour.obj stubs-arcfour.d.obj
cl %FLAGS% /nologo /Ox /MT   -c sha1.c
move sha1.obj sha1.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-sha1.c
move stubs-sha1.obj stubs-sha1.d.obj
cl %FLAGS% /nologo /Ox /MT   -c sha256.c
move sha256.obj sha256.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-sha256.c
move stubs-sha256.obj stubs-sha256.d.obj
cl %FLAGS% /nologo /Ox /MT   -c ripemd160.c
move ripemd160.obj ripemd160.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-ripemd160.c
move stubs-ripemd160.obj stubs-ripemd160.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-md5.c
move stubs-md5.obj stubs-md5.d.obj
cl %FLAGS% /nologo /Ox /MT /D ZLIB_WINAPI /I%ZLIB%\include -c stubs-zlib.c
move stubs-zlib.obj stubs-zlib.d.obj
cl %FLAGS% /nologo /Ox /MT   -c stubs-misc.c
move stubs-misc.obj stubs-misc.d.obj
cl %FLAGS% /Ox /MT   -c stubs-rng.c
move stubs-rng.obj stubs-rng.d.obj

lib /nologo /out:libcryptokit.lib /libpath:%ZLIB%\lib zlibstat.lib rijndael-alg-fst.d.obj stubs-aes.d.obj d3des.d.obj stubs-des.d.obj arcfour.d.obj stubs-arcfour.d.obj sha1.d.obj stubs-sha1.d.obj sha256.d.obj stubs-sha256.d.obj ripemd160.d.obj stubs-ripemd160.d.obj stubs-md5.d.obj stubs-zlib.d.obj stubs-misc.d.obj stubs-rng.d.obj

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
ocamldoc -html -t "Criptokit"-d doc *.mli

:install ======================================================================
ocamlfind remove cryptokit
ocamlfind install cryptokit META

rem copy cryptokit.cmxa cryptokit.cmx cryptokit.lib "%OCAMLLIB%"

rem mkdir %INSTALLDIR%
rem copy *.cmi %INSTALLDIR%
rem copy *.cmxa %INSTALLDIR%
rem copy *.mli %INSTALLDIR%
rem copy cryptokit.lib %INSTALLDIR%
rem copy libcryptokit.lib "%OCAMLLIB%"
rem copy dllcryptokit.dll "%OCAMLLIB%"\stublibs
rem mkdir %INSTALLDIR_DOC%
rem copy doc\* %INSTALLDIR_DOC%
rem rmdir /S /Q doc
rem del *.obj *.lib *.cm* *.exe *.dll dllcryptokit.dll.manifest

echo off

:exit
popd
endlocal
pause






