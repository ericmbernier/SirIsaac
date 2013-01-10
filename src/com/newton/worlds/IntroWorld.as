package com.newton.worlds
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Particle;
	import com.newton.util.Button;
	import com.newton.worlds.GameWorld;
	import com.newton.worlds.TransitionWorld;
	
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	import Playtomic.*;
	
	
	/** 
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class IntroWorld extends World
	{
		private const PLANE_WAIT:Number = 1.2;
		private const HAPPY:int = 0;
		private const SHOCKED:int = 1;
		private const SAD:int = 2;
		private const SHAKE_DURATION:Number = 0.3;
		private const SMOKE_DURATION:Number = 0.8;
		private const EXCLAIM_DURATION:Number = 0.5;
		private const BLDG_DOOR:int = 415;
		
		private var bg_:Image = new Image(Assets.INTRO_BG);
		private var bgGrey_:Image = Image.createRect(Global.GAME_WIDTH, Global.GAME_HEIGHT, 0x333333, 0);
		private var player_:Spritemap = new Spritemap(Assets.BEAR, 30, 30, null);
		private var cloudOne_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudTwo_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudThree_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudFour_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudFive_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var cloudSix_:Spritemap = new Spritemap(Assets.INTRO_CLOUD, 58, 42, null);
		private var planeLeft_:Image = new Spritemap(Assets.INTRO_PLANE);
		private var planeRight_:Image = new Spritemap(Assets.INTRO_PLANE);
		private var sodaBldg_:Image = new Spritemap(Assets.INTRO_BLDG);
		private var sun_:Spritemap = new Spritemap(Assets.INTRO_SUN, 70, 70, null);
		private var skipTxt_:Text = new Text("PRESS ENTER TO SKIP", 150, 590, {size:18, 
				color:0xFFFFFF, outlineColor:0x000000, outlineStrength:2});
		private var exclaimTxt_:Text = new Text("?", 0, 0, {size:24, color:0xFFFFFF, 
				outlineColor:0x000000, outlineStrength:2});
		
		private const planeDelay:Number = 0;
		
		// Happy = 1, Shocked = 1, and Sad = 2 via consts above
		private var emotions_:int = HAPPY;
		
		private var droppedBldg_:Boolean = false;
		private var bldgOnGround_:Boolean = false;
		private var playerExclaimed_:Boolean = false;
			
		private var shakeScreen_:Boolean = false;
		private var shakeTimer_:Number = 0;
		
		private var bldgSmoked_:Boolean = false;
		private var smokeTimer_:Number = 0;
		private var smokeCounter_:int = 0;
		
		private var walk_:Boolean = false;
		private var exclaimTimer_:Number = 0;
		
		private var planeSnd_:Sfx = new Sfx(Assets.SND_PLANES);
		private var bldgDropSnd_:Sfx = new Sfx(Assets.SND_BLDG_DROP);
		private var exclaimSnd_:Sfx = new Sfx(Assets.SND_EXCLAIM);
		private var smokeSnd_:Sfx = new Sfx(Assets.SND_SMOKE);
		
		private var muteImg_:Image = new Image(Assets.MUTE_BTN);
		private var muteHover_:Image = new Image(Assets.MUTE_BTN);
		
		
		public function IntroWorld()
		{
			Global.menuMusic.stop();
			
			this.addGraphic(bg_);
			
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
						
			planeLeft_.x = -400;
			planeLeft_.y = 75;
			this.addGraphic(planeLeft_);
			
			planeRight_.x = -275;
			planeRight_.y = 75;
			this.addGraphic(planeRight_);
			
			sodaBldg_.x = -420;
			sodaBldg_.y = 100;
			this.addGraphic(sodaBldg_);
			
			skipTxt_.centerOO();
			skipTxt_.width = FP.width;
			skipTxt_.x = FP.halfWidth;
			skipTxt_.y = 450;
			TweenMax.to(skipTxt_, 0.10, {alpha:0, ease:Back.easeOut, delay:1,
				onComplete:fadeSkipTxt});
			this.addGraphic(skipTxt_);      
			
			exclaimTxt_.x = 40;
			exclaimTxt_. y = 365;
			exclaimTxt_.visible = false;
			this.addGraphic(exclaimTxt_);
			
			player_.add("standing", [0], 1, true);
			player_.add("walking", [4, 5, 6, 7], 0.2, true);
			player_.x = 30;
			player_.y = 389;
			this.addGraphic(player_);
			
			muteHover_.scale = 1.15
			muteHover_.updateBuffer();
			
			Global.muteBtn = new Button(4, 4, 16, 16, mute);
			Global.muteBtn.normal = muteImg_;
			Global.muteBtn.hover = muteHover_;
			Global.muteBtn.down = muteImg_;
			this.add(Global.muteBtn);
		}
		
		
		override public function update():void
		{
			super.update();
			
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
				player_.play("standing")
				
				planeLeft_.x += 3;
				planeRight_.x += 3;
				sodaBldg_.x += 3;
				
				if (sodaBldg_.x >= -50)
				{
					emotions_ = SHOCKED;
					planeSnd_.play(Global.soundVolume);
				}
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
				
				exclaimTxt_.visible = true;
				
				if (!droppedBldg_)
				{
					planeLeft_.x += 3;
					planeRight_.x += 3;
					sodaBldg_.x += 3; 
					
					// TODO: Figure out best drop point
					if (sodaBldg_.x >= 300)
					{
						droppedBldg_ = true;
					}
				}
				else if (!bldgOnGround_)
				{ 
					planeLeft_.x += 2;
					planeRight_.x += 2;
					sodaBldg_.y += 3;
					
					// TODO: Figure out ground hit point
					if (sodaBldg_.y > 228)
					{
						bldgDropSnd_.play(Global.soundVolume);
						bldgOnGround_ = true;
						shakeScreen_ = true;
						
						emotions_ = SAD;
					}
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
			 	
				if (!shakeScreen_ && bldgOnGround_)
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
							bldgSmoked_ = true;
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
				
				if (!walk_ && bldgSmoked_)
				{
					if (!playerExclaimed_)
					{
						exclaimSnd_.play(Global.soundVolume);	
						
						exclaimTxt_.text = "!";
						exclaimTxt_.color = 0xFF0000;
						exclaimTxt_.updateBuffer();
						
						playerExclaimed_ = true;
					}
					
					exclaimTimer_ += FP.elapsed;
					if (exclaimTimer_ >= EXCLAIM_DURATION)
					{
						exclaimTxt_.visible = false;
						walk_ = true;
					}
				}
				else if (walk_ && playerExclaimed_)
				{
					player_.play("walking");
                	player_.x += 1.5;
					
                	if (player_.x >= BLDG_DOOR)
                	{
                    	this.startGame();
                	}
				}
				
				if (planeLeft_.x <= 650)
				{
					planeLeft_.x +=2;
					planeRight_.x +=2;
				}
            }
        }
        
        
    	private function startGame():void
    	{
			planeSnd_.stop();
			bldgDropSnd_.stop();
			exclaimSnd_.stop();
			smokeSnd_.stop();
			
			this.remove(Global.muteBtn);
        	this.removeAll();
					
        	FP.world = new TransitionWorld(GameWorld);                
    	}
		
		
		private function fadeSkipTxt():void
		{
			TweenMax.to(skipTxt_, 0.25, {alpha: 1, repeat: -1, yoyo:true, ease:Quad.easeInOut});
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
		}
	}
}
