package punk.transition.effects
{
	import net.flashpunk.FP;
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class FadeIn extends Fade
	{
		public function FadeIn(options:Object = null)
		{
			super(options);
			_fade.alpha = 0;
		}
		
		override public function render():void
		{
			//fade out			
			_fade.alpha += (FP.timeInFrames ? 1 : FP.elapsed) / _duration;
			
			if (_fade.alpha >= 1)
			{
				_onComplete();
			}
			super.render();		
		}	
	}
}