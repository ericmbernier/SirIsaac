package punk.transition.effects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class Effect extends Entity 
	{
		private var _cameraTracking:Boolean;
		protected var _onComplete:Function;
				
		public function Effect(cameraTracking:Boolean = true) 
		{			
			super();
			layer = -1;
			_cameraTracking = cameraTracking;
			
			// Pause until transition manager tells it to get moving
			active = false;
		}
		
		override public function render():void 
		{
			if(_cameraTracking)
			{
				x = FP.camera.x;
				y = FP.camera.y;
			}
			super.render();
		}
		
		public function get onComplete():Function 
		{
			return _onComplete;
		}
		
		public function set onComplete(value:Function):void 
		{
			_onComplete = value;
		}		
	}
}