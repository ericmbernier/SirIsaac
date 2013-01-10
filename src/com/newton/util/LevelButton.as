/***************************************************************************************************
 * Class: LevelButton
 * 
 * Description:
 * 
 ***************************************************************************************************
 */


package com.newton.util
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.worlds.GameWorld;
	import com.newton.worlds.TransitionWorld;
	
	import flash.events.MouseEvent;
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
	
	
	public class LevelButton extends Entity
	{	
		private var initialized:Boolean = false;
		
		private var _normal:Text;
		private var _hover:Graphic = new Graphic;
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
		
		private var levelNum_:int = 0;
		private var levelTxt_:Text;
		private var levelString_:String;
		private var bobUp_:Boolean = true;
		
		
		public function LevelButton(levelNum:int, x:Number=0, y:Number=0, width:int=0, height:int=0, 
				bobUp:Boolean = true)
		{
			super(x, y);
			
			bobUp_ = bobUp;
			width_ = width;
			height_ = height;
			
			if (levelNum > 0)
			{
				levelNum_ = levelNum;
				levelString_ = levelNum_.toString();
				setHitbox(width_, height_);
			}
			else
			{
				levelString_ = "?";
				this.setHitbox(0, 0);
			}
						
			levelTxt_ = new Text(levelString_);
			levelTxt_.size = Global.TEXT_BTN_NORMAL;
			
			_normal = levelTxt_;
			graphic = _normal;
			
			if (bobUp_)
			{
				this.bobUp();
				this.bobImgUp();
			}
			else
			{
				this.bobDown();
				this.bobImgDown();
			}
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
					if (bg != null)
					{						
						_normal.size = Global.TEXT_BTN_HOVER;
						_gfx = new Graphiclist(_bg, _normal);
						graphic = _gfx;
					}
					else
					{
						graphic = _hover;
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
				graphic = _normal;
				_normalChanged = false;
				
				if (rollOverSnd_ != null)
				{
					playRollOverSnd_ = true;
				}
			}
			
			super.update();
		}
		
		
		private function onMouseUp(e:MouseEvent=null):void
		{
			if (!shouldCall) 
			{
				return;
			}
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) 
			{
				if (playSelectSnd_)
				{
					selectSnd_.play(Global.soundVolume);	
				}
				
				if (levelNum_ > 0)
				{
					//------------------------------------------------------------------------------
					// Load the selected level, subtracting one to account for the nextLevel call
					// in our GameWorld class
					//------------------------------------------------------------------------------
					Global.level = levelNum_ - 1;
					FP.world.removeAll();
					FP.world = new TransitionWorld(GameWorld);
				}
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
		
		
		public function get hover():Graphic
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
		
		
		private function bobUp():void
		{
			TweenMax.to(levelTxt_, 0.4, {y: -6, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function bobDown():void
		{
			TweenMax.to(levelTxt_, 0.4, {y: +6, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function bobImgUp():void
		{
			TweenMax.to(_bg, 0.4, {y: -6, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
		
		
		private function bobImgDown():void
		{
			TweenMax.to(_bg, 0.4, {y: +6, repeat: -1, yoyo:true, ease:Quad.easeInOut});
		}
	}
}
