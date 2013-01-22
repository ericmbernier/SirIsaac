package com.newton.worlds
{
	import Playtomic.*;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.*;
	import com.newton.entities.solids.*;
	import com.newton.util.Background;
	import com.newton.util.Button;
	import com.newton.util.TextButton;
	import com.newton.util.View;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	
	
	/**
	 * 
	 * @author Eric Bernier
	 */
	public class GameWorld extends World
	{		
		private var tileset:Tilemap;
		private var reset:int = 30;
		private var levelTxt_:Text;
		private var directionsArray_:Array;
		private var addLevelComplete_:Boolean = true;
		private var sponsorLogoBtn:Button;
		

		override public function begin():void
		{
			Log.Play();
			
			if (Global.shared.data.level == undefined)
			{
				Global.level = 0;	
			}
						
			Global.menuMusic.stop();
			Global.gameMusic.loop(Global.musicVolume);
			
			nextlevel();
		}
		
		
		override public function update():void 
		{
			// Only update if the game is not paused
			if (Global.paused)
			{
				if (Input.pressed(Global.keyEnter) || Input.pressed(Global.keyP))
				{
					Global.pausedScreen.unpauseGame();
				}

				if (Input.pressed(Global.keyM))
				{
					Global.pausedScreen.pausedMute();
				}
				
				if (Input.pressed(Global.keyQ))
				{
					var bufferImg:Image = new Image(FP.buffer);
					FP.world.removeAll();
					FP.world = new TransitionWorld(TitleWorld, bufferImg, Global.CIRCLE);
				}
			}
			else
			{	
				if (Input.pressed(Global.keyR) && !Global.restart)
				{
					Global.player.killMe();
				}
				
				if (Input.pressed(Global.keyM))
				{
					Global.hud.mute();
				}
				
				if (Input.pressed(Global.keyP))
				{
					Global.pausedScreen.pauseGame();
				}
				
				super.update();				
			}
			
			if (Global.restart) 
			{ 	
				reset -= 1;
				if (reset == 0) 
				{
					restartlevel();
					Global.restart = false;
					reset = 30;
				}
			}
			
			Global.bg.x -= 0.25;
			Global.bg.y -= 0.25;
			
			// Load next level upon previous level completion
			if (Global.finished) 
			{
				nextlevel();
			}
		}
		
		
		override public function render():void
		{
			super.render();
		}
	
		public function loadlevel():void 
		{	
			Global.bg = new Background();
			Global.bgEntity = new Entity(0, 0, Global.bg);
			this.add(Global.bgEntity);
			
			Global.tvBg = new Background(Global.TV_SCAN);
			Global.tvBg.alpha = 0.05;
			Global.tvBgEntity = new Entity(0, 0, Global.tvBg);
			Global.tvBgEntity.layer = -99999
			this.add(Global.tvBgEntity);

			var file:ByteArray = new Assets.LEVELS[Global.level - 1];
			var str:String = file.readUTFBytes( file.length );
			var xml:XML = new XML(str);

			var e:Entity;
			var o:XML;
			var n:XML;
			
			// Set the level size
			FP.width = xml.width;
			FP.height = xml.height;
			
			// Get the height of the level, used to determine if the player fell to his death
			Global.levelHeight = xml.height;

			add(new Entity(0, 0, tileset = new Tilemap(Assets.TILESET, FP.width, FP.height, 
				Global.grid, Global.grid)));
			
			for each (o in xml.entities[0].door) 
			{ 
				Global.door = new Door(o.@x, o.@y, false);
				this.add(Global.door);
			}
			
			for each (o in xml.entities[0].doorLock) 
			{ 
				Global.door = new Door(o.@x, o.@y, true);
				this.add(Global.door);
			}
			
			for each (o in xml.entities[0].tree) 
			{
				var treeImg:Image = new Image(Assets.TREE);
				treeImg.x = o.@x;
				treeImg.y = o.@y;
				treeImg.y += 1;
				FP.world.addGraphic(treeImg);
			}
			
			for each (o in xml.entities[0].sign) 
			{
				add(new DirectionSign(o.@x, o.@y, o.@text));
			}
			
			add(Global.player = new Player(xml.entities[0].player.@x, xml.entities[0].player.@y));
			
			// Set the view to follow the player, within no restraints, and let it "stray" from the player a bit.
			// for example, if the last parameter was 1, the view would be static with the player. If it was 10, then
			// it would trail behind the player a bit. Higher the number, slower it follows.
			add(Global.view = new View(Global.player as Entity, new Rectangle(0,0,FP.width,FP.height), 10));
			
			for each (o in xml.outdoorTileset[0].tile) 
			{
				//----------------------------------------------------------------------------------
				// Place the tiles in the correct position
				// NOTE that you should replace the TILE_COLUMNS with the amount of columns in your tileset!
				//----------------------------------------------------------------------------------
				tileset.setTile(o.@x / Global.grid, o.@y / Global.grid, 
						(Global.TILE_COLUMNS * (o.@ty / Global.grid)) + (o.@tx/Global.grid));
			}
			
			for each (o in xml.floors[0].rect) 
			{
				add(new Solid(o.@x, o.@y, o.@w, o.@h));
			}
			
			for each (o in xml.entities[0].apple) 
			{
				add(new Apple(o.@x, o.@y));
			}
			
			directionsArray_ = new Array();
			for each (o in xml.entities[0].directions)
			{	
				directionsArray_.push(this.addGraphic(new Text(o.@text, o.@x, o.@y, 
					{size:20, color:0xFFFFFF})));
			}
			
			if (Global.level == 1)
			{				
				var sponsorLogo:Image = new Image(Assets.EB_LOGO);
				sponsorLogoBtn = new Button(100, 50, 254, 150, moreGames);
				sponsorLogoBtn.normal = sponsorLogo;
				sponsorLogoBtn.hover = sponsorLogo;
				sponsorLogoBtn.down = sponsorLogo;
				
				this.add(sponsorLogoBtn);
				sponsorLogoBtn.layer = -999;
			}
			
			Global.appleMeter = new AppleMeter();
			add(Global.appleMeter);
			
			Global.hud = new HUD();
			this.add(Global.hud);
			
			Global.pausedScreen = new PausedScreen(0, 0);
			Global.pausedScreen.visible = false;
			this.add(Global.pausedScreen);
		}
		
		
		public function nextlevel():void
		{
			removeAll();
			Global.appleVal = 0;
			
			if(Global.level < Assets.LEVELS.length) 
			{	
				Global.level += 1; 
			}			
			
			Global.finished = false;
			
			var curSavedLevel:int = int(Global.shared.data.level);
			if (curSavedLevel <= Global.level)
			{
				Global.shared.data.level = Global.level;
			}
			
			loadlevel();
		}
		

		public function restartlevel():void
		{
			removeAll();
			loadlevel();
		}
		
		
		private function moreGames():void
		{		
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
	}
}
