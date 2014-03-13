@cls
@for %%F in (%cd%) do @set title=%%~nF%%~xF
@title "Installing %title%"
@set cwd=%cd%
call "%ProgramFiles(x86)%\Microsoft Visual Studio 11.0\VC\bin\vcvars32.bat"
@set PATH=C:\ocaml\bin;%PATH%
@cd %cwd%
@echo CWD      = %cd%

@set OCAMLLIB=
@for /f %%x in ('ocamlc -where') do @set OCAMLLIB=%%x
@set OCAMLLIB=%OCAMLLIB:/=\%
@echo OCAMLLIB = %OCAMLLIB%
