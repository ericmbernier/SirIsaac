package punk.transition.effects
{
	import net.flashpunk.FP;
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class CircleIn extends Circle
	{
		public function CircleIn(options:Object = null)
		{
			super(options);			
			_scale = _distance;	
		}
		
		override public function render():void
		{
			super.render();	
			_scale -= ((FP.timeInFrames ? 1 : FP.elapsed) / _duration) * _distance;					
			if(_scale < 0)
			{
				_onComplete();
			}	
		}	
	}
}