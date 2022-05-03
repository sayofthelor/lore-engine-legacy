package options;

import flixel.FlxG;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence
		var option:Option = new Option('Colorblind filter: ',
			"Changes the filter used to make the game more accessible to colorblind people.",
			'colorblindFilter',
			'string',
			'NONE', ['NONE',
			"DEUTERANOPIA",
			"PROTANOPIA",
			"TRITANOPIA",]
			);
		#if debug option.description += "\nUses a lot of resources in debug mode, so it's recommended to lower the FPS cap."; #end
		option.onChange = lore.Colorblind.updateFilter;
		addOption(option);
		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ignore Custom Noteskin', //Name
			'If checked, ignores any custom character-wise noteskin values.', //Description
			'ignoreSkin', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Show Note Timing Hitbox', //Name
			'If checked, shows a small hitbox where your note hit in relation to the receptor.', //Description
			'showNoteTimeHitbox', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('StepMania Style Animations', //Name
			'If checked, StepMania style judgement animations will be used.', //Description
			'smJudges', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Smaller Icons', //Name
			'If checked, the health icons will be smaler on the health bar.', //Description
			'tinyIcons', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Icon Head Bop Style: ',
			"The style in which the icon heads will bop to the beat.",
			'bopStyle',
			'string',
			'LORE', ['LORE',
			'PSYCH',
			'DISABLED'
		]);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'SN and Time Left',
			['SN and Time Left', 'SN and Time Elapsed', 'Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Bar Zoom on Hit',
			"If unchecked, disables the Score bar zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Show Score Bar',
			"If unchecked, disables the Score bar.",
			'showScoreBar',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		var option:Option = new Option('FPS Counter Pos: ',
			"The position the FPS counter is in.",
			'fpsPosition',
			'string',
			'BOTTOM LEFT', ['TOP LEFT', 'BOTTOM LEFT']);
		addOption(option);
		#end
		
		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}