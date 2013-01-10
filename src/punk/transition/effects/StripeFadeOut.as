package punk.transition.effects 
{
	/**
	 * StripeFadeOut effect class. Shorthand for StripeFade(false, LEFT, options).
	 * 
	 * @author azrafe7
	 */
	public class StripeFadeOut extends StripeFade 
	{
		
		public function StripeFadeOut(options:Object=null) 
		{
			super(false, options);
		}
		
	}

}