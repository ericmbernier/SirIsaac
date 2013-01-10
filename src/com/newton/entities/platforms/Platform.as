package com.newton.entities.platforms
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Physics;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class Platform extends Physics
	{
		private var SAD_DURATION:Number = 1.5;
		
		private var sprite:Spritemap = new Spritemap(Assets.OBJECT_PLATFORM_NORMAL, 32, 32, null);
		
		private var playerOnTop_:Boolean = false;
		private var isSad_:Boolean = false;
		private var sadTimer_:Number = 0;
		
		
		public function Platform(x:int, y:int) 
		{
			super(x, y);
			
			graphic = sprite;
			this.type = Global.SOLID_TYPE;
			
			sprite.add("idle", [0], 1, true);
			sprite.add("onTop", [2, 3], .08, true);
			sprite.add("sad", [4], 1, true);
			
			setHitbox(32, 32);
		}
		
		
		override public function update():void
		{
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
