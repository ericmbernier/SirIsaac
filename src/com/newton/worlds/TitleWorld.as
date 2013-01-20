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
	import net.flashpunk.World;
	import net.flashpunk.debug.Console;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class TitleWorld extends World
	{ 
		private var titleLogo_:Image = new Image(Assets.TITLE_LOGO);
		private var titleBg_:Image = new Image(Assets.TITLE_BG);
		
		private var darkScreen_:Image = Image.createRect(Global.GAME_WIDTH, Global.GAME_HEIGHT, 0x000000, 0);
		private var creditsBg_:Image = new Image(Assets.TITLE_CREDITS_BG, null);
		private var isaacNewton_:Image = new Image(Assets.TITLE_ISAAC_NEWTON);
		
		// Text on the main menu screen
		private var playGameTxt_:Text = new Text("Play Game", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var playGameTxtHover_:Text = new Text("Play Game", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var creditsTxt_:Text = new Text("Credits", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var creditsTxtHover_:Text = new Text("Credits", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var backTxt_:Text = new Text("Back", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var backTxtHover_:Text = new Text("Back", 0, 20, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var gameByTxt_:Text = new Text("A Game by Eric Bernier", 0, 10, {size:18, color:0xFFFFFF, 
			font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var levelSelTxt_:Text = new Text("Select Your Level!", 220, 150, {size:26, color:0xFFFFFF, visible:false,
			font:"Essays", outlineColor:0x000000, outlineStrength:2});
		
		// Text graphics on the credits screen
		private var creditsDesc_:Text = new Text("Programming, and design by", 
			190, 90, {size:20, visible:false, color:0x000000, font:"Essays"});
		private var creditsName_:Text = new Text("Eric Bernier", 
			245, 110, {size:24, visible:false, color:0x000000, font:"Essays"});
		private var creditsSite_:Text = new Text("www.ericbernier.com", 
			220, 130, {size:20, visible:false, color:0x000000, font:"Essays"});
		private var creditsArt_:Text = new Text("In-game art provided by opengameart.org.  Title screen clipart is public domain", 
			175, 155, {size:20, visible:false, color:0x000000, font:"Essays"});
		private var creditsMusic_:Text = new Text("Royalty Free Classical music provided by royaltyfreemusic.com", 
			125, 180, {size:20, visible:false, color:0x000000, font:"Essays"});
		
		// Buttons on the title screen
		private var playGameBtn_:TextButton;
		private var creditsBtn_:TextButton;
		private var backBtn_:TextButton;
		
		// Booleans used to keep track of which screen of the Title World the player is viewing
		private var viewingTitle_:Boolean = true;
		private var viewingLevelSelect_:Boolean = false;
		private var levelSelectEntities_:Array;
		private var viewingCredits_:Boolean = false;
		
		private var buttonHoverSnd_:Sfx = new Sfx(Assets.SND_BUTTON_HOVER);
		private var buttonSelectSnd_:Sfx = new Sfx(Assets.SND_BUTTON_SELECT);
		private var buttonBackSnd_:Sfx = new Sfx(Assets.SND_BUTTON_BACK);
		
		private var muteImg_:Image = new Image(Assets.MUTE_BTN);
		private var muteHover_:Image = new Image(Assets.MUTE_BTN);
		private var unmuteImg_:Image = new Image(Assets.UNMUTE_BTN);
		private var unmuteHover_:Image = new Image(Assets.UNMUTE_BTN);
		
		
		public function TitleWorld() 
		{
			Global.gameMusic.stop();
			Global.menuMusic.loop(Global.musicVolume * 0.85);
			
			titleLogo_.x = 140;
			titleLogo_.y = 40;
			
			this.addGraphic(titleBg_);
			this.addGraphic(titleLogo_);
			this.addGraphic(isaacNewton_);
			
			isaacNewton_.x = 225;
			isaacNewton_.y = 110;
			
			// Initialize and set all of the text on the main screen
			playGameTxt_.width = FP.width;
			playGameTxt_.y -= 28;
			playGameTxtHover_.width = FP.width;
			playGameTxtHover_.y -=  28;
			
			creditsTxt_.width = FP.width;
			creditsTxt_.y -= 28;
			creditsTxtHover_.width = FP.width;
			creditsTxtHover_.y -=  28;
			
			gameByTxt_.centerOO();
			gameByTxt_.width = FP.width;
			gameByTxt_.x = FP.halfWidth;
			this.addGraphic(gameByTxt_);
			
			// Initialize all of the buttons on the main menu
			playGameBtn_ = new TextButton(playGameTxt_, 200, 430, 130, 30, startGame);
			playGameBtn_.normal = playGameTxt_;
			playGameBtn_.hover = playGameTxtHover_;
			playGameBtn_.setRollOverSound(buttonHoverSnd_);
			playGameBtn_.setSelectSound(buttonSelectSnd_);
			this.add(playGameBtn_);
			
			creditsBtn_ = new TextButton(creditsTxt_, 350, 430, 90, 30, viewCredits);
			creditsBtn_.normal = creditsTxt_;
			creditsBtn_.hover = creditsTxtHover_;
			creditsBtn_.setRollOverSound(buttonHoverSnd_);
			creditsBtn_.setSelectSound(buttonSelectSnd_);
			this.add(creditsBtn_);
			
			this.addGraphic(darkScreen_);
			this.addGraphic(levelSelTxt_);
			
			creditsBg_.x = 85;
			creditsBg_.y = Global.GAME_HEIGHT + 15;
			creditsBg_.scale = 0.75;
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
			
			// Get our shared object for the game to determine levels beaten
			Global.shared = SharedObject.getLocal(Global.SHARED_OBJECT);
			var levelCheck:int = int(Global.shared.data.level);
			if (Global.shared.data.level == undefined || levelCheck == 1)
			{
				Global.shared.flush();			
			}
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
			viewLevelSelect();
		}
		
		
		private function viewLevelSelect():void
		{
			this.clearMainTitleScreen();
			viewingLevelSelect_ = true;
			
			levelSelTxt_.visible = true;
			
			playGameBtn_.visible = false;
			creditsBtn_.visible = false;
			isaacNewton_.visible = false;
			
			var levelsToAdd:int =  Global.NUM_LEVELS // Global.shared.data.level;
			var lockedLevels:int = Global.NUM_LEVELS - levelsToAdd;
			
			var xBuffer:int = 260;
			var yBuffer:int = 200;
			var bobUp:Boolean = true;
			levelSelectEntities_ = new Array();
			
			// Add all of the level select buttons
			for (var i:int = 0; i < levelsToAdd; i++)
			{
				var levelNum:int = i + 1;
				var levelTxt:Text = new Text(levelNum.toString(), 0, 0, {outlineColor:0x000000, outlineStrength:2});
				levelTxt.color = 0xFFFFFF;
				levelTxt.size = 28;
				levelTxt.font = "Essays";
				
				var levelTxtHover:Text = new Text(levelNum.toString(), 0, 0, {outlineColor:0x000000, outlineStrength:2});
				levelTxtHover.color = 0xFFFFFF;
				levelTxt.size = 28;
				levelTxtHover.font = "Essays";
				
				var levelBtn:TextButton = new TextButton(levelTxt, xBuffer, yBuffer, 32, 32, null,
					levelNum);
				levelBtn.hover = levelTxtHover;
				
				levelBtn.setRollOverSound(buttonHoverSnd_);
				levelBtn.setSelectSound(buttonSelectSnd_);
				
				levelSelectEntities_.push(FP.world.add(levelBtn));
				
				var diff:int = i % 3;
				if (diff == 2)
				{
					xBuffer = 260;
					yBuffer += 45;
				}
				else
				{
					xBuffer += 45;
				}
			}
			
			for (var j:int = 0; j < lockedLevels; j++)
			{
				var question:Text = new Text("?");
				question.color = 0xFFFFFF;
				question.size = 28;
				question.font = "LuckiestGuy";
				
				var lockedBtn:TextButton = new TextButton(question, xBuffer, yBuffer, 32, 32);
				lockedBtn.setHitbox(0, 0);
				levelSelectEntities_.push(FP.world.add(lockedBtn));
				
				var levelChecker:int = levelsToAdd + j + 1;
				
				var ldiff:int = i % 6;
				if (ldiff == 5)
				{
					xBuffer = 30;
					yBuffer += 35;
				}
				else
				{
					xBuffer += 45;
				}
				
				i++;
			}
			
			if (backBtn_ != null)
			{
				this.remove(backBtn_);
			}
			
			backTxt_.width = FP.width;
			backTxt_.y = 0;
			backTxtHover_.width = FP.width;
			backTxtHover_.y = 0;
			
			backBtn_ = new TextButton(backTxt_, 295, 415, 150, 30, backToTitle);
			backBtn_.normal = backTxt_;
			backBtn_.hover = backTxtHover_;
			backBtn_.setHitbox(120, 30, 0, 0);
			backBtn_.setRollOverSound(buttonHoverSnd_);
			backBtn_.setSelectSound(buttonBackSnd_);
			this.add(backBtn_);
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
			
			if (backBtn_ != null)
			{
				this.remove(backBtn_);
			}
			
			backTxt_.width = FP.width;
			backTxt_.y = 0;
			backTxtHover_.width = FP.width;
			backTxtHover_.y = 0;
			
			backBtn_ = new TextButton(backTxt_, 260, 400, 110, 30, backToTitle);
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
			else if (viewingLevelSelect_)
			{
				playGameBtn_.visible = true;
				creditsBtn_.visible = true;
				isaacNewton_.visible = true;
				levelSelTxt_.visible = true;
				viewingLevelSelect_ = false;
			}
			
			playGameBtn_.visible = true;
			playGameBtn_.setHitbox(155, 30, 0, 0);
			
			creditsBtn_.visible = true;
			creditsBtn_.setHitbox(120, 30, 0, 0);
			
			if (backBtn_ != null)
			{
				this.remove(backBtn_);
			}
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
		
		
		private function goToEricsSite():void
		{	
			var url:String = new String("http://www.ericbernier.com");
			navigateToURL(new URLRequest(url));
		}
	}
}
