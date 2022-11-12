package lore;

import lime.app.Application;
import lime.*;
import openfl.*;
import flixel.*;
import shadertoy.FlxShaderToyRuntimeShader;
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import #if html5 lime.utils.Assets; #else sys.io.File; #end

using StringTools;

/**
 * This is where all of the hscript stuff that isn't for FunkinLua is.
 * 
 * You can find all of that stuff in FunkinLua.HScript.
 * 
 * FunkinLua.HScript is used here to steal a bunch of variable setting I don't wanna do again.
 * 
 * getExprFromString and the import code (as well as the inspiration for this file in general) is owed to YoshiCrafter29.
 * 
 * Feel free to add any lua callbacks I forgot, and merge them as PRs, if you wish.
 * 
 * @see http://github.com/YoshiCrafter29/YoshiCrafterEngine
 */
 

class FunkinHX implements IFlxDestroyable {
    private var interp:Interp;
    public var scriptName:String = "unknown";
    public var loaded:Bool = false;
    public var ignoreErrors:Bool = false;

    public function destroy():Void {
        interp = null;
        scriptName = null;
        loaded = false;
    }

    public function traace(text:String):Void {
        var posInfo = interp.posInfos();
        #if sys Sys.println #else js.Browser.console.log #end (scriptName + ":" + posInfo.lineNumber + ": " + text);
    }

    public function interpVarExists(k:String):Bool {
        if (interp != null) {
            return interp.variables.exists(k);
        }
        return false;
    }
    public function setInterpVariable(k:String, v:Dynamic):Void {
        if (interp != null) interp.variables.set(k, v);
    }

    public function getInterpVariable(k:String):Dynamic {
        if (interp != null) return interp.variables.get(k);
        return null;
    }

    public function new(f:String, ?type:FunkinHXType = FILE):Void {
        scriptName = f;
        var ttr:String = null;
        if (type == FILE) {
            ttr = #if sys File.getContent #else Assets.getText #end (f);
        } else if (type == STRING) {
            ttr = f;
        }
        interp = new Interp();
        interp.variables.set("import", function(className:String)
            {
                var splitClassName = [for (e in className.split(".")) e.trim()];
                var realClassName = splitClassName.join(".");
                var cl = Type.resolveClass(realClassName);
                var en = Type.resolveEnum(realClassName);
                if (cl == null && en == null)
                {
                    traace('Class / Enum at $realClassName does not exist.');
                }
                else
                {
                    if (en != null)
                    {
                        // ENUM!!!!
                        var enumThingy = {};
                        for (c in en.getConstructors())
                        {
                            Reflect.setField(enumThingy, c, en.createByName(c));
                        }
                        interp.variables.set(splitClassName[splitClassName.length - 1], enumThingy);
                    }
                    else
                    {
                        // CLASS!!!!
                        interp.variables.set(splitClassName[splitClassName.length - 1], cl);
                    }
                }
            });
            interp.variables.set('FlxG', flixel.FlxG);
            interp.variables.set('FlxSprite', flixel.FlxSprite);
            interp.variables.set('FlxCamera', flixel.FlxCamera);
            interp.variables.set('FlxTimer', flixel.util.FlxTimer);
            interp.variables.set('FlxTween', flixel.tweens.FlxTween);
            interp.variables.set('FlxEase', flixel.tweens.FlxEase);
            interp.variables.set('PlayState', PlayState);
            interp.variables.set('game', PlayState.instance);
            interp.variables.set('Paths', Paths);
            interp.variables.set('Conductor', Conductor);
            interp.variables.set('ClientPrefs', ClientPrefs);
            interp.variables.set('Character', Character);
            interp.variables.set('Alphabet', Alphabet);
            interp.variables.set('Json', haxe.Json);
            #if !flash
            interp.variables.set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
            interp.variables.set('FlxShaderToyRuntimeShader', FlxShaderToyRuntimeShader);
            interp.variables.set('ShaderFilter', openfl.filters.ShaderFilter);
            #end
            interp.variables.set('StringTools', StringTools);
    
            interp.variables.set('setVar', function(name:String, value:Dynamic)
            {
                PlayState.instance.variables.set(name, value);
            });
            interp.variables.set('getVar', function(name:String)
            {
                var result:Dynamic = null;
                if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
                return result;
            });
            interp.variables.set('removeVar', function(name:String)
            {
                if(PlayState.instance.variables.exists(name))
                {
                    PlayState.instance.variables.remove(name);
                    return true;
                }
                return false;
            });
            interp.variables.set("Sys", Sys);
            interp.variables.set("add", PlayState.instance.add);
            interp.variables.set("addBehindDad", PlayState.instance.addBehindDad);
            interp.variables.set("addBehindGF", PlayState.instance.addBehindGF);
            interp.variables.set("addBehindBF", PlayState.instance.addBehindBF);
            interp.variables.set("remove", PlayState.instance.remove);
            interp.variables.set("insert", PlayState.instance.insert);
            interp.variables.set("indexOf", PlayState.instance.members.indexOf);
            interp.variables.set("create", function() {});
            interp.variables.set("createPost", function() {});
            interp.variables.set("update", function(elapsed:Float) {});
            interp.variables.set("updatePost", function(elapsed:Float) {});
            interp.variables.set("startCountdown", function() {});
            interp.variables.set("onCountdownStarted", function() {});
            interp.variables.set("onCountdownTick", function(tick:Int) {});
            interp.variables.set("onUpdateScore", function(miss:Bool) {});
            interp.variables.set("onNextDialogue", function(counter:Int) {});
            interp.variables.set("onSkipDialogue", function() {});
            interp.variables.set("onSongStart", function() {});
            interp.variables.set("eventEarlyTrigger", function(eventName:String) {});
            interp.variables.set("onResume", function() {});
            interp.variables.set("onPause", function() {});
            interp.variables.set("onSpawnNote", function(note:Note) {});
            interp.variables.set("onGameOver", function() {});
            interp.variables.set("onEvent", function(name:String, val1:Dynamic, val2:Dynamic) {});
            interp.variables.set("onMoveCamera", function(char:String) {});
            interp.variables.set("onEndSong", function() {});
            interp.variables.set("onGhostTap", function(key:Int) {});
            interp.variables.set("onKeyPress", function(key:Int) {});
            interp.variables.set("onKeyRelease", function(key:Int) {});
            interp.variables.set("noteMiss", function(note:Note) {});
            interp.variables.set("noteMissPress", function(direction:Int) {});
            interp.variables.set("opponentNoteHit", function(note:Note) {});
            interp.variables.set("goodNoteHit", function(note:Note) {});
            interp.variables.set("noteHit", function(note:Note) {});
            interp.variables.set("stepHit", function() {});
            interp.variables.set("beatHit", function() {});
            interp.variables.set("sectionHit", function() {});
            interp.variables.set("onRecalculateRating", function() {});
            interp.variables.set("Function_Stop", FunkinLua.Function_Stop);
            interp.variables.set("onIconUpdate", function(p:String) {});
            interp.variables.set("onHeadBop", function(name:String) {});
            interp.variables.set("onGameOverStart", function() {});
            interp.variables.set("onGameOverConfirm", function() {});
            interp.variables.set("Std", Std);
            interp.variables.set("WinAPI", WinAPI);
            interp.variables.set("script", this);
            interp.variables.set("destroy", function() {});
            interp.variables.set("Note", Note);
            interp.variables.set("trace", traace);

            if (ttr != null) try {
                interp.execute(getExprFromString(ttr, true));
                trace("haxe file loaded successfully: " + f);
                loaded = true;
            } catch (e:Dynamic) traace('$e');
    }


