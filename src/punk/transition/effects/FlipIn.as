package punk.transition.effects 
{
	/**
	 * FlipIn effect class. Shorthand for Flip(true, Flip.RIGHT, options).
	 * 
	 * @author azrafe7
	 */
	public class FlipIn extends Flip 
	{
		
		public function FlipIn(options:Object=null) 
		{
			super(true, options);
		}
		
	}

}