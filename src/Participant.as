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
		
		private var m_fFixedYPos:Number;
		private var m_fWobbleTimer:Number;
		private var m_bWobbleUp:Boolean;
		
		// STATS:
		private var m_iAge:int = 1;	// equal to current year, max 5
		
		public var m_iPotentialDefend:int;
		public var m_iPotentialMelee:int;
		public var m_iPotentialRanged:int;
		public var m_iPotentialMagic:int;
		public var m_iPotentialOverall:int;

		public var m_iCurrentDefend:int;
		public var m_iCurrentMelee:int;
		public var m_iCurrentRanged:int;
		public var m_iCurrentMagic:int;
		public var m_iCurrentOverall:int;
		
		public var m_bRevealDefend:Boolean;
		public var m_bRevealMelee:Boolean;
		public var m_bRevealRanged:Boolean;
		public var m_bRevealMagic:Boolean;
		
		public var m_iThisYearTraining:int;
		public var m_bReportView:Boolean = false;
		public var m_bEliminationView:Boolean = false;
		public var m_bEliminate:Boolean = false;
		
		public function Participant(fYPos:Number) 
		{
			super(0, fYPos);
			loadGraphic(imgParticipant);
			
			x = FlxU.random() * (FlxG.width - width);
			y -= height - 16;
			m_fFixedYPos = y;
			
			m_fWobbleTimer = (FlxU.random() - 0.5) * 2;	// -1 to +1
			m_bWobbleUp = (m_fWobbleTimer > 0);
			
			// Set attributes:		
			m_sForename = XmlData.m_aForenames.shift();
			m_sSurname = XmlData.m_aSurnames.shift();
			
			m_iPotentialDefend = 100 * FlxU.random();
			m_iPotentialMelee = 100 * FlxU.random();
			m_iPotentialRanged = 100 * FlxU.random();
			m_iPotentialMagic = 100 * FlxU.random();
			m_iPotentialOverall = (m_iPotentialDefend + m_iPotentialMelee + m_iPotentialRanged + m_iPotentialMagic) / 4;
			
			// Ability as per year 1/5
			var fMod:Number = m_iAge / 5.0;
			m_iCurrentDefend = m_iPotentialDefend * fMod;
			m_iCurrentMelee = m_iPotentialMelee * fMod;
			m_iCurrentRanged = m_iPotentialRanged * fMod;
			m_iCurrentMagic = m_iPotentialMagic * fMod;
			m_iCurrentOverall = m_iPotentialOverall * fMod;
		}
		
		override public function update():void 
		{
			if (m_bWobbleUp)
				m_fWobbleTimer -= FlxG.elapsed;
			else
				m_fWobbleTimer += FlxG.elapsed;
			
			if (m_fWobbleTimer > 1.0)
				m_bWobbleUp = true;
			else if (m_fWobbleTimer < -1.0)
				m_bWobbleUp = false;
			
			y = (m_bWobbleUp) ? (m_fFixedYPos - 2 ): (m_fFixedYPos + 2);
			
			super.update();
		}
		
		public function getRatingStr(iScore:int):String
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
		
		public function ageOneYear():void
		{
			m_iAge++;
			
			var fMod:Number = m_iAge / 5.0;
			m_iCurrentDefend = m_iPotentialDefend * fMod;
			m_iCurrentMelee = m_iPotentialMelee * fMod;
			m_iCurrentRanged = m_iPotentialRanged * fMod;
			m_iCurrentMagic = m_iPotentialMagic * fMod;
			m_iCurrentOverall = m_iPotentialOverall * fMod;
			
			m_bReportView = true;
		}
	}
}