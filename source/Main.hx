package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import states.SplashState;

class Main extends Sprite
{
	var gameWidth:Int = 1280;
	var gameHeight:Int = 720;
	var initialState:Class<FlxState> = SplashState;
	var framerate:Int = 60;
	var skipSplash:Bool = false;
	var startFullscreen:Bool = false;

	public static function main():Void
	{
		openfl.Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?event:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = openfl.Lib.current.stage.stageWidth;
		var stageHeight:Int = openfl.Lib.current.stage.stageHeight;

		addChild(new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, startFullscreen));

		FlxG.autoResize = true;
		FlxG.mouse.useSystemCursor = true;
		
		#if mobile
		FlxG.autoPause = false;
		#end
	}
}
