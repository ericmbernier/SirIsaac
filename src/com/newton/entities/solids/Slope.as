package com.newton.entities.solids 
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.entities.solids.Solid;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	
	
	public class Slope extends Solid
	{
		public var slopeMask:Pixelmask
		
		public function Slope(x:int, y:int, type:int) 
		{
			super(x, y, 0, 0);
			
			var slope:Class;
			switch(type) 
			{
				case 0: 
				{
					slope = Assets.TILESET_SLOPE_1; 
					break;
				}
				case 1: 
				{
					slope = Assets.TILESET_SLOPE_2; 
					break;
				}
				case 2: 
				{
					slope = Assets.TILESET_SLOPE_3; 
					break;
				}
				case 3: 
				{
					slope = Assets.TILESET_SLOPE_4; 
					break;
				}
			}
			
			slopeMask = new Pixelmask(slope, 0, 0);
			mask = slopeMask;
			
			// Hide us - we don't need to ever be updated
			active = false;
			visible = false;
		}
	}
}
