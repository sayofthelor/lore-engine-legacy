package lore;

class ScriptedState extends MusicBeatState {
    public var script:FunkinHX;
    public var scriptName:String;
    public var instance:ScriptedState;
    override public function new(name:String) {
        instance = this;
        scriptName = "states/" + name + ".hx";
        if (sys.FileSystem.exists(Paths.modFolders(scriptName))) {
            script = new FunkinHX(Paths.modFolders(scriptName), FunkinHX.FunkinHXType.NOEXEC);
        } else if (sys.FileSystem.exists(Paths.getPreloadPath(scriptName))) {
            script = new FunkinHX(Paths.getPreloadPath(scriptName), FunkinHX.FunkinHXType.NOEXEC);
        } else {
            super();
            return;
        }
        @:privateAccess {
            script.interp.variables.remove("game");
            script.interp.variables.remove("add");
            script.interp.variables.remove("remove");
            script.interp.variables.remove("insert");
            script.interp.variables.remove("indexOf");
            script.interp.variables.remove("addBehindBF");
            script.interp.variables.remove("addBehindGF");
            script.interp.variables.remove("addBehindDad");
            script.interp.variables.remove("PlayState");
            script.interp.variables.set("state", instance);
            script.interp.variables.set("add", add);
            script.interp.variables.set("remove", remove);
            script.interp.variables.set("insert", insert);
            script.scriptType = FILE;
            script.doFile();
        }
        super();
    }
    public override function create():Void {
        script.runFunc("create", []);
        super.create();
        script.runFunc("createPost", []);
    }
    public override function update(elapsed:Float):Void {
        script.runFunc("update", [elapsed]);
        super.update(elapsed);
        script.runFunc("updatePost", [elapsed]);
    }
    public override function stepHit():Void {
        script.setInterpVariable("curStep", curStep);
        script.runFunc("stepHit", []);
        super.stepHit();
    }
    public override function beatHit():Void {
        script.setInterpVariable("curBeat", curBeat);
        script.runFunc("beatHit", []);
        super.beatHit();
    }
    public override function sectionHit():Void {
        script.setInterpVariable("curSection", curSection);
        script.runFunc("sectionHit", []);
        super.sectionHit();
    }
    public override function destroy():Void {
        script.runFunc("destroy", []);
        script.destroy();
        super.destroy();
    }
}