    public static function getExprFromString(code:String, critical:Bool = false, ?path:String):Expr
        {
            if (code == null)
                return null;
            var parser = new hscript.Parser();
            parser.allowTypes = true;
            var ast:Expr = null;
            try
            {
                ast = parser.parseString(code);
            }
            catch (ex)
            {
                trace(ex);
                var exThingy = Std.string(ex);
                var line = parser.line;
                if (path != null)
                {
                    if (!openfl.Lib.application.window.fullscreen && critical)
                        openfl.Lib.application.window.alert('Failed to parse the file located at "$path".\r\n$exThingy at $line');
                    trace('Failed to parse the file located at "$path".\r\n$exThingy at $line');
                }
                else
                {
                    if (!openfl.Lib.application.window.fullscreen && critical)
                        openfl.Lib.application.window.alert('Failed to parse the given code.\r\n$exThingy at $line');
                    trace('Failed to parse the given code.\r\n$exThingy at $line');
                    if (!critical)
                        throw new haxe.Exception('Failed to parse the given code.\r\n$exThingy at $line');
                }
            }
            return ast;
        }

        public function runFunc(f:String, ?args:Array<Dynamic>):Any {
            if (!loaded) return null;
            try {
                if (interp.variables.exists(f)) {
                    if (Reflect.isFunction(interp.variables[f])) {
                        var f = interp.variables[f];
                        if (args.length < 1) return f();
                        else return Reflect.callMethod(null, f, args);
                    }
                    trace('$f exists, but is not a function!');
                    return null;
                }
            } catch (e:Dynamic) if (!ignoreErrors) openfl.Lib.application.window.alert('Error with script: ' + scriptName + ' at line ' + interp.posInfos().lineNumber + ":\n" + e, 'Haxe script error');
            trace('$f does not exist!');
            return null;
        }

        public function execute(code:String):Any {
            if (!loaded) return null;
            try {
                return interp.execute(getExprFromString(code, true));
            } catch (e:Dynamic) trace('$e');
            return null;
        }
    
}

@:enum abstract FunkinHXType(Int) from Int to Int {
    var FILE = 0;
    var STRING = 1;
    var NOEXEC = 2;
}