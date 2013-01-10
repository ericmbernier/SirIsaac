package com.newton.entities
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.BannerMessage;
	
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;

		
	/**
	 *
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class Apple extends Entity
	{			
        private const WIDTH:uint = 24;
        private const HEIGHT:uint = 24;
    
		private var image_:Image = new Image(Assets.APPLE);			
		private var appleSnd_:Sfx = new Sfx(Assets.SND_APPLE);		
	

		public function Apple(xCoord:int, yCoord:int)
		{	
			this.x = xCoord;
			this.y = yCoord;
			
			this.type = Global.APPLE_TYPE;	

			this.graphic = image_;
			TweenMax.to(image_, 0.3, {y: -5, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			
			this.setHitbox(WIDTH, HEIGHT);
		}
        
			
		override public function update():void
		{	
			super.update();	
		}

		public function collect():void
		{	
            Global.appleVal += 1;
            
            world.add(new Particle(x, y, .5, .5, .1, 0x8B4513));
            world.add(new Particle(x + 5, y + 5, .5, .5, .1, 0x8B4513));
            world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0x8B4513));
			
			appleSnd_.play(Global.soundVolume);
			FP.world.remove(this);
		}
	}
}
