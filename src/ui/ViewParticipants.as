package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import states.PlayState;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	public class ViewParticipants
	{
		[Embed(source = '../../data/ui/participant_info.png')] private var imgInfoBox:Class;
		[Embed(source = '../../data/ui/arrow_large.png')] private var imgArrowSelect:Class;
		[Embed(source = '../../data/ui/arrow_up.png')] private var imgArrowUp:Class;
		[Embed(source = '../../data/ui/arrow_down.png')] private var imgArrowDown:Class;
		
		[Embed(source = '../../data/ui/skill_none.png')] private var imgSkillNone:Class;
		[Embed(source = '../../data/ui/skill_defend.png')] private var imgSkillDefend:Class;
		[Embed(source = '../../data/ui/skill_melee.png')] private var imgSkillMelee:Class;
		[Embed(source = '../../data/ui/skill_ranged.png')] private var imgSkillRanged:Class;
		[Embed(source = '../../data/ui/skill_magic.png')] private var imgSkillMagic:Class;
		
		[Embed(source = '../../data/ui/skill_tick.png')] private var imgTick:Class;
		[Embed(source = '../../data/ui/skill_cross.png')] private var imgCross:Class;
		
		private const k_iNumEntriesOnScreen:int = 10;
		
		public var m_aGraphics:FlxGroup;
		
		// Graphic objects:
		private var m_aBackingBoxes:FlxGroup;
		private var m_tArrowUp:FlxSprite;
		private var m_tArrowDown:FlxSprite;
		private var m_tSelectArrow:FlxSprite;
		private var m_tYearText:FlxText;
		private var m_aParticipantSprites:FlxGroup;
		private var m_aIndexText:FlxGroup;
		private var m_aNameText:FlxGroup;
		private var m_aStatText:FlxGroup;
		private var m_aSkillImages:FlxGroup;
		private var m_aSkillText:FlxGroup;
		private var m_aClassImages:FlxGroup;
		private var m_aClassText:FlxGroup;
		
		private var m_bActive:Boolean = false;
		private var m_aCurrentParticipants:FlxGroup;
		private var m_iCurrentIndex:int = 0;		// Index into array of participants
		private var m_iCurrentSelection:int = 0;	// Currently highlighted entry
		
		public function ViewParticipants() 
		{				
			m_aBackingBoxes = new FlxGroup;
			var fY:Number = 40;
			for (var j:int = 0; j < k_iNumEntriesOnScreen; j++)
			{
				var tBox:FlxSprite = new FlxSprite(0,fY);
				tBox.loadGraphic(imgInfoBox);
				tBox.x = (FlxG.width - tBox.width) * 0.5;
				
				m_aBackingBoxes.add(tBox);
				fY += tBox.height;
			}
			
			m_tArrowUp = new FlxSprite(m_aBackingBoxes.members[0].x,
										m_aBackingBoxes.members[0].y);
			m_tArrowUp.loadGraphic(imgArrowUp);
			m_tArrowUp.x -= m_tArrowUp.width * 2;
			
			m_tArrowDown = new FlxSprite(m_aBackingBoxes.members[0].x,
										m_aBackingBoxes.members[k_iNumEntriesOnScreen-1].y + m_aBackingBoxes.members[k_iNumEntriesOnScreen-1].height);
			m_tArrowDown.loadGraphic(imgArrowDown);
			m_tArrowDown.x -= m_tArrowDown.width * 2;
			m_tArrowDown.y -= m_tArrowDown.height;
			
			m_tSelectArrow = new FlxSprite(m_aBackingBoxes.members[0].x + m_aBackingBoxes.members[0].width, m_aBackingBoxes.members[0].y);
			m_tSelectArrow.loadGraphic(imgArrowSelect);
			
			m_tYearText = new FlxText(0, 5, FlxG.width);
			m_tYearText.setFormat("Istria", 32, 0xfff2f2f2, "center");
			
			// First time build list
			populateList();
			
			m_aGraphics = new FlxGroup;
			m_aGraphics.add(m_aBackingBoxes);
			m_aGraphics.add(m_aParticipantSprites);
			m_aGraphics.add(m_aClassImages);
			m_aGraphics.add(m_aSkillImages);
			m_aGraphics.add(m_aSkillText);
			m_aGraphics.add(m_tYearText);
			m_aGraphics.add(m_aIndexText);
			m_aGraphics.add(m_aClassText);
			m_aGraphics.add(m_aNameText);
			m_aGraphics.add(m_aStatText);
			m_aGraphics.add(m_tArrowUp);
			m_aGraphics.add(m_tArrowDown);
			m_aGraphics.add(m_tSelectArrow);
			m_aGraphics.exists = false;
		}
		
		private function populateList():void
		{
			m_aCurrentParticipants = new FlxGroup;
			for (var i:int = m_iCurrentIndex; i < m_iCurrentIndex + k_iNumEntriesOnScreen; i++)
				m_aCurrentParticipants.add(PlayState.m_aParticipants.members[i]);
				
			m_aParticipantSprites = new FlxGroup;
			m_aIndexText = new FlxGroup;
			m_aNameText = new FlxGroup;
			m_aStatText = new FlxGroup;
			m_aSkillImages = new FlxGroup;
			m_aSkillText = new FlxGroup;
			m_aClassImages = new FlxGroup;
			m_aClassText = new FlxGroup;
			for (var j:int = 0; j < k_iNumEntriesOnScreen; j++)
			{
				var pThisBox:FlxSprite = m_aBackingBoxes.members[j];
				var pThisGuy:Participant = m_aCurrentParticipants.members[j];
				var iXOffset:int = (j % 2) ? pThisGuy.width : 0;
				var tThisSprite:FlxSprite = new FlxSprite(pThisBox.x +24 +iXOffset, pThisBox.y -8);
				tThisSprite.loadGraphic(pThisGuy.imgParticipant);
				
				m_aParticipantSprites.add(tThisSprite);
				
				var iID:int = m_iCurrentIndex + j +1;
				var tText:FlxText = new FlxText(pThisBox.x +8, pThisBox.y +8, pThisBox.width, iID.toString());
				tText.setFormat("Istria", 20, 0xff2d1601, "left");
				m_aIndexText.add(tText);
				
				var tNames:FlxText = new FlxText(tText.x + 100, tText.y -4, pThisBox.width, pThisGuy.m_sForename + " " + pThisGuy.m_sSurname);
				tNames.setFormat("Istria", 20, 0xff2d1601, "left");
				m_aNameText.add(tNames);
				
				// Showing overall ability
				var tStat:FlxText = new FlxText(FlxG.width * 0.5 +10, tText.y + 4, FlxG.width * 0.5,
												"Overall ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentOverall));
				tStat.setFormat("Istria", 16, 0xff2d1601, "left");
				m_aStatText.add(tStat);
				
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_DO_NOTHING;
				var tSkillSprite:FlxSprite = new FlxSprite(pThisBox.x + pThisBox.width -8, pThisBox.y);
				tSkillSprite.loadGraphic(imgSkillNone);
				tSkillSprite.x -= tSkillSprite.width;
				m_aSkillImages.add(tSkillSprite);
				
				var tSkillText:FlxText = new FlxText(tSkillSprite.x - 20, tText.y, 100, "");
				tSkillText.setFormat("Istria", 12, 0xff2d1601, "left");
				m_aSkillText.add(tSkillText);
				
				var tClassSprite1:FlxSprite = new FlxSprite(tThisSprite.x, tThisSprite.y + tThisSprite.height - 20);
				tClassSprite1.exists = false;
				var tClassSprite2:FlxSprite = new FlxSprite(tThisSprite.x + tThisSprite.width - 20, tThisSprite.y + tThisSprite.height - 20);
				tClassSprite2.exists = false;
				m_aClassImages.add(tClassSprite1);
				m_aClassImages.add(tClassSprite2);
				
				var tClassText:FlxText = new FlxText(tNames.x, tNames.y +20, 200, pThisGuy.getClassName());
				tClassText.setFormat("Istria", 12, 0xff592b02, "left");
				m_aClassText.add(tClassText);
			}
			
			m_tArrowUp.color = (m_iCurrentIndex == 0) ? 0x797979 : 0xffffff;
			m_tArrowDown.color = (m_iCurrentIndex + k_iNumEntriesOnScreen == PlayState.m_aParticipants.members.length) ? 0x797979 : 0xffffff;
		}
		
		private function rePopulateList():void
		{
			m_aCurrentParticipants = new FlxGroup;
			for (var i:int = m_iCurrentIndex; i < m_iCurrentIndex + k_iNumEntriesOnScreen; i++)
				m_aCurrentParticipants.add(PlayState.m_aParticipants.members[i]);
				
			for (var j:int = 0; j < k_iNumEntriesOnScreen; j++)
			{
				var pThisGuy:Participant = m_aCurrentParticipants.members[j];

				m_aParticipantSprites.members[j].loadGraphic(pThisGuy.imgParticipant);
				
				if (pThisGuy.m_tTrainingImg1.exists)
				{
					var pClassGraphic:Class;
					switch(pThisGuy.m_iTraining1)
					{
						case pThisGuy.e_SKILL_TRAIN_DEFEND:	pClassGraphic = pThisGuy.imgDefend; break;
						case pThisGuy.e_SKILL_TRAIN_MELEE:	pClassGraphic = pThisGuy.imgMelee; break;
						case pThisGuy.e_SKILL_TRAIN_RANGED:	pClassGraphic = pThisGuy.imgRanged; break;
						case pThisGuy.e_SKILL_TRAIN_MAGIC:	pClassGraphic = pThisGuy.imgMagic; break;
					}
					m_aClassImages.members[j * 2].loadGraphic(pClassGraphic);
					m_aClassImages.members[j * 2].exists = true;
					
					if (pThisGuy.m_tTrainingImg2.exists)
					{
						switch(pThisGuy.m_iTraining2)
						{
							case pThisGuy.e_SKILL_TRAIN_DEFEND:	pClassGraphic = pThisGuy.imgDefend; break;
							case pThisGuy.e_SKILL_TRAIN_MELEE:	pClassGraphic = pThisGuy.imgMelee; break;
							case pThisGuy.e_SKILL_TRAIN_RANGED:	pClassGraphic = pThisGuy.imgRanged; break;
							case pThisGuy.e_SKILL_TRAIN_MAGIC:	pClassGraphic = pThisGuy.imgMagic; break;
						}
						m_aClassImages.members[j * 2 +1].loadGraphic(pClassGraphic);
						m_aClassImages.members[j * 2 +1].exists = true;
					}
					else
						m_aClassImages.members[j * 2 +1].exists = false;
				}
				else
				{
					m_aClassImages.members[j * 2].exists = false;
					m_aClassImages.members[j * 2 +1].exists = false;
				}
				
				var iID:int = m_iCurrentIndex + j +1;
				m_aIndexText.members[j].text = iID.toString();
				
				m_aNameText.members[j].text = pThisGuy.m_sForename + " " + pThisGuy.m_sSurname;
				
				m_aClassText.members[j].text = pThisGuy.getClassName();
				
				if (pThisGuy.m_bEliminationView)
				{
					// ELIMINATION MODE special case
					var pGraphic:Class = pThisGuy.m_bEliminate ? imgCross : imgTick;
					m_aSkillImages.members[j].loadGraphic(pGraphic);
				}
				
				if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_DO_NOTHING)
				{
					if (pThisGuy.m_iTraining1 && pThisGuy.m_iTraining2)
						m_aStatText.members[j].text = "Class ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentClass);
					else
						m_aStatText.members[j].text = "Overall ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentOverall);
					
					if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[j].loadGraphic(imgSkillNone);
				}
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_DEFEND
							|| pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_DEFEND)
				{
					if (pThisGuy.m_bRevealDefend)
						m_aStatText.members[j].text = "Defence potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialDefend);
					else
						m_aStatText.members[j].text = "Defence ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentDefend);
						
					if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[j].loadGraphic(imgSkillDefend);
				}
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MELEE
							|| pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MELEE)
				{
					if (pThisGuy.m_bRevealMelee)
						m_aStatText.members[j].text = "Melee potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMelee);
					else
						m_aStatText.members[j].text = "Melee ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMelee);
					
					if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[j].loadGraphic(imgSkillMelee);
				}
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_RANGED
							|| pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_RANGED)
				{
					if (pThisGuy.m_bRevealRanged)
						m_aStatText.members[j].text = "Ranged potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialRanged);
					else
						m_aStatText.members[j].text = "Ranged ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentRanged);
					
					if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[j].loadGraphic(imgSkillRanged);
				}
				else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC
							|| pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MAGIC)
				{
					if (pThisGuy.m_bRevealMagic)
						m_aStatText.members[j].text = "Magic potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMagic);
					else
						m_aStatText.members[j].text = "Magic ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMagic);
					
					if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[j].loadGraphic(imgSkillMagic);
				}
				
				if (!pThisGuy.m_bEliminationView && !pThisGuy.m_bReportView)
				{
					if (pThisGuy.m_iThisYearTraining >= pThisGuy.e_SKILL_ASSESS_DEFEND
						&& pThisGuy.m_iThisYearTraining <= pThisGuy.e_SKILL_ASSESS_MAGIC)
						m_aSkillText.members[j].text = "ASSESS";
					else if(pThisGuy.m_iThisYearTraining >= pThisGuy.e_SKILL_TRAIN_DEFEND
						&& pThisGuy.m_iThisYearTraining <= pThisGuy.e_SKILL_TRAIN_MAGIC)
						m_aSkillText.members[j].text = "TRAIN";
					else
						m_aSkillText.members[j].text = "";
				}
				else
					m_aSkillText.members[j].text = "";
			}
			
			m_tArrowUp.color = (m_iCurrentIndex == 0) ? 0x797979 : 0xffffff;
			m_tArrowDown.color = (m_iCurrentIndex + k_iNumEntriesOnScreen == PlayState.m_aParticipants.members.length) ? 0x797979 : 0xffffff;
		}
		
		public function setIsActive(bActive:Boolean):void
		{
			// Reset previous skill selections if setting up
			if (bActive)
			{
				for (var i:int = 0; i < PlayState.m_aParticipants.members.length; i++)
				{
					var pThisGuy:Participant = PlayState.m_aParticipants.members[i];
					if(pThisGuy.m_iThisYearTraining > pThisGuy.e_SKILL_DO_NOTHING)
						pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_DO_NOTHING;
				}
			
				m_iCurrentIndex = 0;
				m_iCurrentSelection = 0;
				m_tSelectArrow.y = m_aBackingBoxes.members[0].y;
				
				rePopulateList();
			}
			
			m_bActive = bActive;
			m_aGraphics.exists = m_bActive;
		}
		
		public function getIsActive():Boolean
		{
			return m_bActive;
		}
		
		public function moveSelectionUp():void
		{
			if	(m_iCurrentSelection > m_iCurrentIndex)
			{
				m_iCurrentSelection--;
				m_tSelectArrow.y = m_aBackingBoxes.members[m_iCurrentSelection - m_iCurrentIndex].y;
			}
			else if (m_iCurrentIndex > 0)
			{
				m_iCurrentIndex--;
				m_iCurrentSelection--;
				m_tSelectArrow.y = m_aBackingBoxes.members[m_iCurrentSelection - m_iCurrentIndex].y;
				rePopulateList();
			}
		}
		
		public function moveSelectionDown():void
		{
			if	(m_iCurrentSelection < m_iCurrentIndex + k_iNumEntriesOnScreen -1)
			{
				m_iCurrentSelection++;
				m_tSelectArrow.y = m_aBackingBoxes.members[m_iCurrentSelection - m_iCurrentIndex].y;
			}
			else if (m_iCurrentIndex + k_iNumEntriesOnScreen < PlayState.m_aParticipants.members.length)
			{
				m_iCurrentIndex++;
				m_iCurrentSelection++;
				m_tSelectArrow.y = m_aBackingBoxes.members[m_iCurrentSelection - m_iCurrentIndex].y;
				rePopulateList();
			}
		}
		
		public function toggleAssessment():void
		{
			var pThisGuy:Participant = PlayState.m_aParticipants.members[m_iCurrentSelection];
			if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_DO_NOTHING
				|| pThisGuy.m_iThisYearTraining > pThisGuy.e_SKILL_ASSESS_MAGIC)
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_ASSESS_DEFEND;
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_DO_NOTHING
			else
				pThisGuy.m_iThisYearTraining++;
				
			// Change image/stat text...
			var iIndex:int = m_iCurrentSelection - m_iCurrentIndex;
			if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_DO_NOTHING)
			{
				if (pThisGuy.m_iTraining1 && pThisGuy.m_iTraining2)
					m_aStatText.members[iIndex].text = "Class ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentClass);
				else
					m_aStatText.members[iIndex].text = "Overall ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentOverall);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillNone);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_DEFEND)
			{
				if (pThisGuy.m_bRevealDefend)
					m_aStatText.members[iIndex].text = "Defence potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialDefend);
				else
					m_aStatText.members[iIndex].text = "Defence ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentDefend);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillDefend);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MELEE)
			{
				if (pThisGuy.m_bRevealMelee)
					m_aStatText.members[iIndex].text = "Melee potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMelee);
				else
					m_aStatText.members[iIndex].text = "Melee ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMelee);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillMelee);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_RANGED)
			{
				if (pThisGuy.m_bRevealRanged)
					m_aStatText.members[iIndex].text = "Ranged potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialRanged);
				else
					m_aStatText.members[iIndex].text = "Ranged ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentRanged);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillRanged);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
			{
				if (pThisGuy.m_bRevealMagic)
					m_aStatText.members[iIndex].text = "Magic potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMagic);
				else
					m_aStatText.members[iIndex].text = "Magic ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMagic);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillMagic);
			}
				
			// Change text...
			if (pThisGuy.m_iThisYearTraining >= pThisGuy.e_SKILL_ASSESS_DEFEND
				&& pThisGuy.m_iThisYearTraining <= pThisGuy.e_SKILL_ASSESS_MAGIC)
				m_aSkillText.members[iIndex].text = "ASSESS";
			else
				m_aSkillText.members[iIndex].text = "";
		}
		
		public function toggleTraining():void
		{
			var pThisGuy:Participant = PlayState.m_aParticipants.members[m_iCurrentSelection];
			if (pThisGuy.m_iThisYearTraining < pThisGuy.e_SKILL_TRAIN_DEFEND)
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_TRAIN_DEFEND;
			else if (pThisGuy.m_iThisYearTraining >= pThisGuy.e_SKILL_TRAIN_MAGIC)
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_DO_NOTHING;
			else
				pThisGuy.m_iThisYearTraining++;
				
			// Change image/stat text...
			var iIndex:int = m_iCurrentSelection - m_iCurrentIndex;
			if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_DO_NOTHING)
			{
				if (pThisGuy.m_iTraining1 && pThisGuy.m_iTraining2)
					m_aStatText.members[iIndex].text = "Class ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentClass);
				else
					m_aStatText.members[iIndex].text = "Overall ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentOverall);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillNone);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_DEFEND)
			{
				if (pThisGuy.m_bRevealDefend)
					m_aStatText.members[iIndex].text = "Defence potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialDefend);
				else
					m_aStatText.members[iIndex].text = "Defence ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentDefend);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillDefend);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MELEE)
			{
				if (pThisGuy.m_bRevealMelee)
					m_aStatText.members[iIndex].text = "Melee potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMelee);
				else
					m_aStatText.members[iIndex].text = "Melee ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMelee);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillMelee);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_RANGED)
			{
				if (pThisGuy.m_bRevealRanged)
					m_aStatText.members[iIndex].text = "Ranged potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialRanged);
				else
					m_aStatText.members[iIndex].text = "Ranged ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentRanged);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillRanged);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_TRAIN_MAGIC)
			{
				if (pThisGuy.m_bRevealMagic)
					m_aStatText.members[iIndex].text = "Magic potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMagic);
				else
					m_aStatText.members[iIndex].text = "Magic ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMagic);
				
				m_aSkillImages.members[iIndex].loadGraphic(imgSkillMagic);
			}
			
			// Change text...
			if (pThisGuy.m_iThisYearTraining >= pThisGuy.e_SKILL_TRAIN_DEFEND
				&& pThisGuy.m_iThisYearTraining <= pThisGuy.e_SKILL_TRAIN_MAGIC)
				m_aSkillText.members[iIndex].text = "TRAIN";
			else
				m_aSkillText.members[iIndex].text = "";
		}
		
		public function toggleView():void
		{
			var pThisGuy:Participant = PlayState.m_aParticipants.members[m_iCurrentSelection];
			if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
				pThisGuy.m_iThisYearTraining = pThisGuy.e_SKILL_DO_NOTHING
			else
				pThisGuy.m_iThisYearTraining++;
				
			// Change image/stat text...
			var iIndex:int = m_iCurrentSelection - m_iCurrentIndex;
			if (pThisGuy.m_bEliminationView)
			{
				// ELIMINATION MODE special case
				var pGraphic:Class = pThisGuy.m_bEliminate ? imgCross : imgTick;
				m_aSkillImages.members[iIndex].loadGraphic(pGraphic);
			}
			
			if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_DO_NOTHING)
			{
				if (pThisGuy.m_iTraining1 && pThisGuy.m_iTraining2)
					m_aStatText.members[iIndex].text = "Class ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentClass);
				else
					m_aStatText.members[iIndex].text = "Overall ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentOverall);
				
				if (!pThisGuy.m_bEliminationView)
					m_aSkillImages.members[iIndex].loadGraphic(imgSkillNone);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_DEFEND)
			{
				if (pThisGuy.m_bRevealDefend)
					m_aStatText.members[iIndex].text = "Defence potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialDefend);
				else
					m_aStatText.members[iIndex].text = "Defence ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentDefend);
				
				if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[iIndex].loadGraphic(imgSkillDefend);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MELEE)
			{
				if (pThisGuy.m_bRevealMelee)
					m_aStatText.members[iIndex].text = "Melee potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMelee);
				else
					m_aStatText.members[iIndex].text = "Melee ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMelee);
				
				if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[iIndex].loadGraphic(imgSkillMelee);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_RANGED)
			{
				if (pThisGuy.m_bRevealRanged)
					m_aStatText.members[iIndex].text = "Ranged potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialRanged);
				else
					m_aStatText.members[iIndex].text = "Ranged ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentRanged);
				
				if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[iIndex].loadGraphic(imgSkillRanged);
			}
			else if (pThisGuy.m_iThisYearTraining == pThisGuy.e_SKILL_ASSESS_MAGIC)
			{
				if (pThisGuy.m_bRevealMagic)
					m_aStatText.members[iIndex].text = "Magic potential:  " + pThisGuy.getRatingStr(pThisGuy.m_iPotentialMagic);
				else
					m_aStatText.members[iIndex].text = "Magic ability:  " + pThisGuy.getRatingStr(pThisGuy.m_iCurrentMagic);
				
				if (!pThisGuy.m_bEliminationView)
						m_aSkillImages.members[iIndex].loadGraphic(imgSkillMagic);
			}
		}
		
		public function toggleElimination():void
		{
			var pThisGuy:Participant = PlayState.m_aParticipants.members[m_iCurrentSelection];

			var iIndex:int = m_iCurrentSelection - m_iCurrentIndex;
			if (pThisGuy.m_bEliminate)
			{
				pThisGuy.m_bEliminate = false;
				m_aSkillImages.members[iIndex].loadGraphic(imgTick);
			}
			else
			{
				pThisGuy.m_bEliminate = true;
				m_aSkillImages.members[iIndex].loadGraphic(imgCross);
			}
		}
		
		public function setYearText(sString:String):void
		{
			m_tYearText.text = sString;
		}
	}
}