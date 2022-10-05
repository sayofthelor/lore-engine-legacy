package lore;

import flixel.ui.FlxBar;
import flixel.math.FlxMath;

class FlxSmoothBar extends FlxBar {
    var f:Float;
    override public function updateValueFromParent():Void {
        f = Reflect.getProperty(parent, parentVariable);
    }
    override public function update(elapsed:Float):Void {
        if (value != f) value = FlxMath.lerp(value, f, CoolUtil.boundTo(1 - (elapsed * 18), 0, 1));
        super.update(elapsed);
    }
}