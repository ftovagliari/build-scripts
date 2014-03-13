@cls
@call ..\..\devel\build-scripts\setenv.bat
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

set SQLITE3=D:\sqlite3
set LIB=%LIB%;%SQLITE3%
set INCLUDE=%INCLUDE%;%SQLITE3%\include\sqlite3
set OCAMLLIB=%OCAMLLIB%
@rem set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib
@rem set CCOPT=-LC:\PROGRA~1\MICROS~3\v7.0\lib -LC:\PROGRA~2\MICROS~1.0\VC\lib -LC:\PROGRA~2\MICROS~1.0\VC\ATLFMC\lib -L%ZLIB%\lib

@REM End of Configuration Section ==============================================

@pushd lib
@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest

cl /nologo -c sqlite3_stubs.c /I"%OCAMLLIB%" /I%SQLITE3%\include 
lib /nologo /out:libcamlsqlite3.lib /libpath:%SQLITE3%\lib sqlite3.lib sqlite3_stubs.obj
flexlink -o dllcamlsqlite3.dll sqlite3_stubs.obj %SQLITE3%\lib\sqlite3.lib %CCOPT% -default-manifest

ocamlopt.opt -g -c sqlite3.mli
ocamlopt.opt -g -c sqlite3.ml
ocamlopt.opt -verbose -g -a -o sqlite3.cmxa -ccopt "%CCOPT%" -cclib -lcamlsqlite3 -cclib -lz sqlite3.cmx 

@popd

:test =========================================================================
@pushd test
@set PATH=%PATH%;%SQLITE3%\lib
@del *.obj *.lib *.cm* *.exe *.zip

title test_db
@ocamlopt.opt -g -o test_db.exe -I ..\lib unix.cmxa ../lib/sqlite3.cmxa test_db.ml 
.\test_db.exe
rem @pause

title test_agg
@ocamlopt.opt -g -o test_agg.exe -I ..\lib unix.cmxa ../lib/sqlite3.cmxa test_agg.ml 
.\test_agg.exe
rem @pause

title test_exec
@ocamlopt.opt -g -o test_exec.exe -I ..\lib unix.cmxa ../lib/sqlite3.cmxa test_exec.ml 
.\test_exec.exe
rem @pause

title test_fun
@ocamlopt.opt -g -o test_fun.exe -I ..\lib unix.cmxa str.cmxa ../lib/sqlite3.cmxa test_fun.ml 
.\test_fun.exe
rem @pause

title test_stmt
@ocamlopt.opt -g -o test_stmt.exe -I ..\lib unix.cmxa str.cmxa ../lib/sqlite3.cmxa test_stmt.ml 
.\test_stmt.exe
rem @pause

@del *.exe *.obj *.cm* 
@popd

:install =======================================================================

@pushd lib
ocamlfind remove sqlite3
ocamlfind install sqlite3 META *.cmxa *.lib *.cmi *.mli
@popd

:exit =========================================================================
@endlocal
@pause
