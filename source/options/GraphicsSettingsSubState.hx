package options;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option(Locale.get("aspectRatioGraphicsText"),
			Locale.get("aspectRatioGraphicsDesc"),
			'aspectRatio',
			'string',
			'16:9', ['16:9', '16:10', '3:2', '4:3', '5:4']);
		addOption(option);

		var option:Option = new Option(Locale.get("pauseOnFocusLostGraphicsText"),
			Locale.get("pauseOnFocusLostGraphicsDesc"),
			'pauseOnFocusLost',
			'bool',
			true);
		option.onChange = function():Void
		{
			FlxG.autoPause = ClientPrefs.pauseOnFocusLost;
		}
		addOption(option);	

		var option:Option = new Option(Locale.get("persistentCachingGraphicsText"),
			Locale.get("persistentCachingGraphicsDesc"),
			'persistentCaching',
			'bool',
			false);
		addOption(option);	

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option(Locale.get("lowQualityGraphicsText"), //Name
			Locale.get("lowQualityGraphicsDesc"), //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option(Locale.get("antialiasingGraphicsText"),
			Locale.get("antialiasingGraphicsDesc"),
			'globalAntialiasing',
			'bool',
			true);
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		var option:Option = new Option(Locale.get("shadersGraphicsText"), //Name
			Locale.get("shadersGraphicsDesc"), //Description
			'shaders', //Save data variable name
			'bool', //Variable type
			true); //Default value
		addOption(option);

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option(Locale.get("framerateGraphicsText"),
			Locale.get("framerateGraphicsDesc"),
			'framerate',
			'int',
			60);
		addOption(option);

		option.minValue = 60;
		option.maxValue = 360;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}