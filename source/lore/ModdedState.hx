package lore;

class ModdedState extends ScriptableState {
    override public function new(scriptName:String) {
        super(scriptName, "states");
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