package com.newton.entities
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.newton.Assets;
	
	import com.newton.Global;
	import com.newton.worlds.EndWorld;
	
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	import punk.transition.Transition;
	import punk.transition.effects.StarIn;
	import punk.transition.effects.StarOut;

		
	/**
	 *
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class Apple extends Entity
	{			
        private const WIDTH:uint = 24;
        private const HEIGHT:uint = 24;
    
		private var image_:Image = new Image(Assets.APPLE);			
		private var appleSnd_:Sfx = new Sfx(Assets.SND_APPLE);
		private var appleHurtSnd_:Sfx = new Sfx(Assets.SND_APPLE_HURT);
	

		public function Apple(xCoord:int, yCoord:int)
		{	
			this.x = xCoord;
			this.y = yCoord;
			
			this.type = Global.APPLE_TYPE;	

			this.graphic = image_;
			
			if (Global.level < Global.NUM_LEVELS)
			{
				TweenMax.to(image_, 0.3, {y: -5, repeat: -1, yoyo:true, ease:Quad.easeInOut});
			}
			
			this.setHitbox(WIDTH, HEIGHT);
		}
        
			
		override public function update():void
		{	
			super.update();	
			
			if (Global.player.ending_)
			{
				this.y += FP.elapsed * 100;
				
				if (this.collide(Global.PLAYER_TYPE, x, y - 4))
				{
					this.type = "NOT_AN_APPLE";
					appleHurtSnd_.play(Global.soundVolume);
					
					world.add(new Particle(x, y, .5, .5, .1, 0xF3232D));
					world.add(new Particle(x + 5, y + 5, .5, .5, .1, 0xF3232D));
					world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0xF3232D));
					
					Global.gameMusic.stop();
					var question:Text = new Text("?", Global.player.x + 9, Global.player.y - 32, {size:22, color:0xFFFFFF, 
							font:"Essays", outlineColor:0x000000, outlineStrength:2});
					FP.world.addGraphic(question);
					
					Transition.to(EndWorld, 
						new StarIn({duration:3, track:Global.PLAYER_TYPE}), 
						new StarOut());
					
					FP.world.remove(this);
				}
			}
		}
		

		public function collect():void
		{	
            Global.appleVal += 1;
            
            world.add(new Particle(x, y, .5, .5, .1, 0xF3232D));
            world.add(new Particle(x + 5, y + 5, .5, .5, .1, 0xF3232D));
            world.add(new Particle(x - 5, y - 5, .5, .5, .1, 0xF3232D));
			
			appleSnd_.play(Global.soundVolume);
			FP.world.remove(this);
		}
	}
}
