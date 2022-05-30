@echo off

cd crash-dialog
echo Building crash dialog...
lime build windows
copy build\openfl\windows\bin\CrashDialog.exe ..\export\release\windows\bin\CrashDialog.exe
cd ..

@echo on