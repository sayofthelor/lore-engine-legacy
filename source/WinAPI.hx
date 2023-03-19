#if cpp
import cpp.ConstCharStar;
#end
#if windows
@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
</target>
')

@:headerCode('
#include <Windows.h>
#include <cstdio>
#include <iostream>
#include <tchar.h>
#include <dwmapi.h>
#include <winuser.h>
')
#end
/**
 * Originally from YoshiCrafter Engine
 * 
 * @see http://github.com/YoshiCrafter29/YoshiCrafterEngine
 */
class WinAPI {
    #if windows
    @:functionCode('
        HWND window = GetActiveWindow();

        // make window layered
        alpha = SetWindowLong(window, GWL_EXSTYLE, GetWindowLong(window, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        SetLayeredWindowAttributes(window, RGB(red, green, blue), 0, LWA_COLORKEY);
    ')
    #end
    public static function setTransColor(red:Int, green:Int, blue:Int, alpha:Int = 0) {
        return alpha;
    }

    // kudos to bing chatgpt thing i hate C++
    #if windows
    @:functionCode('
        HWND hwnd = GetActiveWindow();
        HMENU hmenu = GetSystemMenu(hwnd, FALSE);
        if (enable) {
            EnableMenuItem(hmenu, SC_CLOSE, MF_BYCOMMAND | MF_ENABLED);
        } else {
            EnableMenuItem(hmenu, SC_CLOSE, MF_BYCOMMAND | MF_GRAYED);
        }
    ')
    #end
    public static function setCloseButtonEnabled(enable:Bool) {
        return enable;
    }
    // from indie cross \/ \/ \/
    public static function messageBoxYN(#if cpp msg:ConstCharStar = null, title:ConstCharStar = null #else msg:String = null, title:String = null #end):Bool {
        #if windows
        var msgBox:Int = untyped MessageBox(null, msg, title, untyped __cpp__("MB_ICONQUESTION | MB_YESNO"));
        return msgBox == 6;
        #end
        return true;
    }
}