@echo off

cd crash-dialog
echo Building crash dialog...
haxelib run lime build windows
copy build\openfl\windows\bin\CrashDialog.exe ..\export\release\windows\bin\CrashDialog.exe
cd ..

@echo on