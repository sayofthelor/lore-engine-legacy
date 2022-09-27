package lore;

import hscript.Parser;
import hscript.Interp;
import hscript.Expr;

using StringTools;

class FunkinHX  {
    public var interp:Interp;
    public var parser:Parser = new Parser();
    public var scriptName:String = "unknown";
    public var loaded:Bool = false;

    public function traace(text:String):Void {
        var posInfo = interp.posInfos();
        Sys.println("[interp:" + scriptName + ":" + posInfo.lineNumber + "]: " + text);
    }

    public function new(f:String):Void {
        scriptName = f;
        var ttr = sys.io.File.getContent(f);
        interp = new FunkinLua.HScript().interp;
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
            interp.variables.set("add", PlayState.instance.add);
            interp.variables.set("remove", PlayState.instance.remove);
            interp.variables.set("insert", PlayState.instance.insert);
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
            interp.variables.set("onSpawnNote", function(id:Int, direction:Int, type:String, isSustain:Bool) {});
            interp.variables.set("onGameOver", function() {});
            interp.variables.set("onEvent", function(name:String, val1:Dynamic, val2:Dynamic) {});
            interp.variables.set("onMoveCamera", function(char:String) {});
            interp.variables.set("onEndSong", function() {});
            interp.variables.set("onGhostTap", function(key:Int) {});
            interp.variables.set("onKeyPress", function(key:Int) {});
            interp.variables.set("onKeyRelease", function(key:Int) {});
            interp.variables.set("noteMiss", function(id:Int, direction:Int, type:String, isSustain:Bool) {});
            interp.variables.set("noteMissPress", function(direction:Int) {});
            interp.variables.set("opponentNoteHit", function(id:Int, direction:Int, type:String, isSustain:Bool) {});
            interp.variables.set("goodNoteHit", function(id:Int, direction:Int, type:String, isSustain:Bool) {});
            interp.variables.set("stepHit", function() {});
            interp.variables.set("beatHit", function() {});
            interp.variables.set("sectionHit", function() {});
            interp.variables.set("onRecalculateRating", function() {});
            interp.variables.set("Function_Stop", FunkinLua.Function_Stop);
            interp.variables.set("onIconUpdate", function(p:String) {});
            interp.variables.set("onHeadBop", function() {});

            interp.variables.set("script", this);

            interp.execute(getExprFromString(ttr));

            runFunc("create");
            loaded = true;
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
            if (interp.variables.exists(f)) {
                if (Reflect.isFunction(interp.variables[f])) {
                    var f = interp.variables[f];
                    if (args.length < 1) return f();
                    else return Reflect.callMethod(null, f, args);
                }
                trace('$f exists, but is not a function!');
                return null;
            }
            trace('$f does not exist!');
            return null;
        }
    
}