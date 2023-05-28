package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	private var canSwitch:Bool = false;

	var warnText:FlxText;
	#if (flixel_addons < "3.0.0")
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Free_Checker'), 0.2, 0.2, true, true);
	#else
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Free_Checker'));
	#end
	override function create()
	{
		super.create();
		#if (flixel_addons >= "3.0.0")
		checker.scrollFactor.set(0.2, 0.2);
		#end
		checker.color = 0xff666666;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Lore Engine and mods using it contain flashing lights.
			To disable them, press Enter.
			You can also do this later in the options menu.
			Press Escape to ignore this warning and continue.",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, OUTLINE, 0xff000000);
		warnText.borderSize = 2;
		warnText.screenCenter(Y);
		warnText.scale *= 0;
		warnText.alpha = 0;
		FlxTween.tween(warnText.scale, {x:1, y:1}, 0.5, {ease: FlxEase.quadOut, onComplete: (_) -> canSwitch = true});
		FlxTween.tween(warnText, {alpha:1}, 0.25, {startDelay: 0.25});
		add(checker);
		add(warnText);
		checker.alpha = 0;
		checker.scrollFactor.set(0.07,0);
		FlxTween.tween(checker, {alpha:1}, 0.25);
	}

	override function update(elapsed:Float)
	{
		checker.x -= 0.45 / (ClientPrefs.framerate / 60);
		checker.y -= 0.16 / (ClientPrefs.framerate / 60);
		if(!leftState && canSwitch) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				canSwitch = false;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxTween.tween(warnText, {alpha:0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(checker, {alpha:0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warnText.scale, {x:1.5, y:1.5}, .5, {ease: FlxEase.quadIn, onComplete: (_) -> new FlxTimer().start(0.5, (t) -> MusicBeatState.switchState(new TitleState()))});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha:0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(checker, {alpha:0}, 0.25, {startDelay: 0.25});
					FlxTween.tween(warnText.scale, {x:0, y:0}, .5, {ease: FlxEase.quadIn, onComplete: (_) -> new FlxTimer().start(0.5, (t) -> MusicBeatState.switchState(new TitleState()))});
				}
			}
		}
		super.update(elapsed);
	}
}
