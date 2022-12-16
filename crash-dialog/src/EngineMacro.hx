package;
import haxe.macro.Expr;

class EngineMacro {
    public static macro function getEngineVersion():ExprOf<String> {
        var ver:String = sys.io.File.getContent("../engineVersion.txt");
        return macro $v{ver};
    }
}