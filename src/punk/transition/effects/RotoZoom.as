package punk.transition.effects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	/**
	 * RotoZoom effect class.
	 * 
	 * @author azrafe7
	 */
	public class RotoZoom extends Effect 
	{

		protected var _xformInfo:Object = {zoomOut:0, angle:0};	// transformation info used by the tween function
		protected var _rotoZoomImg:Image;
		protected var _rotoZoomBMD:BitmapData;
		protected var _rotoEndAngle:Number;	// rotation ending angle
		protected var _center:Vector3D;
		protected var _rotoZoomBMP:Bitmap;
		protected var _rotoZoomSprite:Sprite;
		protected var _matrix3D:Matrix3D;
		
		protected var _rotoZoomIn:Boolean;	// "direction" of effect

		// options
		protected var _zoomOut:Number = 10000;
		protected var _ease:Function = null;	// null => linear
		protected var _duration:Number = 4;
		protected var _delay:Number = 0;
		protected var _rotoEase:Function = null;	// null => linear
		protected var _rotations:Number = 4;
		protected var _smoothing:Boolean = false;
		

		/**
		 * RotoZoom effect constructor.
		 * @param	rotoZoomIn	If true the image will rotoZoom in. Defaults to false.
		 * @param	options		An object containing key/value pairs of the following optional parameters:
		 * 						duration		Optional number indicating the time (in seconds) the effect will last (approximately). Defaults to 2.
		 * 						ease			Optional easer function. Defaults to linear.
		 * 						delay			Optional number indicating the time (in seconds) the effect must wait before starting (approximately). Defaults to 0.
		 * 						zoomOut			Optional number indicating how far in the z axis the original image must go. Defaults to 10000.
		 * 						rotoEase		Optional rotation easer function. Defaults to linear.
		 * 						rotations		Optional number indicating the number of rotations to apply (can also be negative or zero). Defaults to 4.
		 * 						smoothing		Optional boolean indicating whether smoothing must be used. Defaults to false.
		 * 
		 * Example: new RotoZoom(true, { ease:Ease.expoOut, zoomOut:100000, rotoEase:Ease.cubeOut, rotations:10, smoothing:true });
		 */
		public function RotoZoom(rotoZoomIn:Boolean=false, options:Object=null) 
		{
			super();
			_rotoZoomIn = rotoZoomIn;

			if (options) {
				if (options.hasOwnProperty("duration")) _duration = options.duration;
				if (options.hasOwnProperty("ease")) _ease = options.ease;
				if (options.hasOwnProperty("delay")) _delay = options.delay;
				if (options.hasOwnProperty("zoomOut")) _zoomOut = options.zoomOut;
				if (options.hasOwnProperty("rotoEase")) _rotoEase = options.rotoEase;
				if (options.hasOwnProperty("rotations")) _rotations = options.rotations;
				if (options.hasOwnProperty("smoothing")) _smoothing = options.smoothing;
			}
			
			_rotoZoomBMD = new BitmapData(FP.width, FP.height, false, 0);
			_rotoZoomSprite = new Sprite;
			_rotoZoomBMP = new Bitmap(_rotoZoomBMD, "auto", _smoothing);
			_rotoZoomSprite.addChild(_rotoZoomBMP);
			_matrix3D = new Matrix3D;
			_rotoZoomBMP.transform.matrix3D = _matrix3D;
			
			// assign starting/ending rotation angle and scale
			var sign:Number = (_rotoZoomIn ? -1 : 1);
			_xformInfo.zoomOut = (_rotoZoomIn ? _zoomOut : 1);
			_xformInfo.angle = 0;
			_rotoEndAngle = sign * _rotations * 360;
			_center = new Vector3D(FP.halfWidth, FP.halfHeight);
		}
		
		// called once the effect gets added to the world
		override public function added():void 
		{
			super.added();

			var tween1Options:Object = { ease:_ease, complete:_onComplete };
			var tween2Options:Object = { ease:_rotoEase };
			if (_delay > 0) tween1Options.delay = tween2Options.delay = _delay;
			
			FP.tween(_xformInfo, { zoomOut: _rotoZoomIn ? 0 : _zoomOut }, _duration, tween1Options);
			FP.tween(_xformInfo, { angle: _rotoEndAngle }, _duration, tween2Options);
		}
		
		override public function render():void 
		{
			_rotoZoomBMD.copyPixels(FP.buffer, FP.buffer.rect, FP.zero);			// copy FP buffer
			_matrix3D.identity();													// reset transform matrix
			_matrix3D.prependRotation(_xformInfo.angle, Vector3D.Z_AXIS, _center);	// apply rotation
			_matrix3D.appendTranslation(0, 0, _xformInfo.zoomOut);					// apply z-translation
			FP.buffer.fillRect(FP.buffer.rect, FP.screen.color);					// clear FP.buffer
			FP.buffer.draw(_rotoZoomSprite);										// draw to FP.buffer
		}
	}

}