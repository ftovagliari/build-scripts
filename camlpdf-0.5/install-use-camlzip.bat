cls
setlocal

REM Configuration Section ====================================================

set LIB=%LIB%
set INCLUDE=%INCLUDE%
set OCAMLLIB=%OCAMLLIB%
set ZLIB=C:\zlib\lib
set INSTALLDIR="%OCAMLLIB%"\cpdf
set INSTALLDIR_DOC="%OCAMLLIB%"\..\doc\cpdf
REM set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib
set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib 

set CFLAGS=-I +zip

REM End of Configuration Section ==============================================

del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll dllcamlpdf.dll.manifest

cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" /DPIC 
lib /nologo /out:libcamlpdf.lib /libpath:%ZLIB% zlib.lib zlibstubs.obj
flexlink -o dllcamlpdf.dll zlibstubs.obj zlib.lib %CCOPT% -LC:\zlib\lib -default-manifest

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

REM ocamlopt.opt -verbose -a -o cpdf.cmxa -ccopt "%CCOPT%" -cclib -lcamlpdf -cclib -lz utility.cmx istring.cmx io.cmx unzip.cmx pdfio.cmx cgenlex.cmx zlib.cmx transform.cmx units.cmx paper.cmx pdf.cmx pdfcrypt.cmx pdfwrite.cmx pdfcodec.cmx pdfread.cmx pdfpages.cmx pdfdoc.cmx pdfannot.cmx pdffun.cmx pdfspace.cmx pdfimage.cmx glyphlist.cmx pdftext.cmx fonttables.cmx pdfgraphics.cmx pdfshapes.cmx pdfmarks.cmx pdfdate.cmx cff.cmx 

ocamlopt.opt -verbose -a -o cpdf.cmxa -I +zip utility.cmx istring.cmx io.cmx unzip.cmx pdfio.cmx cgenlex.cmx transform.cmx units.cmx paper.cmx pdf.cmx pdfcrypt.cmx pdfwrite.cmx pdfcodec.cmx pdfread.cmx pdfpages.cmx pdfdoc.cmx pdfannot.cmx pdffun.cmx pdfspace.cmx pdfimage.cmx glyphlist.cmx pdftext.cmx fonttables.cmx pdfgraphics.cmx pdfshapes.cmx pdfmarks.cmx pdfdate.cmx cff.cmx 

:test =========================================================================
ocamlopt.opt -verbose -o pdfhello.exe -I +zip unix.cmxa bigarray.cmxa zlib.cmxa cpdf.cmxa pdfhello.ml 
pdfhello
hello.pdf

:doc ==========================================================================
mkdir doc
ocamldoc -html -d doc *.mli

:install ======================================================================
mkdir %INSTALLDIR%
copy *.cmi %INSTALLDIR%
copy *.cmxa %INSTALLDIR%
copy *.mli %INSTALLDIR%
copy cpdf.lib %INSTALLDIR%
copy libcamlpdf.lib "%OCAMLLIB%"
copy dllcamlpdf.dll "%OCAMLLIB%"\stublibs
mkdir %INSTALLDIR_DOC%
copy doc\* %INSTALLDIR_DOC%

rmdir /S /Q doc
del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll dllcamlpdf.dll.manifest

:exit =========================================================================
endlocal