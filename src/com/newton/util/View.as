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
			
			Global.hud.x = FP.camera.x;
			Global.hud.y = FP.camera.y;
			Global.pauseBtn.x = FP.camera.x + 450;
			Global.muteBtnTxt.x = FP.camera.x + 510;
			Global.restartBtn.x = FP.camera.x + 565;
			
			Global.pausedScreen.x = FP.camera.x;
			Global.pausedScreen.y = FP.camera.y;
			
			// Stay within constraints
			if(within_ != null) 
			{
				if (FP.camera.x < within_.x) 
				{ 
					FP.camera.x = within_.x; 
					
					Global.hud.x = within_.x;
					Global.pauseBtn.x = within_.x + 450;
					Global.muteBtnTxt.x = within_.x + 510;
					Global.restartBtn.x = within_.x + 565;
					Global.pausedScreen.x = within_.x;
				}
				
				if (FP.camera.y < within_.y) 
				{ 
					FP.camera.y = within_.y; 
					Global.hud.y = within_.y;
					Global.pausedScreen.y = within_.y;
				}
				
				if (FP.camera.x + FP.screen.width > within_.x + within_.width) 
				{ 
					FP.camera.x = within_.x + within_.width - FP.screen.width;
					
					Global.hud.x = within_.x + within_.width - FP.screen.width;
					Global.pauseBtn.x = within_.x + within_.width - FP.screen.width + 450;
					Global.muteBtnTxt.x = within_.x + within_.width - FP.screen.width + 510;
					Global.restartBtn.x = within_.x + within_.width - FP.screen.width + 565;	
					Global.pausedScreen.x = within_.x + within_.width - FP.screen.width;
				}
				
				if (FP.camera.y + FP.screen.height > within_.y + within_.height) 
				{ 
					FP.camera.y = within_.y + within_.height - FP.screen.height; 
					Global.hud.y = within_.y + within_.height - FP.screen.height;
					Global.pausedScreen.y = within_.y + within_.height - FP.screen.height;
				}
				
				Global.pauseBtn.setHitbox(45, 17, Global.pauseBtn.x - 450, 
					Global.pauseBtn.y - 3);
				Global.muteBtnTxt.setHitbox(40, 17, Global.muteBtnTxt.x - 510,
					Global.muteBtnTxt.y - 3);
				Global.restartBtn.setHitbox(65, 17, Global.restartBtn.x - 565, 
					Global.restartBtn.y - 3);
			}
		}
		
		
		public function setFollow(e:Entity):void
		{
			toFollow_ = e;
		}
	}
}
