package punk.transition.effects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	/**
	 * Flip effect class.
	 * 
	 * @author azrafe7
	 */
	public class Flip extends Effect 
	{

		protected var _flipInfo:Object = {angle:0};	// flip info used by the tween function
		protected var _flipEndAngle:Number;	// ending flip angle
		protected var _flipCenter:Vector3D;
		protected var _flipAxis:Vector3D;	// flip axis
		protected var _flippedBMD:BitmapData;
		protected var _flippedBMP:Bitmap;
		protected var _flippedSprite:Sprite;
		protected var _matrix3D:Matrix3D;
		
		// main options
		protected var _flipIn:Boolean;	// "direction" of effect
		protected var _flipDir:int = Flip.RIGHT;	// side to flip
		
		// extra options
		protected var _ease:Function = null;	// null => linear
		protected var _duration:Number = 2;
		protected var _delay:Number = 0;
		protected var _smoothing:Boolean = false;
		
		// flip direction constants
		public static const LEFT:int = 0;
		public static const DOWN:int = 1;
		public static const RIGHT:int = 2;
		public static const UP:int = 3;

		
		/**
		 * Flip effect constructor.
		 * @param	flipIn		If true the image will flip in. Defaults to false.
		 * @param	flipDir		In which direction the image will flip. Possible values are Flip.LEFT, Flip.UP, Flip.RIGHT, Flip.DOWN. Defaults to Flip.RIGHT.
		 * @param	options		An object containing key/value pairs of the following optional parameters:
		 * 						duration		Optional number indicating the time (in seconds) the effect will last (approximately). Defaults to 2.
		 * 						ease			Optional easer function. Defaults to linear.
		 * 						delay			Optional number indicating the time (in seconds) the effect must wait before starting (approximately). Defaults to 0.
		 * 						smoothing		Optional boolean indicating whether smoothing must be used. Defaults to false.
		 * 
		 * Example: new Flip(true, Flip.DOWN, { ease:Ease.backIn, duration:3.2, smoothing:true });
		 */
		public function Flip(flipIn:Boolean=false, options:Object=null) 
		{
			super(false);
			_flipIn = flipIn;

			if (options) {
				if (options.hasOwnProperty("duration")) _duration = options.duration;
				if (options.hasOwnProperty("flipDir")) _flipDir = options.flipDir;
				if (options.hasOwnProperty("ease")) _ease = options.ease;
				if (options.hasOwnProperty("delay")) _delay = options.delay;
				if (options.hasOwnProperty("smoothing")) _smoothing = options.smoothing;
			}
			
			_flippedBMD = new BitmapData(FP.width, FP.height, false, 0);
			_flippedSprite = new Sprite;
			_flippedBMP = new Bitmap(_flippedBMD, "auto", _smoothing);
			_flippedSprite.addChild(_flippedBMP);
			_matrix3D = new Matrix3D;
			_flippedBMP.transform.matrix3D = _matrix3D;
			
			// assign starting/ending rotation angle and axis
			_flipAxis = (_flipDir % 2 == 0 ? Vector3D.Y_AXIS : Vector3D.X_AXIS);
			var sign:Number = (_flipDir >= 2 ? 1 : -1);
			_flipInfo.angle = sign * (_flipIn ? 90 : 0);
			_flipEndAngle = sign * (_flipInfo.angle - 90);
			_flipCenter = new Vector3D(FP.halfWidth, FP.halfHeight);
		}
		
		// called once the effect gets added to the world
		override public function added():void 
		{
			super.added();

			var tweenOptions:Object = { ease:_ease, complete:_onComplete };
			if (_delay > 0) tweenOptions.delay = _delay;
			
			FP.tween(_flipInfo, { angle: _flipEndAngle }, _duration, tweenOptions);
		}
		
		override public function render():void 
		{
			_flippedBMD.copyPixels(FP.buffer, FP.buffer.rect, FP.zero);			// copy FP buffer
			_matrix3D.identity();												// reset transform matrix
			_matrix3D.prependRotation(_flipInfo.angle, _flipAxis, _flipCenter);	// apply transform matrix
			FP.buffer.fillRect(FP.buffer.rect, FP.screen.color);				// clear FP.buffer
			FP.buffer.draw(_flippedSprite);										// draw to FP.buffer
		}
	}

}