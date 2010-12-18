package ui 
{
	import states.PlayState;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 18/12/10
	 */
	public class ViewParticipants
	{
		public var m_bActive:Boolean = false;
		
		private var m_aCurrentParticipants:Array;
		private var iCurrentIndex:int = 0;	// Index into array of participants
		
		public function ViewParticipants() 
		{
			m_aCurrentParticipants = new Array;
			for (var i:int = 0; i < iCurrentIndex; i++)
				m_aCurrentParticipants.push(PlayState.m_aParticipants[iCurrentIndex + i]);
		}
	}
}