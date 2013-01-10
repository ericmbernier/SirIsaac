package punk.transition.effects 
{
	/**
	 * StripeFadeIn effect class. Shorthand for StripeFade(true, RIGHT, options).
	 * 
	 * @author azrafe7
	 */
	public class StripeFadeIn extends StripeFade 
	{
		
		public function StripeFadeIn(options:Object=null) 
		{
			super(true, options);
		}
		
	}

}