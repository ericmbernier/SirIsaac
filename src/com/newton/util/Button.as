/***************************************************************************************************
 * Class: Button
 * 
 * Description:
 * 
 ***************************************************************************************************
 */


package com.newton.util
{
	import com.newton.Assets;
	import com.newton.Global;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.utils.Input;
	
	
	/**
	 * 
	 * Courtesy of rolpege on the flashpunk.net forums
	 */
	public class Button extends Entity
	{
		public var callback:Function = null;
		
		private var initialized:Boolean = false;
		
		private var _normal:Graphic = new Graphic;
		private var _hover:Graphic = new Graphic;
		private var _down:Graphic = new Graphic;
		private var _gfx:Graphiclist = new Graphiclist;
		
		private var _normalChanged:Boolean = false;
		private var _hoverChanged:Boolean = false;
		private var _downChanged:Boolean = false;
		
		public var shouldCall:Boolean = true;
		
		
		public function Button(x:Number=0, y:Number=0, width:int=0, height:int=0, 
							   callback:Function=null)
		{
			super(x, y);
			
			setHitbox(width, height);
			
			this.callback = callback;
			graphic = normal;
		}
		
		
		override public function update():void
		{
			if(!initialized)
			{
				if(FP.stage != null)
				{
					FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
			
			super.update();
			
			if(collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				Mouse.cursor = MouseCursor.BUTTON;
				
				if(Input.mousePressed)
				{
					if(graphic != _down || _downChanged)
					{
						graphic = _down;
						_downChanged = false;
					}
				}
				else if(graphic != _hover || _hoverChanged)
				{
					graphic = _hover;
					_hoverChanged = false;
				}
			}
			else if(graphic != _normal || _normalChanged)
			{
				Mouse.cursor = MouseCursor.ARROW;
				graphic = _normal;
				_normalChanged = false;				
			}
		}
		
		
		private function onMouseUp(e:MouseEvent=null):void
		{
			if (!shouldCall || (callback == null)) 
			{
				return;
			}
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) 
			{
				callback();
			}
		}
		
		
		override public function removed():void
		{
			super.removed();
			
			if(FP.stage != null)
			{
				FP.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		
		public function set normal(normal:Graphic):void
		{
			_normal = normal;
			_normalChanged = true;
		}
		
		
		public function set hover(hover:Graphic):void
		{
			_hover = hover;
			_hoverChanged = true;
		}
		
		
		public function set down(down:Graphic):void
		{
			_down = down;
			_downChanged = true;
		}
			
		
		public function get normal():Graphic
		{ 
			return _normal; 
		}
		
		
		public function get hover():Graphic
		{ 
			return _hover; 
		}
		
		
		public function get down():Graphic
		{ 
			return _down; 
		}
	}
}
