package com.newton 
{
	/**
	 * 
	 * @author Eric Bernier <http://www.ericbernier.com>
	 */
	public class Assets
	{	
		// Embed the levels
		[Embed(source = '../assets/levels/Level1.oel',  mimeType = "application/octet-stream")] public static const LEVEL1:Class;
		[Embed(source = '../assets/levels/Level2.oel',  mimeType = "application/octet-stream")] public static const LEVEL2:Class;
		[Embed(source = '../assets/levels/Level3.oel',  mimeType = "application/octet-stream")] public static const LEVEL3:Class;
		[Embed(source = '../assets/levels/Level4.oel',  mimeType = "application/octet-stream")] public static const LEVEL4:Class;
		[Embed(source = '../assets/levels/Level5.oel',  mimeType = "application/octet-stream")] public static const LEVEL5:Class;
		[Embed(source = '../assets/levels/Level6.oel',  mimeType = "application/octet-stream")] public static const LEVEL6:Class;
		[Embed(source = '../assets/levels/Level7.oel',  mimeType = "application/octet-stream")] public static const LEVEL7:Class;
		[Embed(source = '../assets/levels/Level8.oel',  mimeType = "application/octet-stream")] public static const LEVEL8:Class;
		[Embed(source = '../assets/levels/Level9.oel',  mimeType = "application/octet-stream")] public static const LEVEL9:Class;
		[Embed(source = '../assets/levels/Level10.oel',  mimeType = "application/octet-stream")] public static const LEVEL10:Class;
		
		public static const LEVELS:Array = new Array(LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5,
				LEVEL6, LEVEL7, LEVEL8, LEVEL9, LEVEL10);
		
		// Eric Bernier logos
		[Embed(source = '../assets/graphics/ebLogo.png')] public static const EB_LOGO:Class;
		
		// Tilesets
		[Embed(source = '../assets/graphics/tileset.png')] public static const TILESET:Class;
		
		// HUD
		[Embed(source = '../assets/graphics/apple.png')] public static const APPLE_METER:Class;		
		
		// Gameworld graphics
		[Embed(source = '../assets/graphics/mute.png')] public static const MUTE_BTN:Class;
		
		// Platforms and Objects
		[Embed(source = '../assets/graphics/crate.png')] public static const OBJECT_CRATE:Class;
		[Embed(source = '../assets/graphics/platformHorizontal.png')] public static const OBJECT_PLATFORM_HORIZONTAL:Class;
		[Embed(source = '../assets/graphics/platformVertical.png')] public static const OBJECT_PLATFORM_VERTICAL:Class;        
        [Embed(source = '../assets/graphics/door.png')] public static const OBJECT_DOOR:Class;
		
		// Collectables
		[Embed(source = '../assets/graphics/apple.png')] public static const APPLE:Class;
		
		// Player
		[Embed(source = '../assets/graphics/newtonSprite.png')] public static const ISAAC:Class;
		
		// Enemies
		
		// Intro
		
		// Music
		[Embed(source = '../assets/music/rootBearFloat.mp3')] public static const MUS_MENU:Class;
		[Embed(source = '../assets/music/watchOutBear.mp3')] public static const MUS_GAME:Class;
		[Embed(source = '../assets/music/happyBear.mp3')] public static const MUS_ENDING:Class;
		
		// Sound
		// [Embed(source = '../assets/sound/bigRedButton.mp3')] public static const SND_BIG_RED_BUTTON:Class;
	}
}