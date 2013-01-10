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
		
		private var sprite:Spritemap = new Spritemap(Assets.ROOT_BEER_METER, 350, 22, null);
		private var text:Text = new Text("SODA METER", 0, 0, {size:18, 
			outlineColor:0x000000, outlineStrength:3});
		
		private var meterValue_:int = EMPTY;
		private var meterType_:int = Global.ROOT_BEER_METER;
		
		private var gotFizz_:Boolean = false;
		
		private var gfxList_:Graphiclist;
		
		
		public function AppleMeter(type:int = ROOT_BEER_DEFAULT)
		{
			meterType_ = type;
			
			if (meterType_ == Global.ROOT_BEER_METER)
			{
				sprite.add("empty", [0], 0.1, true);
				sprite.add("oneSoda", [1, 2, 3], 0.05, true);
				sprite.add("twoSodas", [4, 5, 6], 0.05, true);
				sprite.add("threeSodas", [7, 8, 9], 0.05, true);
				sprite.add("full", [10, 11, 12, 12, 10, 11], 0.02, true);
			}
			else
			{
				sprite = new Spritemap(Assets.FIZZY_METER, 350, 22, null);
				sprite.add("empty", [0], 0.1, true);
				sprite.add("oneSoda", [1, 2, 3], 0.05, true);
				sprite.add("twoSodas", [4, 5, 6], 0.05, true);
				sprite.add("full", [7, 8, 9, 9, 7, 8], 0.02, true);     
				
				this.visible = false;
			}
			
			this.x = 210;
			this.y = 5;
			
			sprite.play("empty");
			
			text.x -= 112;
			
			gfxList_ = new Graphiclist(sprite, text);
			gfxList_.x = 215;
			this.graphic = gfxList_;
		}
		
		
		override public function update():void
		{
			if (meterType_ == Global.ROOT_BEER_METER)
			{
				if (Global.rootBeerVal == EMPTY)
				{
					sprite.play("empty");
				}
				else if (Global.rootBeerVal == ONE_SODA)
				{
					sprite.play("oneSoda");
				}
				else if (Global.rootBeerVal == TWO_SODAS)
				{
					sprite.play("twoSodas");
				}
				else if (Global.rootBeerVal == THREE_SODAS)
				{
					sprite.play("threeSodas");
				}
				else if (Global.rootBeerVal == FULL_ROOT_BEER)
				{
					sprite.play("full");
				}            
			}
			else
			{
				this.visible = true;
				
				if (Global.fizzyVal == EMPTY)
				{
					if (meterType_ == Global.FIZZY_METER)
					{
						gotFizz_ = false;
						FP.world.remove(Global.fizzyMeter);
					}
					else
					{
						sprite.play("empty");
					}
				}
				else if (Global.fizzyVal == ONE_SODA)
				{
					sprite.play("oneSoda");
				}
				else if (Global.fizzyVal == TWO_SODAS)
				{
					sprite.play("twoSodas");
				}
				else if (Global.fizzyVal == FULL_FIZZY)
				{
					sprite.play("full");
				}
			}
		}
		
		
		public function fillMeter():void
		{
			if (meterType_ == Global.ROOT_BEER_METER)
			{
				meterValue_ = Global.ROOT_BEER_MAX;
			}
			else
			{
				meterValue_ = Global.FIZZY_MAX;
			}
		}
		
		
		public function makeRootBeer():void
		{	
			sprite = new Spritemap(Assets.ROOT_BEER_METER, 350, 22, null);
			
			sprite.add("empty", [0], 0.1, true);
			sprite.add("oneSoda", [1, 2, 3], 0.05, true);
			sprite.add("twoSodas", [4, 5, 6], 0.05, true);
			sprite.add("threeSodas", [4, 5, 6], 0.05, true);
			sprite.add("full", [7, 8, 9, 9, 7, 8], 0.02, true);
			
			gfxList_ = new Graphiclist(sprite, text);
			gfxList_.x = 215;
			this.graphic = gfxList_;
		}
		
		
		public function makeFizzy():void
		{
			sprite = new Spritemap(Assets.FIZZY_METER, 350, 22, null);
			sprite.add("empty", [0], 0.1, true);
			sprite.add("oneSoda", [1, 2, 3], 0.05, true);
			sprite.add("twoSodas", [4, 5, 6], 0.05, true);
			sprite.add("full", [7, 8, 9, 9, 7, 8], 0.02, true);
			
			gfxList_ = new Graphiclist(sprite, text);
			gfxList_.x = 215;
			this.graphic = gfxList_;
		}
		
		
		public function setFizz(gotFizz:Boolean):void
		{
			gotFizz_ = gotFizz;
		}
		
		
		public function gotFizz():Boolean
		{
			return gotFizz_;
		}
	}
}
