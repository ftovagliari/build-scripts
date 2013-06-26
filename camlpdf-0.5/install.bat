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
set INSTALLDIR="%OCAMLLIB%"\cpdf
set INSTALLDIR_DOC="%OCAMLLIB%"\..\doc\cpdf
@rem set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -L%ZLIB%\lib
set CCOPT=-LC:\PROGRA~1\MICROS~3\v7.0\lib -LC:\PROGRA~2\MICROS~1.0\VC\lib -LC:\PROGRA~2\MICROS~1.0\VC\ATLFMC\lib -L%ZLIB%\lib

set CFLAGS=-I +site-lib/zip

@REM End of Configuration Section ==============================================

@del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll

cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" /I%ZLIB%\include /DPIC 
lib /nologo /out:libcamlpdf.lib /libpath:%ZLIB%\lib zlibstat.lib zlibstubs.obj
flexlink -o dllcamlpdf.dll zlibstubs.obj zlibstat.lib %CCOPT% -L%ZLIB%\lib -default-manifest

ocamlopt.opt -c %CFLAGS% utility.mli
ocamlopt.opt -c %CFLAGS% utility.ml
ocamlopt.opt -c %CFLAGS% istring.mli
ocamlopt.opt -c %CFLAGS% istring.ml
ocamlopt.opt -c %CFLAGS% io.mli
ocamlopt.opt -c %CFLAGS% io.ml
ocamlopt.opt -c %CFLAGS% unzip.mli
ocamlopt.opt -c %CFLAGS% unzip.ml
ocamlopt.opt -c %CFLAGS% pdfio.mli
ocamlopt.opt -c %CFLAGS% pdfio.ml
ocamlopt.opt -c %CFLAGS% cgenlex.mli
ocamlopt.opt -c %CFLAGS% cgenlex.ml
REM ocamlopt.opt -c zlib.mli
REM ocamlopt.opt -c zlib.ml
ocamlopt.opt -c %CFLAGS% transform.mli
ocamlopt.opt -c %CFLAGS% transform.ml
ocamlopt.opt -c %CFLAGS% units.mli
ocamlopt.opt -c %CFLAGS% units.ml
ocamlopt.opt -c %CFLAGS% paper.mli
ocamlopt.opt -c %CFLAGS% paper.ml
ocamlopt.opt -c %CFLAGS% pdf.mli
ocamlopt.opt -c %CFLAGS% pdf.ml
ocamlopt.opt -c %CFLAGS% pdfcrypt.mli
ocamlopt.opt -c %CFLAGS% pdfcrypt.ml
ocamlopt.opt -c %CFLAGS% pdfwrite.mli
ocamlopt.opt -c %CFLAGS% pdfwrite.ml
ocamlopt.opt -c %CFLAGS% pdfcodec.mli
ocamlopt.opt -c %CFLAGS% pdfcodec.ml
ocamlopt.opt -c %CFLAGS% pdfread.mli
ocamlopt.opt -c %CFLAGS% pdfread.ml
ocamlopt.opt -c %CFLAGS% pdfpages.mli
ocamlopt.opt -c %CFLAGS% pdfpages.ml
ocamlopt.opt -c %CFLAGS% pdfdoc.mli
ocamlopt.opt -c %CFLAGS% pdfdoc.ml
ocamlopt.opt -c %CFLAGS% pdfannot.mli
ocamlopt.opt -c %CFLAGS% pdfannot.ml
ocamlopt.opt -c %CFLAGS% pdffun.mli
ocamlopt.opt -c %CFLAGS% pdffun.ml
ocamlopt.opt -c %CFLAGS% pdfspace.mli
ocamlopt.opt -c %CFLAGS% pdfspace.ml
ocamlopt.opt -c %CFLAGS% pdfimage.mli
ocamlopt.opt -c %CFLAGS% pdfimage.ml
ocamlopt.opt -c %CFLAGS% glyphlist.mli
ocamlopt.opt -c %CFLAGS% glyphlist.ml
ocamlopt.opt -c %CFLAGS% pdftext.mli
ocamlopt.opt -c %CFLAGS% pdftext.ml
ocamlopt.opt -c %CFLAGS% fonttables.mli
ocamlopt.opt -c %CFLAGS% fonttables.ml
ocamlopt.opt -c %CFLAGS% pdfgraphics.mli
ocamlopt.opt -c %CFLAGS% pdfgraphics.ml
ocamlopt.opt -c %CFLAGS% pdfshapes.mli
ocamlopt.opt -c %CFLAGS% pdfshapes.ml
ocamlopt.opt -c %CFLAGS% pdfmarks.mli
ocamlopt.opt -c %CFLAGS% pdfmarks.ml
ocamlopt.opt -c %CFLAGS% pdfdate.mli
ocamlopt.opt -c %CFLAGS% pdfdate.ml
ocamlopt.opt -c %CFLAGS% cff.mli
ocamlopt.opt -c %CFLAGS% cff.ml

ocamlfind ocamlopt -package zip,bigarray -a -o cpdf.cmxa -ccopt "%CCOPT%" -cclib -lcamlpdf -cclib -lz utility.cmx istring.cmx io.cmx unzip.cmx pdfio.cmx cgenlex.cmx transform.cmx units.cmx paper.cmx pdf.cmx pdfcrypt.cmx pdfwrite.cmx pdfcodec.cmx pdfread.cmx pdfpages.cmx pdfdoc.cmx pdfannot.cmx pdffun.cmx pdfspace.cmx pdfimage.cmx glyphlist.cmx pdftext.cmx fonttables.cmx pdfgraphics.cmx pdfshapes.cmx pdfmarks.cmx pdfdate.cmx cff.cmx 

:test =========================================================================
ocamlfind ocamlopt -package zip,bigarray -linkpkg -o pdfhello.exe cpdf.cmxa pdfhello.ml 
pdfhello
hello.pdf

:doc ==========================================================================
mkdir doc
ocamldoc -html -t "Camlpdf" -d doc *.mli
:install ======================================================================

ocamlfind remove cpdf
@echo version="0.5" > META
@echo requires="unix,bigarray,zip" >> META
@echo archive(byte)="cpdf.cma,cpdf.cma" >> META
@echo archive(native)="cpdf.cmxa,cpdf.cmxa" >> META
ocamlfind install cpdf META *.cm?a *.cmi *.mli *.lib *.dll >> META
pause

copy doc\* %INSTALLDIR_DOC%

@rmdir /S /Q doc
@del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll

:exit =========================================================================
@endlocal
@pause
