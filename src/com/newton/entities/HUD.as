package com.newton.entities
{
	import Playtomic.*;
	
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
	
	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class HUD extends Entity
	{	
		private var levelTxt_:Text = new Text("Level", 10, 3, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:3, font:"Bangers"});
		private var levelNum_:Text = new Text("0", 40, 3, {size:16, 
			outlineColor:0x000000, outlineStrength:3, font:"Bangers"});
		private var levelName_:Text = new Text("The Forest", 50, 3, {size:16, 
			outlineColor:0x000000, outlineStrength:3, font:"Bangers"});
		
		private var pauseTxt_:Text = new Text("[P]ause", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:2, font: "Bangers"});
		private var pauseTxtHover_:Text = new Text("[P]ause", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:2, font: "Bangers"});
		
		private var muteTxt_:Text = new Text("[M]ute", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:2, font: "Bangers"});
		private var muteTxtHover_:Text = new Text("[M]ute", 0, 0, {size:16, color:0xFFFFFF, 
			outlineColor:0x000000, outlineStrength:2, font: "Bangers"});
		
		private var restartTxt_:Text = new Text("[R]estart", 0, 0, {size:16, outlineColor:0x000000, 
			outlineStrength:2, font: "Bangers"});
		private var restartTxtHover_:Text = new Text("[R]estart", 0, 0, {size:16, outlineColor:0x000000, 
			outlineStrength:2, font: "Bangers"});
		
		private var gfx_:Graphiclist;
		
		
		public function HUD()
		{	
			Global.pauseBtn = new TextButton(pauseTxt_, 550, 3, 30, 13, pauseGame)
			Global.pauseBtn.normal = pauseTxt_;
			Global.pauseBtn.hover = pauseTxtHover_;
			FP.world.add(Global.pauseBtn);
			
			Global.muteBtnTxt = new TextButton(muteTxt_, 670, 3, 30, 13, mute)
			Global.muteBtnTxt.normal = muteTxt_;
			Global.muteBtnTxt.hover = muteTxtHover_;
			FP.world.add(Global.muteBtnTxt);
			
			Global.restartBtn = new TextButton(restartTxt_, 700, 3, 65, 16, restartLevel);
			Global.restartBtn.normal = restartTxt_;
			Global.restartBtn.hover = restartTxtHover_;
			FP.world.add(Global.restartBtn);
			
			var curLevel:int = Global.level;
			levelNum_.text = curLevel.toString();
			
			levelName_.text = "Level Name";
			
			gfx_ = new Graphiclist(levelTxt_, levelNum_, levelName_);
			this.graphic = gfx_;
		}
		
		
		override public function update():void
		{
			levelNum_.updateTextBuffer();
		}
		
		
		/*******************************************************************************************
		 * Method:
		 * 
		 * Description:
		 ******************************************************************************************/
		public function mute():void
		{
			if (Global.musicVolume <= 0 || Global.soundVolume <= 0)
			{
				Global.musicVolume = Global.DEFAULT_MUSIC_VOLUME;				
				Global.soundVolume = Global.DEFAULT_SFX_VOLUME;
			}
			else
			{
				Global.musicVolume = 0;
				Global.soundVolume = 0;
			}
			
			Global.menuMusic.volume = Global.musicVolume;
			Global.gameMusic.volume = Global.musicVolume;
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
				var cloneList:Array = [];
				world.getClass(Player, cloneList);
				
				for each (var clone:Player in cloneList)
				{
					clone.killMe();
				}
				
				Global.player.killMe();
			}
		}
		
		
		private function pauseGame():void
		{
			if (Global.paused)
			{
				Global.pausedScreen.unpauseGame();
			}
			else
			{
				Global.pausedScreen.pauseGame();
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
				Global.shared.flush();
				
				Global.paused = false;
				
				FP.world.removeAll();
				
				//TODO: Polish up transition world to checkerboard pattern
				FP.world = new TransitionWorld(TitleWorld);
			}
		}	
	}
}
