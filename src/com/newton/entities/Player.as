package com.newton.entities 
{
	import Playtomic.*;
	
	import com.newton.Assets;
	import com.newton.Global;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	/**
	 * 
	 * @author Eric Bernier
	 */
	public class Player extends Physics
	{
		private var APPLE_JUMP:int = 25;
		private var JUMP:int = 8;
		
		// TODO: Format variables and make speeds global variables and not hard-coded values        
		private var sprite:Spritemap = new Spritemap(Assets.NEWTON, 32, 32, null);
		
		// How fast we accelerate
		private var movement:Number = 1;
		
		// Current player direction (true = right, false = left)
		private var direction_:Boolean = true;
		
		// Are we on the ground?
		public var onGround_:Boolean = false;		
	
		// Are we walljumping? (0 = no, 1 = left, 2 = right)
		private var walljumping:int = 0;
		
		// Are we double jumping
		public var doubleJump_:Boolean = false;
		
		private var dead:Boolean = false;
		private var start:Point;
		
		private var rootBeer_:Boolean = false;
		
		private var jumpSnd_:Sfx = new Sfx(Assets.SND_JUMP);
		private var burpSnd_:Sfx = new Sfx(Assets.SND_APPLE_JUMP);
		private var deathSnd_:Sfx = new Sfx(Assets.SND_DEATH);
		
		
		public function Player(x:int, y:int) 
		{
			// Set position
			super(x, y);
			start = new Point(x, y);
			type = Global.PLAYER_TYPE;
			
			// Set different speeds and such
			gravity_ = 0.4;
			maxSpeed_ = new Point(4, 8);
			friction_ = new Point(0.5, 0.5);
			
			// Set up animations
			sprite.add("standLeft", [0, 12], 1, true);
			sprite.add("standRight", [0, 12], 1, true);
			sprite.add("walkLeft", [0, 4, 8, 12, 1], 8, true);
			sprite.add("walkRight", [0, 4, 8, 12, 1], 8, true);
			
			sprite.add("jumpLeft", [1], 0, false);
			sprite.add("jumpRight", [1], 0, false);
			
			sprite.play("standRight");
			
			// Set hitbox & graphic
			this.setHitbox(25, 25, 0, -5);
			graphic = sprite;
			sprite.scale = 1.5;
		}
		
		
		override public function update():void 
		{
			if (dead) 
			{ 
				sprite.alpha -= 0.1; 
				return; 
			} 
			else if (sprite.alpha < 1) 
			{ 
				sprite.alpha += 0.1 
			}
			
            // Are we on the ground?
            onGround_ = false;
            if (collide(Global.SOLID_TYPE, x, y + 1) || Global.onMovingPlatform) 
            { 
                onGround_ = true;
                doubleJump_ = true;
                walljumping = 0;
            }
            
            // Set acceleration to nothing
            acceleration_.x = 0;
            
            // Increase acceleration, if we're not going too fast
            if ((Input.check(Global.keyLeft) || Input.check(Global.keyA)) && 
                    speed_.x > -maxSpeed_.x) 
            { 
                acceleration_.x = -movement; 
                direction_ = false; 
            }
            
            if ((Input.check(Global.keyRight) || Input.check(Global.keyD)) && 
                    speed_.x < maxSpeed_.x) 
            { 
                acceleration_.x = movement; 
                direction_ = true; 
            }
            
            // Friction (apply if we're not moving, or if our speed_.x is larger than maxspeed)
            if (( (!Input.check(Global.keyLeft) && !Input.check(Global.keyA)) && 
                    (!Input.check(Global.keyRight) && !Input.check(Global.keyD))) || 
                    Math.abs(speed_.x) > maxSpeed_.x) 
            { 
                friction(true, false); 
            }
            
            // We should jump
            if (Input.pressed(Global.keyX) || Input.pressed(Global.keyUp) || Input.pressed(Global.keyW)) 
            {
                var jumped:Boolean = false;
                
                // Normal jump
                if (onGround_) 
                { 
                    speed_.y = -JUMP; 
                    jumped = true;
                    
                    world.add(new Particle(x, y + 30, .5, .5, .1, 0xFFFFFF));
                    world.add(new Particle(x + 5, y + 28 + 5, .5, .5, .1, 0xFFFFFF));
                    world.add(new Particle(x - 5, y + 25 - 5, .5, .5, .1, 0xFFFFFF));
                    
                    jumpSnd_.play(Global.soundVolume, 0);
                }
            }
                            
            gravity();
            
            //----------------------------------------------------------------------------------
            // Make sure we're not going too fast vertically. The reason we don't stop the 
            // player from moving too fast left/right is because that would (partially) destroy 
            // the walljumping. Instead, we just make sure the player, using the arrow keys, 
            // can't go faster than the max speed, and if we are going faster
            //than the max speed, descrease it with friction slowly.
            //----------------------------------------------------------------------------------
            maxspeed(false, true);
            
            // Variable jumping (triple gravity)
            if ((speed_.y < 0 && (!Input.check(Global.keyX) && !Input.check(Global.keyUp) && 
                    !Input.check(Global.keyW))))
            { 
                gravity(); 
                gravity(); 
            }        

			// Set the sprites according to if we're on the ground, and if we are moving or not
			if (onGround_)
			{
				if (speed_.x < 0) 
				{ 
					sprite.play("walkLeft"); 
				}
				
				if (speed_.x > 0) 
				{ 
					sprite.play("walkRight"); 
				}
				
				if (speed_.x == 0) 
				{
					if (direction_) 
					{
						sprite.play("standRight"); 
					} 
					else 
					{ 
						sprite.play("standLeft"); 
					}
				}
			}
			else 
			{
				if (direction_) 
				{ 
					sprite.play("jumpRight"); 
				} 
				else 
				{ 
					sprite.play("jumpLeft"); 
				}
				
				// Are we sliding on a wall?
				if (collide(Global.SOLID_TYPE, x - 1, y)) 
				{ 
					sprite.play("slideRight"); 
				}
				
				if (collide(Global.SOLID_TYPE, x + 1, y)) 
				{ 
					sprite.play("slideLeft"); 
				}
			}

			// Set the motion. We set this later so it stops all movement if we should be stopped
			motion();
			
			// Check if we just died, either via enemy contact or falling to our death
			if ((collide(Global.ENEMY_TYPE, x, y) && speed_.y > 0) || this.y >= Global.levelHeight)
			{
				this.killMe();
			}
			
			if (!direction_)
			{
				sprite.flipped = true;
			}
			else
			{
				sprite.flipped = false;
			}
			
			this.collectKey();
		}	
        
		
		public function killMe():void
		{
			dead = true;
			
			world.add(new Explode(x, y, .5, .5, .1));
			this.setHitbox(0, 0);
			FP.world.remove(this);
			
			deathSnd_.play(Global.soundVolume);		
			Global.restart = true;
		}
		
		
		public function animEnd():void 
		{ 
			// Do nothing
		}
		
		
		public function isDead():Boolean
		{
			return dead;
		}

        
		private function collectApple():void
		{
			/*
			var rootbeer:RootBeer = collide(Global.ROOT_BEER_TYPE, x, y) as RootBeer;
			
			if (rootbeer)
			{
				rootBeer_ = true;
				rootbeer.collect();
			}
			*/
		}

       
		private function collectKey():void
		{
			var key:DoorKey = collide(Global.DOOR_KEY_TYPE, x, y) as DoorKey;
			
			if (key)
			{
				key.collect();
			}
		}
			
		
		public function bounce():void
		{
			speed_.y = -JUMP * 1.5;
		}
		
	
		public function appleJump():void
		{
			world.add(new Particle(x, y + 10, .5, .5, .1, 0xFFFFFF));
			world.add(new Particle(x + 5, y + 15, .5, .5, .1, 0xFFFFFF));
			world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0xFFFFFF));
			
			Global.appleVal -= 1;
			
			if (Global.appleVal <= 0 )
			{
				Global.appleVal = 0;
				rootBeer_ = false;
			}
			
			speed_.y = -APPLE_JUMP;
			burpSnd_.play(Global.soundVolume);
		}
	}
}
