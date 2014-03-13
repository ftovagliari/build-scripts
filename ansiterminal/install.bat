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

@set LIB=%LIB%
@set INCLUDE=%INCLUDE%
@set OCAMLLIB=%OCAMLLIB%
@set CCOPT=

@REM End of Configuration Section ==============================================

@pushd src
@del /Q ANSITerminal_stubs.c
@del /Q ANSITerminal.ml
@copy ANSITerminal_win_stubs.c ANSITerminal_stubs.c
@copy ANSITerminal_win.ml ANSITerminal.ml
@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest META

cl /nologo -c ANSITerminal_stubs.c /I"%OCAMLLIB%"

ocamlc.opt -g -c ANSITerminal.mli

ocamlmklib -verbose -ocamlc "ocamlc.opt -g" -ocamlopt "ocamlopt.opt -g" -o ansiterminal  ANSITerminal_stubs.obj ANSITerminal_common.ml ANSITerminal.ml

@dir
@popd

:install =======================================================================

@pushd src
@echo name="ansiterminal" > META
@echo version="0.6.3" >> META
@echo description="Colors and cursor movements on ANSI terminals" >> META
@echo requires="unix" >> META
@echo archive(byte)="ansiterminal.cma" >> META
@echo archive(native)="ansiterminal.cmxa" >> META
@echo linkopts = "" >> META

@ocamlfind remove ansiterminal
@ocamlfind install ansiterminal META ansiterminal.cma ansiterminal.cmxa *.lib *.cmi *.mli *.dll
@popd

:test =========================================================================

@del *.exe *.cm* *.obj
pause

ocamlfind ocamlc -package ansiterminal -linkpkg -o test.exe test.ml
ocamlfind ocamlopt -package ansiterminal -linkpkg -o test.opt.exe test.ml
@rem pause 
@rem start /WAIT test.exe
ocamlfind ocamlc -package ansiterminal -linkpkg -o showcolors.exe showcolors.ml
ocamlfind ocamlopt -package ansiterminal -linkpkg -o showcolors.opt.exe showcolors.ml
@rem pause
@rem start /WAIT showcolors.exe

:exit =========================================================================
@endlocal
@pause
