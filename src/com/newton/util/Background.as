package com.newton.util
{
	import com.greensock.TweenMax;
	
	import com.newton.Assets;
	import com.newton.Global;
	
	import net.flashpunk.graphics.Backdrop;

	
	public class Background extends Backdrop
	{
		public function Background(type:uint = 0)
		{	
			var bg:Class = Assets.TITLE_BG;
			
			super(bg, true, true);
		}
		
		
		override public function update():void
		{	
			super.update();
		}
	}
}