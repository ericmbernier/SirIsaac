package com.newton.entities
{
	import com.newton.Global;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	
	public class Physics extends Entity
	{		
		// TODO: Format variables and make speeds global variables and not hard-coded values        
		public var speed_:Point = new Point(0, 0);			
		public var acceleration_:Point = new Point(0, 0);	
		
		public var gravity_:Number = 0.2;
		public var friction_:Point = new Point(0.5, 0.5);
		public var slopeHeight_:int = 1;
		public var maxSpeed_:Point = new Point(3, 8);
		public var enemy_:Boolean = false;
		
		public function Physics(x:int = 0, y:int = 0) 
		{
			super(x, y);
			type = Global.SOLID_TYPE;
		}
		
		
		override public function update():void 
		{
			motion();
			gravity();
		}
		
		
		/**
		 * Moves this entity at it's current speed_(speed_.x, speed_.y) and increases speed_based on 
		 * acceleration (acceleration.x, acceleration.y)
		 * @param	mx		Include horizontal movement
		 * @param	my		Include vertical movement
		 * @return	void
		 */
		public function motion(mx:Boolean = true, my:Boolean = true):void 
		{	
			// If we should move horizontally
			if (mx)
			{
				//make us move, and stop us on collision
				if (!motionx(this, speed_.x)) 
				{ 
					speed_.x = 0; 
				}
				
				// Increase velocity/speed
				speed_.x += acceleration_.x;
			}
			
			// If we should move vertically
			if (my)
			{
				// Make us move, and stop us on collision
				if (!motiony(this, speed_.y)) 
				{ 
					speed_.y = 0; 
				}
				
				// Increase velocity/speed
				speed_.y += acceleration_.y;
			}			
		}
		
		
		/**
		 * Increases this entities speed, based on its gravity (mGravity)
		 * @return	Void
		 */
		public function gravity():void 
		{
			// Increase velocity/speed_based on gravity
			speed_.y += gravity_;
		}
		
		
		/**
		 * Slows this entity down, according to its friction (mFriction.x, mFriction.y)
		 * @param	mx		Include horizontal movement
		 * @param	my		Include vertical movement
		 * @return	void
		 */
		public function friction(x:Boolean = true, y:Boolean = true):void 
		{
			// If we should use friction, horizontally
			if (x)
			{
				// Speed > 0 then slow down
				if (speed_.x > 0)
				{
					speed_.x -= friction_.x;
					// If we go below 0, stop.
					if (speed_.x < 0) 
					{ 
						speed_.x = 0; 
					}
				}
				
				// Speed < 0  then "speed_up" (in a sense)
				if (speed_.x < 0)
				{
					speed_.x += friction_.x;
					
					// If we go above 0 then stop
					if (speed_.x > 0) 
					{ 
						speed_.x = 0; 
					}
				}
			}
		}
		
		
		/**
		 * Stops entity from moving to fast, according to maxspeed_(mMaxspeed_.x, mMaxspeed_.y)
		 * @param	mx		Include horizontal movement
		 * @param	my		Include vertical movement
		 * @return	void
		 */
		public function maxspeed(x:Boolean = true, y:Boolean = true):void
		{
			if (x) 
			{
				if (Math.abs(speed_.x) > maxSpeed_.x)
				{
					speed_.x = maxSpeed_.x * FP.sign(speed_.x);
				}
			}
			
			if (y) 
			{
				if (Math.abs(speed_.y) > maxSpeed_.y)
				{
					speed_.y = maxSpeed_.y * FP.sign(speed_.y);
				}
			}
		}
		
		
		/**
		 * Moves the set entity horizontal at a given speed, checking for collisions and slopes
		 * @param	e		The entity you want to move
		 * @param	spdx	The speed_at which the entity should move
		 * @return	True (didn't hit a solid) or false (hit a solid)
		 */
		public function motionx(e:Entity, spdx:Number):Boolean
		{
			// Check each pixel before moving it
			for (var i:int = 0; i < Math.abs(spdx); i ++) 
			{
				// If we've moved
				var moved:Boolean = false;
				var below:Boolean = true;
				
				if (!e.collide(Global.SOLID_TYPE, e.x, e.y + 1)) 
				{ 
					below = false; 
				}
				
				// Run through how high a slope we can move up
				for (var s:int = 0; s <= slopeHeight_; s ++)
				{
					// If we don't hit a solid in the direction we're moving, move
					if (!e.collide(Global.SOLID_TYPE, e.x + FP.sign(spdx), e.y - s)) 
					{
						// Increase/decrease positions
						// If the player is in the way don't move, but don't consider them stopped
						if (!e.collide(Global.player.type, e.x + FP.sign(spdx), e.y - s) || enemy_) 
						{ 
							e.x += FP.sign(spdx);
						}
						
						// Move up the slope
						e.y -= s;
						
						//we've moved
						moved = true;
						
						// Stop checking for slope (so we don't fly up into the air)
						break;
					}
				}
				
				// If we are now in the air, but just above a platform, move us down
				if (below && !e.collide(Global.SOLID_TYPE,e.x, e.y + 1)) 
				{ 
					e.y += 1; 
				}
				
				// If we haven't moved, set our speed_to 0
				if (!moved) 
				{ 
					return false; 
				}
			}
			
			// Hit nothing!
			return true;
		}
		
		
		/**
		 * Moves the set entity vertical at a given speed, checking for collisions
		 * @param	e		The entity you want to move
		 * @param	spdy	The speed at which the entity should move
		 * @return	True (didn't hit a solid) or false (hit a solid)
		 */
		public function motiony(e:Entity, spdy:Number):Boolean
		{
			// For each pixel that we will move
			for (var i:int = 0; i < Math.abs(spdy); i ++)
			{
				// If we DON'T collide with solid
				if (!e.collide(Global.SOLID_TYPE, e.x, e.y + FP.sign(spdy))) 
				{ 
					// If we don't run into a player, then move us
					// Note that we wont stop our movement if we hit a player.
					if (!e.collide(Global.player.type, e.x, e.y + FP.sign(spdy))) 
					{ 
						e.y += FP.sign(spdy); 
					}
				} 
				else 
				{ 
					// Stop movement if we hit a solid
					return false; 
				}
			}
			
			// Hit nothing!
			return true;
		}
		
		
		/**
		 * Moves an entity of the given type that is on top of this entity (if any). 
		 * Also moves player if it's on top of the entity on top of this one.
		 * Mostly used for moving platforms
		 * @param	type	Entity type to check for
		 * @param	speed	The speep at which to move the thing above you
		 * @return	void
		 */
		public function moveontop(type:String, speed:Number):void
		{
			var e:Entity = collide(type, x, y - 1) as Entity;
			if (e) 
			{
				motionx(e, speed);
				
				// If the player is on top of the thing that's being moved, move him/her too.
				var p:Physics = e as Physics;
				if(p != null) 
				{ 
					p.moveontop(Global.PLAYER_TYPE, speed); 
				}
			}
		}
		
		
		/**
		 * Moves an entity of the given type that is on top of this entity (if any). 
		 * Also moves player if it's on top of the entity on top of this one.
		 * Mostly used for moving platforms
		 * @param	type	Entity type to check for
		 * @param	speed	The speep at which to move the thing above you
		 * @return	void
		 */
		public function moveUpOnTop(type:String, speed:Number):void
		{
			var e:Entity = collide(type, x, y - 1) as Entity;
			if (e) 
			{
				motiony(e, speed);
				
				// If the player is on top of the thing that's being moved, move him/her too.
				var p:Physics = e as Physics;
				if(p != null) 
				{ 
					p.moveUpOnTop(Global.PLAYER_TYPE, speed); 
				}
			}
		}
	}
}
