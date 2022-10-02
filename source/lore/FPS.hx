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
	private var bor1:TextField;
	private var bor2:TextField;
	private var bor3:TextField;
	private var bor4:TextField;
	private var bor5:TextField;
	private var bor6:TextField;
	private var bor7:TextField;
	private var bor8:TextField;
	private var borderSize:Int = 2;
	
	public function new(?x:Float = 3, ?y:Float = 3, ?color:Int = 0xFFFFFFFF)
	{
		super();

		this.x = x;
		width = FlxG.width;
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 16, color);
		text = "0 FPS";

		bor1 = new TextField();
		bor1.x = x - borderSize;
		bor1.width = FlxG.width;
		bor1.selectable = false;
		bor1.mouseEnabled = false;
		bor1.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor1.text = "0 FPS";
		Main.instance.addChild(bor1);
		
		bor2 = new TextField();
		bor2.x = x;
		bor2.width = FlxG.width;
		bor2.selectable = false;
		bor2.mouseEnabled = false;
		bor2.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor2.text = "0 FPS";
		Main.instance.addChild(bor2);
		
		bor3 = new TextField();
		bor3.x = x + borderSize;
		bor3.width = FlxG.width;
		bor3.selectable = false;
		bor3.mouseEnabled = false;
		bor3.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor3.text = "0 FPS";
		Main.instance.addChild(bor3);

		bor4 = new TextField();
		bor4.x = x - borderSize;
		bor4.width = FlxG.width;
		bor4.selectable = false;
		bor4.mouseEnabled = false;
		bor4.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor4.text = "0 FPS";
		Main.instance.addChild(bor4);
		
		bor5 = new TextField();
		bor5.x = x + borderSize;
		bor5.width = FlxG.width;
		bor5.selectable = false;
		bor5.mouseEnabled = false;
		bor5.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor5.text = "0 FPS";
		Main.instance.addChild(bor5);

		bor6 = new TextField();
		bor6.x = x - borderSize;
		bor6.width = FlxG.width;
		bor6.selectable = false;
		bor6.mouseEnabled = false;
		bor6.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor6.text = "0 FPS";
		Main.instance.addChild(bor6);
		
		bor7 = new TextField();
		bor7.x = x;
		bor7.width = FlxG.width;
		bor7.selectable = false;
		bor7.mouseEnabled = false;
		bor7.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor7.text = "0 FPS";
		Main.instance.addChild(bor7);
		
		bor8 = new TextField();
		bor8.x = x + borderSize;
		bor8.width = FlxG.width;
		bor8.selectable = false;
		bor8.mouseEnabled = false;
		bor8.defaultTextFormat = new TextFormat("VCR OSD Mono", 16, 0xff000000);
		bor8.text = "0 FPS";
		Main.instance.addChild(bor8);

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	// Event Handlers
	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate) currentFPS = ClientPrefs.framerate;
		var memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 2));
		var gigaFlag:Bool = memoryMegas >= 1000;
		if (memoryMegas > 1000) memoryMegas = FlxMath.roundDecimal(memoryMegas / 1000, 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			text =
			currentFPS + " FPS" +
			(ClientPrefs.showMem ? "\nMemory: " + memoryMegas + (gigaFlag ? " GB" : " MB") : "") +
			(ClientPrefs.showLore ? "\nLore v" + (MainMenuState.loreEngineVersion.endsWith(".0") ? MainMenuState.loreEngineVersion.replace(".0", "") : MainMenuState.loreEngineVersion) : "")
			+ MainMenuState.versionSuffix
			#if debug + " (debug)" #end;
			var mod:Int = (text.split("\n").length == 2) ? 39 : (text.split("\n").length == 3) ? 53 : 22;
			if (ClientPrefs.fpsPosition == "TOP LEFT") 
				this.y = 3 
			else 
				this.y = Lib.application.window.height - mod;

			bor1.text = text;
			bor2.text = text;
			bor3.text = text;
			bor4.text = text;
			bor5.text = text;
			bor6.text = text;
			bor7.text = text;
			bor8.text = text;

			bor1.y = this.y - borderSize;
			bor2.y = this.y - borderSize;
			bor3.y = this.y - borderSize;
			bor4.y = this.y;
			bor5.y = this.y;
			bor6.y = this.y + borderSize;
			bor7.y = this.y + borderSize;
			bor8.y = this.y + borderSize;
		
		}

		cacheCount = currentCount;
	}
}
