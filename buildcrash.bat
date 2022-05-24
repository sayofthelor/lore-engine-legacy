cd crash-dialog
haxe hxwidgets-windows.hxml
copy build\windows_x86\Main.exe ..\export\release\windows\bin\CrashDialog.exe
copy %WXWIN%\lib\vc_lib\wxbase316u_vc_custom.dll ..\export\release\windows\bin\wxbase316u_vc_custom.dll
copy %WXWIN%\lib\vc_lib\wxmsw316ud_propgrid_vc_custom.dll ..\export\release\windows\bin\wxmsw316ud_propgrid_vc_custom.dll
copy %WXWIN%\lib\vc_lib\wxbase316ud_vc_custom.dll ..\export\release\windows\bin\wxbase316ud_vc_custom.dll
copy %WXWIN%\lib\vc_lib\wxmsw316ud_core_vc_custom.dll ..\export\release\windows\bin\wxmsw316ud_core_vc_custom.dll
copy %WXWIN%\lib\vc_lib\wxmsw316ud_gl_vc_custom.dll ..\export\release\windows\bin\wxmsw316ud_gl_vc_custom.dll
cd ..