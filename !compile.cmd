@echo off
if exist sabot0.bin del sabot0.bin
if exist sabot0.inc del sabot0.inc
if exist sabot0.lst del sabot0.lst
if exist sabot1-*.bin del sabot1-*.bin
if exist sabot1-*.lst del sabot1-*.lst
if exist sabot1-*.zx0 del sabot1-*.zx0
if exist saboteur-*.bin del saboteur-*.bin
if exist saboteur-*.rks del saboteur-*.rks

rem Define ESCchar to use in ANSI escape sequences
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESCchar=%%E"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "DATESTAMP=%YYYY%-%MM%-%DD%"
for /f %%i in ('git rev-list HEAD --count') do (set REVISION=%%i)
echo VER.%REVISION% %DATESTAMP%
echo 	DEFM "VER.%REVISION% %DATESTAMP%" > version.inc

echo Compiling sabot0 first pass...
tools\sjasmplus --nologo --msg=war --i8080 sabot0.asm --lst=sabot0.lst --exp=sabot0.inc -DLZSIZE1=19000 --raw=sabot0.bin
if errorlevel 1 goto Failed
dir /-c sabot0.bin|findstr /R /C:"sabot0.bin"

echo Compiling code: BW...
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=0 sabot1.asm --lst=sabot1-bw.lst --raw=sabot1-bw.bin
if errorlevel 1 goto Failed
dir /-c sabot1-bw.bin|findstr /R /C:"sabot1-bw.bin"
echo Compiling code: C4...
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=4 sabot1.asm --lst=sabot1-c4.lst --raw=sabot1-c4.bin
if errorlevel 1 goto Failed
dir /-c sabot1-c4.bin|findstr /R /C:"sabot1-c4.bin"
echo Compiling code: C8...
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=8 sabot1.asm --lst=sabot1-c8.lst --raw=sabot1-c8.bin
if errorlevel 1 goto Failed
dir /-c sabot1-c8.bin|findstr /R /C:"sabot1-c8.bin"

echo Compressing ...
tools\salvador.exe -classic -c sabot1-bw.bin sabot1-bw.zx0
if errorlevel 1 goto Failed
dir /-c sabot1-bw.zx0|findstr /R /C:"sabot1-bw.zx0"
tools\salvador.exe -classic -c sabot1-c4.bin sabot1-c4.zx0
if errorlevel 1 goto Failed
dir /-c sabot1-c4.zx0|findstr /R /C:"sabot1-c4.zx0"
tools\salvador.exe -classic -c sabot1-c8.bin sabot1-c8.zx0
if errorlevel 1 goto Failed
dir /-c sabot1-c8.zx0|findstr /R /C:"sabot1-c8.zx0"

echo Compiling sabot0 second pass...
call :FileSize sabot1-bw.zx0
set lzsize1=%fsize%
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=0 sabot0.asm --lst=sabot0.lst --exp=sabot0.inc -DLZSIZE1=%lzsize1% --raw=sabot0-bw.bin
if errorlevel 1 goto Failed
call :FileSize sabot1-c4.zx0
set lzsize1=%fsize%
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=4 sabot0.asm --lst=sabot0.lst --exp=sabot0.inc -DLZSIZE1=%lzsize1% --raw=sabot0-c4.bin
if errorlevel 1 goto Failed
call :FileSize sabot1-c8.zx0
set lzsize1=%fsize%
tools\sjasmplus --nologo --msg=war --i8080 -DCOLOR=8 sabot0.asm --lst=sabot0.lst --exp=sabot0.inc -DLZSIZE1=%lzsize1% --raw=sabot0-c8.bin
if errorlevel 1 goto Failed

copy /b sabot0-bw.bin+sabot1-bw.zx0 saboteur-bw.bin >nul
copy /b sabot0-c4.bin+sabot1-c4.zx0 saboteur-c4.bin >nul
copy /b sabot0-c8.bin+sabot1-c8.zx0 saboteur-c8.bin >nul

echo Converting sabotuer-xx.bin to rks...
python .\tools\bin2rks.py saboteur-bw.bin
dir /-c saboteur-bw.rks|findstr /R /C:"saboteur-bw.rks"
python .\tools\bin2rks.py saboteur-c4.bin
dir /-c saboteur-c4.rks|findstr /R /C:"saboteur-c4.rks"
python .\tools\bin2rks.py saboteur-c8.bin
dir /-c saboteur-c8.rks|findstr /R /C:"saboteur-c8.rks"

echo %ESCchar%[92mSUCCESS%ESCchar%[0m
exit

:Failed
@echo off
echo %ESCchar%[91mFAILED%ESCchar%[0m
exit /b

:FileSize
set fsize=%~z1
exit /b 0
