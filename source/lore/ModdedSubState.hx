package lore;

class ModdedSubState extends ScriptableSubState {
    public override function new(scriptName:String) {
        super(scriptName, "substates");
    }    
    override public function create() {
        super.create();
        super.createPost();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        super.updatePost(elapsed);
    }
}