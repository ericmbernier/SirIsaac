package com.newton.entities.solids 
{
	import com.newton.Global;
	
	import net.flashpunk.Entity;
	
	
	public class Solid extends Entity
	{
		public function Solid(x:int, y:int, w:int = 32, h:int = 32) 
		{
			type = Global.SOLID_TYPE
			setHitbox(w, h);
			
			this.x = x;
			this.y = y;
			
			// Hide us - we don't need to ever be updated or rendered
			active = false;
			visible = false;
		}
	}
}
