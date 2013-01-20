package com.newton.effects
{
	import com.newton.Assets;
	import com.newton.Global;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	
	public class Blur extends Entity 
	{	
		private const WIDTH:uint = 32;
		private const DASH:uint = 0;
		private const ICE_WIDTH:int = 24;
		private const ICE_HEIGHT:int = 12;
		private const HEAT_HEIGHT:int = 4;
		
		public var image:Image = new Image(Assets.EFFECTS_DASH_BLUR);
		
		
		public function Blur(xCoord:int, yCoord:int, right:Boolean, type:int = 0)
		{
			image.alpha = 0.75;
			image.scale = 1;
			
			this.x = xCoord;
			this.y = yCoord;
			
			if (!right)
			{
				image.flipped = true;
				this.x = x + WIDTH;
			}
			
			graphic = image;
			image.originX = image.width / 2;
			image.originY = image.height;
		}
		
		
		override public function update():void 
		{
			image.scale -= FP.elapsed * 2;
			image.alpha -= FP.elapsed * 3;
			
			if (image.alpha <= 0)
			{
				world.recycle(this);
			}
		}
	}
}
