package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 19/12/10
	 */
	public class ViewEndGame
	{
		[Embed(source = '../../data/ui/dialog_box.png')] private var imgBackingBox:Class;
		
		public var m_aGraphics:FlxGroup;
		
		// Graphic objects:
		private var m_tBackingBox:FlxSprite;
		private var m_tText:FlxText;
		
		public function ViewEndGame() 
		{
			
		}
	}
}