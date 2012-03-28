cls
setlocal
REM Configuration Section ====================================================

set OCAMLLIB=%OCAMLLIB%
set INSTALLDIR="%OCAMLLIB%"\cpdf
set CCOPT=-LC:\Programmi\MIC977~1\Lib -LC:\Programmi\MID05A~1\VC\lib -LC:\zlib\lib

REM End of Configuration Section ==============================================

del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll

cl /nologo -c zlibstubs.c /I"%OCAMLLIB%" /DPIC 
lib /nologo /out:libcamlpdf.lib /libpath:C:\zlib\lib zlib.lib zlibstubs.obj
flexlink -o dllcamlpdf.dll zlibstubs.obj zlib.lib %CCOPT% -LC:\zlib\lib -default-manifest

ocamlopt.opt -c utility.mli
ocamlopt.opt -c utility.ml
ocamlopt.opt -c istring.mli
ocamlopt.opt -c istring.ml
ocamlopt.opt -c io.mli
ocamlopt.opt -c io.ml
ocamlopt.opt -c unzip.mli
ocamlopt.opt -c unzip.ml
ocamlopt.opt -c pdfio.mli
ocamlopt.opt -c pdfio.ml
ocamlopt.opt -c cgenlex.mli
ocamlopt.opt -c cgenlex.ml
ocamlopt.opt -c zlib.mli
ocamlopt.opt -c zlib.ml
ocamlopt.opt -c transform.mli
ocamlopt.opt -c transform.ml
ocamlopt.opt -c units.mli
ocamlopt.opt -c units.ml
ocamlopt.opt -c paper.mli
ocamlopt.opt -c paper.ml
ocamlopt.opt -c pdf.mli
ocamlopt.opt -c pdf.ml
ocamlopt.opt -c pdfcrypt.mli
ocamlopt.opt -c pdfcrypt.ml
ocamlopt.opt -c pdfwrite.mli
ocamlopt.opt -c pdfwrite.ml
ocamlopt.opt -c pdfcodec.mli
ocamlopt.opt -c pdfcodec.ml
ocamlopt.opt -c pdfread.mli
ocamlopt.opt -c pdfread.ml
ocamlopt.opt -c pdfpages.mli
ocamlopt.opt -c pdfpages.ml
ocamlopt.opt -c pdfdoc.mli
ocamlopt.opt -c pdfdoc.ml
ocamlopt.opt -c pdfannot.mli
ocamlopt.opt -c pdfannot.ml
ocamlopt.opt -c pdffun.mli
ocamlopt.opt -c pdffun.ml
ocamlopt.opt -c pdfspace.mli
ocamlopt.opt -c pdfspace.ml
ocamlopt.opt -c pdfimage.mli
ocamlopt.opt -c pdfimage.ml
ocamlopt.opt -c glyphlist.mli
ocamlopt.opt -c glyphlist.ml
ocamlopt.opt -c pdftext.mli
ocamlopt.opt -c pdftext.ml
ocamlopt.opt -c fonttables.mli
ocamlopt.opt -c fonttables.ml
ocamlopt.opt -c pdfgraphics.mli
ocamlopt.opt -c pdfgraphics.ml
ocamlopt.opt -c pdfshapes.mli
ocamlopt.opt -c pdfshapes.ml
ocamlopt.opt -c pdfmarks.mli
ocamlopt.opt -c pdfmarks.ml
ocamlopt.opt -c pdfdate.mli
ocamlopt.opt -c pdfdate.ml
ocamlopt.opt -c cff.mli
ocamlopt.opt -c cff.ml

ocamlopt.opt -verbose -a -o cpdf.cmxa -ccopt "%CCOPT%" -cclib -lcamlpdf -cclib -lz utility.cmx istring.cmx io.cmx unzip.cmx pdfio.cmx cgenlex.cmx zlib.cmx transform.cmx units.cmx paper.cmx pdf.cmx pdfcrypt.cmx pdfwrite.cmx pdfcodec.cmx pdfread.cmx pdfpages.cmx pdfdoc.cmx pdfannot.cmx pdffun.cmx pdfspace.cmx pdfimage.cmx glyphlist.cmx pdftext.cmx fonttables.cmx pdfgraphics.cmx pdfshapes.cmx pdfmarks.cmx pdfdate.cmx cff.cmx 

:test =========================================================================
ocamlopt.opt -verbose -o pdfhello.exe unix.cmxa bigarray.cmxa cpdf.cmxa pdfhello.ml 
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
mkdir %INSTALLDIR%\doc
copy doc\* %INSTALLDIR%\doc

rmdir /S /Q doc
del *.obj *.lib *.cm* *.exe hello.pdf dllcamlpdf.dll

:exit =========================================================================
endlocal