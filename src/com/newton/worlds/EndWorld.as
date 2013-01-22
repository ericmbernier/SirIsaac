package com.newton.worlds
{
	import com.newton.Assets;
	import com.newton.Global;
	import com.newton.util.TextButton;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;

	
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class EndWorld extends World
	{
		private var endImg_:Image = new Image(Assets.END_SCREEN);
		private var titleBtn_:TextButton;
		
		private var backTxt_:Text = new Text("Back To Title", 0, 0, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		private var backTxtHover_:Text = new Text("Back To Title", 0, 0, {size:28, color:0xFFFFFF, font:"Essays", outlineColor:0x000000, outlineStrength:2});
		
		private var buttonHoverSnd_:Sfx = new Sfx(Assets.SND_BUTTON_HOVER);
		private var buttonSelectSnd_:Sfx = new Sfx(Assets.SND_BUTTON_SELECT);
		private var buttonBackSnd_:Sfx = new Sfx(Assets.SND_BUTTON_BACK);
		
		
		public function EndWorld()
		{
			FP.world.removeAll();
			this.addGraphic(endImg_);
			
			Global.endMusic.loop(Global.musicVolume);
			
			titleBtn_ = new TextButton(backTxt_, 230, 395, 200, 30, goToTitle);
			titleBtn_.normal = backTxt_;
			titleBtn_.hover = backTxtHover_;
			titleBtn_.setRollOverSound(buttonHoverSnd_);
			titleBtn_.setSelectSound(buttonSelectSnd_);
			this.add(titleBtn_);
		}
		
		
		
		private function goToTitle():void
		{
			var screen:Image = new Image(FP.buffer);
			FP.world = new TransitionWorld(TitleWorld, screen, Global.CIRCLE);
		}
	}
}