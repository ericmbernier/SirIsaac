package com.newton.entities 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;

	
	public class Explode extends Entity 
	{
		private static const RADIUS:Number = 32;
		private static const MOVE:Number = 10;
		private static const WHITE:uint = 0xFFFFFF;
		
		private static var p:Point = new Point;
		
		private var image:Image = Image.createCircle(RADIUS, 0xFF0000);
		private var scale:Number;
		private var rate:Number;
		private var min:Number;
		private var a:Number = FP.rand(90);
		private var ar:Number = FP.choose(1, -1);
		
		private static var id:int;
		private var i:int = id ++;
		
		private var started:Boolean = false;
		private var emitter:Emitter;
		
		private var color_:int = WHITE;
		
		
		public function Explode(x:Number, y:Number, s:Number = 1, r:Number = .5, m:Number = .2,
				color:uint = WHITE, radius:uint = RADIUS) 
		{
			color_ = color
			image = Image.createCircle(radius, color_);
			
			scale = s;
			rate = r;
			min = m;
			
			image.scale = 0;
			image.centerOrigin();
			super(x, y, image);
			
			TweenMax.to(image, .25, { scale:s, ease:Cubic.easeOut, onComplete:destroy } );
			TweenMax.delayedCall(.1, spawn);
			TweenMax.delayedCall(.15, spawn);
			TweenMax.delayedCall(.2, spawn);
			TweenMax.delayedCall(.25, spawn);
			
			// Snd.play(Snd["POOF" + String(2 + FP.rand(3))], .5);
		}
		
		override public function added():void 
		{
			if (!started)
			{
				started = true;
				start();
			}
			
			if (!started)
			{
				super.added();
				this.burst(x, y, RADIUS * scale);
			}
		}
		
		
		public function start():void
		{
			
		}
		
		
		override public function removed():void 
		{
			super.removed();
		}
		
		
		public function emit(x:Number, y:Number, count:uint = 1, type:String="pixel"):void
		{
			while (count --)
			{
				emitter.emit(type, x, y);
			}
		}
		
		
		public function burst(x:Number, y:Number, radius:Number, count:uint = 1, type:String="pixel"):void
		{
			while (count --)
			{
				FP.angleXY(p, FP.random * 360, FP.random * radius, x, y);
				emitter.emit(type, p.x, p.y);
			}
		}
		
		
		public function spawn():void
		{
			if (world && scale > min)
			{
				FP.angleXY(p, a, RADIUS * scale, x, y);
				a += 80 + 20 * FP.random;
				world.add(new Explode(p.x, p.y, scale * rate, rate, min, color_));
			}
		}
		
		
		public function destroy():void
		{
			TweenMax.to(image, .2, { alpha:0, onComplete:remove } );
		}
		
		
		public function remove():void
		{
			if (world)
			{
				world.remove(this);
			}
		}
	}
}