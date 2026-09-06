package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.utils.Assets;

class MainMenuState extends FlxState
{
	private var headerBar:FlxSprite;
	private var titleText:FlxText;
	private var btnAdd:FlxButton;

	private var emptyStateGroup:FlxGroup;
	private var emptyText:FlxText;

	private var containerGroup:FlxGroup;

	private var modContainers:Array<Dynamic> = [];

	override public function create():Void
	{
		super.create();

		bgColor = 0xFF181818;

		FlxG.mouse.visible = true;

		containerGroup = new FlxGroup();
		emptyStateGroup = new FlxGroup();

		add(containerGroup);
		add(emptyStateGroup);

		buildHeader();
		buildEmptyState();

		refreshContainers();
	}

	private function buildHeader():Void
	{
		headerBar = new FlxSprite(0, 0);
		headerBar.makeGraphic(FlxG.width, 70, 0xFF242424);
		add(headerBar);

		titleText = new FlxText(20, 18, 0, "PORTER-MOBILE", 24);
		titleText.setFormat("fonts/ui_font.ttf", 24, FlxColor.WHITE, LEFT);
		if (!Assets.exists("fonts/ui_font.ttf"))
		{
			titleText.systemFont = "Arial";
		}
		add(titleText);

		if (Assets.exists("images/btn_add.png"))
		{
			btnAdd = new FlxButton(FlxG.width - 80, 10, "", openModalAddMod);
			btnAdd.loadGraphic("images/btn_add.png");
		}
		else
		{
			btnAdd = new FlxButton(FlxG.width - 100, 15, " + ADD ", openModalAddMod);
			btnAdd.makeGraphic(80, 40, 0xFF00E676);
			btnAdd.label.setFormat(null, 18, FlxColor.BLACK, CENTER);
		}
		add(btnAdd);
	}

	private function buildEmptyState():Void
	{
		emptyText = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, 
			"Nenhum Container Criado.\nClique no botão '+' no topo para importar uma Source de Mod.", 18);
		emptyText.alignment = CENTER;
		emptyText.color = FlxColor.GRAY;
		emptyStateGroup.add(emptyText);
	}

	private function openModalAddMod():Void
	{
		openSubState(new SetupModModal(function(newModData:Dynamic) {
			if (newModData != null)
			{
				modContainers.push(newModData);
				refreshContainers();
			}
		}));
	}

	private function refreshContainers():Void
	{
		containerGroup.clear();

		if (modContainers.length == 0)
		{
			emptyStateGroup.visible = true;
			return;
		}

		emptyStateGroup.visible = false;
    
		var startX:Float = 40;
		var startY:Float = 100;
		var cardWidth:Float = 360;
		var cardHeight:Float = 180;
		var padding:Float = 20;

		for (i in 0...modContainers.length)
		{
			var mod = modContainers[i];

			var cardBg = new FlxSprite(startX, startY);
			cardBg.makeGraphic(Std.int(cardWidth), Std.int(cardHeight), 0xFF2A2A2A);
			containerGroup.add(cardBg);

			var modTitle = new FlxText(startX + 15, startY + 15, cardWidth - 30, mod.title, 18);
			modTitle.color = FlxColor.WHITE;
			containerGroup.add(modTitle);

			var engineText = new FlxText(startX + 15, startY + 45, cardWidth - 30, "Engine: " + mod.engine, 14);
			engineText.color = 0xFF00E676;
			containerGroup.add(engineText);

			var btnSettings = new FlxButton(startX + 15, startY + 120, "Config", function() {
			});
			btnSettings.makeGraphic(80, 35, 0xFF424242);
			containerGroup.add(btnSettings);

			var btnAndroid = new FlxButton(startX + 115, startY + 120, "Android", function() {
			});
			btnAndroid.makeGraphic(90, 35, 0xFF3DDC84);
			btnAndroid.label.color = FlxColor.BLACK;
			containerGroup.add(btnAndroid);

			var btnApple = new FlxButton(startX + 220, startY + 120, "iOS", function() {
			});
			btnApple.makeGraphic(80, 35, 0xFFE0E0E0);
			btnApple.label.color = FlxColor.BLACK;
			containerGroup.add(btnApple);

			startX += cardWidth + padding;
			if (startX + cardWidth > FlxG.width)
			{
				startX = 40;
				startY += cardHeight + padding;
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
