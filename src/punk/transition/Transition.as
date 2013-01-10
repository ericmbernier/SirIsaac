package punk.transition
{
	import flash.ui.Mouse;
	import punk.transition.effects.*;
	import flash.display.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * @author GIT:		cjke 
	 * @author Mail:	cjke.7777@gmail.com
	 */
	public class Transition
	{
		// == Private Static Variables == //
		private static var _in:Effect;
		private static var _inWorldClass:*;
		private static var _inWorld:World;		
		private static var _out:Effect;
		private static var _outWorld:World;		
		private static var _onOutComplete:Function = null;
		private static var _onInComplete:Function = null;
		
		public function Transition()
		{
			
		}
		
		/**
		 * Transition to the next world using an out effect and in effect
		 * @param	inWorld Can be class or the world itself
		 * @param	outEffect
		 * @param	inEffect
		 */
		public static function to(inWorld:*, outEffect:Effect, inEffect:Effect, options:Object = null):void
		{
			// Link worlds
			_outWorld = FP.world;
			_inWorldClass = inWorld;
			
			// Options
			if (options) 
			{
				if (options.hasOwnProperty("onOutComplete")) _onOutComplete = options.onOutComplete;
				if (options.hasOwnProperty("onInComplete")) _onInComplete = options.onInComplete;
			}
			
			// Create out effects
			_out = outEffect;			
			_out.onComplete = onOut;
			_out.active = true; // all effects are inactive by default
			
			// Prepare in effects
			_in = inEffect;
			_in.onComplete = onIn;
			
			_outWorld.add(_out);
		}
		
		/**
		 * Called when the out effect is done
		 */
		private static function onOut():void 
		{
			// Remove the old effect from the world
			_outWorld.remove(_out);
			_out.active = false;
			
			// Set new world
			if(_inWorldClass is Class)
			{
				_inWorld = new _inWorldClass() as World;
				FP.world = _inWorld;
			}
			else if(_inWorldClass is World)
			{
				FP.world = _inWorld = _inWorldClass;
			}
			
			if(_onOutComplete != null) _onOutComplete();
						
			// Turn on in effect
			_in.active = true;
			
			if(_inWorld) 
			{
				_inWorld.add(_in);
			}
			else
			{
				FP.world.add(_in);
			}
		}
		
		/**
		 * Called when the in effect is done
		 */
		private static function onIn():void
		{
			if(_onInComplete != null) _onInComplete();
			
			FP.world.remove(_in);
			_in.active = false;
		}
	}
}
