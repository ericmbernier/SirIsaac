package com.newton.entities
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	
	public class DirectionSign extends Entity
	{
		private const WIDTH:uint = 24;
		private const HEIGHT:uint = 40;
		private const SMALL:uint = 1;
		private const MEDIUM:uint = 2;
		private const LARGE:uint = 3;
		private const DEFAULT_X:uint = 55;
		private const DEFAULT_Y:uint = 10;
		
		private var image_:Image = new Image(Assets.DIR_SIGN);
		private var directions_:Directions;
		private var dirTxt_:String;
		private var showingDirs_:Boolean = false;
		
		public function DirectionSign(xCoord:int, yCoord:int, text:String, size:int=MEDIUM)
		{
			x = xCoord;
			y = yCoord;
			super(x, y + 2);
			
			type = Global.DIRECTION_SIGN_TYPE;
			
			dirTxt_ = text;
			
			this.graphic = image_;
			setHitbox(WIDTH, HEIGHT);
		}
		
		
		override public function update():void
		{
			if (this.collide(Global.PLAYER_TYPE, x, y))
			{
				if (!showingDirs_)
				{
					showDirections();
				}
			}
			else if (showingDirs_)
			{
				showingDirs_ = false;
				
				var fromY:int = directions_.y;
				directions_.y = -105;
				
				TweenMax.from(directions_, 0.08, {y: fromY, ease:Quad.easeOut, delay:0, onComplete:removeDirs});
			}
		}
		
		
		private function showDirections():void
		{
			var xCoord:int = DEFAULT_X;
			var xOffset:int = Global.view.x;
			if (xOffset > 0)
			{
				xCoord += xOffset;
			}
			
			directions_ = new Directions(DEFAULT_X, DEFAULT_Y, dirTxt_);
			TweenMax.from(directions_, 0.50, {y: -105, ease:Quad.easeOut, delay:0, onComplete:null});
			
			FP.world.add(directions_);
			
			showingDirs_ = true;
		}
		
		
		private function removeDirs():void
		{
			FP.world.remove(directions_);
		}
	}
}