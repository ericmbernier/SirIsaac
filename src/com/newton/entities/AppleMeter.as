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
		private static const EMPTY:uint = 0;
		private static const ONE_APPLE:uint = 1;
		private static const TWO_APPLES:uint = 2;
		private static const THREE_APPLES:uint = 3;
		private static const FOUR_APPLES:uint = 4;
		private static const WIDTH:int = 350;
		private static const HEIGHT:int = 22;
		private static const APPLE_WIDTH:int = 30;
		
		private var text:Text = new Text("Apples", 0, 0, {size:18, 
			outlineColor:0x000000, outlineStrength:3, font:"Essays"});
		private static const sprite:Spritemap = new Spritemap(Assets.APPLE_METER, 80, 20, null);		
		private var meterValue_:int = 0;		
		private var gfxList_:Graphiclist;
		
		
		public function AppleMeter()
		{
			this.x = 10;
			this.y = 5;	
			
			sprite.add("empty", [0], 1, false);
			sprite.add("oneApple", [1], 1, false);
			sprite.add("twoApples", [2], 1, false);
			sprite.add("threeApples", [3], 1, false);
			sprite.add("fourApples", [4], 1, false);
			
			gfxList_ = new Graphiclist(text, sprite);
			gfxList_.x = 10;
			this.graphic = gfxList_;            
		}
		
		
		override public function update():void
		{
			if (Global.appleVal == EMPTY)
			{
				sprite.play("empty");
			}
			else if (Global.appleVal == ONE_APPLE)
			{
				sprite.play("oneApple");
			}
			else if (Global.appleVal == TWO_APPLES)
			{
				sprite.play("twoApples");
			}
			else if (Global.appleVal == THREE_APPLES)
			{
				sprite.play("threeApples");			
			}
			else if (Global.appleVal == FOUR_APPLES)
			{
				sprite.play("fourApples");
			}
		}	
	}
}
