package lore;

import flixel.FlxSprite;
import flixel.util.FlxAxes;

enum abstract SpriteAlignment(String) {
    var LEFT = "LEFT";
    var RIGHT = "RIGHT";
    var CENTER = "CENTER";
    var TOP = "TOP";
    var BOTTOM = "BOTTOM";
}

class FlxSpriteTools {
    public static function centerOnSprite(s:FlxSprite, t:FlxSprite, ?axes:FlxAxes = FlxAxes.XY):Void {
        if (axes == FlxAxes.XY || axes == FlxAxes.X) s.x = t.x + (t.width / 2) - (s.width / 2);
        if (axes == FlxAxes.XY || axes == FlxAxes.Y) s.y = t.y + (t.height / 2) - (s.height / 2);
    }
}