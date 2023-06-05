package;
import haxe.macro.Expr;

class EngineMacro {
    public static macro function getEngineVersion():ExprOf<String> {
        #if !display
        return macro $v{sys.io.File.getContent("../engineVersion.txt")};
        #else
        return macro $v{"X.X.X"}
        #end
    }
}