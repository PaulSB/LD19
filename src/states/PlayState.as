package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import ui.DialogBox;
	import ui.ViewParticipants;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */	
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../data/world/bg.png')] private var imgBG:Class;
		[Embed(source = '../../data/ui/black.png')] private var imgBlack:Class;
		
		// Constants
		private const e_STATE_YEARINTRO:int = 0;
		private const e_STATE_YEARSTART:int = 1;
		private const e_STATE_YEARMID:int = 2;		// Non-interactive state where the year's activities just "happen"
		private const e_STATE_YEAREND:int = 3;
		private const e_STATE_ELIMINATION:int = 4;	
			
		// Render layers:
		static private var s_layerBackground:FlxGroup;
		static private var s_layerObjects:FlxGroup;
		static private var s_layerForeground:FlxGroup;
		static private var s_layerOverlay:FlxGroup;
		
		static public var m_aParticipants:FlxGroup;
		static public var m_iCurrentYear:int = 0;		// 0 = year1/5, 4 = year 5/5, 5 = endgame
		private var m_tBG:FlxSprite;
		private var m_tBlackScrn:FlxSprite;
		private var m_tParticipantList:ViewParticipants;
		private var m_tDialogBox:DialogBox;
		
		private var m_tInstructions:FlxText;
		private var m_tInstructionsShadow:FlxText;
		
		private var m_fFadeInTimer:Number = 1.0;
		private var m_fFadeThroughTimer:Number = 0.0;
		//private var m_iNumParticipants:int = 50;

		private var m_iCurrentState:int = e_STATE_YEARINTRO;
		
		override public function create():void
		{
			bgColor = 0xff000000;
			
			m_tBG = new FlxSprite;
			m_tBG.loadGraphic(imgBG);
			
			// The participants...
			m_aParticipants = new FlxGroup;
			var fNumParticipants:Number = 50;
			for (var i:int = 0; i < 50; i++)
			{
				var fY:Number = FlxG.height*0.5 + (i / fNumParticipants) * (FlxG.height*0.5);
				m_aParticipants.add(new Participant(fY));
			}
			
			// UI overlays
			m_tParticipantList = new ViewParticipants;
			m_tDialogBox = new DialogBox;
			
			// Instruction text
			m_tInstructions = new FlxText(0, FlxG.height -32, FlxG.width, "");
			m_tInstructions.setFormat("Istria", 20, 0xfff2f2f2, "center");
			m_tInstructionsShadow = new FlxText(0, FlxG.height -32 +2, FlxG.width +2, "");
			m_tInstructionsShadow.setFormat("Istria", 20, 0xff000000, "center");
			
			m_tBlackScrn = new FlxSprite;
			m_tBlackScrn.loadGraphic(imgBlack);
			
			// Add objects to layers
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_tBG);
			
			s_layerObjects = new FlxGroup;
			s_layerObjects.add(m_aParticipants);
			
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tParticipantList.m_aGraphics);
			s_layerForeground.add(m_tDialogBox.m_aGraphics);
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
				if (m_iCurrentState != e_STATE_YEARINTRO)
					m_iCurrentState = e_STATE_YEARINTRO;
				
				m_tBlackScrn.alpha = m_fFadeInTimer;
				m_fFadeInTimer -= FlxG.elapsed;
				
				super.update();
				return;
			}
			
			if (m_iCurrentState == e_STATE_YEARMID)
			{
				// Need to show progress through year
				m_fFadeThroughTimer += FlxG.elapsed;
				
				if(m_fFadeThroughTimer < 1.0)
					m_tBlackScrn.alpha = m_fFadeThroughTimer;
				else if (m_fFadeThroughTimer < 2.0)
					m_tBlackScrn.alpha = 2.0 - m_fFadeThroughTimer;
				else
				{
					m_fFadeThroughTimer = 0;
					m_tBlackScrn.alpha = 0;
					m_iCurrentState = e_STATE_YEAREND;
				}
			}
			
			super.update();
			
			processInput();
		}
		
		private function processInput():void
		{
			if (m_iCurrentState == e_STATE_YEARINTRO)
			{
				if (m_tDialogBox.getIsActive())
				{
					if (FlxG.keys.justPressed("ONE"))
					{
						m_tDialogBox.setIsActive(false);
						m_iCurrentState = e_STATE_YEARSTART;
					}
				}
				else
				{
					m_tDialogBox.setIsActive(true);
					
					m_tDialogBox.setText(XmlData.m_aYearStartText[m_iCurrentYear] + "\n\n-Mr. Advisor");
					
					m_tInstructions.text = "1 - Continue";
					m_tInstructionsShadow.text = "1 - Continue";
				}
			}
			else if (m_iCurrentState == e_STATE_YEARSTART)
			{
				if (m_tParticipantList.getIsActive())
				{
					if (FlxG.keys.justPressed("UP"))
					{
						m_tParticipantList.moveSelectionUp();
					}
					else if (FlxG.keys.justPressed("DOWN"))
					{
						m_tParticipantList.moveSelectionDown();
					}
					if (FlxG.keys.justPressed("ONE"))
					{
						// Toggle an assessment option for current entry
						m_tParticipantList.toggleAssessment();
					}
					if (FlxG.keys.justPressed("THREE"))
					{
						// Confirm
						m_tParticipantList.setIsActive(false);
						m_iCurrentState = e_STATE_YEARMID;
						
						m_tInstructions.text = "";
						m_tInstructionsShadow.text = "";
					}
				}
				else
				{
					// Reset assignments
					for (i = 0; i < m_aParticipants.members.length; i++)
					{
						m_aParticipants.members[i].m_bEliminationView = false;
						m_aParticipants.members[i].m_iThisYearTraining = m_aParticipants.members[i].e_SKILL_DO_NOTHING;
					}
					
					m_tParticipantList.setIsActive(true);
					var iYearsToGo:int = 5 - m_iCurrentYear;
					m_tParticipantList.setYearText(iYearsToGo.toString() + " years remain");
					
					m_tInstructions.text = "1 - Toggle assessment, 2 - Toggle training, 3 - Confirm plans";
					m_tInstructionsShadow.text = "1 - Toggle assessment, 2 - Toggle training, 3 - Confirm plans";
				}
			}
			else if (m_iCurrentState == e_STATE_YEAREND)
			{
				if (m_tParticipantList.getIsActive())
				{
					if (FlxG.keys.justPressed("UP"))
					{
						m_tParticipantList.moveSelectionUp();
					}
					else if (FlxG.keys.justPressed("DOWN"))
					{
						m_tParticipantList.moveSelectionDown();
					}
					if (FlxG.keys.justPressed("ONE"))
					{
						// Toggle an assessment option for current entry
						m_tParticipantList.toggleView();
					}
					if (FlxG.keys.justPressed("TWO"))
					{
						m_tParticipantList.setIsActive(false);
						m_iCurrentState = e_STATE_ELIMINATION;
					}
				}
				else
				{
					proceedOneYear();
					
					m_tParticipantList.setIsActive(true);
					var iThisYear:int = m_iCurrentYear;
					m_tParticipantList.setYearText("End of Year " + iThisYear.toString() + " Report");
					
					m_tInstructions.text = "1 - Toggle skill view, 2 - Begin elimination";
					m_tInstructionsShadow.text = "1 - Toggle skill view, 2 - Begin elimination";
				}
			}
			else if (m_iCurrentState == e_STATE_ELIMINATION)
			{
				if (m_tParticipantList.getIsActive())
				{
					if (FlxG.keys.justPressed("UP"))
					{
						m_tParticipantList.moveSelectionUp();
					}
					else if (FlxG.keys.justPressed("DOWN"))
					{
						m_tParticipantList.moveSelectionDown();
					}
					else if (FlxG.keys.justPressed("ONE"))
					{
						m_tParticipantList.toggleView();
					}
					else if (FlxG.keys.justPressed("TWO"))
					{
						// Toggle whether to eliminate current entry
						m_tParticipantList.toggleElimination();
					}
					else if (FlxG.keys.justPressed("THREE"))
					{
						var iCount:int = 0;
						for (var i:int = 0; i < m_aParticipants.members.length; i++)
						{
							if (m_aParticipants.members[i].m_bEliminate)
								iCount++;
						}
						
						if (iCount == 10)
						{
							// ELIMINATE!
							for (i = 0; i < m_aParticipants.members.length; i++)
							{
								if (m_aParticipants.members[i].m_bEliminate)
								{
									m_aParticipants.members[i].exists = false;
									m_aParticipants.members.splice(i--, 1);
								}
							}
							
							m_tParticipantList.setIsActive(false);
							m_iCurrentState = e_STATE_YEARINTRO;
						}
					}
				}
				else
				{
					// From here want to ignore training types and just use elimination stuff
					for (i = 0; i < m_aParticipants.members.length; i++)
					{
						m_aParticipants.members[i].m_bReportView = false;
						m_aParticipants.members[i].m_bEliminationView = true;
					}
					
					m_tParticipantList.setIsActive(true);
					m_tParticipantList.setYearText("Select the 10 participants to eliminate");
					
					m_tInstructions.text = "1 - Toggle skill view, 2 - Toggle elimination, 3 - Confirm choices";
					m_tInstructionsShadow.text = "1 - Toggle skill view, 2 - Toggle elimination, 3 - Confirm choices";
				}
			}
		}
		
		private function proceedOneYear():void
		{
			m_iCurrentYear++;
			
			for (var i:int = 0; i < m_aParticipants.members.length; i++)
			{
				var pThisGuy:Participant = m_aParticipants.members[i];
				pThisGuy.ageOneYear();
				
				if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_DEFEND)
					pThisGuy.m_bRevealDefend = true;
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MELEE)
					pThisGuy.m_bRevealMelee = true;
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_RANGED)
					pThisGuy.m_bRevealRanged = true;
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
					pThisGuy.m_bRevealMagic = true;
			}
		}
	}
}