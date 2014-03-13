@cls
@setlocal
@call ..\..\devel\build-scripts\setenv.bat

@REM Configuration Section ====================================================

@set LIB=%LIB%
@set INCLUDE=%INCLUDE%
@set OCAMLLIB=%OCAMLLIB%
@set ZLIB=D:\zlib
@echo ZLIB     = %ZLIB%
@echo INCLUDE  = %INCLUDE%
@echo LIB      = %LIB%
for %%A in ("C:\Program Files\Microsoft SDKs\Windows\v7.0\Lib") do @set F1=%%~sA
for %%A in ("C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\lib") do @set F2=%%~sA
for %%A in ("C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\atlmfc\lib") do @set F3=%%~sA
@set CCOPT=-L%F1% -L%F2% -L%F3% -L%ZLIB%\lib

@REM End of Configuration Section ==============================================

@del *.obj *.lib *.cm* *.exe *.dll dllcamlzip.dll.manifest 2>NUL
cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" /I%ZLIB%\include /D ZLIB_WINAPI

@rem Copy %ZLIB%\lib\libstat.lib to %ZLIB%\lib\libz.lib
@if not exist %ZLIB%\lib\libz.lib copy %ZLIB%\lib\libstat.lib %ZLIB%\lib\libz.lib
@set LIBSTAT=libz.lib
lib /nologo /out:libcamlzip.lib /libpath:%ZLIB%\lib %LIBSTAT% zlibstubs.obj
flexlink -o dllcamlzip.dll zlibstubs.obj %LIBSTAT% %CCOPT% -default-manifest
flexlink -o dllcamlzlib.dll zlibstubs.obj %LIBSTAT% %CCOPT% -default-manifest

ocamlc.opt -g -c zlib.mli
ocamlc.opt -g -c zlib.ml
ocamlc.opt -g -c zip.mli
ocamlc.opt -g -c zip.ml
ocamlc.opt -g -c gzip.mli
ocamlc.opt -g -c gzip.ml

ocamlmklib -o zlib -oc camlzlib zlib.cmo gzip.cmo -L%ZLIB% -lz
ocamlmklib -o zip -oc camlzip zip.cmo gzip.cmo -L%ZLIB% -lz 

ocamlopt.opt -g -c zlib.mli
ocamlopt.opt -g -c zlib.ml
ocamlopt.opt -g -c zip.mli
ocamlopt.opt -g -c zip.ml
ocamlopt.opt -g -c gzip.mli
ocamlopt.opt -g -c gzip.ml

ocamlopt.opt -verbose -g -a -o zlib.cmxa -ccopt "%CCOPT%" -cclib -lcamlzip -cclib -lz zlib.cmx 
ocamlopt.opt -verbose -g -a -o zip.cmxa -ccopt "%CCOPT%" -cclib -lcamlzip -cclib -lz zip.cmx gzip.cmx 

:test =========================================================================
pushd test
@del *.obj *.lib *.cm* *.exe *.zip 2>NUL
@ocamlopt.opt -g -o minizip.exe -I .. unix.cmxa ../zlib.cmxa ../zip.cmxa minizip.ml 
minizip c test.zip testzlib.ml minizip.ml minigzip.ml
@test.zip
@popd

: doc ==========================================================================
@mkdir doc 2>NUL
ocamldoc -html -t "Camlzip" -d doc *.mli

:install ======================================================================
ocamlfind remove zip
ocamlfind install zip META *.cma *.cmxa *.cmi *.mli *.lib *.dll

:exit =========================================================================
@endlocal
@pause
@pushd test
@del test.zip *.exe *.obj *.cm*
@popd
