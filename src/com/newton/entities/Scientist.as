package com.newton.entities
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Particle;
	import com.newton.entities.Physics;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	
	
	public class Scientist extends Physics
	{
		private const SCIENTIST_WIDTH:uint = 32;
		private const SCIENTIST_HEIGHT:uint = 32;
		private const WALK_RANGE:int = 100;
		
		private var sprite:Spritemap = new Spritemap(Assets.ENEMY_SCIENTIST, SCIENTIST_WIDTH, 
				SCIENTIST_HEIGHT);
		
		// This variable is going to determine how our enemy scientist moves
		private var onPlatform_:Boolean = false;
		
		private var movement:Number = 1;
		
		private var dead_:Boolean = false;
		private var direction_:Boolean = true;
		private var onGround_:Boolean = false;
		
		private var walked_:Number = 0;
		
		private var deathSnd_:Sfx = new Sfx(Assets.SND_SCIENTIST);
		
		public function Scientist(xCoord:int, yCoord:int)
		{
			super(xCoord, yCoord);
			this.type = Global.SCIENTIST_TYPE;
			enemy_ = true;
			
			sprite.add("standLeft", [0, 1], 0.1, true);
			sprite.add("standRight", [0, 1], 0.1, true);
			sprite.add("walkLeft", [4, 5, 6, 7], 0.1, true);
			sprite.add("walkRight", [4, 5, 6, 7], 0.1, true);
			
			// Set hitbox & graphic
			this.setHitbox(25, 25, 0, -5);
			graphic = sprite;
			
			speed_.x = 2;
		}
		
		
		override public function update():void
		{
			if (dead_)
			{
				
			}
			else
			{
				onGround_ = false;
				if (collide(Global.SOLID_TYPE, x, y + 1)) 
				{ 
					onGround_ = true;
				}
				
				if (!dead_)
				{
					this.checkPlayer();
				}
				
				walked_ += 2;
				if (walked_ >= WALK_RANGE)
				{
					walked_ = 0;
					direction_ = !direction_;
					
					if (direction_)
					{
						speed_.x = 2;
						sprite.flipped = false;
					}
					else
					{
						speed_.x = -2;
						sprite.flipped = true;
					}
				}
				
				gravity();
				
				if (!onGround_)
				{
					gravity();
					gravity();
				}
			}
			
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
			
			this.motion();
		}
		
		
		private function checkPlayer():void
		{
			var e:Entity = collide(Global.PLAYER_TYPE, x, y - 1) as Entity;
			if (e && Global.player.y < this.y)
			{
				this.die();
				Global.player.bounce();
			}
			else if (e)
			{
				Global.player.killMe();
			}
		}


		private function die():void
		{
			dead_ = true;
			
			world.add(new Particle(x, y, .5, .5, .1, 0xCCCCCC));
			world.add(new Particle(x + 5, y + 5, .5, .5, .1, 0xCCCCCC));
			world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0xCCCCCC));
			
			deathSnd_.play(Global.soundVolume);
			
			FP.world.remove(this);
		}
	}
}