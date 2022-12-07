package lore;

import haxe.Json;

class Locale {
    public static var selectedLocale:String;
    private static var localeObject:Dynamic;

    public static function init():Void {
        selectedLocale = ClientPrefs.locale;
        localeObject = Json.parse(lime.utils.Assets.getText(Paths.localeFile(selectedLocale)));
    }

    public static function get(key:String):String {
        return Reflect.field(localeObject, key);
    }
}