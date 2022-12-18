package lore;

import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxG;
import openfl.Lib;
import openfl.system.System;
import flixel.math.FlxMath;

using StringTools;

// Credits to OpenFL repository for the original code
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;
	public var visibility(default, set):Bool = true;
	public function set_visibility(value:Bool):Bool {
		visible = value;
		for (i in borders) i.visible = value;
		return value;
	}
	private final borders:Array<TextField> = new Array<TextField>();
	private var borderSize:Int = 2;

	public var rainbowEnabled(default, set):Bool = false;
	public function set_rainbowEnabled(v:Bool):Bool {
		if (!v) textColor = 0xffffffff;
		return rainbowEnabled = v;
	}

	private var templateText:String = "";
	
	public function new(?x:Float = 3, ?y:Float = 3, ?color:Int = 0xFFFFFFFF)
	{
		super();

		var defText = "0";

		this.x = x;
		width = FlxG.width;
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 16, color);
		text = defText;

		for (i in 0...8) {
			borders.push(new TextField());
			if ([0, 3, 5].contains(i)) borders[i].x = x - borderSize;
			else if ([2, 4, 7].contains(i)) borders[i].x = x + borderSize;
			else borders[i].x = x;
			borders[i].width = FlxG.width;
			borders[i].selectable = false;
			borders[i].mouseEnabled = false;
			borders[i].defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
			borders[i].text = defText;
			Main.instance.addChild(borders[i]);
		}

		cacheCount = 0;
		currentTime = 0;
		times = [];
		updateFromPrefs();
	}

	// Event Handlers
	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void
	{
		if (rainbowEnabled) doRainbowThing();
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		#if !html5 if (currentFPS > ClientPrefs.framerate) currentFPS = ClientPrefs.framerate; #end
		var memReadable:Float = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2));
		var gigaFlag:Bool = memReadable >= 1000;
		if (memReadable > 1000) memReadable = FlxMath.roundDecimal(memReadable / 1000, 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = ((templateText.replace("{fps}", '${currentFPS}')).replace("{memory}", '${memReadable}')).replace("{memEnd}", (gigaFlag ? "GB" : "MB"));
			for (i in borders) i.text = text;
		}

		cacheCount = currentCount;
	}

	public function updateFromPrefs():Void {
		templateText = "";
		var fpsThing:String = " FPS";
		var memThing:String = "Memory: ";
		var loreThing:String = "Lore v";
		if (ClientPrefs.compactFPS) {
			fpsThing = "";
			memThing = "";
			loreThing = "v";
		}
		if (ClientPrefs.showFPSNum) { templateText += '{fps}${fpsThing}'; if (ClientPrefs.showMem || ClientPrefs.showLore) templateText += "\n"; }
		if (ClientPrefs.showMem) { templateText += '${memThing}{memory} {memEnd}'; if (ClientPrefs.showLore) templateText += "\n"; }
		if (ClientPrefs.showLore) { templateText += '${loreThing}${(MainMenuState.loreEngineVersion.endsWith(".0") ? MainMenuState.loreEngineVersion.replace(".0", "") : MainMenuState.loreEngineVersion) + MainMenuState.versionSuffix}'; }
		#if debug if (templateText != "") templateText += " "; templateText += '(debug)'; #end
		if (MainMenuState.isNotFinal && MainMenuState.commitHash != "") { if (templateText != "") templateText += " "; templateText += '(${MainMenuState.commitHash.substr(0, 6)})'; }
		set_visibility(ClientPrefs.showFPS);
		set_rainbowEnabled(ClientPrefs.rainbowFPS);
		updatePosition();
	}

	public function updatePosition():Void {
		var mod:Int = (templateText.split("\n").length == 2) ? 39 : (templateText.split("\n").length == 3) ? 53 : 22;
		if (ClientPrefs.fpsPosition == "TOP LEFT") 
			this.y = 3 
		else 
			this.y = Lib.application.window.height - mod;
		

		for (i in 0...borders.length) {
			if ([0, 1, 2].contains(i)) borders[i].y = this.y - borderSize;
			else if ([5, 6, 7].contains(i)) borders[i].y = this.y + borderSize;
			else borders[i].y = this.y;
		}

	}

	private var hue:Float = 0;

	private function doRainbowThing():Void {
		textColor = flixel.util.FlxColor.fromHSL({hue = (hue + (FlxG.elapsed * 100)) % 360; hue;}, 1, 0.8);
	}
}
