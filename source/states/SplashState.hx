package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SplashState extends FlxState
{
	private var logo:FlxSprite;
	private var startupSound:FlxSound;
	private var hasStarted:Bool = false;

	override public function create():Void
	{
		super.create();

		bgColor = 0xFF121212;

		logo = new FlxSprite();
		
		if (openfl.utils.Assets.exists("images/logo.png"))
		{
			logo.loadGraphic("images/logo.png");
		}
		else
		{
			logo.makeGraphic(300, 300, FlxColor.TRANSPARENT);
		}

		logo.screenCenter();
		logo.alpha = 0;
		logo.scale.set(0.8, 0.8);
		add(logo);

		FlxG.mouse.visible = false;

		startSplashSequence();
	}

	private function startSplashSequence():Void
	{
		if (openfl.utils.Assets.exists("sounds/startup.ogg"))
		{
			FlxG.sound.play("sounds/startup.ogg", 1.0);
		}

		FlxTween.tween(logo, {alpha: 1}, 1.5, {
			ease: FlxEase.quadOut
		});

		FlxTween.tween(logo.scale, {x: 1.0, y: 1.0}, 2.0, {
			ease: FlxEase.sineOut,
			onComplete: function(twn:FlxTween) {
				new FlxTimer().start(1.0, function(tmr:FlxTimer) {
					goToMainMenu();
				});
			}
		});
	}

	private function goToMainMenu():Void
	{
		if (hasStarted) return;
		hasStarted = true;

		FlxG.cameras.fade(FlxColor.BLACK, 0.8, false, function() {
			FlxG.switchState(new MainMenuState());
		});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				goToMainMenu();
			}
		}
		#end

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			goToMainMenu();
		}
	}
}
