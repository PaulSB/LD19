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
		
		[Embed(source = '../data/ui/train_defend.png')] public var imgDefend:Class;
		[Embed(source = '../data/ui/train_melee.png')] public var imgMelee:Class;
		[Embed(source = '../data/ui/train_ranged.png')] public var imgRanged:Class;
		[Embed(source = '../data/ui/train_magic.png')] public var imgMagic:Class;
		
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
		
		public var m_tTrainingImg1:FlxSprite;
		public var m_tTrainingImg2:FlxSprite;
		public var m_iTraining1:int = 0;
		public var m_iTraining2:int = 0;
		
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
		public var m_iCurrentClass:int = 0;
		
		public var m_bRevealDefend:Boolean = false;
		public var m_bRevealMelee:Boolean = false;
		public var m_bRevealRanged:Boolean = false;
		public var m_bRevealMagic:Boolean = false;
		
		public var m_bTrainedDefend:Boolean = false;
		public var m_bTrainedMelee:Boolean = false;
		public var m_bTrainedRanged:Boolean = false;
		public var m_bTrainedMagic:Boolean = false;
		
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
			
			m_tTrainingImg1 = new FlxSprite(x, y + height - 20);
			m_tTrainingImg1.exists = false;
			m_tTrainingImg2 = new FlxSprite(x + width - 20, y + height - 20);
			m_tTrainingImg2.exists = false;	
			
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
			
			m_tTrainingImg1.y = y + height - 20;
			m_tTrainingImg2.y = y + height - 20;
			
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
		
		public function getClassName():String
		{
			if (m_iTraining1 == 0)
			{
				return "";
			}
			else if (m_iTraining2 == 0)
			{
				switch(m_iTraining1)
				{
					case e_SKILL_TRAIN_DEFEND:	return "defence trainee";
					case e_SKILL_TRAIN_MELEE:	return "melee trainee";
					case e_SKILL_TRAIN_RANGED:	return "ranged trainee";
					case e_SKILL_TRAIN_MAGIC:	return "magic trainee";
				}
			}
			else
			{
				if (m_iTraining1 == e_SKILL_TRAIN_DEFEND)
				{
					switch(m_iTraining2)
					{
						case e_SKILL_TRAIN_MELEE:	return "KNIGHT";
						case e_SKILL_TRAIN_RANGED:	return "GUARDIAN";
						case e_SKILL_TRAIN_MAGIC:	return "PALADIN";
					}
				}
				else if (m_iTraining1 == e_SKILL_TRAIN_MELEE)
				{
					switch(m_iTraining2)
					{
						case e_SKILL_TRAIN_DEFEND:	return "KNIGHT";
						case e_SKILL_TRAIN_RANGED:	return "RANGER";
						case e_SKILL_TRAIN_MAGIC:	return "BATTLE MAGE";
					}
				}
				else if (m_iTraining1 == e_SKILL_TRAIN_RANGED)
				{
					switch(m_iTraining2)
					{
						case e_SKILL_TRAIN_DEFEND:	return "GUARDIAN";
						case e_SKILL_TRAIN_MELEE:	return "RANGER";
						case e_SKILL_TRAIN_MAGIC:	return "WIZARD";
					}
				}
				else if (m_iTraining1 == e_SKILL_TRAIN_MAGIC)
				{
					switch(m_iTraining2)
					{
						case e_SKILL_TRAIN_DEFEND:	return "PALADIN";
						case e_SKILL_TRAIN_MELEE:	return "BATTLE MAGE";
						case e_SKILL_TRAIN_RANGED:	return "WIZARD";
					}
				}
			}
			
			return "";
		}
		
		public function setClassRating():void
		{
			var iRating1:int = 0;
			var iRating2:int = 0;
			switch(m_iTraining1)
			{
				case e_SKILL_TRAIN_DEFEND:	iRating1 = m_iCurrentDefend;	break;
				case e_SKILL_TRAIN_MELEE:	iRating1 = m_iCurrentMelee;		break;
				case e_SKILL_TRAIN_RANGED:	iRating1 = m_iCurrentRanged;	break;
				case e_SKILL_TRAIN_MAGIC:	iRating1 = m_iCurrentMagic;		break;
			}
			switch(m_iTraining2)
			{
				case e_SKILL_TRAIN_DEFEND:	iRating2 = m_iCurrentDefend;	break;
				case e_SKILL_TRAIN_MELEE:	iRating2 = m_iCurrentMelee;		break;
				case e_SKILL_TRAIN_RANGED:	iRating2 = m_iCurrentRanged;	break;
				case e_SKILL_TRAIN_MAGIC:	iRating2 = m_iCurrentMagic;		break;
			}
			
			m_iCurrentClass = (iRating1 + iRating2) / 2.0;
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