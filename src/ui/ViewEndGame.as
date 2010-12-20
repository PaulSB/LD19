package ui 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 19/12/10
	 */
	public class ViewEndGame
	{
		[Embed(source = '../../data/ui/dialog_box.png')] private var imgBackingBox:Class;
		
		public var m_aGraphics:FlxGroup;
		
		// Graphic objects:
		private var m_tBackingBox:FlxSprite;
		private var m_tHeaderText:FlxText;
		private var m_tRatingHeaderText:FlxText;
		private var m_aParticipantSprites:FlxGroup;
		private var m_aNameText:FlxGroup;
		private var m_aClassText:FlxGroup;
		private var m_aClassImages:FlxGroup;
		private var m_aRatingText:FlxGroup;
		private var m_tResultsText:FlxText;
		private var m_tRemarksText:FlxText;
		
		private var m_bActive:Boolean = false;
		public var m_aFinalFive:FlxGroup;
		
		public function ViewEndGame() 
		{
			m_tBackingBox = new FlxSprite(0,90);
			m_tBackingBox.loadGraphic(imgBackingBox);
			m_tBackingBox.x = (FlxG.width - m_tBackingBox.width) * 0.5;
			
			m_tHeaderText = new FlxText(m_tBackingBox.x + 8, 10, m_tBackingBox.width -16, "The Five");
			m_tHeaderText.setFormat("Istria", 48, 0xfff2f2f2, "center");
			
			m_tRatingHeaderText = new FlxText(m_tBackingBox.x + m_tBackingBox.width - 80, m_tBackingBox.y -20, 80, "Rating");
			m_tRatingHeaderText.setFormat("Istria", 20, 0xfff2f2f2, "center");
			
			m_tResultsText = new FlxText(m_tBackingBox.x + 8, m_tBackingBox.y + 5, m_tBackingBox.width -16);
			m_tResultsText.setFormat("Istria", 32, 0xff2d1601, "center");
			
			m_tRemarksText = new FlxText(m_tResultsText.x, m_tBackingBox.y + 80, m_tResultsText.width);
			m_tRemarksText.setFormat("Istria", 24, 0xff2d1601, "left");
			
			m_aParticipantSprites = new FlxGroup;
			m_aNameText = new FlxGroup;
			m_aClassText = new FlxGroup;
			m_aRatingText = new FlxGroup;
			m_aClassImages = new FlxGroup;
			for (var i:int; i < 5; i++)
			{
				var tThisSprite:FlxSprite = new FlxSprite(m_tBackingBox.x + 5, m_tBackingBox.y + 60 * i);
				m_aParticipantSprites.add(tThisSprite);
				
				var tNames:FlxText = new FlxText(tThisSprite.x + 40, tThisSprite.y + 20, m_tBackingBox.width);
				tNames.setFormat("Istria", 20, 0xff2d1601, "left");
				m_aNameText.add(tNames);
				
				var tClass:FlxText = new FlxText(FlxG.width * 0.5 - 50, tNames.y -5, m_tBackingBox.width * 0.5);
				tClass.setFormat("Istria", 32, 0xff2d1601, "left");
				m_aClassText.add(tClass);
				
				var tClassSprite1:FlxSprite = new FlxSprite(tThisSprite.x, tThisSprite.y - 20);
				tClassSprite1.exists = false;
				var tClassSprite2:FlxSprite = new FlxSprite(tThisSprite.x - 20, tThisSprite.y - 20);
				tClassSprite2.exists = false;
				m_aClassImages.add(tClassSprite1);
				m_aClassImages.add(tClassSprite2);
				
				var tRating:FlxText = new FlxText(m_tRatingHeaderText.x, tNames.y -10, m_tRatingHeaderText.width);
				tRating.setFormat("Istria", 48, 0xff2d1601, "center");
				m_aRatingText.add(tRating);
			}
			
			m_aGraphics = new FlxGroup;
			m_aGraphics.add(m_tBackingBox);
			m_aGraphics.add(m_tHeaderText);
			m_aGraphics.add(m_tRatingHeaderText);
			m_aGraphics.add(m_aNameText);
			m_aGraphics.add(m_aClassText);
			m_aGraphics.add(m_aRatingText);
			m_aGraphics.add(m_aParticipantSprites);
			m_aGraphics.add(m_aClassImages);
			m_aGraphics.add(m_tResultsText);
			m_aGraphics.add(m_tRemarksText);
			m_aGraphics.exists = false;
			
			m_aFinalFive = new FlxGroup;
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
		
		public function setPreview():void
		{
			for (var i:int; i < 5; i++)
			{
				var pThisGuy:Participant = m_aFinalFive.members[i];
				m_aParticipantSprites.members[i].loadGraphic(pThisGuy.imgParticipant);
				
				m_aNameText.members[i].text = pThisGuy.m_sForename + " " + pThisGuy.m_sSurname;
				
				m_aClassText.members[i].text = pThisGuy.getClassName();
				
				m_aRatingText.members[i].text = pThisGuy.m_iCurrentClass.toString();
				
				m_aClassImages.members[i * 2].y += m_aParticipantSprites.members[i].height
				m_aClassImages.members[i * 2 +1].x += m_aParticipantSprites.members[i].width
				m_aClassImages.members[i * 2 +1].y += m_aParticipantSprites.members[i].height
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
					m_aClassImages.members[i * 2].loadGraphic(pClassGraphic);
					m_aClassImages.members[i * 2].exists = true;
					
					if (pThisGuy.m_tTrainingImg2.exists)
					{
						switch(pThisGuy.m_iTraining2)
						{
							case pThisGuy.e_SKILL_TRAIN_DEFEND:	pClassGraphic = pThisGuy.imgDefend; break;
							case pThisGuy.e_SKILL_TRAIN_MELEE:	pClassGraphic = pThisGuy.imgMelee; break;
							case pThisGuy.e_SKILL_TRAIN_RANGED:	pClassGraphic = pThisGuy.imgRanged; break;
							case pThisGuy.e_SKILL_TRAIN_MAGIC:	pClassGraphic = pThisGuy.imgMagic; break;
						}
						m_aClassImages.members[i * 2 +1].loadGraphic(pClassGraphic);
						m_aClassImages.members[i * 2 +1].exists = true;
					}
					else
						m_aClassImages.members[i * 2 +1].exists = false;
				}
				else
				{
					m_aClassImages.members[i * 2].exists = false;
					m_aClassImages.members[i * 2 +1].exists = false;
				}
			}
		}
		
		public function setResults():void
		{
			m_tRatingHeaderText.exists = false;
			m_aNameText.exists = false;
			m_aClassText.exists = false;
			m_aRatingText.exists = false;
			m_aParticipantSprites.exists = false;
			m_aClassImages.exists = false;
			
			//m_tResultsText.exists = true;
			
			var iTotalRating:int = 0;
			var bClasslessChars:Boolean = false;
			for (var i:int; i < 5; i++)
			{
				var pThisGuy:Participant = m_aFinalFive.members[i];
				iTotalRating += pThisGuy.m_iCurrentClass;
				
				if (!bClasslessChars && (!pThisGuy.m_iTraining1 || !pThisGuy.m_iTraining2))
					bClasslessChars = true;
			}
			
			m_tResultsText.text = "Overall team ability: " + iTotalRating.toString() + " ";
			if(iTotalRating > 420)
				m_tResultsText.text = m_tResultsText.text.concat("(Excellent!)");
			else if (iTotalRating > 340)
				m_tResultsText.text = m_tResultsText.text.concat("(Good)");
			else if (iTotalRating > 260)
				m_tResultsText.text = m_tResultsText.text.concat("(Okay)");
			else if (iTotalRating > 180)
				m_tResultsText.text = m_tResultsText.text.concat("(Poor)");
			else
				m_tResultsText.text = m_tResultsText.text.concat("(Unprepared!)");
			
			m_tRemarksText.text = "Remarks:\n";
			if (bClasslessChars)
				m_tRemarksText.text = m_tRemarksText.text.concat("-Some party members have not trained a full class!\n");
		}
		
		public function setFinale():void
		{
			var iTotalDefend:int = 0;
			var iTotalHeal:int = 0;
			var iTotalDamage:int = 0;
			for (var i:int; i < 5; i++)
			{
				var pThisGuy:Participant = m_aFinalFive.members[i];
				switch(pThisGuy.m_iTraining1)
				{
					case pThisGuy.e_SKILL_TRAIN_DEFEND:	iTotalDefend += pThisGuy.m_iCurrentDefend; break;
					case pThisGuy.e_SKILL_TRAIN_MAGIC:	iTotalHeal   += pThisGuy.m_iCurrentMagic; break;
					case pThisGuy.e_SKILL_TRAIN_MELEE:	iTotalDamage += pThisGuy.m_iCurrentMelee; break;
					case pThisGuy.e_SKILL_TRAIN_RANGED:	iTotalDamage += pThisGuy.m_iCurrentRanged; break;
				}
				switch(pThisGuy.m_iTraining2)
				{
					case pThisGuy.e_SKILL_TRAIN_DEFEND:	iTotalDefend += pThisGuy.m_iCurrentDefend; break;
					case pThisGuy.e_SKILL_TRAIN_MAGIC:	iTotalHeal 	 += pThisGuy.m_iCurrentMagic; break;
					case pThisGuy.e_SKILL_TRAIN_MELEE:	iTotalDamage += pThisGuy.m_iCurrentMelee; break;
					case pThisGuy.e_SKILL_TRAIN_RANGED:	iTotalDamage += pThisGuy.m_iCurrentRanged; break;
				}
			}
			
			var bHealingTest:Boolean = (iTotalHeal >= 100);
			var bDefendTest:Boolean = ((iTotalDefend + iTotalHeal * 0.5) >= 300);
			var bDamageTest:Boolean = (iTotalDamage >= 400);
			var bWin:Boolean = false;
			
			m_tResultsText.text = "The Five met the Demon Lord that Winter, hoping they were prepared.\n\n";
			if (bDefendTest)
			{
				m_tRemarksText.text = "The battle was hard-fought: the resilience of The Five was remarkable in the face of the Demon Lord.\n";
				
				if (bHealingTest)
				{
					m_tRemarksText.text = m_tRemarksText.text.concat("Thanks to those bearing the gift of magic, they held their assault with strength.\n");
					
					if (bDamageTest)
					{
						m_tRemarksText.text = m_tRemarksText.text.concat("As they lay siege to the monstrous Lord, fearing that they might not be able to carry on much longer, the beast fell!\n");
						bWin = true;
					}
					else
						m_tRemarksText.text = m_tRemarksText.text.concat("The Five continued to absorb the attacks of the fiend, but their stamina waned. They did not have enough to deal the killing blow.\n");
				}
				else
					m_tRemarksText.text = m_tRemarksText.text.concat("But The Five and their shields could not stand forever. The Winds of Magic need to cast more favour against one such as the Demon Lord.\n");
			}
			else
				m_tRemarksText.text = "The battle did not last long: the sheer force of the Demon Lord quickly scattered the Five and their insufficient defences.\n";
			
			if (bWin)
				m_tRemarksText.text = m_tRemarksText.text.concat("VICTORY! The land is saved!");
			else
				m_tRemarksText.text = m_tRemarksText.text.concat("FAILURE. The Five have fallen... the land is doomed.");
		}
	}
}