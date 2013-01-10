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
			var bg:Class = Assets.BLUE_LINES;
		
			if (type == Global.TV_SCAN)
			{
				bg = Assets.TV_SCAN;
			}
			else if (type == Global.CHECKERS)
			{
				bg = Assets.BLUE_CHECKERS;
			}
			
			super(bg, true, true);
		}
		
		
		
		
		override public function update():void
		{	
			super.update();
		}
	}
}