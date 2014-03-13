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

@set JPEG=D:\libjpeg

@set LIB=%LIB%
@set INCLUDE=%INCLUDE%
@set OCAMLLIB=%OCAMLLIB%
@set CCOPT=

@REM End of Configuration Section ==============================================

@pushd corelib
@rem set MLMODULES="camlimages,mstring,color,region,tmpfile,bitmap,genimage,rgba32,rgb24,index8,index16,cmyk32,images,oColor,oImages,reduce,geometry,colorhist,blend"
@rem set MLMODULES=camlimages mstring color region tmpfile bitmap genimage rgba32 rgb24 index8 index16 cmyk32 images oColor oImages reduce geometry colorhist blend

@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest META

@set CMOS=camlimages.cmo mstring.cmo color.cmo region.cmo tmpfile.cmo bitmap.cmo genimage.cmo rgba32.cmo rgb24.cmo index8.cmo index16.cmo cmyk32.cmo images.cmo oColor.cmo oImages.cmo reduce.cmo geometry.cmo colorhist.cmo blend.cmo

@set CMXS=camlimages.cmx mstring.cmx color.cmx region.cmx tmpfile.cmx bitmap.cmx genimage.cmx rgba32.cmx rgb24.cmx index8.cmx index16.cmx cmyk32.cmx images.cmx oColor.cmx oImages.cmx reduce.cmx geometry.cmx colorhist.cmx blend.cmx

@set COMP=@ocamlc.opt -w -26 -c
@set COMPOPT=@ocamlopt.opt -w -26 -c

@rem %COMP% camlimages.mli
%COMP% mstring.mli
%COMP% color.mli
%COMP% region.mli
%COMP% tmpfile.mli
%COMP% bitmap.mli
%COMP% info.mli
%COMP% genimage.mli 
%COMP% rgba32.mli
%COMP% rgb24.mli
%COMP% index8.mli
%COMP% index16.mli
%COMP% cmyk32.mli
%COMP% images.mli
%COMP% oColor.mli
%COMP% oImages.mli
%COMP% reduce.mli
@rem %COMP% geometry.mli
@rem %COMP% colorhist.mli
%COMP% blend.mli

%COMP% camlimages.ml
%COMP% mstring.ml
%COMP% color.ml
%COMP% region.ml
%COMP% tmpfile.ml
%COMP% bitmap.ml
@rem %COMP% info.ml
%COMP% genimage.ml 
%COMP% rgba32.ml
%COMP% rgb24.ml
%COMP% index8.ml
%COMP% index16.ml
%COMP% cmyk32.ml
%COMP% images.ml
%COMP% oColor.ml
%COMP% oImages.ml
%COMP% reduce.ml
%COMP% geometry.ml
%COMP% colorhist.ml
%COMP% blend.ml

%COMPOPT% camlimages.ml
%COMPOPT% mstring.ml
%COMPOPT% color.ml
%COMPOPT% region.ml
%COMPOPT% tmpfile.ml
%COMPOPT% bitmap.ml
@rem %COMPOPT% info.ml
%COMPOPT% genimage.ml 
%COMPOPT% rgba32.ml
%COMPOPT% rgb24.ml
%COMPOPT% index8.ml
%COMPOPT% index16.ml
%COMPOPT% cmyk32.ml
%COMPOPT% images.ml
%COMPOPT% oColor.ml
%COMPOPT% oImages.ml
%COMPOPT% reduce.ml
%COMPOPT% geometry.ml
%COMPOPT% colorhist.ml
%COMPOPT% blend.ml

@rem ocamlc.opt -a -linkall -o ci_core.cma %CMOS%
@rem ocamlmklib -linkall -verbose -ocamlc "ocamlc.opt -g" -ocamlopt "ocamlopt.opt -g" -o ci_core %CMOS% %CMXS%

ocamlopt -a -linkall -o ci_core.cmxa %CMXS%

@popd
@goto libs

:ocamlc ========================================================================
@if exist %1.mli ocamlc.opt -c %2 %1.mli -w -26
@if exist %1.ml (
  echo %1
  ocamlc.opt -c %2 %1.ml -w -26 -g
  ocamlopt.opt -c %2 %1.ml -w -26 -g 
  @set CMOS=%CMOS% %1.cmo
  @set CMXS=%CMXS% %1.cmx
)
@goto :eof

:libs ==========================================================================

@REM ---------------------------------------------------------------------- JPEG
@set LIBNAME=jpeg
@pushd %LIBNAME%
@set LIBDIR=D:\libjpeg
@rem set LIBDIR=C:\GTK
@set PATH=%PATH%;%LIBDIR%\bin
@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest META

cl /nologo -c jpegread.c /I"%OCAMLLIB%" /I.. /I%LIBDIR%\include
cl /nologo -c jpegwrite.c /I"%OCAMLLIB%" /I.. /I%LIBDIR%\include

@set FLAGS=-w -26

ocamlc.opt -I ../corelib %FLAGS% -c jpeg.mli
ocamlc.opt -I ../corelib %FLAGS% -c jpeg.ml
ocamlc.opt -I ../corelib %FLAGS% -c oJpeg.ml
ocamlopt.opt -I ../corelib %FLAGS% -c jpeg.ml
ocamlopt.opt -I ../corelib %FLAGS% -c oJpeg.ml

ocamlmklib -verbose -ocamlc "ocamlc.opt -g" -ocamlopt "ocamlopt.opt -g" -linkall -I ../corelib -l%LIBNAME% -L%LIBDIR%\lib -o ci_%LIBNAME% jpegread.obj jpegwrite.obj jpeg.cmo oJpeg.cmo jpeg.cmx oJpeg.cmx
@popd

@REM ---------------------------------------------------------------------- PNG
@set LIBNAME=png
@pushd %LIBNAME%
@set LIBDIR=D:\libpng
@rem set LIBDIR=C:\GTK
@set PATH=%PATH%;%LIBDIR%\bin
@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest META

cl /nologo -c pngread.c /I"%OCAMLLIB%" /I.. /I%LIBDIR%\include /IC:\zlib\include
cl /nologo -c pngwrite.c /I"%OCAMLLIB%" /I.. /I%LIBDIR%\include /IC:\zlib\include

@set FLAGS=-w -26

ocamlc.opt -I ../corelib %FLAGS% -c png.mli
ocamlc.opt -I ../corelib %FLAGS% -c png.ml
ocamlc.opt -I ../corelib %FLAGS% -c oPng.ml
ocamlopt.opt -I ../corelib %FLAGS% -c png.ml
ocamlopt.opt -I ../corelib %FLAGS% -c oPng.ml

ocamlmklib -verbose -ocamlc "ocamlc.opt -g" -ocamlopt "ocamlopt.opt -g" -linkall -I ../corelib -l%LIBNAME% -L%LIBDIR%\lib -o ci_%LIBNAME% pngread.obj pngwrite.obj png.cmo oPng.cmo png.cmx oPng.cmx
@popd

:crop =========================================================================
@pushd examples\crop
@del *.obj *.lib *.cm* *.exe *.dll *.dll.manifest META
ocamlopt.opt -o crop.exe -I ../../corelib -I ../../jpeg -I ../../png unix.cmxa ci_core.cmxa ci_jpeg.cmxa ci_png.cmxa crop.ml
crop 83251.png
@popd
goto exit

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
@goto exit

:exit =========================================================================
@endlocal
@pause
