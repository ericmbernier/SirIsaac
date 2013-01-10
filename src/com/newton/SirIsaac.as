package com.newton
{	
	import Playtomic.*;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	[SWF(width='640', height='480', scale='exactfit')]
	
	
	/**
	 *
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class SirIsaac extends Sprite
	{
		private static const mainClassName: String = "com.cbc.Main";
		
		private static const WIDTH:uint = 640;
		private static const HEIGHT:uint = 480;
		
		private static const BG_COLOR:uint = 0x000000;
		private static const PB_COLOR:uint = 0xF7EAE8;
		private static const FG_COLOR:uint = 0xFFFFFF;
		private static const TXT_COLOR:uint = 0xCCCCCC;
		
		private static const PROGRESS_BAR_WIDTH:uint = 367;
		private static const PROGRESS_BAR_HEIGHT:uint = 17;
		private static const PROG_BAR_X:uint = 134;
		
		[Embed(source = 'assets/fonts/Essays1743.ttf', embedAsCFF="false", fontFamily = 'Essays')]
		private static const FONT:Class;
		
		// TODO: Update these!
		[Embed("assets/graphics/preloaderBg.png")] private var bgPattern:Class;
		private var bgImg_:Bitmap = new bgPattern;
		[Embed("assets/graphics/titleLogo.png")] private var logo:Class;
		private var logo_:Bitmap = new logo;	
		
		// Embed the social media icons 
		[Embed("assets/graphics/ebLogo.png")] private var ebLogo:Class;
		private var ebLogo_:Bitmap = new ebLogo;
		
		[Embed("assets/graphics/twitter.png")] private var twitter:Class;
		private var twitter_:Bitmap = new twitter;
		
		[Embed("assets/graphics/facebook.png")] private var facebook:Class;
		private var facebook_:Bitmap = new facebook;
		
		[Embed("assets/graphics/youtube.png")] private var youtube:Class;
		private var youtube_:Bitmap = new youtube;
		
		[Embed("assets/graphics/googleplus.png")] private var googleplus:Class;
		private var googleplus_:Bitmap = new googleplus;
		
		[Embed("assets/graphics/playButton.png")] private var playBtn:Class;
		private var playBtn_:Bitmap = new playBtn;
		private var playBtnClip_:MovieClip = new MovieClip();
		
		private var progressBar:Shape;
		private var progressBarBg:Shape;
		private var px:int;
		private var py:int;
		private var w:int
		private var h:int;
		private var sw:int;
		private var sh:int;
		private var loadingCounter:int;
		private var adsFinished_:Boolean = false;
		
		// Set this to true to enable Playtomic logging
		private var playtomic_:Boolean = true;
		
		private var SWFID:int = 962067;
		private var GUID:String = "e94ec5015ec04f74";
		private var API_Key:String = "24229aa70c0d4bf9b9be2aa806e0b6";
		
		private var mustClick_:Boolean = true;
		private var loadPreloader_:Boolean = true;
		private var linkAdded_:Boolean = false;
		private var playBtnLoaded_:Boolean = false;
		
		/*
		[Embed("assets/intro.swf")] private var splash:Class;
		private var splash_:MovieClip;
		private var playSplash_:Boolean = true;
		private var playingSplash_:Boolean = false;
		private var loadedOnce_:Boolean = false;
		private const SPLASH_FRAMES:int = 30;
		private var splashFrames_:int = 0;
		*/
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		public function SirIsaac()
		{	
			// Log the entry to PlayTomic
			// Log.View(PT_SWF_ID:int, PT_GUID:string, PT_API:string, root.loaderInfo.loaderURL);
			Log.View(SWFID, GUID, API_Key, root.loaderInfo.loaderURL);
			
			this.init();
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		private function init():void
		{	
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.8;
			h = PROGRESS_BAR_HEIGHT;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.addChild(bgImg_);
			
			this.addChild(logo_);
			logo_.x = 200;
			logo_.y = 90;
			TweenMax.from(logo_, 0.85, {y: -200, ease:Bounce.easeOut, delay:0, onComplete:null});		
			
			this.addChild(ebLogo_);
			ebLogo_.x = 25;
			ebLogo_.y = 25;
			TweenMax.from(ebLogo_, 1.1, {y: -200, ease:Cubic.easeOut, delay:0, onComplete:null});
			
			this.addChild(twitter_);
			twitter_.x = 95;
			twitter_.y = 25;
			TweenMax.from(twitter_, 1.1, {y: -200, ease:Cubic.easeOut, delay:0, onComplete:null});
			
			this.addChild(facebook_);
			facebook_.x = 130;
			facebook_.y = 25;
			TweenMax.from(facebook_, 1.1, {y: -200, ease:Cubic.easeOut, delay:0, onComplete:null});
			
			this.addChild(googleplus_);
			googleplus_.x = 165;
			googleplus_.y = 25;
			TweenMax.from(googleplus_, 1.1, {y: -200, ease:Cubic.easeOut, delay:0, onComplete:null});
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5 + 50;
			
			progressBarBg = new Shape();
			progressBarBg.graphics.beginFill(BG_COLOR);
			progressBarBg.graphics.drawRect(175, py - 3, 375, h + 6);
			progressBarBg.graphics.endFill();
			progressBarBg.alpha = 0.6;
			this.addChild(progressBarBg);
			TweenMax.from(progressBarBg, 0.35, {x: -300, ease:Quad.easeIn, delay:0, onComplete:null});	
			
			graphics.beginFill(0xF7EAE8);
			graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
			graphics.endFill();
			progressBar = new Shape();
			addChild(progressBar);
			TweenMax.from(progressBar, 0.35, {x: -300, ease:Quad.easeIn, delay:0, onComplete:null});	
			
			/*
			splash_ = MovieClip(new splash());
			splash_.scaleX = 0.80;
			splash_.scaleY = 0.80;
			this.addChild(splash_);
			splash_.play();
			*/
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		public function onEnterFrame (e:Event):void
		{ 
			if (loadPreloader_)
			{
				if (hasLoaded())
				{
					progressBar.graphics.clear();
					progressBar.graphics.beginFill(PB_COLOR);
					
					progressBar.graphics.drawRect(PROG_BAR_X + 45, py, PROGRESS_BAR_WIDTH, h);
					progressBar.graphics.endFill();
					
					if (!playBtnLoaded_)
					{
						var bgX:int = progressBarBg.x;
						progressBarBg.x = 800;
						TweenMax.from(progressBarBg, 0.75, {x:173, ease:null, delay:0, onComplete:null});
						
						progressBar.x = 800;
						TweenMax.from(progressBar, 0.75, {x:175, ease:null, delay:0, onComplete:null});
						
						playBtn_.x = 290;
						playBtn_.y = 270;
						TweenMax.from(playBtn_, 0.75, {x: -200, ease:Back.easeOut, delay:0, onComplete:null});
						
						playBtnClip_.addChild(playBtn_);
						playBtnClip_.addEventListener(MouseEvent.CLICK, onMouseDown);
						this.addChild(playBtnClip_);
						
						playBtnLoaded_ = true;
					}
				} 
				else 
				{					
					var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
					
					progressBar.graphics.clear();
					progressBar.graphics.beginFill(PB_COLOR);
					
					progressBar.graphics.drawRect(PROG_BAR_X + 45, py, p * PROGRESS_BAR_WIDTH, h);
					progressBar.graphics.endFill();
				}       
			}
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		private function hasLoaded ():Boolean 
		{
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		private function onMouseDown(e:MouseEvent):void 
		{
			if (hasLoaded())
			{
				playGame();
			}
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		private function playGame (): void 
		{	
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
		
		
		/*******************************************************************************************
		 * Method: 
		 * 
		 * Description: 
		 ******************************************************************************************/
		private function finishedAds():void
		{
			adsFinished_ = true;
		}
		
		
		/*******************************************************************************************
		 * Method: goToSponsorSite
		 * 
		 * Description: Callback method that will navigate to sponsor's site
		 ******************************************************************************************/
		private function goToSponsorSite(e:Event):void
		{
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
		
		
		/*******************************************************************************************
		 * Method: goToEricBernier
		 * 
		 * Description: Callback method that will navigate to sponsor's site
		 ******************************************************************************************/
		private function goToEricBernier(e:Event):void
		{
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
	}
}
