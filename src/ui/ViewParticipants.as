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
		
		private const k_iNumEntriesOnScreen:int = 10;
		
		public var m_aGraphics:FlxGroup;
		
		// Graphic objects:
		private var m_aBackingBoxes:FlxGroup;
		private var m_tArrowUp:FlxSprite;
		private var m_tArrowDown:FlxSprite;
		private var m_tSelectArrow:FlxSprite;
		private var m_aParticipantSprites:FlxGroup;
		private var m_aIndexText:FlxGroup;
		private var m_aNameText:FlxGroup;
		private var m_aStatText:FlxGroup;
		
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
			
			// First time build list
			populateList();
			
			m_aGraphics = new FlxGroup;
			m_aGraphics.add(m_aBackingBoxes);
			m_aGraphics.add(m_aParticipantSprites);
			m_aGraphics.add(m_aIndexText);
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
				
				var tNames:FlxText = new FlxText(tText.x + 100, tText.y, pThisBox.width, pThisGuy.m_sForename + " " + pThisGuy.m_sSurname);
				tNames.setFormat("Istria", 20, 0xff2d1601, "left");
				m_aNameText.add(tNames);
				
				// Showing overall ability
				var tStat:FlxText = new FlxText(FlxG.width * 0.5, tText.y, FlxG.width * 0.5,
												"Overall ability:  " + pThisGuy.GetRatingStr(pThisGuy.m_iCurrentOverall));
				tStat.setFormat("Istria", 20, 0xff2d1601, "left");
				m_aStatText.add(tStat);
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
				
				var iID:int = m_iCurrentIndex + j +1;
				m_aIndexText.members[j].text = iID.toString();
				
				m_aNameText.members[j].text = pThisGuy.m_sForename + " " + pThisGuy.m_sSurname;
				
				m_aStatText.members[j].text = "Overall ability:  " + pThisGuy.GetRatingStr(pThisGuy.m_iCurrentOverall);
			}
			
			m_tArrowUp.color = (m_iCurrentIndex == 0) ? 0x797979 : 0xffffff;
			m_tArrowDown.color = (m_iCurrentIndex + k_iNumEntriesOnScreen == PlayState.m_aParticipants.members.length) ? 0x797979 : 0xffffff;
		}
		
		public function setIsActive(bActive:Boolean):void
		{
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
				rePopulateList();
			}
		}
	}
}