package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxBackdrop;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	#if (flixel_addons < "3.0.0")
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Substate_Checker'), 0.2, 0.2, true, true);
	#else
	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('Substate_Checker'));
	#end
	public static var checkerX:Float = 0;
	public static var checkerY:Float = 0;
	static var options:Array<String>;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var things:Map<String, Void->Void>;

	function openSelectedSubstate(label:String) {
		// switch(label) {
		// 	case options[0]:
		// 		openSubState(new options.NotesSubState());
		// 	case options[1]:
		// 		openSubState(new options.ControlsSubState());
		// 	case options[2]:
		// 		LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		// 	case options[3]:
		// 		openSubState(new options.GraphicsSettingsSubState());
		// 	case options[4]:
		// 		openSubState(new options.VisualsUISubState());
		// 	case options[5]:
		// 		openSubState(new options.GameplaySettingsSubState());
		// }
		things.get(label)();
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if (flixel_addons < "3.0.0")
		checker.scrollFactor.set(0.2, 0.2);
		#end
		options = [Locale.get("noteColorsOption"), Locale.get("controlsOption"), Locale.get("delayOption"), Locale.get("graphicsOption"), Locale.get("visualsUIOption"), Locale.get("gameplayOption")];
		things = [
			options[0] => function() openSubState(new options.NotesSubState()),
			options[1] => function() openSubState(new options.ControlsSubState()),
			options[2] => function() LoadingState.loadAndSwitchState(new options.NoteOffsetState()),
			options[3] => function() openSubState(new options.GraphicsSettingsSubState()),
			options[4] => function() openSubState(new options.VisualsUISubState()),
			options[5] => function() openSubState(new options.GameplaySettingsSubState())
		];
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		checker.x=BaseOptionsMenu.checkerX;
		checker.y=BaseOptionsMenu.checkerY;
		add(checker);
		checker.scrollFactor.set(0.07,0);
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.x = 128;
			optionText.screenCenter(Y);
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		checker.x -= 0.45 / (ClientPrefs.framerate / 60);
		checkerX = checker.x;
		checker.y -= 0.16 / (ClientPrefs.framerate / 60);
		checkerY = checker.y;
		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}