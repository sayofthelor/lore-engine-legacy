package lore.macros;

import haxe.macro.Context;
import haxe.macro.Expr;


using haxe.macro.Tools;


class MacroTools {
    // https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
    public static macro function getGitCommitHash():ExprOf<String> {
        #if (!display)
        var commitHash:String = "";
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if (process.exitCode() != 0) {
          var message = process.stderr.readAll().toString();
          trace('git commit error: ${message}');
        } else commitHash = process.stdout.readLine();
        
        // Generates a string expression
        return macro $v{commitHash};
        #else 
        // `#if display` is used for code completion. In this case returning an
        // empty string is good enough; We don't want to call git on every hint.
        var commitHash:String = "";
        return macro $v{commitHash};
        #end
      }
    
    public static macro function getEngineVersion():ExprOf<String> {
        var ver:String = sys.io.File.getContent("engineVersion.txt");
        return macro $v{ver};
    }

    // modified from flixel.system.macros.FlxMacroUtil
    // you still have to use get (e.g. FlxColor.get("WHITE") instead of FlxColor.WHITE) but it seems to be the best i can do
    public static macro function getMapFromAbstract(typePath:Expr, invert:Bool = false, ?exclude:Array<String>):ExprOf<Map<String, Dynamic>>
        {
            var type = Context.getType(typePath.toString());
            var values:Map<String, Dynamic> = [];
    
            if (exclude == null)
                exclude = ["NONE_IS_ACTUALLY_A_VAR_BUT_THIS_PROBABLY_ISNT"];
    
            switch (type.follow())
            {
                case TAbstract(_.get() => ab, _):
                    for (f in ab.impl.get().statics.get())
                    {
                        switch (f.kind)
                        {
                            case FVar(AccInline, _):
                                var value = 0;
                                switch (f.expr().expr)
                                {
                                    case TCast(Context.getTypedExpr(_) => expr, _):
                                        value = expr.getValue();
                                    default:
                                }
                                if (f.name.toUpperCase() == f.name && !exclude.contains(f.name)) // uppercase?
                                {
                                    values.set(f.name, value);
                                }
                            default:
                        }
                    }
                default:
            }
    
            var finalExpr:Map<String, Dynamic> = [];
            for (k => v in values) {
                if (invert) finalExpr.set(v, k);
                else finalExpr.set(k, v);
            }
    
            return macro $v{finalExpr};
        }
}