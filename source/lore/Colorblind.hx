package lore;
import flixel.FlxG;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.BitmapFilter;

/*
    pretty much straight nabbed from Forever Engine, thanks Yoshubs
    if this shit doesn't work imma be mad
*/

class Colorblind {
    public static var filters:Array<BitmapFilter> = []; // the filters the game has active
	public static var activeFilter:BitmapFilter = null; // the filter that's currently active
    public static var gameFilters:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}> = [
		"DEUTERANOPIA" => {
			var matrix:Array<Float> = [
				0.43, 0.72, -.15, 0, 0,
				0.34, 0.57, 0.09, 0, 0,
				-.02, 0.03,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		},
		"PROTANOPIA" => {
			var matrix:Array<Float> = [
				0.20, 0.99, -.19, 0, 0,
				0.16, 0.79, 0.04, 0, 0,
				0.01, -.01,    1, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		},
		"TRITANOPIA" => {
			var matrix:Array<Float> = [
				0.97, 0.11, -.08, 0, 0,
				0.02, 0.82, 0.16, 0, 0,
				0.06, 0.88, 0.18, 0, 0,
				   0,    0,    0, 1, 0,
			];
			{filter: new ColorMatrixFilter(matrix)}
		}
	];
    public static function updateFilter() {
        filters = [];
        FlxG.game.setFilters(filters);
        if (ClientPrefs.colorblindFilter != "NONE" && gameFilters.get(ClientPrefs.colorblindFilter) != null) {
            var realFilter = gameFilters.get(ClientPrefs.colorblindFilter).filter;
            if (realFilter != null) filters.push(realFilter);
			activeFilter = realFilter;
        }
        FlxG.game.setFilters(filters);
    }
}