package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import states.PlayState;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	public class ViewParticipants
	{
		[Embed(source = '../../data/ui/participant_info.png')] private var imgInfoBox:Class;
		[Embed(source = '../../data/ui/arrow_large.png')] private var imgArrow:Class;
		
		private const k_iNumEntriesOnScreen:int = 10;
		
		public var m_bActive:Boolean = false;
		public var m_aGraphics:FlxGroup;
		
		private var m_tBackingBoxes:FlxGroup;
		private var m_tSelectArrow:FlxSprite;
		private var m_tParticipantSprites:FlxGroup;
		
		private var m_aCurrentParticipants:FlxGroup;
		private var m_iCurrentIndex:int = 0;	// Index into array of participants
		
		public function ViewParticipants() 
		{				
			m_tBackingBoxes = new FlxGroup;
			var fY:Number = 40;
			for (var j:int = 0; j < k_iNumEntriesOnScreen; j++)
			{
				var tBox:FlxSprite = new FlxSprite(0,fY);
				tBox.loadGraphic(imgInfoBox);
				tBox.x = (FlxG.width - tBox.width) * 0.5;
				
				m_tBackingBoxes.add(tBox);
				fY += tBox.height;
			}
			
			m_tSelectArrow = new FlxSprite(m_tBackingBoxes.members[0].x + m_tBackingBoxes.members[0].width, m_tBackingBoxes.members[0].y);
			m_tSelectArrow.loadGraphic(imgArrow);
			
			populateList();			
			
			m_aGraphics = new FlxGroup;
			m_aGraphics.add(m_tBackingBoxes);
			m_aGraphics.add(m_tParticipantSprites);
			m_aGraphics.add(m_tSelectArrow);
		}
		
		private function populateList():void
		{
			m_aCurrentParticipants = new FlxGroup;
			for (var i:int = m_iCurrentIndex; i < k_iNumEntriesOnScreen; i++)
				m_aCurrentParticipants.add(PlayState.m_aParticipants.members[i]);
				
			m_tParticipantSprites = new FlxGroup;
			for (var j:int = 0; j < k_iNumEntriesOnScreen; j++)
			{
				var pThisBox:FlxSprite = m_tBackingBoxes.members[j];
				var pThisGuy:Participant = m_aCurrentParticipants.members[j];
				var iXOffset:int = (j % 2) ? pThisGuy.width : 0;
				var tThisSprite:FlxSprite = new FlxSprite(pThisBox.x +8 +iXOffset, pThisBox.y -8);
				tThisSprite.loadGraphic(pThisGuy.imgParticipant);
				
				m_tParticipantSprites.add(tThisSprite);
			}
		}
	}
}