package com.newton.entities
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.Particle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 *
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class DoorKey extends Entity
	{
		private static const KEY_WIDTH:uint = 12;
		private static const KEY_HEIGHT:uint = 16;
		
		private var doorKeyImg_:Image = new Image(Assets.COLLECT_KEY);
		
		private var keySnd_:Sfx = new Sfx(Assets.SND_KEY);
		
		
		public function DoorKey(xCoord:int, yCoord:int)
		{
			this.x = xCoord;
			this.y = yCoord;
			
			this.type = Global.DOOR_KEY_TYPE;
			this.graphic = doorKeyImg_; 
			this.setHitbox(KEY_WIDTH, KEY_HEIGHT);
			
			TweenMax.to(doorKeyImg_, 0.3, {y: -5, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}		
		

        override public function update():void
		{	
			super.update();	
		}

        
		public function collect():void
		{				
			world.add(new Particle(x, y, .5, .5, .1, 0xFFCC00));
			world.add(new Particle(x + 5, y + 5, .5, .5, .1, 0xFFCC00));
			world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0xFFCC00));
			
			keySnd_.play(Global.soundVolume);
			
			Global.door.unlockDoor();
			FP.world.remove(this);
		}
	}
}
