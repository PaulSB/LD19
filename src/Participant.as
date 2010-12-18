package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	
	public class Participant extends FlxSprite
	{
		[Embed(source = '../data/characters/participant.png')] public var imgParticipant:Class;
		
		public var m_sForename:String;
		public var m_sSurname:String;
		
		// STATS:
		private var m_iPotentialDefend:int;
		private var m_iPotentialMelee:int;
		private var m_iPotentialRanged:int;
		private var m_iPotentialMagic:int;
		private var m_iPotentialOverall:int;

		public var m_iCurrentDefend:int;
		public var m_iCurrentMelee:int;
		public var m_iCurrentRanged:int;
		public var m_iCurrentMagic:int;
		public var m_iCurrentOverall:int;
		
		public function Participant(fYPos:Number) 
		{
			super(0, fYPos);
			loadGraphic(imgParticipant);
			
			x = FlxU.random() * (FlxG.width - width);
			
			// Set attributes: TO DO: REPLACE HARCODED CRAP!
			m_sForename = "Sanjiv";
			m_sSurname = "Lal";
			
			m_iPotentialDefend = 50;
			m_iPotentialMelee = 50;
			m_iPotentialRanged = 50;
			m_iPotentialMagic = 50;
			m_iPotentialOverall = (m_iPotentialDefend + m_iPotentialMelee + m_iPotentialRanged + m_iPotentialMagic) / 4;
			
			m_iCurrentDefend = m_iPotentialDefend * 0.2;
			m_iCurrentMelee = m_iPotentialMelee * 0.2;
			m_iCurrentRanged = m_iPotentialRanged * 0.2;
			m_iCurrentMagic = m_iPotentialMagic * 0.2;
			m_iCurrentOverall = m_iPotentialOverall * 0.2;
		}
		
		public function GetRatingStr(iScore:int):String
		{
			if(iScore < 20)
				return "Terrible";
			else if(iScore < 40)
				return "Poor";
			else if(iScore < 60)
				return "Okay";
			else if(iScore < 80)
				return "Good";
			else
				return "Excellent";
		}
	}
}