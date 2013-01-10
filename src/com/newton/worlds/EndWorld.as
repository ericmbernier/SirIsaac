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
	import com.newton.entities.Explode;
	import com.newton.entities.Particle;
	import com.newton.util.Button;
	import com.newton.util.HackTextButton;
	import com.newton.worlds.GameWorld;
	import com.newton.worlds.TransitionWorld;
	
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.NetStreamPlayTransitions;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.utils.Input;
	
	import mochi.as3.*;
	
	
	/** 
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class EndWorld extends World
	{
		private const HAPPY:int = 0;
		private const SHOCKED:int = 1;
		private const SAD:int = 2;
		private const EXPLODE_DURATION:Number = 0.8;
		private const SHAKE_DURATION:Number = 0.3;
		private const SMOKE_DURATION:Number = 0.8;
		private const SAFE_FOREST:int = 30;
		private const EXPLOSIONS:int = 6;
		
		private var bg_:Image = new Image(Assets.INTRO_BG);
		private var bgGrey_:Image = Image.createRect(Global.GAME_WIDTH, Global.GAME_HEIGHT, 0x333333, 0.6);
		private var player_:Spritemap = new Spritemap(Assets.BEAR, 30, 30, null);
		private var cloudOne_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudTwo_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudThree_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudFour_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudFive_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudSix_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);

		private var sodaBldg_:Image = new Spritemap(Assets.INTRO_BLDG);
		private var sun_:Spritemap = new Spritemap(Assets.INTRO_SUN, 70, 70, null);
		
		// Happy = 1, Shocked = 1, and Sad = 2 via consts above
		private var emotions_:int = SAD;
		
		private var shakeScreen_:Boolean = false;
		private var shakeTimer_:Number = 0;
		
		private var bldgSmoked_:Boolean = false;
		private var smokeTimer_:Number = 0;
		private var smokeCounter_:int = 0;
		
		private var explodeTimer_:Number = 0;
		private var explodeCounter_:int = 0;
		private var bldgExploded_:Boolean = false;
		
		private var walk_:Boolean = false;
		
		private var buildingExplode_:Sfx = new Sfx(Assets.SND_BLDG_EXPLODE);
		private var smokeSnd_:Sfx = new Sfx(Assets.SND_SMOKE);
		
		private var muteImg_:Image = new Image(Assets.MUTE_BTN);
		private var muteHover_:Image = new Image(Assets.MUTE_BTN);
		
		private var awesomeTxt_:Text = new Text("AWESOME!!!", 0, 150, {size:72, outlineColor:0x000000, 
				outlineStrength:3, visible:false});
		private var scoreTxt_:Text = new Text("Score: ", 0, 220, {size:48, outlineColor:0x000000,
				outlineStrength:3, visible:false});
		private var submitScoreTxt_:Text = new Text("Submit Score", 0, 20, {size:30, 
				outlineColor:0x000000, outlineStrength:2});
		private var moreGamesTxt_:Text = new Text("More Games", 0, 20, {size:30, 
				outlineColor:0x000000, outlineStrength:2});
		private var statsTxt_:Text = new Text("Stats", 0, 20, {size:30, 
				outlineColor:0x000000, outlineStrength:2});
		private var playAgainTxt_:Text = new Text("Play Again", 0, 20, {size:30, 
				outlineColor:0x000000, outlineStrength:2});
		private var mainMenuTxt_:Text = new Text("Main Menu", 0, 20, {size:30,
				outlineColor:0x000000, outlineStrength:2});
		private var backTxt_:Text = new Text("Back", 0, 20, {size:30, 
				outlineColor:0x000000, outlineStrength:2});
		
		// Text graphics on the stats screen
		private var timePlayedTxt_:Text = new Text("Time Played: ", 0, 265, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		private var deathsTxt_:Text = new Text("Deaths: ", 0, 295, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		private var rootBeerTxt_:Text = new Text("Root Beer Floats Collected: ", 0, 325, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		private var burpsTxt_:Text = new Text("Burps: ", 0, 355, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		private var coinsTxt_:Text = new Text("Coins Collected: ", 0, 385, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		private var sodaTxt_:Text = new Text("Soda Pop Bottles Collected: ", 0, 415, 
			{size:20, visible:false, outlineColor:0x000000, outlineStrength:2});
		
		private var submitScoreBtn_:HackTextButton;
		private var moreGamesBtn_:HackTextButton;
		private var statsBtn_:HackTextButton;
		private var playAgainBtn_:HackTextButton;
		private var mainMenuBtn_:HackTextButton;
		private var backBtn_:HackTextButton;
		private var btnBg_:Image;
		
		private var colors:Array = [0xef1754, 0xefec17, 0x27ef17, 0x38cef9, 0x96a0ff, 0xff53f1];
		private var index:int = 1;
		private var lastColor:uint = colors[0];
		private var time:Number = 2;
		private var elapsed:Number = 0;
		private var tf:ColorTransform = new ColorTransform();
		private var rate:Number = 1;
		
		private var buttonHoverSnd_:Sfx = new Sfx(Assets.SND_BUTTON_HOVER);
		private var buttonSelectSnd_:Sfx = new Sfx(Assets.SND_BUTTON_SELECT);
		private var buttonBackSnd_:Sfx = new Sfx(Assets.SND_BUTTON_BACK);
		
		private var mochiScore_:Number = 0;
		
		
		public function EndWorld()
		{	
			this.addGraphic(bg_);
			
			Global.menuMusic.stop();
			Global.gameMusic.stop();
			
			cloudOne_.add("happy", [0], 1, true);
			cloudOne_.add("shocked", [1], 1, true);
			cloudOne_.add("sad", [2], 1, true);
			cloudOne_.x = 115;
			cloudOne_.y = 15;
			this.addGraphic(cloudOne_);
			
			cloudTwo_.add("happy", [0], 1, true);
			cloudTwo_.add("shocked", [1], 1, true);
			cloudTwo_.add("sad", [2], 1, true);
			cloudTwo_.x = 180;
			cloudTwo_.y = 45;
			this.addGraphic(cloudTwo_);
			
			cloudThree_.add("happy", [0], 1, true);
			cloudThree_.add("shocked", [1], 1, true);
			cloudThree_.add("sad", [2], 1, true);                        
			cloudThree_.x = 245;
			cloudThree_.y = 15;
			this.addGraphic(cloudThree_);
			
			cloudFour_.add("happy", [0], 1, true);
			cloudFour_.add("shocked", [1], 1, true);
			cloudFour_.add("sad", [2], 1, true);                        
			cloudFour_.x = 310;
			cloudFour_.y = 45;
			this.addGraphic(cloudFour_);
			
			cloudFive_.add("happy", [0], 1, true);
			cloudFive_.add("shocked", [1], 1, true);
			cloudFive_.add("sad", [2], 1, true);                        
			cloudFive_.x = 375;
			cloudFive_.y = 15;
			this.addGraphic(cloudFive_);
			
			cloudSix_.add("happy", [0], 1, true);
			cloudSix_.add("shocked", [1], 1, true);
			cloudSix_.add("sad", [2], 1, true);                        
			cloudSix_.x = 440;
			cloudSix_.y = 45;
			this.addGraphic(cloudSix_);
			
			sun_.add("happy", [0], 1, true);
			sun_.add("shocked", [1], 1, true);
			sun_.add("sad", [2], 1, true);
			sun_.x = 525;
			sun_.y = 10;
			sun_.scale = 1.5;
			this.addGraphic(sun_);

			this.addGraphic(bgGrey_);

			if (Global.konamiCode)
			{
				player_ = new Spritemap(Assets.TURTLE, 30, 30, null);
			}
			
			sodaBldg_.x = 300;
			sodaBldg_.y = 228;
			this.addGraphic(sodaBldg_);    
						
			player_.add("standing", [0], 0.1, true);
			player_.add("dancing", [0, 1], 0.1, true);
			player_.add("walking", [4, 5, 6, 7], 0.2, true);
			player_.x = 415;
			player_.y = 389;
			player_.flipped = true;
			this.addGraphic(player_);
			
			muteHover_.scale = 1.15
			muteHover_.updateBuffer();
			
			Global.muteBtn = new Button(4, 4, 16, 16, mute);
			Global.muteBtn.normal = muteImg_;
			Global.muteBtn.hover = muteHover_;
			Global.muteBtn.down = muteImg_;
			this.add(Global.muteBtn);
			
			awesomeTxt_.centerOO();
			awesomeTxt_.width = FP.width;
			awesomeTxt_.x = FP.halfWidth;
			awesomeTxt_.angle = -3;
			this.addGraphic(awesomeTxt_);
			
			var score:int = 0;
			for (var i:int = 0; i < Global.levelObject.data.levelScores.length; i++)
			{
				score += int(Global.levelObject.data.levelScores[i]);
			}
			
			var deaths:int = Global.statsObject.data.deaths;
			for (var j:int = 0; j < deaths; j++)
			{
				score -= Global.DEATH_SCORE;
				
				if (score < 0)
				{
					score = 0;
				}
			}
			
			var sodasCollected:int = int(Global.sodasObject.data.collected);
			if (sodasCollected == Global.NUM_SODAS)
			{
				score += Global.SODA_BONUS;
			}
			
			// Set our mochi score that can be submitted
			mochiScore_ = score;
			
			scoreTxt_.text = scoreTxt_.text + score.toString();
			scoreTxt_.updateBuffer();
			scoreTxt_.centerOO();
			scoreTxt_.width = FP.width;
			scoreTxt_.x = FP.halfWidth;
			scoreTxt_.visible = false;
			this.addGraphic(scoreTxt_);

			submitScoreTxt_.centerOO();
			submitScoreTxt_.angle = -3;
			submitScoreTxt_.width = FP.width;
			submitScoreTxt_.x = FP.halfWidth;
			submitScoreTxt_.visible = false;
			
			moreGamesTxt_.centerOO();
			moreGamesTxt_.angle = 3;
			moreGamesTxt_.width = FP.width;
			moreGamesTxt_.x = FP.halfWidth;
			moreGamesTxt_.visible = false;
			
			statsTxt_.centerOO();
			statsTxt_.angle = -3;
			statsTxt_.width = FP.width;
			statsTxt_.x = FP.halfWidth;
			statsTxt_.visible = false;

			playAgainTxt_.centerOO();
			playAgainTxt_.angle = 3;
			playAgainTxt_.width = FP.width;
			playAgainTxt_.x = FP.halfWidth;
			playAgainTxt_.visible = false;
			
			mainMenuTxt_.centerOO();
			mainMenuTxt_.angle = -3;
			mainMenuTxt_.width = FP.width;
			mainMenuTxt_.x = FP.halfWidth;
			mainMenuTxt_.visible = false;
			
			btnBg_ = Image.createRect(FP.width, 36, 0xFFFFFF, 0.8);
			
			moreGamesBtn_ = new HackTextButton(moreGamesTxt_, 0, 250, 150, 30, moreGames);
			moreGamesBtn_.normal = moreGamesTxt_;
			moreGamesBtn_.bg = btnBg_;
			moreGamesBtn_.setRollOverSound(buttonHoverSnd_);
			moreGamesBtn_.setSelectSound(buttonSelectSnd_);
			this.add(moreGamesBtn_);
			
			submitScoreBtn_ = new HackTextButton(submitScoreTxt_, 0, 290, 150, 30, submitScore);
			submitScoreBtn_.normal = submitScoreTxt_;
			submitScoreBtn_.bg = btnBg_;
			submitScoreBtn_.setRollOverSound(buttonHoverSnd_);
			submitScoreBtn_.setSelectSound(buttonSelectSnd_);
			this.add(submitScoreBtn_);
			
			statsBtn_ = new HackTextButton(statsTxt_, 0, 330, 150, 30, viewStats);
			statsBtn_.normal = statsTxt_;
			statsBtn_.bg = btnBg_;
			statsBtn_.setRollOverSound(buttonHoverSnd_);
			statsBtn_.setSelectSound(buttonSelectSnd_);
			this.add(statsBtn_);
			
			playAgainBtn_ = new HackTextButton(playAgainTxt_, 0, 370, 150, 30, playAgain);
			playAgainBtn_.normal = playAgainTxt_;
			playAgainBtn_.bg = btnBg_;
			playAgainBtn_.setRollOverSound(buttonHoverSnd_);
			playAgainBtn_.setSelectSound(buttonSelectSnd_);
			this.add(playAgainBtn_);
			
			mainMenuBtn_ = new HackTextButton(mainMenuTxt_, 0, 410, 150, 30, viewMainMenu);
			mainMenuBtn_.normal = mainMenuTxt_;
			mainMenuBtn_.bg = btnBg_;
			mainMenuBtn_.setRollOverSound(buttonHoverSnd_);
			mainMenuBtn_.setSelectSound(buttonSelectSnd_);
			this.add(mainMenuBtn_);
			
			var timePlayed:Number = Global.statsObject.data.time;
			if (timePlayed > 0)
			{
				timePlayed = timePlayed / 60;
				timePlayed += 0.5;
			}
			timePlayedTxt_.text = timePlayedTxt_.text + " " + timePlayed.toFixed(0) + " minutes";
			
			deathsTxt_.text = deathsTxt_.text + " " + Global.statsObject.data.deaths;
			rootBeerTxt_.text = rootBeerTxt_.text + " " + Global.statsObject.data.rootbeers;
			burpsTxt_.text = burpsTxt_.text + " " + Global.statsObject.data.burps;
			coinsTxt_.text = coinsTxt_.text + " " + Global.statsObject.data.coins;	
			sodaTxt_.text = sodaTxt_.text + " " + Global.sodasObject.data.collected + " / " + 
				Global.NUM_SODAS;
			
			timePlayedTxt_.centerOO();
			timePlayedTxt_.width = FP.width;
			timePlayedTxt_.x = FP.halfWidth;
			this.addGraphic(timePlayedTxt_);
			
			deathsTxt_.centerOO();
			deathsTxt_.width = FP.width;
			deathsTxt_.x = FP.halfWidth;
			this.addGraphic(deathsTxt_);
			
			coinsTxt_.centerOO();
			coinsTxt_.width = FP.width;
			coinsTxt_.x = FP.halfWidth;
			this.addGraphic(coinsTxt_);
			
			rootBeerTxt_.centerOO();
			rootBeerTxt_.width = FP.width;
			rootBeerTxt_.x = FP.halfWidth;
			this.addGraphic(rootBeerTxt_);
			
			burpsTxt_.centerOO();
			burpsTxt_.width = FP.width;
			burpsTxt_.x = FP.halfWidth;
			this.addGraphic(burpsTxt_);
			
			sodaTxt_.centerOO();
			sodaTxt_.width = FP.width;
			sodaTxt_.x = FP.halfWidth;
			this.addGraphic(sodaTxt_);
			
			backTxt_.centerOO();
			backTxt_.angle = 3;
			backTxt_.width = FP.width;
			backTxt_.x = FP.halfWidth;
			TweenMax.from(backTxt_, 1, {x:0 - FP.halfWidth, ease:Back.easeOut, delay:1, 
				onComplete:shakeBackTxt});
		}
		
		
		override public function update():void
		{	
			elapsed += FP.elapsed * rate;
			if (elapsed >= time)
			{
				elapsed -= time;
				lastColor = colors[index];
				index = (index + 1) % colors.length;
			}
			
			if (Input.pressed(Global.keyEnter))
			{
				this.startGame();
			}
			
			if (Input.pressed(Global.keyM))
			{
				this.mute();
			}
			
			if (emotions_ == HAPPY)
			{
				cloudOne_.play("happy");
				cloudTwo_.play("happy");
				cloudThree_.play("happy");
				cloudFour_.play("happy");
				cloudFive_.play("happy");
				cloudSix_.play("happy");
				sun_.play("happy");
				player_.play("dancing")
			}
			else if (emotions_ == SHOCKED)
			{	
				cloudOne_.play("shocked");
				cloudTwo_.play("shocked");
				cloudThree_.play("shocked");
				cloudFour_.play("shocked");
				cloudFive_.play("shocked");
				cloudSix_.play("shocked");
				sun_.play("shocked");
				
				explodeTimer_ += FP.elapsed;
				if (explodeTimer_ >= EXPLODE_DURATION)
				{
					this.buildingExplode();
					explodeTimer_ = 0;
				}
			}
			else
			{
				cloudOne_.play("sad");
				cloudTwo_.play("sad");
				cloudThree_.play("sad");
				cloudFour_.play("sad");
				cloudFive_.play("sad");
				cloudSix_.play("sad");
				sun_.play("sad");
				
				if (shakeScreen_)
				{
					FP.screen.x = 8 - 6 * 2 * FP.random;
					FP.screen.y = 8 - 6 * 2 * FP.random;
					
					shakeTimer_ += FP.elapsed;
					
					if (shakeTimer_ > SHAKE_DURATION)
					{
						shakeTimer_ = 0;
						shakeScreen_ = false;
					}
				}
				
				if (!shakeScreen_)
				{
					if (smokeTimer_ == 0)
					{
						var x:Number = sodaBldg_.x + 90;
						var y:Number = sodaBldg_.y - 5;
						
						// Add smoke particles for the first smoke stack
						this.add(new Particle(x, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x + 9, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x - 4, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x - 3, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x + 3, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x - 3, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x -1, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x + 8, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x - 8, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						
						// Add smoke particles for the second smoke stack
						var x2:Number = sodaBldg_.x + 205;
						this.add(new Particle(x2, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 + 9, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 - 4, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 - 3, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 + 3, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 - 3, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 -1, y, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 + 8, y + 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						this.add(new Particle(x2 - 8, y - 5, .5, .5, .1, 0x333333, 10, true, Global.DIR_UP));
						
						if (smokeCounter_ <= 2)
						{
							smokeSnd_.play(Global.soundVolume);
						}
						else if (smokeCounter_ == 3)
						{
							walk_ = true;
							TweenMax.to(bgGrey_, 0.50, {alpha:0.6, repeat: 0, yoyo:false, ease:Quad.easeIn});
						}
					}
					
					smokeTimer_ += FP.elapsed;
					if (smokeTimer_ >= SMOKE_DURATION)
					{
						smokeTimer_ = 0;
						smokeCounter_ += 1;
					}
				}
				
				if (walk_)
				{
					player_.play("walking");
					player_.x -= 1.5;
					
					if (player_.x <= SAFE_FOREST)
					{
						player_.play("standing");
						walk_ = false;
						player_.flipped = false;
						
						this.buildingExplode();
						emotions_ = SHOCKED;
					}
				}
			}
			
			
			super.update();
		}

		
		override public function render():void 
		{
			super.render();
			
			// If we want to set an individual graphic's color to our new color then simply
			// assign its color property to the color value that is calculated directly below
			var color:uint = FP.colorLerp(lastColor, colors[index], elapsed / time);
			tf.redMultiplier = Number(color >> 16 & 0xFF) / 255;
			tf.greenMultiplier = Number(color >> 8 & 0xFF) / 255;
			tf.blueMultiplier = Number(color & 0xFF) / 255;
			
			awesomeTxt_.color = color;
			btnBg_.color = color;
		}
		

		private function startGame():void
		{
			smokeSnd_.stop();
			
			this.remove(Global.muteBtn);
			this.removeAll();
			
			FP.world = new TransitionWorld(GameWorld);                
		}


		private function buildingExplode():void
		{
			explodeCounter_ += 1;
			
			if (explodeCounter_ <= EXPLOSIONS)
			{
				var explodeX:int = 0;
				var explodeY:int = 0;
				
				if (explodeCounter_ == 1)
				{
					explodeX = sodaBldg_.x + 130;
					explodeY = sodaBldg_.y + 80;
				}
				else if (explodeCounter_ == 2)
				{
					explodeX = sodaBldg_.x + 280;
					explodeY = sodaBldg_.y + 150;
				}
				else if (explodeCounter_ == 3)
				{
					explodeX = sodaBldg_.x + 15;
					explodeY = sodaBldg_.y + 90;
					
					// Fade the building out
					TweenMax.to(sodaBldg_, 2.40, {alpha:0, repeat: 0, yoyo:false, ease:Quad.easeIn});
				}
				else if (explodeCounter_ == 4)
				{
					explodeX = sodaBldg_.x + 220;
					explodeY = sodaBldg_.y + 120;					
				}
				else if (explodeCounter_ == 5)
				{
					explodeX = sodaBldg_.x + 165;
					explodeY = sodaBldg_.y + 75;
				}
				else if (explodeCounter_ == 6)
				{
					explodeX = sodaBldg_.x + 40;
					explodeY = sodaBldg_.y + 100;
				}
				
				buildingExplode_.play(Global.soundVolume);
				var explosion:Explode = new Explode(explodeX, explodeY, 1, 0.5, .2, 0xFFFFFF);
				this.add(explosion);
			}
			else
			{
				TweenMax.to(bgGrey_, 0.50, {alpha:0, repeat: 0, yoyo:false, ease:Quad.easeIn, 
						onComplete:makeHappy});
				
				Global.endMusic.loop(0);
				var cfade:SfxFader = new SfxFader(Global.endMusic);
				FP.world.addTween(cfade, true);
				cfade.fadeTo(Global.musicVolume, 30, null);
			}
		}
		
		
		private function makeHappy():void
		{
			emotions_ = HAPPY;
			
			TweenMax.to(cloudOne_, 0.5, {y: cloudOne_.y + 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(cloudTwo_, 0.5, {y: cloudTwo_.y - 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(cloudThree_, 0.5, {y: cloudThree_.y + 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(cloudFour_, 0.5, {y: cloudFour_.y - 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(cloudFive_, 0.5, {y: cloudFive_.y + 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(cloudSix_, 0.5, {y: cloudSix_.y - 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			TweenMax.to(sun_, 0.5, {y: sun_.y + 10, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			
			awesomeTxt_.visible = true;
			scoreTxt_.visible = true;
			submitScoreTxt_.visible = true;
			moreGamesTxt_.visible = true;
			statsTxt_.visible = true;
			playAgainTxt_.visible = true;
			mainMenuTxt_.visible = true;
			
			TweenMax.from(awesomeTxt_, .3, {delay:.5, scale:10, alpha:0, 
				ease:Cubic.easeOut, onComplete:shakeAwesomeTxt});
			TweenMax.from(scoreTxt_, 1, {x:FP.width + FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:null});		
			TweenMax.from(submitScoreTxt_, 1, {x:0 - FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:shakeSubmitScoreTxt});
			TweenMax.from(moreGamesTxt_, 1, {x:FP.width + FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:shakeMoreGamesTxt});
			TweenMax.from(statsTxt_, 1, {x:0 - FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:shakeStatsTxt});
			TweenMax.from(playAgainTxt_, 1, {x:FP.width + FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:shakePlayAgainTxt});
			TweenMax.from(mainMenuTxt_, 1, {x:0 - FP.halfWidth, ease:Back.easeOut, delay:1,
				onComplete:shakeMainMenuTxt});
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function mute():void
		{
			if (Global.musicVolume <= 0 || Global.soundVolume <= 0)
			{
				Global.musicVolume = Global.DEFAULT_MUSIC_VOLUME;				
				Global.soundVolume = Global.DEFAULT_SFX_VOLUME;
				
				// Log the unmute action to Playtomic
				Log.LevelCounterMetric("Unmute", Global.level); 
			}
			else
			{
				Global.musicVolume = 0;
				Global.soundVolume = 0;
				
				// Log the mute action to Playtomic
				Log.LevelCounterMetric("Mute", Global.level);
			}
			
			Global.menuMusic.volume = Global.musicVolume;
			Global.gameMusic.volume = Global.musicVolume;
			Global.endMusic.volume = Global.musicVolume;
		}
		
		
		private function submitScore():void
		{
			MochiScores.showLeaderboard({score:mochiScore_});
		}
		
		
		/*******************************************************************************************
		 * Method: moreGames
		 * 
		 * Description: Callback method that will navigate to sponsor's site
		 ******************************************************************************************/
		private function moreGames():void
		{	
			var url:String = new String("http://www.gamescatch.com/?utm_source=ColaBearFloat&utm_medium=Flash&utm_campaign=Game");
			// var url:String = new String("http://armor.ag/MoreGames");
			navigateToURL(new URLRequest(url));
		}
		
		
		private function viewStats():void	
		{
			this.clearEndWorldScreen();
			
			timePlayedTxt_.visible = true;
			deathsTxt_.visible = true;
			coinsTxt_.visible = true;
			rootBeerTxt_.visible = true;
			burpsTxt_.visible = true;
			sodaTxt_.visible = true;
			
			if (backBtn_ != null)
			{
				this.remove(backBtn_);
			}
			
			backBtn_ = new HackTextButton(backTxt_, 0, 440, 150, 30, backToEndWorld);
			backBtn_.normal = backTxt_;
			backBtn_.bg = btnBg_;
			backBtn_.setHitbox(120, 30, -255, 0);
			backBtn_.setRollOverSound(buttonHoverSnd_);
			backBtn_.setSelectSound(buttonBackSnd_);
			this.add(backBtn_);
			
			submitScoreBtn_.setHitbox(0, 0);
			moreGamesBtn_.setHitbox(0, 0);
			statsBtn_.setHitbox(155, 0);
			playAgainBtn_.setHitbox(0, 0);
			mainMenuBtn_.setHitbox(0, 0);
		}
		
		
		private function backToEndWorld():void
		{
			timePlayedTxt_.visible = false;
			deathsTxt_.visible = false;
			coinsTxt_.visible = false;
			rootBeerTxt_.visible = false;
			burpsTxt_.visible = false;
			sodaTxt_.visible = false;
			
			submitScoreBtn_.visible = true;
			moreGamesBtn_.visible = true;
			statsBtn_.visible = true;
			playAgainBtn_.visible = true;
			mainMenuBtn_.visible = true;
			
			submitScoreBtn_.setHitbox(210, 30, -215, 0);
			moreGamesBtn_.setHitbox(200, 30, -220, 0);
			statsBtn_.setHitbox(155, 30, -240, 0);
			playAgainBtn_.setHitbox(170, 30, -230, 0);
			mainMenuBtn_.setHitbox(170, 30, -230, 0);
			
			this.remove(backBtn_);
		}
		
		
		private function clearEndWorldScreen():void
		{
			submitScoreBtn_.visible = false;
			moreGamesBtn_.visible = false;
			statsBtn_.visible = false;
			playAgainBtn_.visible = false;
			mainMenuBtn_.visible = false;
		}
		
		
		private function playAgain():void
		{
			// Reset all of the global variables
			Global.level = 0;
			Global.levelCoins = 0;
			Global.coinsCollected = 0;		
			
			Global.endMusic.stop();
			
			FP.world.remove(Global.muteBtn);
			this.removeAll();
			FP.world = new TransitionWorld(GameWorld);
		}
		
		
		private function viewMainMenu():void
		{
			// Reset all of the global variables
			Global.level = 0;
			Global.levelCoins = 0;
			Global.coinsCollected = 0;		
			
			Global.endMusic.stop();
			
			Global.levelObject.flush();
			Global.statsObject.flush();
			Global.sodasObject.flush();
			
			FP.world.remove(Global.muteBtn);
			this.removeAll();
			FP.world = new TransitionWorld(TitleWorld);
		}
		
		
		private function shakeAwesomeTxt():void
		{
			TweenMax.to(awesomeTxt_, 1, {angle: 3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakeSubmitScoreTxt():void
		{
			submitScoreBtn_.setHitbox(210, 30, -215, 0);
			TweenMax.to(submitScoreTxt_, 1, {angle: 3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakeMoreGamesTxt():void
		{			
			moreGamesBtn_.setHitbox(200, 30, -220, 0);
			TweenMax.to(moreGamesTxt_, 1, {angle: -3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakeStatsTxt():void
		{
			statsBtn_.setHitbox(155, 30, -240, 0);
			TweenMax.to(statsTxt_, 1, {angle: 3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakePlayAgainTxt():void
		{
			playAgainBtn_.setHitbox(170, 30, -230, 0);
			TweenMax.to(playAgainTxt_, 1, {angle: -3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakeMainMenuTxt():void
		{
			mainMenuBtn_.setHitbox(170, 30, -230, 0);
			TweenMax.to(mainMenuTxt_, 1, {angle: 3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function shakeBackTxt():void
		{
			TweenMax.to(backTxt_, 1, {angle: -3, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
	}
}
