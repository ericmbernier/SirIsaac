package com.newton.worlds
{
	import Playtomic.*;
	
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.*;
	import com.newton.entities.platforms.*;
	import com.newton.entities.solids.*;
	import com.newton.util.Background;
	import com.newton.util.Button;
	import com.newton.util.TextButton;
	import com.newton.util.View;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	
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
		
		// Timer so that reset level doesn't happen right away
		private var reset:int = 60;
		
		private var colors:Array = [0x3366FF, 0x1DE3FF, 0xFFB619];
		private var index:int = 1;
		private var lastColor:uint = colors[0];
		private var time:Number = 0.2;
		private var elapsed:Number = 0;
		private var tf:ColorTransform = new ColorTransform();
		private var rate:Number = 1;
		
		private var levelTxt_:Text;
		private var directionsArray_:Array;
		
		private var addLevelComplete_:Boolean = true;
		private var sponsorLogoBtn:Button;
		

		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		override public function begin():void
		{
			Log.Play();
			
			if (Global.levelObject.data.level == undefined)
			{
				Global.level = 0;	
			}
						
			Global.menuMusic.stop();
			Global.gameMusic.loop(Global.musicVolume);
			
			Global.coinsCollected = 0;
			nextlevel();
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		override public function update():void 
		{
			// Only update if the game is not paused
			if (Global.paused)
			{
				if (Input.pressed(Global.keyEnter) || Input.pressed(Global.keyP))
				{
					Global.pausedScreen.unpauseGame();
				}
				
				// Allow the player to mute the game from the paused screen
				if (Input.pressed(Global.keyM))
				{
					Global.pausedScreen.pausedMute();
				}
			}
			else if (Global.bannerLoaded)
			{
				Global.banner.update();
			}
			else
			{				
				elapsed += FP.elapsed * rate;
				
				if (elapsed >= time)
				{
					elapsed -= time;
					lastColor = colors[index];
					index = (index + 1) % colors.length;
				}
				
				if (Input.pressed(Global.keyR) && !Global.restart && !Global.levelComplete)
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
			
			// If we should restart
			if (Global.restart) 
			{ 	
				// Make a timer so it isn't instant
				reset -= 1;
				if (reset == 0) 
				{
					// Restart level
					restartlevel();
					
					//Set restart to false
					Global.restart = false;
					
					//Reset our timer
					reset = 60;
				}
			}
			
			Global.bg.x -= 0.25;
			Global.bg.y -= 0.25;
			
			Global.statsObject.data.time += FP.elapsed;
			
			// load next level on level completion
			if (Global.finished) 
			{
				nextlevel();
			}
			else if (Global.levelComplete)
			{
				if (addLevelComplete_)
				{
					if (Global.level == 1)
					{
						sponsorLogoBtn.setHitbox(0, 0);
					}
					
					Global.levelCompleteScreen = new LevelComplete();
					this.add(Global.levelCompleteScreen);
					addLevelComplete_ = false;
				}
			}
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		override public function render():void 
		{
			super.render();
			
			// If we want to set an individual graphic's color to our new color then simply
			// assign its color property to the color value that is calculated directly below
			var color:uint = FP.colorLerp(lastColor, colors[index], elapsed / time);
			
			tf.redMultiplier = Number(color >> 16 & 0xFF) / 255;
			tf.greenMultiplier = Number(color >> 8 & 0xFF) / 255;
			tf.blueMultiplier = Number(color & 0xFF) / 255;
			
			// FP.buffer.colorTransform(FP.buffer.rect, tf);
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function loadlevel():void 
		{	
			Global.bg = new Background();
			Global.bgEntity = new Entity(0, 0, Global.bg);
			this.add(Global.bgEntity);
			
			Global.tvBg = new Background(Global.TV_SCAN);
			Global.tvBgEntity = new Entity(0, 0, Global.tvBg);
			this.add(Global.tvBgEntity);
			Global.tvBg.alpha = 0.25;
			
			// Get the XML
			var file:ByteArray = new Assets.LEVELS[Global.level - 1];
			var str:String = file.readUTFBytes( file.length );
			var xml:XML = new XML(str);
			
			//define some variables that we will use later on
			var e:Entity;
			var o:XML;
			var n:XML;
			
			//set the level size
			FP.width = xml.width;
			FP.height = xml.height;
			
			// Get the height of the level, used to determine if the player fell to his death
			Global.levelHeight = xml.height;
			
			//add the tileset to the world
			add(new Entity(0, 0, tileset = new Tilemap(Assets.TILESET, FP.width, FP.height, 
					Global.grid, Global.grid)));
			
			for each (o in xml.objects[0].levelNum)
			{
				var fontSizes:Array = new Array(45, 50, 55, 60, 65);
				var randomFont:uint = FP.rand(fontSizes.length);
				
				levelTxt_ = new Text("Level " + Global.level.toString());
				levelTxt_.x = o.@x;
				levelTxt_.y = o.@y;
				levelTxt_.angle = FP.rand(30);
				levelTxt_.color = 0x40B0BF;
				levelTxt_.alpha = 0.5;
				levelTxt_.size = fontSizes[randomFont];
				this.addGraphic(levelTxt_);
			}
			
			// Add the door!
			for each (o in xml.objects[0].door) 
			{ 
				Global.door = new Door(o.@x, o.@y, false);
				this.add(Global.door);
			}
			
			for each (o in xml.objects[0].doorLock) 
			{ 
				Global.door = new Door(o.@x, o.@y, true);
				this.add(Global.door);
			}
			
			// Add the view, and the player
			add(Global.player = new Player(xml.objects[0].player.@x, xml.objects[0].player.@y));
			
			//set the view to follow the player, within no restraints, and let it "stray" from the player a bit.
			//for example, if the last parameter was 1, the view would be static with the player. If it was 10, then
			//it would trail behind the player a bit. Higher the number, slower it follows.
			add(Global.view = new View(Global.player as Entity, new Rectangle(0,0,FP.width,FP.height), 10));
			
			//add tiles
			for each (o in xml.tilesAbove[0].tile) 
			{
				//place the tiles in the correct position
				//NOTE that you should replace the "5" with the amount of columns in your tileset!
				tileset.setTile(o.@x / Global.grid, o.@y / Global.grid, (5 * (o.@ty/Global.grid)) + 
						(o.@tx/Global.grid));
			}
			
			//place the solids
			for each (o in xml.floors[0].rect) 
			{
				//place flat solids, setting their position & width/height
				add(new Solid(o.@x, o.@y, o.@w, o.@h));
			}
			
			for each (o in xml.objects[0].platformNormal)
			{
				add(new Platform(o.@x, o.@y));
			}
			
			//place a crate
			for each (o in xml.objects[0].crate) 
			{ 
				add(new Crate(o.@x, o.@y)); 
			}
			
			//place a moving platform
			for each (o in xml.objects[0].platformHorizontal) 
			{ 
				add(new PlatformHorizontal(o.@x, o.@y)); 
			}
			
			//place a moving platform
			for each (o in xml.objects[0].platformVertical) 
			{ 
				add(new PlatformVertical(o.@x, o.@y)); 
			}
			
			//place a moving platform
			for each (o in xml.objects[0].platformDrop) 
			{ 
				add(new PlatformDrop(o.@x, o.@y)); 
			}
			
			//place a moving platform
			for each (o in xml.objects[0].platformExplode) 
			{ 
				add(new PlatformExplode(o.@x, o.@y)); 
			}
			
			// Add all of the RootBeer floats
			for each (o in xml.objects[0].spring) 
			{ 
				//add(new RootBeer(o.@x, o.@y, Global.ROOT_BEER_FLOAT)); 
				add(new SpringBoard(o.@x, o.@y));
			}
			
			// Add all of the RootBeer floats
			for each (o in xml.objects[0].rootBeer) 
			{ 
				Global.rootBeersInLevel += 1;
				add(new RootBeer(o.@x, o.@y, Global.ROOT_BEER)); 
			}
			
			// Add all of the RootBeer floats
			for each (o in xml.objects[0].superFizzySoda) 
			{ 
				Global.rootBeersInLevel += 1;
				add(new RootBeer(o.@x, o.@y, Global.SUPER_FIZZY)); 
			}
			
			// Add all of the Coins 
			for each (o in xml.objects[0].coin) 
			{ 
				Global.coinsInLevel += 1;
				add(new Coin(o.@x, o.@y));
			}

			for each (o in xml.objects[0].eSwitch) 
			{
				add(new ESwitch(o.@x, o.@y));
			}
			
			for each (o in xml.objects[0].bigRedButton) 
			{
				add(new BigRedButton(o.@x, o.@y));
			}
			
			// Add all of the Thumper pieces
			for each (o in xml.objects[0].thumper) 
			{
				add(new Thumper(o.@x, o.@y, Global.THUMPER_VERTICAL));
			}

			// Add all of the Thumper pieces
			for each (o in xml.objects[0].thumperLeft) 
			{
				add(new Thumper(o.@x, o.@y, Global.THUMPER_LEFT));
			}
			
			// Add all of the Thumper pieces
			for each (o in xml.objects[0].thumperRight) 
			{
				add(new Thumper(o.@x, o.@y, Global.THUMPER_RIGHT));
			}

			// Add all of the Enemy Scientists
			for each (o in xml.objects[0].scientist) 
			{
				add(new Scientist(o.@x, o.@y));
			}

			for each(o in xml.objects[0].spike)
			{
				add (new Spike(o.@x, o.@y, 0));
			}
			
			for each(o in xml.objects[0].spikeDown)
			{
				add (new Spike(o.@x, o.@y, 180));
			}
			
			for each(o in xml.objects[0].spikeRight)
			{
				add (new Spike(o.@x, o.@y, 270));
			}
			
			for each(o in xml.objects[0].spikeLeft)
			{
				add (new Spike(o.@x, o.@y, 90));
			}
			
			
			for each(o in xml.objects[0].laserVertical)
			{
				add (new LaserBeam(o.@x, o.@y, Global.LASER_VERTICAL, o.@width, o.@height));
			}
			
			for each(o in xml.objects[0].laserHorizontal)
			{
				add (new LaserBeam(o.@x, o.@y, Global.LASER_HORIZONTAL, o.@width, o.@height));
			}
			
			for each(o in xml.objects[0].laserFour)
			{
				add (new LaserBeam(o.@x, o.@y, o.@width, o.@height, Global.LASER_FOUR));
			}
			
			for each(o in xml.objects[0].fanDown)
			{
				add (new Fan(o.@x, o.@y, Global.DIR_DOWN));
			}
			
			for each(o in xml.objects[0].fanUp)
			{
				add (new Fan(o.@x, o.@y, Global.DIR_UP));
			}
			
			for each(o in xml.objects[0].fanLeft)
			{
				add (new Fan(o.@x, o.@y, Global.DIR_LEFT));
			}
			
			for each(o in xml.objects[0].fanRight)
			{
				add (new Fan(o.@x, o.@y, Global.DIR_RIGHT));
			}
						
			// Add all of the Collectable sodas 
			for each (o in xml.objects[0].soda) 
			{
				var id:int = int(o.@id);
				if (this.checkCollected(id))
				{
					add(new Coin(o.@x, o.@y));	
				}
				else
				{
					add(new Soda(o.@x, o.@y, o.@id));	
				}
			}
			
			// Add all of the keys
			for each (o in xml.objects[0].key) 
			{
				add(new DoorKey(o.@x, o.@y));
			}
			
			directionsArray_ = new Array();
			for each (o in xml.objects[0].directions)
			{	
				directionsArray_.push(this.addGraphic(new Text(o.@text, o.@x, o.@y, 
					{size:20, color:0xFFFFFF})));
			}
			
			// Add the temporary sponsor logo here
			if (Global.level == 1)
			{				
				var sponsorLogo:Image = new Image(Assets.SPONSOR_LOGO);
				sponsorLogoBtn = new Button(100, 50, 254, 150, moreGames);
				sponsorLogoBtn.normal = sponsorLogo;
				sponsorLogoBtn.hover = sponsorLogo;
				sponsorLogoBtn.down = sponsorLogo;
				
				this.add(sponsorLogoBtn);
				sponsorLogoBtn.layer = -999;
			}
			
			Global.rootBeerMeter = new RootBeerMeter();
			add(Global.rootBeerMeter);
			
			Global.fizzyMeter = new RootBeerMeter(Global.FIZZY_METER);
			
			Global.hud = new HUD();
			this.add(Global.hud);
			
			// Reset some of the player specific variables
			Global.rootBeerVal = 0;
			
			Global.pausedScreen = new PausedScreen(0, 0);
			Global.pausedScreen.visible = false;
			this.add(Global.pausedScreen);
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function nextlevel():void
		{
			removeAll();
			
			Global.levelComplete = false;
			addLevelComplete_ = true;
			
			// Log the percentage of root beers collected this level and then reset their counts
			Log.LevelRangedMetric("PercentRootBeersCollected", Global.level, 
					int(Global.levelRootBeers / Global.rootBeersInLevel * 100), false);
			
			Global.levelRootBeers = 0;
			Global.rootBeersInLevel = 0;
			
			// Log the percentage of coins collected this level and then reset their counts
			Log.LevelRangedMetric("PercentCoinsCollected", Global.level, 
					int(Global.levelCoins / Global.coinsInLevel * 100), false);
			
			Global.levelCoins = 0;
			Global.coinsInLevel = 0;
						
			if (Global.level > 0)
			{
				// Add the completed level score to the current score
				Global.score += Global.LEVEL_SCORE;
				
				var levelScores:Array = Global.levelObject.data.levelScores;
				var tempScore:int = levelScores[Global.level - 1];
				if (tempScore < Global.score)
				{
					levelScores[Global.level - 1] = Global.score;
					Global.levelObject.data.levelScores = levelScores;
					Global.levelObject.flush();
				}
			}
			
			if (Global.lastSodaId > 0)
			{
				this.clearSoda(Global.lastSodaId);
			}
			
			if(Global.level < Assets.LEVELS.length) 
			{	
				Global.level += 1; 
			}			
			
			Global.score = 0;
			Global.finished = false;
			
			var curSavedLevel:int = int(Global.levelObject.data.level);
			if (curSavedLevel <= Global.level)
			{
				Global.levelObject.data.level = Global.level;
			}
			
			loadlevel();
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function restartlevel():void
		{
			removeAll();
			loadlevel();
			
			Global.rootBeersCollected -= Global.levelRootBeers;
			Global.levelRootBeers = 0;
			
			Global.coinsCollected -= Global.levelCoins;
			Global.statsObject.data.coins -= Global.levelCoins;
			Global.levelCoins = 0;
			
			Global.lastSodaId = 0;
			
			Global.score = 0;
			
			// Increase deaths
			Global.deaths ++;
		}
		
		
		public function checkCollected(id:int):Boolean
		{
			var collected:Boolean = false;
			
			switch (id)
			{
				case 1:
				{
					if (Global.sodasObject.data.soda1 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
		
					break;
				}
				case 2:
				{
					if (Global.sodasObject.data.soda2 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 3:
				{
					if (Global.sodasObject.data.soda3 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 4:
				{
					if (Global.sodasObject.data.soda4 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 5:
				{
					if (Global.sodasObject.data.soda5 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 6:
				{
					if (Global.sodasObject.data.soda6 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 7:
				{
					if (Global.sodasObject.data.soda7 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 8:
				{
					if (Global.sodasObject.data.soda8 == 1)
					{
						collected = true;		
					}
					else
					{
						collected = false;
					}
					
					break;
				}
				case 9:
				{
					if (Global.sodasObject.data.soda9 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 10:
				{
					if (Global.sodasObject.data.soda10 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 11:
				{
					if (Global.sodasObject.data.soda11 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 12:
				{
					if (Global.sodasObject.data.soda12 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 13:
				{
					if (Global.sodasObject.data.soda13 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 14:
				{
					if (Global.sodasObject.data.soda14 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 15:
				{
					if (Global.sodasObject.data.soda15 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 16:
				{
					if (Global.sodasObject.data.soda16 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
				case 17:
				{
					if (Global.sodasObject.data.soda17 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 18:
				{
					if (Global.sodasObject.data.soda18 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 19:
				{
					if (Global.sodasObject.data.soda19 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 20:
				{
					if (Global.sodasObject.data.soda20 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 21:
				{
					if (Global.sodasObject.data.soda21 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 22:
				{
					if (Global.sodasObject.data.soda22 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 23:
				{
					if (Global.sodasObject.data.soda23 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 24:
				{
					if (Global.sodasObject.data.soda24 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 25:
				{
					if (Global.sodasObject.data.soda25 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 26:
				{
					if (Global.sodasObject.data.soda26 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 27:
				{
					if (Global.sodasObject.data.soda27 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 28:
				{
					if (Global.sodasObject.data.soda28 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 29:
				{
					if (Global.sodasObject.data.soda29 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}	
				case 30:
				{
					if (Global.sodasObject.data.soda30 == 1)
					{
						collected =  true;		
					}
					else
					{
						collected =  false;
					}
					
					break;
				}
			}
			
			return collected;
		}
		
		
		/*******************************************************************************************
		 * Method: clearSoda
		 *
		 * Description:
		 ******************************************************************************************/
		public function clearSoda(id:int):void
		{
			var collected:Boolean = false;
			
			switch (id)
			{
				case 1:
				{
					Global.sodasObject.data.soda1 = 1;					
					break;
				}
				case 2:
				{
					Global.sodasObject.data.soda2 = 1;					
					break;
				}
				case 3:
				{
					Global.sodasObject.data.soda3 = 1;					
					break;
				}
				case 4:
				{
					Global.sodasObject.data.soda4 = 1;					
					break;
				}
				case 5:
				{
					Global.sodasObject.data.soda5 = 1;					
					break;
				}
				case 6:
				{
					Global.sodasObject.data.soda6 = 1;					
					break;
				}
				case 7:
				{
					Global.sodasObject.data.soda7 = 1;					
					break;
				}
				case 8:
				{
					Global.sodasObject.data.soda8 = 1;					
					break;
				}
				case 9:
				{
					Global.sodasObject.data.soda9 = 1;					
					break;
				}
				case 10:
				{
					Global.sodasObject.data.soda10 = 1;					
					break;
				}
				case 11:
				{
					Global.sodasObject.data.soda11 = 1;					
					break;
				}
				case 12:
				{
					Global.sodasObject.data.soda12 = 1;					
					break;
				}
				case 13:
				{
					Global.sodasObject.data.soda13 = 1;					
					break;
				}
				case 14:
				{
					Global.sodasObject.data.soda14 = 1;					
					break;
				}
				case 15:
				{
					Global.sodasObject.data.soda15 = 1;					
					break;
				}
				case 16:
				{
					Global.sodasObject.data.soda16 = 1;					
					break;
				}
				case 17:
				{
					Global.sodasObject.data.soda17 = 1;					
					break;
				}	
				case 18:
				{
					Global.sodasObject.data.soda18 = 1;					
					break;
				}	
				case 19:
				{
					Global.sodasObject.data.soda19 = 1;					
					break;
				}	
				case 20:
				{
					Global.sodasObject.data.soda20 = 1;					
					break;
				}	
				case 21:
				{
					Global.sodasObject.data.soda21 = 1;					
					break;
				}	
				case 22:
				{
					Global.sodasObject.data.soda22 = 1;					
					break;
				}	
				case 23:
				{
					Global.sodasObject.data.soda23 = 1;					
					break;
				}	
				case 24:
				{
					Global.sodasObject.data.soda24 = 1;					
					break;
				}	
				case 25:
				{
					Global.sodasObject.data.soda25 = 1;					
					break;
				}	
				case 26:
				{
					Global.sodasObject.data.soda26 = 1;					
					break;
				}	
				case 27:
				{
					Global.sodasObject.data.soda27 = 1;					
					break;
				}	
				case 28:
				{
					Global.sodasObject.data.soda28 = 1;					
					break;
				}	
				case 29:
				{
					Global.sodasObject.data.soda29 = 1;					
					break;
				}	
				case 30:
				{
					Global.sodasObject.data.soda30 = 1;					
					break;
				}
			}
			
			// Reset lastSodaId ensuring we don't wipe our collected sodas
			Global.lastSodaId = 0;
		
			// Lastly increment out soda stats count
			Global.sodasObject.data.collected += 1;
		}
		
		
		/*******************************************************************************************
		 * Method: moreGames
		 * 
		 * Description: Callback method that will navigate to sponsor's site
		 ******************************************************************************************/
		private function moreGames():void
		{		
			// var url:String = new String("http://www.gamescatch.com/?utm_source=ColaBearFloat&utm_medium=Flash&utm_campaign=Game");
			var url:String = new String("http://armor.ag/MoreGames");
			navigateToURL(new URLRequest(url));
		}
	}
}
