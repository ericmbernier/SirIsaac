package com.newton.worlds
{
	import Playtomic.*;
	
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.util.Background;
	import com.newton.util.Button;
	import com.newton.util.LevelButton;
	import com.newton.util.TextButton;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TransformMatrixPlugin;
	
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.net.NetStreamPlayTransitions;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.World;
	import net.flashpunk.debug.Console;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class TitleWorld extends World
	{ 
		private const SHAKE_DURATION:Number = 0.3;
		
		private var titleLogo_:Image = new Image(Assets.TITLE_LOGO);
		private var titleBg_:Image = new Image(Assets.TITLE_BG);
		private var titleCody_:Image = new Image(Assets.TITLE_CODY);
		private var titleOptionsBg_:Image = new Image(Assets.TITLE_OPTIONS_BG);
		private var titleCreditsBg_:Image = new Image(Assets.TITLE_CREDITS_BG);
		
		private var darkScreen_:Image = Image.createRect(Global.GAME_WIDTH, Global.GAME_HEIGHT, 0x000000, 0);
		private var creditsBg_:Image = new Image(Assets.TITLE_CREDITS_BG, null);
		
		// Text on the main menu screen
		private var playGameTxt_:Text = new Text("Play Game", 0, 20, {size:28, color:0xFFF6A4, font:"Bangers"});
		private var playGameTxtHover_:Text = new Text("Play Game", 0, 20, {size:28, color:0xA69A35, font:"Bangers"});
		private var creditsTxt_:Text = new Text("Credits", 0, 20, {size:28, color:0xFFF6A4, font:"Bangers"});
		private var creditsTxtHover_:Text = new Text("Credits", 0, 20, {size:28, color:0xA69A35, font:"Bangers"});
		private var backTxt_:Text = new Text("Back", 0, 20, {size:28, color:0x222222, font:"Bangers"});
		private var backTxtHover_:Text = new Text("Back", 0, 20, {size:28, color:0x666666, font:"Bangers"});
		private var versionTxt_:Text = new Text("Version 1.0", 645, 462, {size:14, color:0xFFFFFF, font:"Bangers", 
			outlineColor:0x000000, outlineStrength:0});
		private var gameByTxt_:Text = new Text("A Game by Eric Bernier", 0, 10, {size:18, color:0xFFFFFF, 
			font:"Bangers", outlineColor:0x000000, outlineStrength:0});
		
		// Text graphics on the credits screen
		private var creditsDesc_:Text = new Text("Programming, and design by", 
			125, 80, {size:20, visible:false, color:0x000000, font:"Bangers"});
		private var creditsName_:Text = new Text("Eric Bernier", 
			125, 105, {size:24, visible:false, color:0x000000, font:"Bangers"});
		private var creditsSite_:Text = new Text("www.ericbernier.com", 
			125, 130, {size:20, visible:false, color:0x000000, font:"Bangers"});
		private var creditsArt_:Text = new Text("Art by PIXELCHUNK", 
			125, 155, {size:20, visible:false, color:0x000000, font:"Bangers"});
		private var creditsMusic_:Text = new Text("Music and sound by Daniel Davis", 
			125, 180, {size:20, visible:false, color:0x000000, font:"Bangers"});
		
		// Buttons on the title screen
		private var playGameBtn_:TextButton;
		private var creditsBtn_:TextButton;
		private var backBtn_:TextButton;
		
		// Booleans used to keep track of which screen of the Title World the player is viewing
		private var viewingTitle_:Boolean = true;
		private var viewingCredits_:Boolean = false;
		
		private var buttonHoverSnd_:Sfx = new Sfx(Assets.SND_JUMP);
		private var buttonSelectSnd_:Sfx = new Sfx(Assets.SND_JUMP);
		private var buttonBackSnd_:Sfx = new Sfx(Assets.SND_JUMP);
		
		private var muteImg_:Image = new Image(Assets.MUTE_BTN);
		private var muteHover_:Image = new Image(Assets.MUTE_BTN);
		private var unmuteImg_:Image = new Image(Assets.UNMUTE_BTN);
		private var unmuteHover_:Image = new Image(Assets.UNMUTE_BTN);
	
		
		public function TitleWorld() 
		{
			Global.gameMusic.stop();
			Global.menuMusic.loop(Global.musicVolume * 0.85);
			
			titleLogo_.x = 435;
			titleLogo_.y = 5;
			
			titleCody_.x = 15;
			titleCody_.y = 15;
			
			this.addGraphic(titleBg_);
			this.addGraphic(titleLogo_);
			this.addGraphic(titleCody_);
			
			// Initialize and set all of the text on the main screen
			playGameTxt_.width = FP.width;
			playGameTxt_.y -= 28;
			playGameTxtHover_.width = FP.width;
			playGameTxtHover_.y -=  28;
			
			creditsTxt_.width = FP.width;
			creditsTxt_.y -= 28;
			creditsTxtHover_.width = FP.width;
			creditsTxtHover_.y -=  28;
			
			this.addGraphic(versionTxt_);
			
			gameByTxt_.centerOO();
			gameByTxt_.width = FP.width;
			gameByTxt_.x = FP.halfWidth;
			this.addGraphic(gameByTxt_);
			
			// Initialize all of the buttons on the main menu
			playGameBtn_ = new TextButton(playGameTxt_, 530, 190, 155, 30, startGame);
			playGameBtn_.normal = playGameTxt_;
			playGameBtn_.hover = playGameTxtHover_;
			playGameBtn_.setRollOverSound(buttonHoverSnd_);
			playGameBtn_.setSelectSound(buttonSelectSnd_);
			this.add(playGameBtn_);
			
			creditsBtn_ = new TextButton(creditsTxt_, 530, 295, 120, 30, viewCredits);
			creditsBtn_.normal = creditsTxt_;
			creditsBtn_.hover = creditsTxtHover_;
			creditsBtn_.setRollOverSound(buttonHoverSnd_);
			creditsBtn_.setSelectSound(buttonSelectSnd_);
			this.add(creditsBtn_);
			
			this.addGraphic(darkScreen_);
			
			creditsBg_.x = 85;
			creditsBg_.y = Global.GAME_HEIGHT + 15;
			this.addGraphic(creditsBg_);
			
			// Add all of the credits graphics
			this.addGraphic(creditsDesc_);
			this.addGraphic(creditsName_);
			this.addGraphic(creditsSite_);
			this.addGraphic(creditsArt_);
			this.addGraphic(creditsMusic_);
			
			muteHover_.scale = 1.025;
			muteHover_.updateBuffer();
			
			unmuteHover_.scale = 1.025;
			unmuteHover_.updateBuffer();
			
			Global.muteBtn = new Button(4, 0, 26, 26, mute);
			Global.muteBtn.normal = muteImg_;
			Global.muteBtn.hover = muteHover_;
			Global.muteBtn.down = muteImg_;
			this.add(Global.muteBtn);
		}
		
		
		override public function begin():void
		{                     
			super.begin();
		}
		
		
		override public function update():void
		{  
			if (Input.pressed(Global.keyM))
			{
				this.mute();
			}
			
			super.update();
		}
		
		
		private function main():void
		{
			
		}
		
		
		private function startGame():void
		{
			Playtomic.Log.Play();
			
			TweenMax.to(darkScreen_, 0.25, {alpha:1, repeat: 0, yoyo:false, ease:Quad.easeIn, 
				onComplete:goToLevelSelect});
		}
		
		
		private function goToLevelSelect():void
		{
			FP.world.removeAll();
			FP.world = new LevelSelectWorld();
		}
		
		
		private function viewCredits():void
		{
			this.clearMainTitleScreen();
			viewingCredits_ = true;
			viewingTitle_ = false;
			
			TweenMax.to(darkScreen_, 0.75, {alpha:0.75, repeat: 0, yoyo:false, ease:Quad.easeIn});
			TweenMax.to(creditsBg_, 1.0, {y: 20, repeat:0, yoyo:false, ease:Back.easeOut});
			
			creditsDesc_.visible = true;
			creditsName_.visible = true;
			creditsSite_.visible = true;
			creditsArt_.visible = true;
			creditsMusic_.visible = true;
			
			if (backBtn_ != null)
			{
				this.remove(backBtn_);
			}
			
			backTxt_.width = FP.width;
			backTxt_.y = 0;
			backTxtHover_.width = FP.width;
			backTxtHover_.y = 0;
			
			backBtn_ = new TextButton(backTxt_, 330, 395, 110, 30, backToTitle);
			backBtn_.normal = backTxt_;
			backBtn_.hover = backTxtHover_;
			backBtn_.setHitbox(120, 30);
			backBtn_.setRollOverSound(buttonHoverSnd_);
			backBtn_.setSelectSound(buttonBackSnd_);
			this.add(backBtn_);
		}
		
			
		private function clearMainTitleScreen():void
		{
			playGameBtn_.visible = false;
			playGameBtn_.setHitbox(0, 0);
			
			creditsBtn_.visible = false;
			creditsBtn_.setHitbox(0, 0);
		}
		
		
		private function backToTitle():void
		{
			viewingTitle_ = true;
			
			if (viewingCredits_)
			{
				TweenMax.to(darkScreen_, 0.50, {alpha:0, repeat: 0, yoyo:false, ease:Quad.easeIn});
				TweenMax.to(creditsBg_, 0.50, {y: Global.GAME_HEIGHT + 15, repeat:0, yoyo:false, ease:Back.easeIn});
				
				creditsDesc_.visible = false;
				creditsName_.visible = false;
				creditsSite_.visible = false;
				creditsArt_.visible = false;
				creditsMusic_.visible = false;
				this.remove(backBtn_);
				
				viewingCredits_ = false;
			}
			
			playGameBtn_.visible = true;
			playGameBtn_.setHitbox(155, 30, 0, 0);
			
			creditsBtn_.visible = true;
			creditsBtn_.setHitbox(120, 30, 0, 0);
		}
				
		
		public function mute():void
		{
			if (Global.musicVolume <= 0 || Global.soundVolume <= 0)
			{
				Global.musicVolume = Global.DEFAULT_MUSIC_VOLUME;				
				Global.soundVolume = Global.DEFAULT_SFX_VOLUME;
				
				Global.muteBtn.normal = muteImg_;
				Global.muteBtn.down = muteImg_;
				Global.muteBtn.hover = muteHover_;
			}
			else
			{
				Global.musicVolume = 0;
				Global.soundVolume = 0;
				
				Global.muteBtn.normal = unmuteImg_;
				Global.muteBtn.down = unmuteImg_;
				Global.muteBtn.hover = unmuteHover_;
			}
			
			Global.menuMusic.volume = Global.musicVolume;
			Global.gameMusic.volume = Global.musicVolume;
		}
		
		
		private function resetSharedObjectsData():void
		{
			// Reset the scores for each level
			var levelScores:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			Global.shared.data.levelScores = levelScores;
			Global.shared.flush();
			
			if (Global.shared.data.deaths == undefined)
			{
				Global.shared.data.time = 0;
				Global.shared.data.deaths = 0;
				Global.shared.data.cells = 0;
			}
		}
		
		
		private function moreGames():void
		{	
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
		
		
		private function goToEricsSite():void
		{	
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
		
		
		private function goToFlashPunk():void
		{	
			var url:String = new String("http://www.flashpunk.net");
			navigateToURL(new URLRequest(url));
		}
	}
}