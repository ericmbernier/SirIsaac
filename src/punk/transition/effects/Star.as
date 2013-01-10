package punk.transition.effects
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import punk.transition.Transition;
	import punk.transition.util.Drawing;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class Star extends Effect
	{
		protected var _color:uint = 0xFF000000;
		protected var _distance:Number;
		protected var _duration:Number = 1;		
		protected var _graphic:Image;		
		protected var _r:Rectangle;
		protected var _scale:Number;
		protected var _starBm:BitmapData;
		protected var _startX:Number = FP.halfWidth;
		protected var _startY:Number = FP.halfHeight;		
		protected var _tempSprite:Sprite = new Sprite();
		protected var _track:String = "";		
		protected var _offset:Boolean = true;		
				
		public function Star(options:Object = null)
		{
			super();
				
			if (options) {
				if (options.hasOwnProperty("color")) 		_color 		= options.color;
				if (options.hasOwnProperty("duration")) 	_duration 	= options.duration;
				if (options.hasOwnProperty("startX")) 		_startX 	= options.startX;
				if (options.hasOwnProperty("startY")) 		_startY 	= options.startY;
				if (options.hasOwnProperty("track")) 		_track 		= options.track;
				if (options.hasOwnProperty("offset")) 		_offset 	= options.offset;
			}
			
			// Find the longest distance from the start to any corner,
			// used to track if the animation is done
			var distances:Array = [
			FP.distance(_startX, _startY, 0, 0),
				FP.distance(_startX, _startY, FP.width, 0),
				FP.distance(_startX, _startY, FP.width, FP.height),
				FP.distance(_startX, _startY, 0, FP.height)
			];
			distances.sort();
			_distance = distances[distances.length-1];
			
			// Image Data
			_r = new Rectangle(0, 0, FP.width, FP.height);
			_starBm = new BitmapData(FP.width, FP.height, true, 0xFF003300);
			_graphic = new Image(_starBm);			
			graphic = _graphic;			
		}		
		
		override public function render():void
		{
			_tempSprite.graphics.clear();
			
			// Draw Star
			_tempSprite.graphics.beginFill(0xFF0000, 1);
			if(FP.world.hasOwnProperty(_track))
			{
				if(_offset) 
				{
					Drawing.drawStar(_tempSprite.graphics, FP.world[_track].x - FP.camera.x, FP.world[_track].y - FP.camera.y, _scale, _scale*2);
				} 
				else
				{
					Drawing.drawStar(_tempSprite.graphics, FP.world[_track].x, FP.world[_track].y, _scale, _scale*2);					
				}
			}			
			else
			{
				Drawing.drawStar(_tempSprite.graphics, _startX, _startY, _scale, _scale*2);
			}
						
			// Draw bg
			_starBm.fillRect(_r, _color);
			_starBm.draw(_tempSprite, null, null, BlendMode.ERASE);
			_graphic.updateBuffer();
			
			super.render();
		}
	}
}