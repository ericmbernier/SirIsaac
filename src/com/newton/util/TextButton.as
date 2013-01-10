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
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	
	public class TextButton extends Entity
	{
		public var callback:Function = null;
		
		private var initialized:Boolean = false;
		
		private var _normal:Text;
		private var _hover:Text;
		private var _down:Graphic = new Graphic;
		private var _bg:Graphic = new Graphic;
		private var _gfx:Graphiclist = new Graphiclist;
		
		private var _normalChanged:Boolean = false;
		private var _hoverChanged:Boolean = false;
		private var _downChanged:Boolean = false;
		
		public var shouldCall:Boolean = true;
		
		private var rollOverSnd_:Sfx;
		private var playRollOverSnd_:Boolean = false;

		private var selectSnd_:Sfx;
		private var playSelectSnd_:Boolean = false;
		
		private var width_:Number = 0;
		private var height_:Number = 0;
		
		private var colors:Array = [0xef1754, 0xefec17, 0x27ef17, 0x38cef9, 0x96a0ff, 0xff53f1];
		private var index:int = 1;
		private var lastColor:uint = colors[0];
		private var time:Number = 2;
		private var elapsed:Number = 0;
		private var tf:ColorTransform = new ColorTransform();
		private var rate:Number = 1;
		
		public var changeColor_:Boolean = true;
		public var hasBg_:Boolean = false;
		
		
		public function TextButton(text:Text, x:Number=0, y:Number=0, width:int=0, height:int=0, 
							   callback:Function=null)
		{
			super(x, y);
			
			width_ = width;
			height_ = height;
			setHitbox(width_, height_);
			
			this.callback = callback;
			
			_normal = text;
			graphic = _normal;
		}
		
		
		override public function update():void
		{
			if (!initialized)
			{
				if (FP.stage != null)
				{
					FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
			
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
					if (hasBg_)
					{						
						_normal.size = Global.TEXT_BTN_HOVER;
						_gfx = new Graphiclist(_bg, _normal);
						graphic = _gfx;
					}
					else
					{
						graphic = _hover;
						_hover.size = Global.TEXT_BTN_HOVER;
						_hover.visible = true;
						_normal.visible = false;
					}
					
					if (playRollOverSnd_)
					{
						rollOverSnd_.play(Global.soundVolume);
						playRollOverSnd_ = false;
					}
					
					_hoverChanged = false;					
				}
			}
			else if(graphic != _normal || _normalChanged)
			{
				Mouse.cursor = MouseCursor.ARROW;
				
				_normal.size = Global.TEXT_BTN_NORMAL;
				_normal.visible = true;

				if (!hasBg_)
				{
					_hover.visible = false;
					_hover.size = Global.TEXT_BTN_NORMAL;
				}
				
				graphic = _normal;
				_normalChanged = false;
				
				if (rollOverSnd_ != null)
				{
					playRollOverSnd_ = true;
				}
			}
			
			elapsed += FP.elapsed * rate;
			if (elapsed >= time)
			{
				elapsed -= time;
				lastColor = colors[index];
				index = (index + 1) % colors.length;
			}
			
			super.update();
		}
		
		
		override public function render():void
		{
			super.render();
			
			if (changeColor_ && !hasBg_)
			{
				var color:uint = FP.colorLerp(lastColor, colors[index], elapsed / time);
				tf.redMultiplier = Number(color >> 16 & 0xFF) / 255;
				tf.greenMultiplier = Number(color >> 8 & 0xFF) / 255;
				tf.blueMultiplier = Number(color & 0xFF) / 255;
				
				_hover.color = color;
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
				if (playSelectSnd_)
				{
					selectSnd_.play(Global.soundVolume);	
				}
				
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
		
		
		public function set normal(normal:Text):void
		{
			_normal = normal;
			_normalChanged = true;
		}
		
		
		public function set hover(hover:Text):void
		{
			_hover = hover;
			_hoverChanged = true;
		}
		
		
		public function set down(down:Graphic):void
		{
			_down = down;
			_downChanged = true;
		}
		
		
		public function set bg(bg:Graphic):void
		{
			_bg = bg;
		}
		
		
		public function setRollOverSound(sound:Sfx):void
		{
			rollOverSnd_ = sound;
			playRollOverSnd_ = true;
		}

		
		public function setSelectSound(sound:Sfx):void
		{
			selectSnd_ = sound;
			playSelectSnd_ = true;
		}
		
		
		public function get normal():Text
		{ 
			return _normal; 
		}
		
		
		public function get hover():Text
		{ 
			return _hover; 
		}
		
		
		public function get down():Graphic
		{ 
			return _down; 
		}
		
		
		public function get bg():Graphic
		{
			return _bg;
		}
	}
}

