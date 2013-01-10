package punk.transition.effects
{
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class Fade extends Effect
	{
		protected var _color:uint = 0xFF000000;
		protected var _duration:Number = 1;
		protected var _fade:Image;
		
		public function Fade(options:Object = null)
		{
			super();
			
			if (options) {
				if (options.hasOwnProperty("color")) 		_color 		= options.color;
				if (options.hasOwnProperty("duration")) 	_duration 	= options.duration;
			}
			
			var bm:BitmapData = new BitmapData(FP.width, FP.height, false, _color);
			_fade = new Image(bm);
			graphic = _fade;
		}
	}
}