cls
setlocal
REM Configuration Section ====================================================

set LIB=%LIB%
set INCLUDE=%INCLUDE%
set OCAMLLIB=%OCAMLLIB%
set ZLIB=C:\zlib\lib
set INSTALLDIR="%OCAMLLIB%"\zip
set INSTALLDIR_DOC="%OCAMLLIB%"\..\doc\zip
set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib

REM End of Configuration Section ==============================================

del *.obj *.lib *.cm* *.exe *.dll dllcamlzip.dll.manifest
cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" 
lib /nologo /out:libcamlzip.lib /libpath:%ZLIB% zlib.lib zlibstubs.obj
flexlink -o dllcamlzip.dll zlibstubs.obj zlib.lib %CCOPT% -default-manifest

ocamlopt.opt -g -c zlib.mli
ocamlopt.opt -g -c zlib.ml
ocamlopt.opt -g -c zip.mli
ocamlopt.opt -g -c zip.ml
ocamlopt.opt -g -c gzip.mli
ocamlopt.opt -g -c gzip.ml

ocamlopt.opt -verbose -g -a -o zip.cmxa -ccopt "%CCOPT%" -cclib -lcamlzip -cclib -lz zlib.cmx zip.cmx gzip.cmx 

:test =========================================================================
pushd test
del *.obj *.lib *.cm* *.exe *.zip
ocamlopt.opt -g -o minizip.exe -I .. unix.cmxa ../zip.cmxa minizip.ml 
minizip c test.zip testzlib.ml minizip.ml minigzip.ml
test.zip
del test.zip *.exe *.obj *.cm*
popd

: doc ==========================================================================
mkdir doc
ocamldoc -html -d doc *.mli

:install ======================================================================
mkdir %INSTALLDIR%
copy *.cmi %INSTALLDIR%
copy *.cmxa %INSTALLDIR%
copy *.mli %INSTALLDIR%
copy zip.lib %INSTALLDIR%
copy libcamlzip.lib "%OCAMLLIB%"
copy dllcamlzip.dll "%OCAMLLIB%"\stublibs
mkdir %INSTALLDIR_DOC%
copy doc\* %INSTALLDIR_DOC%
rmdir /S /Q doc
del *.obj *.lib *.cm* *.exe *.dll dllcamlzip.dll.manifest

:exit =========================================================================
endlocal