package punk.transition.effects
{
	import net.flashpunk.FP;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class FadeOut extends Fade
	{
		public function FadeOut(options:Object = null)
		{
			super(options);
			_fade.alpha = 1;
		}

		override public function render():void
		{
			//fade out	
			_fade.alpha -= (FP.timeInFrames ? 1 : FP.elapsed) / _duration;
			
			if (_fade.alpha <= 0)
			{
				_onComplete();
			}
			super.render();		
		}	
	}
}