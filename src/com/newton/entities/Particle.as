package com.newton.entities 
{
	import com.newton.Global;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.utils.Ease;
	
	
	public class Particle extends Entity 
	{
		public static const RADIUS:Number = 8;
		private static const MOVE:Number = 10;
		private static const WHITE:uint = 0xFFFFFF;
		
		private static var p:Point = new Point;
		
		private var image:Image;
		
		private var scale:Number;
		private var rate:Number;
		private var min:Number;
		private var a:Number = FP.rand(90);
		private var ar:Number = FP.choose(1, -1);
		
		private static var id:int;
		public var i:int = id ++;
		
		private var started:Boolean = false;
		private var fanParticle_:Boolean = false;
		private var fanDir_:int = -1;
		
		private var emitter:Emitter;
		
		
		public function Particle(x:Number, y:Number, s:Number = 1, r:Number = .5, m:Number = .2,
				color:uint = WHITE, radius:uint = RADIUS, fanParticle:Boolean = false,
				fanDir:int = -1) 
		{
			image = Image.createRect(10, 10, color, 1);
			image.alpha = 0.8
			
			scale = s;
			rate = r;
			min = m;
			fanParticle_ = fanParticle;
			fanDir_ = fanDir;
			
			image.scale = 0;
			image.centerOrigin();
			super(x, y, image);
			
			if (!fanParticle)
			{
				TweenMax.to(image, 0.2, { scale:s, ease:Cubic.easeOut, onComplete:destroy } );
				TweenMax.delayedCall(0, fadeOut);
			}
			else
			{
				TweenMax.to(image, 0.2, { scale:s, ease:null, onComplete:destroy } );
				TweenMax.delayedCall(0, fadeOut);
			}
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
				this.burst(x, y, 4);
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
		

		public function burst(x:Number, y:Number, radius:Number, count:uint = 1, 
				type:String="pixel"):void
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
				FP.angleXY(p, a, 4 * scale, x, y);
				a += 80 + 20 * FP.random;
				world.add(new Particle(p.x, p.y, scale * rate, rate, min));
			}
		}
		
		
		public function destroy():void
		{
			if (fanParticle_)
			{
				TweenMax.to(image, 0.5, { alpha:0, onComplete:remove } );
			}
			else
			{
				TweenMax.to(image, .2, { alpha:0, onComplete:remove } );
			}
		}
		
		
		public function remove():void
		{
			if (world)
			{
				world.remove(this);
			}
		}


		private function lateFade(t:Number):Number
		{
			return t < .75 ? 0 : (t - .75) / .25;
		}


		private function fadeOut():void
		{
			var tempX:int = FP.rand(10);
			var tempY:int = 0;

            tempY = FP.rand(10);
            TweenMax.to(image, 0.2, {x: tempX, y: tempY, ease:Quad.easeInOut});
		}
	}
}
