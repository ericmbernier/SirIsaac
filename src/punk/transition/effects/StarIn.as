package punk.transition.effects
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;

	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class StarIn extends Star
	{
		public function StarIn(options:Object = null)
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