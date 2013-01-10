package com.newton
{
	import com.newton.worlds.TitleWorld;
	import com.newton.worlds.TransitionWorld;
	
	import flash.display.MovieClip;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	
	[SWF(width='640', height='480', scale='exactfit')]
	
	
	/** 
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class Main extends Engine
	{
		private const WIDTH:int = 640;
		private const HEIGHT:int = 480;
		private const FPS:int = 60;
		
		
		public function Main():void 
		{
			super(WIDTH, HEIGHT, FPS, false);
			
			FP.console.enable();
		}
		

		/*******************************************************************************************
		 * 
		 * 
		 * 
		 ******************************************************************************************/
		override public function init():void
		{
			if (this.checkDomain("ericbernier.com"))
			{	
				// TODO: Make a title buffer as FP.buffer is blank here it seems
				// var screen:Image = new Image(Assets.TITLE_BUFFER);
				var screen:Image = new Image(FP.buffer);
				FP.world = new TransitionWorld(TitleWorld, screen);
				super.init();
			}
			else
			{
				FP.world.addGraphic(new Text("INVALID DOMAIN! GAME OVER!", 200, 200, null));
			}
		}
		
		
		/*******************************************************************************************
		 * 
		 *
		 * 
		 ******************************************************************************************/
		override public function update():void
		{
			super.update();
		}
		
		
		/*******************************************************************************************
		 * 
		 *
		 * 
		 ******************************************************************************************/
		public function checkDomain (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;
			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') 
			{
				return true;
			}
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) 
				{
					return true;
				}
			}
			
			return false;
		}
	}
}
