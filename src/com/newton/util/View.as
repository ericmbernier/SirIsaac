package com.newton.util
{
	import com.newton.Global;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	
	/**
	 *
	 * @author Eric Bernier
	 */
	public class View extends Entity
	{
		private var toFollow_:Entity;
		private var within_:Rectangle;
		private var speed_:Number;
		
		
		public function View(tofollow:Entity, within:Rectangle = null, speed:Number = 1) 
		{
			// Set x to current camera position so we don't "jump" to 0,0 on creation
			x = FP.camera.x;
			y = FP.camera.y;
			
			setView(tofollow, within, speed);
		}
		
		
		/**
		 * Sets the view (camera) to follow a particular entity within a rectangle, at a set speed
		 * @param	tofollow	The entity to follow
		 * @param	within		The rectangle that the view should stay within (if any)
		 * @param	speed		Speed at which to follow the entity (1=static with entity, >1=follows entity)
		 * @return	void
		 */
		public function setView(tofollow:Entity, within:Rectangle = null, speed:Number = 1):void
		{
			toFollow_ = tofollow;
			within_ = within;
			speed_ = speed;
		}
		
		override public function update():void
		{
			// Follow the entity
			var dist:Number = FP.distance(toFollow_.x - FP.screen.width / 2, toFollow_.y - 
					FP.screen.height / 2, FP.camera.x, FP.camera.y);
			var spd:Number = dist / speed_;
			
			FP.stepTowards(this, toFollow_.x - FP.screen.width / 
					2, toFollow_.y - FP.screen.height / 2, spd);
			
			FP.camera.x = x;
			FP.camera.y = y;
						
			// Update the HUD and its various entities
			Global.rootBeerMeter.x = FP.camera.x;
			Global.rootBeerMeter.y = FP.camera.y + 5;
			if (Global.fizzyMeter.gotFizz())
			{
				Global.fizzyMeter.x = FP.camera.x;
				Global.fizzyMeter.y = FP.camera.y + 5;
			}
			
			Global.hud.x = FP.camera.x;
			Global.hud.y = FP.camera.y;
			Global.muteBtn.x = FP.camera.x + 5;
			Global.muteBtn.y = FP.camera.y + 7;
			Global.quitBtn.x = FP.camera.x + 5;
			Global.quitBtn.y = FP.camera.y + 27;
			Global.restartBtn.x = FP.camera.x + 30;
			Global.restartBtn.y = FP.camera.y + 7;
			
			Global.pausedScreen.x = FP.camera.x;
			Global.pausedScreen.y = FP.camera.y;
				
			if (Global.levelComplete)
			{
				Global.levelCompleteScreen.x = FP.camera.x;
				Global.levelCompleteScreen.y = FP.camera.y;
				
				Global.moreGamesBtn.x = FP.camera.x;
				Global.moreGamesBtn.y = FP.camera.y + 105;
				Global.nextLevelBtn.x = FP.camera.x;
				Global.nextLevelBtn.y = FP.camera.y + 155;
				Global.replayLevelBtn.x = FP.camera.x;
				Global.replayLevelBtn.y = FP.camera.y + 205;
				Global.quitGameBtn.x = FP.camera.x;
				Global.quitGameBtn.y = FP.camera.y + 255;
				
				Global.sponsorLogo.x = FP.camera.x + 185;
				Global.sponsorLogo.y = FP.camera.y + 290;
			}
			
			// Stay within constraints
			if(within_ != null) 
			{
				if (FP.camera.x < within_.x) 
				{ 
					FP.camera.x = within_.x; 
					Global.rootBeerMeter.x = within_.x;
					if (Global.fizzyMeter.gotFizz())
					{
						Global.fizzyMeter.x = within_.x;
					}
					
					Global.hud.x = within_.x;
					Global.muteBtn.x = within_.x + 5;
					Global.quitBtn.x = within_.x + 5;
					Global.restartBtn.x = within_.x + 30;
					
					Global.pausedScreen.x = within_.x;
					
					if (Global.levelComplete)
					{
						Global.levelCompleteScreen.x = within_.x;
						Global.moreGamesBtn.x = within_.x;
						Global.nextLevelBtn.x = within_.x;
						Global.replayLevelBtn.x = within_.x;
						Global.quitGameBtn.x = within_.x;
						
						Global.sponsorLogo.x = within_.x + 185;
					}
				}
				
				if (FP.camera.y < within_.y) 
				{ 
					FP.camera.y = within_.y; 
					Global.rootBeerMeter.y = within_.y + 5;
					if (Global.fizzyMeter.gotFizz())
					{
						Global.fizzyMeter.y = within_.y + 5;
					}
					
					Global.hud.y = within_.y;
					Global.muteBtn.y = within_.y + 7;
					Global.quitBtn.y = within_.y + 27;
					Global.restartBtn.y = within_.y + 7;
					
					Global.pausedScreen.y = within_.y;
					
					if (Global.levelComplete)
					{
						Global.levelCompleteScreen.y = within_.y;
						
						Global.moreGamesBtn.y = within_.y + 105;
						Global.nextLevelBtn.y = within_.y + 155;
						Global.replayLevelBtn.y = within_.y + 205;
						Global.quitGameBtn.y = within_.y + 255;
						
						Global.sponsorLogo.y = within_.y + 310;
					}
				}
				
				if (FP.camera.x + FP.screen.width > within_.x + within_.width) 
				{ 
					FP.camera.x = within_.x + within_.width - FP.screen.width;
					Global.rootBeerMeter.x = within_.x + within_.width - FP.screen.width; 
					if (Global.fizzyMeter.gotFizz())
					{
						Global.fizzyMeter.x = within_.x + within_.width - FP.screen.width;
					}
					
					Global.hud.x = within_.x + within_.width - FP.screen.width;
					Global.muteBtn.x = within_.x + within_.width - FP.screen.width + 5;
					Global.quitBtn.x = within_.x + within_.width - FP.screen.width + 5;
					Global.restartBtn.x = within_.x + within_.width - FP.screen.width + 30;
					
					Global.pausedScreen.x = within_.x + within_.width - FP.screen.width;
					
					if (Global.levelComplete)
					{
						Global.levelCompleteScreen.x = within_.x + within_.width - FP.screen.width;
						
						Global.moreGamesBtn.x = within_.x + within_.width - FP.screen.width;
						Global.nextLevelBtn.x = within_.x + within_.width - FP.screen.width;
						Global.replayLevelBtn.x = within_.x + within_.width - FP.screen.width;
						Global.quitGameBtn.x = within_.x + within_.width - FP.screen.width;
						
						Global.sponsorLogo.x = within_.x + within_.width - FP.screen.width + 185;
					}
				}
				
				if (FP.camera.y + FP.screen.height > within_.y + within_.height) 
				{ 
					FP.camera.y = within_.y + within_.height - FP.screen.height; 
					Global.rootBeerMeter.y = within_.y + within_.height - FP.screen.height + 5;
					if (Global.fizzyMeter.gotFizz())
					{
						Global.fizzyMeter.y = within_.y + within_.height - FP.screen.height + 5;
					}
					
					Global.hud.y = within_.y + within_.height - FP.screen.height;
					Global.muteBtn.y = within_.y + within_.height - FP.screen.height + 7;
					Global.quitBtn.y = within_.y + within_.height - FP.screen.height + 27;
					Global.restartBtn.y = within_.y + within_.height - FP.screen.height + 7;
					
					Global.pausedScreen.y = within_.y + within_.height - FP.screen.height;
					
					if (Global.levelComplete)
					{
						Global.levelCompleteScreen.y = within_.y + within_.height - 
							FP.screen.height;
						Global.moreGamesBtn.y = within_.y + within_.height - FP.screen.height + 105;
						Global.nextLevelBtn.y = within_.y + within_.height - FP.screen.height + 155;
						Global.replayLevelBtn.y = within_.y + within_.height - FP.screen.height + 205;
						Global.quitGameBtn.y = within_.y + within_.height - FP.screen.height + 255;
						
						Global.sponsorLogo.y = within_.y + within_.height - FP.screen.height + 310;
					}
				}
				
				if (Global.levelComplete)
				{
					Global.moreGamesBtn.setHitbox(640, 30, Global.moreGamesBtn.x, 
							Global.moreGamesBtn.y - 105);
					Global.nextLevelBtn.setHitbox(640, 30, Global.nextLevelBtn.x, 
							Global.nextLevelBtn.y - 155);
					Global.replayLevelBtn.setHitbox(640, 30, Global.replayLevelBtn.x, 
							Global.replayLevelBtn.y - 205);
					Global.quitGameBtn.setHitbox(640, 30, Global.quitGameBtn.x, 
							Global.quitGameBtn.y - 255);
					Global.sponsorLogo.setHitbox(640, 155, Global.sponsorLogo.x, 
							Global.sponsorLogo.y - 310);
				}
				
				Global.muteBtn.setHitbox(16, 16, Global.muteBtn.x - 10,
						Global.muteBtn.y - 10);
				Global.restartBtn.setHitbox(65, 16, Global.restartBtn.x - 30, 
						Global.restartBtn.y - 10);
				Global.quitBtn.setHitbox(30, 13, Global.quitBtn.x - 5, 
						Global.quitBtn.y - 30);
			
			}
		}	
	}
}
