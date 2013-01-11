package com.newton.entities
{
	import com.newton.Assets;
	import com.newton.Global;
	
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	
	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class AppleMeter extends Entity
	{
		private static const WIDTH:int = 350;
		private static const HEIGHT:int = 22;
		private static const EMPTY:int = 0;
		private static const ONE_SODA:int = 1;
		private static const TWO_SODAS:int = 2;
		private static const THREE_SODAS:int = 3;
		private static const FULL_ROOT_BEER:int = 4;
		private static const FULL_FIZZY:int = 3;
		private static const ROOT_BEER_DEFAULT:int = 1;

		private var text:Text = new Text("Apples", 0, 0, {size:18, 
			outlineColor:0x000000, outlineStrength:3, font:"Essays"});
		
		private var meterValue_:int = EMPTY;
		
		private var gotFizz_:Boolean = false;
		
		private var gfxList_:Graphiclist;
		
		
		public function AppleMeter()
		{
			this.x = 210;
			this.y = 5;
	
			text.x -= 112;
			
			gfxList_ = new Graphiclist(text);
			gfxList_.x = 215;
			this.graphic = gfxList_;
		}
		
		
		override public function update():void
		{
			if (Global.appleVal == EMPTY)
			{
				
			}
			else if (Global.appleVal == ONE_SODA)
			{
			
			}
			else if (Global.appleVal == TWO_SODAS)
			{
			
			}
			else if (Global.appleVal == THREE_SODAS)
			{
			
			}
			else if (Global.appleVal == FULL_ROOT_BEER)
			{
			
			}
		}
		
		
		public function addApple():void
		{
			meterValue_ += 1
		}
	}
}
