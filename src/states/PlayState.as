package states 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import ui.DialogBox;
	import ui.ViewEndGame;
	import ui.ViewParticipants;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */	
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../data/world/bg.png')] private var imgBG:Class;
		[Embed(source = '../../data/ui/black.png')] private var imgBlack:Class;
		[Embed(source='../../data/ui/warning_box.png')] private var imgWarningBox:Class;
		
		[Embed(source='../../data/sfx/select.mp3')] private var sfxSelect:Class;
		
		// Constants
		private const e_STATE_YEARINTRO:int = 0;
		private const e_STATE_YEARSTART:int = 1;
		private const e_STATE_YEARMID:int = 2;		// Non-interactive state where the year's activities just "happen"
		private const e_STATE_YEAREND:int = 3;
		private const e_STATE_ELIMINATION:int = 4;
		private const e_STATE_ENDGAME1:int = 5;
		private const e_STATE_ENDGAME2:int = 6;
		private const e_STATE_ENDGAME3:int = 7;
			
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
		private var m_tEndgameView:ViewEndGame;
		private var m_tDialogBox:DialogBox;
		private var m_tSFXselect:FlxSound;
		
		private var m_tInstructions:FlxText;
		private var m_tInstructionsShadow:FlxText;
		private var m_tWarningText:FlxText;
		private var m_tWarningBacking:FlxSprite;
		private var m_fWarningTimer:Number = 3.0;
		
		private var m_fFadeInTimer:Number = 1.0;
		private var m_fFadeThroughTimer:Number = 0.0;

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
			m_tEndgameView = new ViewEndGame;
			
			// Instruction text
			m_tInstructions = new FlxText(0, FlxG.height -32, FlxG.width, "");
			m_tInstructions.setFormat("Istria", 20, 0xfff2f2f2, "center");
			m_tInstructionsShadow = new FlxText(0 +2, FlxG.height -32 +2, FlxG.width, "");
			m_tInstructionsShadow.setFormat("Istria", 20, 0xff000000, "center");
			
			m_tWarningText = new FlxText(15, FlxG.height * 0.5 -24, FlxG.width-30, "");
			m_tWarningText.setFormat("Istria", 32, 0xff48586d, "center");
			m_tWarningText.alpha = 0;
			m_tWarningBacking = new FlxSprite(10, m_tWarningText.y -8);
			m_tWarningBacking.loadGraphic(imgWarningBox);
			m_tWarningBacking.alpha = 0;
			
			m_tBlackScrn = new FlxSprite;
			m_tBlackScrn.loadGraphic(imgBlack);
			
			// Add objects to layers
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_tBG);
			
			s_layerObjects = new FlxGroup;
			for (i = 0; i < m_aParticipants.members.length; i++)
			{
				s_layerObjects.add(m_aParticipants.members[i]);
				s_layerObjects.add(m_aParticipants.members[i].m_tTrainingImg1);
				s_layerObjects.add(m_aParticipants.members[i].m_tTrainingImg2);
			}
			
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tParticipantList.m_aGraphics);
			s_layerForeground.add(m_tEndgameView.m_aGraphics);
			s_layerForeground.add(m_tDialogBox.m_aGraphics);
			s_layerForeground.add(m_tInstructionsShadow);
			s_layerForeground.add(m_tInstructions);
			s_layerForeground.add(m_tWarningBacking);
			s_layerForeground.add(m_tWarningText);
			
			s_layerOverlay = new FlxGroup;
			s_layerOverlay.add(m_tBlackScrn);
			
			// Add layers
			add(s_layerBackground);
			add(s_layerObjects);
			add(s_layerForeground);
			add(s_layerOverlay);
			
			// SFX
			m_tSFXselect = new FlxSound;
			m_tSFXselect.loadEmbedded(sfxSelect);
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
			
			if (m_tWarningText.alpha > 0)
			{
				if (m_fWarningTimer > 0)
				{
					m_fWarningTimer -= FlxG.elapsed;
				}
				else
				{
					m_fWarningTimer = 0;
					
					m_tWarningText.alpha -= FlxG.elapsed;
					m_tWarningBacking.alpha -= FlxG.elapsed;
					if (m_tWarningText.alpha <= 0)
					{
						m_tWarningText.alpha = 0;
						m_tWarningBacking.alpha = 0;
						m_fWarningTimer = 4.0;
					}
				}
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
						m_tSFXselect.play();
						
						m_tDialogBox.setIsActive(false);
						
						if (m_iCurrentYear == 5)
						{
							// ENDGAME time
							m_iCurrentState = e_STATE_ENDGAME1;
						}
						else
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
					if (FlxG.keys.justPressed("TWO"))
					{
						// Toggle a training option for current entry
						m_tParticipantList.toggleTraining();
					}
					if (FlxG.keys.justPressed("THREE"))
					{
						m_tSFXselect.play();
						
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
					if (iYearsToGo == 1)
						m_tParticipantList.setYearText(iYearsToGo.toString() + " year remains");
					else
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
						m_tSFXselect.play();
						
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
						m_tSFXselect.play();
						
						var iCount:int = 0;
						for (var i:int = 0; i < m_aParticipants.members.length; i++)
						{
							if (m_aParticipants.members[i].m_bEliminate)
								iCount++;
						}
						
						if (m_iCurrentYear == 5)
						{
							if (iCount == 5)
							{
								// ELIMINATE! - final five special case
								for (i = 0; i < m_aParticipants.members.length; i++)
								{
									if (m_aParticipants.members[i].m_bEliminate)
									{
										m_aParticipants.members[i].exists = false;
										m_aParticipants.members[i].m_tTrainingImg1.exists = false;
										m_aParticipants.members[i].m_tTrainingImg2.exists = false;
										m_aParticipants.members.splice(i--, 1);
									}
								}
								
								m_tParticipantList.setIsActive(false);
								m_iCurrentState = e_STATE_YEARINTRO;
							}
							else
							{
								m_tWarningText.text = "You have selected " + iCount.toString() + " participants. Please select 5.";
								m_tWarningText.alpha = m_tWarningBacking.alpha = 1.0;
							}
						}
						else
						{
							if (iCount == 10)
							{
								// ELIMINATE!
								for (i = 0; i < m_aParticipants.members.length; i++)
								{
									if (m_aParticipants.members[i].m_bEliminate)
									{
										m_aParticipants.members[i].exists = false;
										m_aParticipants.members[i].m_tTrainingImg1.exists = false;
										m_aParticipants.members[i].m_tTrainingImg2.exists = false;
										m_aParticipants.members.splice(i--, 1);
									}
								}
								
								m_tParticipantList.setIsActive(false);
								m_iCurrentState = e_STATE_YEARINTRO;
							}
							else 
							{
								m_tWarningText.text = "You have selected " + iCount.toString() + " participants. Please select 10.";
								m_tWarningText.alpha = m_tWarningBacking.alpha = 1.0;
							}
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
					if (m_iCurrentYear == 5)
						m_tParticipantList.setYearText("Select the 5 participants to eliminate");
					else
						m_tParticipantList.setYearText("Select the 10 participants to eliminate");
					
					m_tInstructions.text = "1 - Toggle skill view, 2 - Toggle elimination, 3 - Confirm choices";
					m_tInstructionsShadow.text = "1 - Toggle skill view, 2 - Toggle elimination, 3 - Confirm choices";
				}
			}
			else if (m_iCurrentState == e_STATE_ENDGAME1)
			{
				if (m_tEndgameView.getIsActive())
				{
					if (FlxG.keys.justPressed("ONE"))
					{
						m_tSFXselect.play();
						
						m_tEndgameView.setIsActive(false);
						m_iCurrentState = e_STATE_ENDGAME2;
					}
				}
				else
				{
					for (i = 0; i < m_aParticipants.members.length; i++)
						m_tEndgameView.m_aFinalFive.add(m_aParticipants.members[i]);
					
					m_tEndgameView.setPreview();
					m_tEndgameView.setIsActive(true);
					
					m_tInstructions.text = "1 - Continue";
					m_tInstructionsShadow.text = "1 - Continue";
				}
			}
			else if (m_iCurrentState == e_STATE_ENDGAME2)
			{
				if (m_tEndgameView.getIsActive())
				{
					if (FlxG.keys.justPressed("ONE"))
					{
						m_tSFXselect.play();
						
						m_tEndgameView.setIsActive(false);
						m_iCurrentState = e_STATE_ENDGAME3;
					}
				}
				else
				{
					m_tEndgameView.setResults();
					m_tEndgameView.setIsActive(true);
					
					m_tInstructions.text = "1 - Continue";
					m_tInstructionsShadow.text = "1 - Continue";
				}
			}
			else if (m_iCurrentState == e_STATE_ENDGAME3)
			{
				if (m_tEndgameView.getIsActive())
				{
					if (FlxG.keys.justPressed("ONE"))
					{
						m_tSFXselect.play();
						
						m_tEndgameView.setIsActive(false);
						m_iCurrentState = e_STATE_YEARINTRO;
						m_iCurrentYear = 0;
						
						FlxG.state = new MenuState();
					}
				}
				else
				{
					m_tEndgameView.setFinale();
					m_tEndgameView.setIsActive(true);
					
					m_tInstructions.text = "1 - Exit";
					m_tInstructionsShadow.text = "1 - Exit";
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
				
				if (pThisGuy.m_iThisYearTraining != pThisGuy.e_SKILL_DO_NOTHING)
				{
					if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_DEFEND)
						pThisGuy.m_bRevealDefend = true;
					else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MELEE)
						pThisGuy.m_bRevealMelee = true;
					else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_RANGED)
						pThisGuy.m_bRevealRanged = true;
					else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
						pThisGuy.m_bRevealMagic = true;
					else if (pThisGuy.m_tTrainingImg2.exists)
					{
						// Already fully trained! - BAIL
						m_tWarningText.text = "Remember: Full class-trained participants can gain nothing further from training!";
						m_tWarningText.alpha = m_tWarningBacking.alpha = 1.0;
					}
					else if (pThisGuy.m_iThisYearTraining == pThisGuy.m_iTraining1)
					{
						// Can't train same discipline twice! - BAIL
						m_tWarningText.text = "Remember: Each participant can only train a discipline once!";
						m_tWarningText.alpha = m_tWarningBacking.alpha = 1.0;
					}
					else 
					{
						if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_DEFEND)
						{
							pThisGuy.m_bTrainedDefend = true;
							if (!pThisGuy.m_tTrainingImg1.exists)
							{
								pThisGuy.m_iTraining1 = pThisGuy.e_SKILL_TRAIN_DEFEND;
								pThisGuy.m_tTrainingImg1.loadGraphic(pThisGuy.imgDefend);
								pThisGuy.m_tTrainingImg1.exists = true;
							}
							else
							{
								pThisGuy.m_iTraining2 = pThisGuy.e_SKILL_TRAIN_DEFEND;
								pThisGuy.m_tTrainingImg2.loadGraphic(pThisGuy.imgDefend);
								pThisGuy.m_tTrainingImg2.exists = true;
							}
						}
						else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MELEE)
						{
							pThisGuy.m_bTrainedMelee = true;
							if (!pThisGuy.m_tTrainingImg1.exists)
							{
								pThisGuy.m_iTraining1 = pThisGuy.e_SKILL_TRAIN_MELEE;
								pThisGuy.m_tTrainingImg1.loadGraphic(pThisGuy.imgMelee);
								pThisGuy.m_tTrainingImg1.exists = true;
							}
							else
							{
								pThisGuy.m_iTraining2 = pThisGuy.e_SKILL_TRAIN_MELEE;
								pThisGuy.m_tTrainingImg2.loadGraphic(pThisGuy.imgMelee);
								pThisGuy.m_tTrainingImg2.exists = true;
							}
						}
						else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_RANGED)
						{
							pThisGuy.m_bTrainedRanged = true;
							if (!pThisGuy.m_tTrainingImg1.exists)
							{
								pThisGuy.m_iTraining1 = pThisGuy.e_SKILL_TRAIN_RANGED;
								pThisGuy.m_tTrainingImg1.loadGraphic(pThisGuy.imgRanged);
								pThisGuy.m_tTrainingImg1.exists = true;
							}
							else
							{
								pThisGuy.m_iTraining2 = pThisGuy.e_SKILL_TRAIN_RANGED;
								pThisGuy.m_tTrainingImg2.loadGraphic(pThisGuy.imgRanged);
								pThisGuy.m_tTrainingImg2.exists = true;
							}
						}
						else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MAGIC)
						{
							pThisGuy.m_bTrainedMagic = true;
							if (!pThisGuy.m_tTrainingImg1.exists)
							{
								pThisGuy.m_iTraining1 = pThisGuy.e_SKILL_TRAIN_MAGIC;
								pThisGuy.m_tTrainingImg1.loadGraphic(pThisGuy.imgMagic);
								pThisGuy.m_tTrainingImg1.exists = true;
							}
							else
							{
								pThisGuy.m_iTraining2 = pThisGuy.e_SKILL_TRAIN_MAGIC;
								pThisGuy.m_tTrainingImg2.loadGraphic(pThisGuy.imgMagic);
								pThisGuy.m_tTrainingImg2.exists = true;
							}
						}
					}
				}
				
				pThisGuy.setClassRating();	// Update class score
			}
		}
	}
}