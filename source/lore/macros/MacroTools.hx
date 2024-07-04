package lore.macros;

import haxe.macro.Context;
import haxe.macro.Expr;

using Reflect;
using haxe.macro.Tools;


class MacroTools {
    // https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
    public static macro function getGitCommitHash():ExprOf<String> {
        #if display
        return macro $v{"XXXXXXX"};
        #end
        var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
        if (process.exitCode() != 0) {
          var message = process.stderr.readAll().toString();
          trace('git commit error: ${message}');
          return macro $v{"XXXXXXX"};
        } else return macro $v{process.stdout.readLine()};
      }
    
    public static macro function getEngineVersion():ExprOf<String> {
        #if display
        return macro $v{"X.X.X"};
        #end
        return macro $v{sys.io.File.getContent("./engineVersion.txt")};
    }

    // modified from flixel.system.macros.FlxMacroUtil
    // returns dynamic directly now because i realized reflect still works in macro context
    public static macro function getAbstract(typePath:Expr, ?exclude:Array<String>):Expr {
        #if display
        return macro $v{{}};
        #end

        var finalExpr:Dynamic = {};

        if (exclude == null) exclude = [];

        switch (Context.getType(typePath.toString()).follow()) {
            case TAbstract(_.get() => ab, _):
                for (f in ab.impl.get().statics.get()) {
                    switch (f.kind) {
                        case FVar(AccInline, _):
                            var value:Dynamic = null;
                            switch (f.expr().expr) {
                                case TCast(Context.getTypedExpr(_) => expr, _):
                                    value = expr.getValue();
                                default:
                            }
                            if (!exclude.contains(f.name)) finalExpr.setField(f.name, value);
                        default:
                    }
                }
            default:
        }

        return macro $v{finalExpr};
    }
}