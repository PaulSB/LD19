package states 
{
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../data/ui/black.png')] private var imgBlack:Class;
		
		// Render layers:
		static private var s_layerBackground:FlxGroup;
		static private var s_layerForeground:FlxGroup;
		static private var s_layerOverlay:FlxGroup;
		
		private var m_tBlackScrn:FlxSprite;
		
		private var m_tInstructions:FlxText;
		
		private var m_fFadeInTimer:Number = 1.0;
		
		override public function create():void
		{
			bgColor = 0xff000000;
			
			// Instruction text
			m_tInstructions = new FlxText(0, FlxG.height -40, FlxG.width, "1 - View participants");
			m_tInstructions.setFormat("Istria", 20, 0xffffffff, "center");
			
			m_tBlackScrn = new FlxSprite;
			m_tBlackScrn.loadGraphic(imgBlack);
			
			// Add objects to layers
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tInstructions);
			
			s_layerOverlay = new FlxGroup;
			s_layerOverlay.add(m_tBlackScrn);
			
			// Add layers
			add(s_layerForeground);
			add(s_layerOverlay);
		}
		
		override public function update():void
		{
			// *** MAIN GAME LOOP ***
			
			if (m_fFadeInTimer > 0)
			{
				m_tBlackScrn.alpha = m_fFadeInTimer;
				m_fFadeInTimer -= FlxG.elapsed;
			}
		}
	}
}