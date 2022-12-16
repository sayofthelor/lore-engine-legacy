package lore.macros;

import haxe.macro.Context;
import haxe.macro.Expr;


using haxe.macro.Tools;


class MacroTools {
    // https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
    public static macro function getGitCommitHash():ExprOf<String> {
        #if (!display)
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if (process.exitCode() != 0) {
          var message = process.stderr.readAll().toString();
          var pos = haxe.macro.Context.currentPos();
          haxe.macro.Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
        }
        
        // read the output of the process
        var commitHash:String = process.stdout.readLine();
        
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
    public static macro function getMapFromAbstract(typePath:Expr, invert:Bool = false, ?exclude:Array<String>):Expr
        {
            var type = Context.getType(typePath.toString());
            var values = [];
    
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
                                    values.push({name: f.name, value: value});
                                }
                            default:
                        }
                    }
                default:
            }
    
            var finalExpr;
            if (invert)
                finalExpr = values.map(function(v) return macro $v{v.value} => $v{v.name});
            else
                finalExpr = values.map(function(v) return macro $v{v.name} => $v{v.value});
    
            return macro $a{finalExpr};
        }
}