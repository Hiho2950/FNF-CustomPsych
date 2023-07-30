package;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;

import modcharting.Modifier;
import modcharting.PlayfieldRenderer;
import modcharting.NoteMovement;
import modcharting.ModchartUtil;
import modcharting.NotePositionData;
import modcharting.ModchartFile;
import Math;

final class FunkinScript extends tea.SScript
{
    public static final Function_Stop:Null<Int> = 1;
	public static final Function_Continue:Null<Int> = 0;

    public var scriptname = "";
	
	public function new(?scriptFile:String = "", ?preset:Bool = true)
	{
		traces = true;

        scriptname = scriptFile;

		super(scriptFile, preset);

		try {
			execute();
		} catch (e:Dynamic) {
			lime.app.Application.current.window.alert(e, 'Error on hx script!');
		}
		callOnScript('create');
		callOnScript('onCreate');
	}

	override function preset():Void
	{
		super.preset();

		set('Alphabet', Alphabet);
		set('Application', Application);
		set('Assets', Assets);
		set('Character', Character);
		set('Conductor', Conductor);
		set('CreditsState', CreditsState);
		set('FlxAngle', FlxAngle);
		set('FlxBar', FlxBar);
		set('FlxBasic', FlxBasic);
		set('FlxCamera', FlxCamera);
		set('FlxEase', FlxEase);
		set('FlxG', FlxG);
		set('FlxGroup', FlxGroup);
		set('FlxMath', FlxMath);
		set('FlxObject', FlxObject);
		set('FlxSave', FlxSave);
		set('FlxSound', FlxSound);
		set('FlxSprite', FlxSprite);
		set('FlxSpriteGroup', FlxSpriteGroup);
		set('FlxText', FlxText);
		set('FlxTextBorderStyle', FlxTextBorderStyle);
		set('FlxTimer', FlxTimer);
		set('FlxTween', FlxTween);
		set('FlxTypedGroup', FlxTypedGroup);
		set('FlxTypedSpriteGroup', FlxTypedSpriteGroup);
		set('ClientPrefs', ClientPrefs);
		set('GameOverSubstate', GameOverSubstate);
		set('InputFormatter', InputFormatter);
		set('Lib', Lib);
		set('Main', Main);
		set('Note', Note);
		set('Paths', Paths);
		set('PlayState', PlayState);
		set('game', PlayState.instance);
		set('MusicBeatState', MusicBeatState);
		set('MusicBeatSubstate', MusicBeatSubstate);
		set('this', this);

		set('setVar', function(name:String, value:Dynamic) {
			PlayState.instance.variables.set(name, value);
		});
		set('getVar', function(name:String) {
			var result:Dynamic = null;
			if (PlayState.instance.variables.exists(name))
				result = PlayState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String) {
			if (PlayState.instance.variables.exists(name)) {
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});

		set('add', function(obj:FlxBasic) PlayState.instance.addToGame(obj));
		set('insert', function(pos:Int, obj:FlxBasic) PlayState.instance.insert(pos, obj));
		set('remove', function(obj:FlxBasic, splice:Bool = false) PlayState.instance.remove(obj, splice));

		set('get', function(id:String)
		{
			var dotList:Array<String> = id.split('.');
			if (dotList.length > 1)
			{
				var property:Dynamic = Reflect.getProperty(PlayState.instance, dotList[0]);
				for (i in 1...dotList.length - 1)
				{
					property = Reflect.getProperty(property, dotList[i]);
				}

				return Reflect.getProperty(property, dotList[dotList.length - 1]);
			}
			return Reflect.getProperty(PlayState.instance, id);
		});

		set('set', function(id:String, value:Dynamic)
		{
			var dotList:Array<String> = id.split('.');
			if (dotList.length > 1)
			{
				var property:Dynamic = Reflect.getProperty(PlayState.instance, dotList[0]);
				for (i in 1...dotList.length - 1)
				{
					property = Reflect.getProperty(property, dotList[i]);
				}

				return Reflect.setProperty(property, dotList[dotList.length - 1], value);
			}
			return Reflect.setProperty(PlayState.instance, id, value);
		});

		set('getColorFromRGB', function(r:Int, g:Int, b:Int)
		{
			return FlxColor.fromRGB(r, b, g);
		});

		set('Math', Math);
        set('PlayfieldRenderer', PlayfieldRenderer);
        set('ModchartUtil', ModchartUtil);
        set('Modifier', Modifier);
        set('NoteMovement', NoteMovement);
        set('NotePositionData', NotePositionData);
        set('ModchartFile', ModchartFile);
    }
    public function callOnScript(funcCall:String, ?funcArgs:Array<Dynamic> = null):Dynamic
	{
		var callValue = call(funcCall, funcArgs);
		if (callValue.succeeded)
		    return callValue.returnValue;
		else
		{
			var e = callValue.exceptions[0];
			if (e != null)
			{
			    if (exists(funcCall)) {
				    var msg:String = CoolUtil.getFirstLine(e.toString());
				    msg = scriptname + ":" + funcCall + " - " + msg;
                    PlayState.instance.addTextToDebug(msg, FlxColor.RED);
			    }
			}
			return null;
		}
	}
}