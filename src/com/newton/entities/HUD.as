package com.newton.entities
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.util.Button;
	import com.newton.util.TextButton;
	import com.newton.worlds.GameWorld;
	import com.newton.worlds.TitleWorld;
	import com.newton.worlds.TransitionWorld;
	
	import flash.display.Graphics;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;

	import Playtomic.*;

	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class HUD extends Entity
	{
		private var sprite:Spritemap = new Spritemap(Assets.COLLECT_COIN, 12, 12, null);
		
		private var coinsTxt_:Text = new Text("x", 590, 5, {size:16, color:0xFFFFFF, 
				outlineColor:0x000000, outlineStrength:3});
		private var coinsNum_:Text = new Text(Global.coinsCollected.toString(), 620, 5, {size:16, 
				outlineColor:0x000000, outlineStrength:3});
		
		private var muteImg_:Image = new Image(Assets.MUTE_BTN);
		private var muteHover_:Image = new Image(Assets.MUTE_BTN);
		private var quitTxt_:Text = new Text("Quit", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:3});
		private var restartTxt_:Text = new Text("Restart", 0, 0, {size:10, outlineColor:0x000000, 
			outlineStrength:3});
		private var quitTxtHover_:Text = new Text("Quit", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:3});
		private var restartTxtHover_:Text = new Text("Restart", 0, 0, {size:10, outlineColor:0x000000, 
			outlineStrength:3});
		
		
		private var gfx_:Graphiclist;
	
		
		public function HUD()
		{
			muteHover_.scale = 1.15
			muteHover_.updateBuffer();
			
			Global.muteBtn = new Button(0, 0, 16, 16, mute);
			Global.muteBtn.normal = muteImg_;
			Global.muteBtn.hover = muteHover_;
			Global.muteBtn.down = muteImg_;
			FP.world.add(Global.muteBtn);
			
			restartTxt_.scale = 0.5;
			restartTxtHover_.scale = 0.5;
			Global.restartBtn = new TextButton(restartTxt_, 0, 0, 65, 16, restartLevel);
			Global.restartBtn.normal = restartTxt_;
			Global.restartBtn.hover = restartTxtHover_;
			Global.restartBtn.changeColor_ = false;
			FP.world.add(Global.restartBtn);
			
			quitTxt_.scale = 0.5;
			quitTxtHover_.scale = 0.5;
			Global.quitBtn = new TextButton(quitTxt_, 0, 0, 30, 13, quitGame)
			Global.quitBtn.normal = quitTxt_;
			Global.quitBtn.hover = quitTxtHover_;
			Global.quitBtn.changeColor_ = false;
			FP.world.add(Global.quitBtn);
			
			sprite.add("spin", [0, 1], 0.1, true);
			
			sprite.x = 575;
			sprite.y = 9;
			
			coinsTxt_.x = 590;
			coinsTxt_.y = 5;
			
			coinsNum_.x = 605;
			coinsNum_.y = 6;
			
			gfx_ = new Graphiclist(sprite, coinsTxt_, coinsNum_);
			this.graphic = gfx_;
		}
		
		
		override public function update():void
		{			
			sprite.play("spin");
			coinsNum_.text = String(Global.coinsCollected);
			coinsNum_.updateTextBuffer();
			coinsTxt_.updateTextBuffer();
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function mute():void
		{
			if (!Global.paused)
			{
				if (Global.musicVolume <= 0 || Global.soundVolume <= 0)
				{
					Global.musicVolume = Global.DEFAULT_MUSIC_VOLUME;				
					Global.soundVolume = Global.DEFAULT_SFX_VOLUME;
					
					// Log the unmute action to Playtomic
					Log.LevelCounterMetric("Unmute", Global.level); 
				}
				else
				{
					Global.musicVolume = 0;
					Global.soundVolume = 0;
					
					// Log the mute action to Playtomic
					Log.LevelCounterMetric("Mute", Global.level);
				}
				
				Global.menuMusic.volume = Global.musicVolume;
				Global.gameMusic.volume = Global.musicVolume;
			}
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		private function restartLevel():void
		{
			if (!Global.paused)
			{
				// Log the restart level action to Playtomic
				Log.LevelCounterMetric("RestartLevel", Global.level);
				
				Global.player.killMe();
			}
		}
		
		
		/*******************************************************************************************
		 * Method: quitGame
		 * 
		 * Description: Callback method that returns home to the TitleWorld, removing all entities
		 * ****************************************************************************************/
		private function quitGame():void
		{	
			if (!Global.paused)
			{
				Global.levelObject.flush();
				Global.sodasObject.flush();
				Global.statsObject.flush();
				
				// Log the Quit action to Playtomic
				Log.LevelCounterMetric("Quit", Global.level);
				
				Global.paused = false;
				
				FP.world.removeAll();
				
				//TODO: Polish up transition world to checkerboard pattern
				FP.world = new TransitionWorld(TitleWorld);
			}
		}	
	}
}
