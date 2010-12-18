package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import ui.ViewParticipants;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */	
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../data/world/bg.png')] private var imgBG:Class;
		[Embed(source = '../../data/ui/black.png')] private var imgBlack:Class;
			
		// Render layers:
		static private var s_layerBackground:FlxGroup;
		static private var s_layerObjects:FlxGroup;
		static private var s_layerForeground:FlxGroup;
		static private var s_layerOverlay:FlxGroup;
		
		static public var m_aParticipants:Array;
		private var m_tBG:FlxSprite;
		private var m_tBlackScrn:FlxSprite;
		private var m_tParticipantList:ViewParticipants;
		
		private var m_tInstructions:FlxText;
		private var m_tInstructionsShadow:FlxText;
		
		private var m_fFadeInTimer:Number = 1.0;
		private var m_iNumParticipants:int = 10;
		
		override public function create():void
		{
			bgColor = 0xff000000;
			
			m_tBG = new FlxSprite;
			m_tBG.loadGraphic(imgBG);
			
			// The participants...
			m_aParticipants = new Array;
			var fNumParticipants:Number = m_iNumParticipants;
			for (var i:int = 0; i < m_iNumParticipants; i++)
			{
				var fY:Number = FlxG.height*0.5 + (i / fNumParticipants) * (FlxG.height*0.5);
				m_aParticipants.push(new Participant(fY));
				m_aParticipants[i].y -= (m_aParticipants[i].height - 16);
			}
			
			// UI overlays
			m_tParticipantList = new ViewParticipants;
			
			// Instruction text
			m_tInstructions = new FlxText(0, FlxG.height -40, FlxG.width, "1 - View participants");
			m_tInstructions.setFormat("Istria", 20, 0xfff2f2f2, "center");
			m_tInstructionsShadow = new FlxText(0, FlxG.height -40 +2, FlxG.width +2, "1 - View participants");
			m_tInstructionsShadow.setFormat("Istria", 20, 0xff000000, "center");
			
			m_tBlackScrn = new FlxSprite;
			m_tBlackScrn.loadGraphic(imgBlack);
			
			// Add objects to layers
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_tBG);
			
			s_layerObjects = new FlxGroup;
			for (i = 0; i < m_iNumParticipants; i++)
			{
				s_layerObjects.add(m_aParticipants[i]);
			}
			
			s_layerForeground = new FlxGroup;
			//s_layerForeground.add(m_tParticipantList);	// TO DO: add graphical elements to layer here
			s_layerForeground.add(m_tInstructionsShadow);
			s_layerForeground.add(m_tInstructions);
			
			s_layerOverlay = new FlxGroup;
			s_layerOverlay.add(m_tBlackScrn);
			
			// Add layers
			add(s_layerBackground);
			add(s_layerObjects);
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
			
			super.update();
		}
	}
}