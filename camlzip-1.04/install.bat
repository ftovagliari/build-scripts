@cls
@for %%F in (%cd%) do @set name=%%~nF%%~xF
@title "Installing %name%"
@setlocal
@set cwd=%cd%
@call "%ProgramFiles(x86)%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat"
@cd %cwd%
@echo Current working directory: %cd%

@set OCAMLLIB=
@for /f %%x in ('ocamlc -where') do @set OCAMLLIB=%%x
@set OCAMLLIB=%OCAMLLIB:/=\%
@echo OCAMLLIB=%OCAMLLIB%

@REM Configuration Section ====================================================

set LIB=%LIB%
set INCLUDE=%INCLUDE%
set OCAMLLIB=%OCAMLLIB%
set ZLIB=C:\zlib
set INSTALLDIR=%OCAMLLIB%\zip
set INSTALLDIR_DOC=%OCAMLLIB%\..\doc\zip
@rem set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib
set CCOPT=-LC:\PROGRA~1\MICROS~3\v7.0\lib -LC:\PROGRA~2\MICROS~1.0\VC\lib -LC:\PROGRA~2\MICROS~1.0\VC\ATLFMC\lib -L%ZLIB%\lib

@REM End of Configuration Section ==============================================

@del *.obj *.lib *.cm* *.exe *.dll dllcamlzip.dll.manifest
cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" /I%ZLIB%\include /D ZLIB_WINAPI
lib /nologo /out:libcamlzip.lib /libpath:%ZLIB%\lib zlibstat.lib zlibstubs.obj
flexlink -o dllcamlzip.dll zlibstubs.obj zlibstat.lib %CCOPT% -default-manifest

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
@del *.obj *.lib *.cm* *.exe *.zip
@ocamlopt.opt -g -o minizip.exe -I .. unix.cmxa ../zlib.cmxa ../zip.cmxa minizip.ml 
minizip c test.zip testzlib.ml minizip.ml minigzip.ml
test.zip
@del test.zip *.exe *.obj *.cm*
@popd

: doc ==========================================================================
mkdir doc
ocamldoc -html -t "Camlzip" -d doc *.mli

:install ======================================================================
mkdir %INSTALLDIR%
copy *.cmi %INSTALLDIR%
copy *.cmxa %INSTALLDIR%
copy *.mli %INSTALLDIR%
copy zip.lib %INSTALLDIR%
copy zlib.lib %INSTALLDIR%
copy libcamlzip.lib "%OCAMLLIB%"
copy dllcamlzip.dll "%OCAMLLIB%"\stublibs
mkdir %INSTALLDIR_DOC%
copy doc\* %INSTALLDIR_DOC%
rmdir /S /Q doc
del *.obj *.lib *.cm* *.exe *.dll dllcamlzip.dll.manifest

:exit =========================================================================
endlocal
pause