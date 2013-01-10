package com.newton.worlds
{	
	import com.newton.Global;
	
	import flash.display.*;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	
	import punk.transition.Transition;
	import punk.transition.effects.*;
	
	
	public class TransitionWorld extends World
	{		
		private var screen_:Image;
		private var display_:Entity;
		
		// What world to transition to and the boolean that ensures we only make one transition call
		private var goto_:Class;
		private var transitioned_:Boolean = false;	
		
		private var transitionType_:uint;
		
		public function TransitionWorld(goto:Class, screen:Image=null, transitionType:uint = 0) 
		{
			// Set the screen to what was last being displayed
			screen_ = screen;
			
			display_ = new Entity(0, 0, screen_);
			this.add(display_);
			
			goto_ = goto;
			transitionType_ = transitionType;
		}
		
		
		override public function update():void
		{
			if (!transitioned_)
			{
				switch (transitionType_)
				{
					case Global.FLIP_SCREEN:
					{
						Transition.to(goto_, 
							new FlipOut({duration:0.75}), 
							new FlipIn({duration:0.75}));
						
						break;
					}
					case Global.CIRCLE:
					{
						Transition.to(goto_, 
							new CircleIn({duration:1}), 
							new CircleOut({duration:0.5})
						);
						
						break;
					}
					case Global.STAR:
					{
						
						break;
					}
					case Global.FADE:
					{
						
						break;
					}						
				}
				
				transitioned_ = true;
			}
			
			super.update();
		}
	}
}
