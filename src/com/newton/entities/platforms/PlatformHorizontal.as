package com.newton.entities.platforms 
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Physics;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	
	/**
	 * 
	 * @author Eric Bernier
	 */
	public class PlatformHorizontal extends Physics
	{
		private const MAX_DISTANCE:int = 250;
		private var SAD_DURATION:Number = 1.5;
		
		public var sprite:Spritemap = new Spritemap(Assets.OBJECT_PLATFORM_HORIZONTAL, 
				64, 32, null);
		
		public var direction:Boolean = false;
		public var movement:Number = 2;
		public var carry:Array = new Array(Global.SOLID_TYPE, Global.PLAYER_TYPE);
		
		private var playerOnTop_:Boolean = false;
		private var isSad_:Boolean = false;
		private var sadTimer_:Number = 0;
		
		private var distanceTraveled_:int = 0;
		
		
		public function PlatformHorizontal(x:int, y:int) 
		{
			super(x, y);

			graphic = sprite;
			this.type = Global.SOLID_TYPE;
			
			sprite.add("idle", [0, 1, 2], 0.01, true);
			sprite.add("onTop", [3, 4], .08, true);
			sprite.add("sad", [5], 1, true);
			
			setHitbox(64, 32);
		}
		
		
		override public function update():void 
		{
			distanceTraveled_ += 1;
			if (distanceTraveled_ >= MAX_DISTANCE)
			{
				direction = !direction;
				distanceTraveled_ = 0;
			}
			
			// If we've stopped moving, switch directions!
			if (speed_.x == 0) 
			{ 
				direction = !direction;
				distanceTraveled_ = 0;
			}
			
			// Move in the correct direction
			speed_.x = direction ? movement : - movement;
			
			// Move stuff that's on top of us, for each type of entity we can carry
			for each(var i:String in carry) 
			{
				moveontop(i, speed_.x);
			}
			
			// Move ourselves
			motion();
			
			this.checkOnTop();
			
			if (playerOnTop_)
			{
				sprite.play("onTop");
			}
			else if (isSad_)
			{
				sprite.play("sad");
				
				sadTimer_ += FP.elapsed;
				if (sadTimer_ >= SAD_DURATION)
				{
					isSad_ = false;
					sadTimer_ = 0;
				}
			}
			else
			{
				sprite.play("idle");
			}
		}
		
		
		private function checkOnTop():void
		{
			var e:Entity = collide(Global.PLAYER_TYPE, x, y - 1) as Entity;
			if (e)
			{
				playerOnTop_ = true;	
			}
			else
			{
				if (playerOnTop_)
				{
					isSad_ = true;
				}
				
				playerOnTop_ = false;
			}
		}
	}
}
