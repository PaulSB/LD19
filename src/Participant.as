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
		
		// Constants:
		public const e_SKILL_DO_NOTHING:int = 0;
		public const e_SKILL_ASSESS_DEFEND:int = 1;
		public const e_SKILL_ASSESS_MELEE:int = 2;
		public const e_SKILL_ASSESS_RANGED:int = 3;
		public const e_SKILL_ASSESS_MAGIC:int = 4;
		public const e_SKILL_TRAIN_DEFEND:int = 5;
		public const e_SKILL_TRAIN_MELEE:int = 6;
		public const e_SKILL_TRAIN_RANGED:int = 7;
		public const e_SKILL_TRAIN_MAGIC:int = 8;
		
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
		
		public var m_iThisYearTraining:int;
		
		public function Participant(fYPos:Number) 
		{
			super(0, fYPos);
			loadGraphic(imgParticipant);
			
			x = FlxU.random() * (FlxG.width - width);
			
			// Set attributes:		
			m_sForename = XmlData.m_aForenames.shift();
			m_sSurname = XmlData.m_aSurnames.shift();
			
			m_iPotentialDefend = 100 * FlxU.random();
			m_iPotentialMelee = 100 * FlxU.random();
			m_iPotentialRanged = 100 * FlxU.random();
			m_iPotentialMagic = 100 * FlxU.random();
			m_iPotentialOverall = (m_iPotentialDefend + m_iPotentialMelee + m_iPotentialRanged + m_iPotentialMagic) / 4;
			
			// Ability as per year 1/5
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