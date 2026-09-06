package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.utils.Assets;

class SetupModModal extends FlxSubState
{
	private var modalBg:FlxSprite;
	private var overlay:FlxSprite;
	
	private var titleText:FlxText;
	private var engineLabel:FlxText;
	private var statusText:FlxText;

	private var engineOptions:Array<String> = [
		"Psych Engine",
		"Codename Engine",
		"Nightmare Vision",
		"Custom Engine"
	];
	private var currentEngineIndex:Int = 0;
	private var btnEngineSelect:FlxButton;

	private var btnAddSource:FlxButton;
	private var btnConfirm:FlxButton;
	private var btnClose:FlxButton;

	private var zipLoaded:Bool = false;
	private var modTitle:String = "Novo Mod FNF";
	private var selectedZipPath:String = "";

	private var onCompleteCallback:Dynamic -> Void;

	public function new(onComplete:Dynamic -> Void)
	{
		super(0x88000000);
		this.onCompleteCallback = onComplete;
	}

	override public function create():Void
	{
		super.create();

		var modalWidth:Int = 550;
		var modalHeight:Int = 380;
		var modalX:Float = (FlxG.width - modalWidth) / 2;
		var modalY:Float = (FlxG.height - modalHeight) / 2;

		modalBg = new FlxSprite(modalX, modalY);
		modalBg.makeGraphic(modalWidth, modalHeight, 0xFF222222);
		add(modalBg);

		titleText = new FlxText(modalX + 20, modalY + 20, modalWidth - 40, "CRIAR CONTAINER DE MOD", 20);
		titleText.setFormat(null, 20, FlxColor.WHITE, CENTER);
		add(titleText);

		engineLabel = new FlxText(modalX + 30, modalY + 75, modalWidth - 60, "Qual a Engine do Mod?", 14);
		engineLabel.color = FlxColor.LIGHTGRAY;
		add(engineLabel);

		btnEngineSelect = new FlxButton(modalX + 30, modalY + 100, engineOptions[currentEngineIndex], toggleEngine);
		btnEngineSelect.makeGraphic(modalWidth - 60, 40, 0xFF333333);
		btnEngineSelect.label.setFormat(null, 16, 0xFF00E676, CENTER);
		add(btnEngineSelect);

		btnAddSource = new FlxButton(modalX + 30, modalY + 165, "ADD SOURCE CODE (.ZIP)", selectZipFile);
		btnAddSource.makeGraphic(modalWidth - 60, 45, 0xFF1E88E5);
		btnAddSource.label.setFormat(null, 16, FlxColor.WHITE, CENTER);
		add(btnAddSource);

		statusText = new FlxText(modalX + 30, modalY + 220, modalWidth - 60, "Aguardando seleção do código-fonte...", 12);
		statusText.alignment = CENTER;
		statusText.color = FlxColor.GRAY;
		add(statusText);

		btnConfirm = new FlxButton(modalX + 30, modalY + 255, "Confirm ✓", confirmContainer);
		btnConfirm.makeGraphic(modalWidth - 60, 45, 0xFF00C853);
		btnConfirm.label.setFormat(null, 18, FlxColor.WHITE, CENTER);
		btnConfirm.visible = false;
		add(btnConfirm);

		btnClose = new FlxButton(modalX + modalWidth - 40, modalY + 10, "X", function() {
			close();
		});
		btnClose.makeGraphic(30, 30, 0xFFD32F2F);
		add(btnClose);
	}

	private function toggleEngine():Void
	{
		currentEngineIndex = (currentEngineIndex + 1) % engineOptions.length;
		btnEngineSelect.text = engineOptions[currentEngineIndex];
	}

	private function selectZipFile():Void
	{
		statusText.text = "Lendo código-fonte e mapeando arquivos...";
		statusText.color = 0xFFFFD54F;

		#if android
		#end

		haxe.Timer.delay(function() {
			zipLoaded = true;
			modTitle = "Mod " + engineOptions[currentEngineIndex];
			
			statusText.text = "Código-fonte lido com sucesso! " + modTitle;
			statusText.color = 0xFF69F0AE;

			btnAddSource.visible = false;
			btnConfirm.visible = true;
		}, 1200);
	}

	private function confirmContainer():Void
	{
		if (!zipLoaded) return;

		var containerData = {
			title: modTitle,
			engine: engineOptions[currentEngineIndex],
			zipPath: selectedZipPath
		};

		if (onCompleteCallback != null)
		{
			onCompleteCallback(containerData);
		}

		close();
	}
}
