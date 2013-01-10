package punk.transition.effects
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com 
	 */
	public class StarOut extends Star
	{
		public function StarOut(options:Object = null)
		{
			super(options);			
			_scale = 10;
		}
		
		override public function render():void
		{
			super.render();
			_scale += ((FP.timeInFrames ? 1 : FP.elapsed) / _duration) * _distance;			
			if(_scale > _distance)
			{
				_onComplete();
			}
		}
	}
}