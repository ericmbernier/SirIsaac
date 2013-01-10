package com.newton.entities.platforms 
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Physics;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	
	
	/**
	 *
	 * @author Eric Bernier
	 */
	public class Crate extends Physics
	{
		//private var sprite:Image = new Image(Assets.OBJECT_CRATE);
		private var sprite:Spritemap = new Spritemap(Assets.OBJECT_CRATE, 32, 32, null);
		
		// This is here to check how long the player has been direction, before crate is moving_
		private var timer_:int = 10;
		
		private var direction_:int;
		
		// If we're moving (being pushed)
		private var moving_:Boolean = false;
		
		// Our speed when being pushed (shouldn't be larger than player speed)
		private var movement_:int = 2;
		
		private var playerOnTop_:Boolean = false;
		
		
		public function Crate(x:int, y:int) 
		{
			super(x, y);
			
			graphic = sprite;
			this.type = Global.SOLID_TYPE;
			
			sprite.add("idle", [0], 1, true);
			sprite.add("push", [1], 1, true);
			
			setHitbox(32, 32);
		}
		
		
		override public function update():void 
		{
			// Only move vertically here
			motion(false,true);
			gravity();

			// Check if we're being pushed
			direction_ = Global.IDLE;
			if (collide(Global.PLAYER_TYPE, x + 1, y) && (Input.check(Global.keyLeft) || 
				Input.check(Global.keyA))) 
			{ 
				direction_ = Global.LEFT;
			}
			
			if (collide(Global.PLAYER_TYPE, x - 1, y) && (Input.check(Global.keyRight) || 
				Input.check(Global.keyD)))
			{ 
				direction_ = Global.RIGHT;
			}
			
			//if we're being pushed, count the timer_ down
			if (direction_ != Global.IDLE)
			{
				if (timer_ > 0) 
				{ 
					timer_--; 
				}
				
				// Start moving_ if timer_ has hit bottom
				if (timer_ < 1) 
				{ 
					moving_ = true; 
				}
			}

			if (moving_) 
			{
				// If we're still being pushed, set our speed
				if (direction_ != Global.IDLE) 
				{ 
					  speed_.x = movement_ * direction_; 
				}
				
				// Update the crate's position and the player's position
				motion(true, false);
				Global.player.motion(true,false);
				
				// No longer being pushed
				if (direction_ == Global.IDLE)
				{
					timer_ = 10;
					moving_ = false;
				}
				
				sprite.play("push");
			}
			
			// Slide to a stop if we're not moving
			if (!moving_) 
			{ 
				friction(true, false); 
				motion(true, false); 
				
				sprite.play("idle");
			}
			
			
			var e:Entity = collide(Global.PLAYER_TYPE, x, y - 1) as Entity;
			if (e)
			{
				playerOnTop_ = true;
			}
			else
			{
				playerOnTop_ = false;
			}
		}
		
		
		public function playerOnTop():Boolean
		{
			return playerOnTop_;
		}
	}
}
