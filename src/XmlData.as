package  
{
	import flash.utils.ByteArray;
	import org.flixel.FlxU;
	/**
	 * LD19 - "Discovery"
	 * @author Paul S Burgess - 19/12/10
	 */
	public class XmlData
	{
		[Embed(source='../data/xml/data.xml', mimeType="application/octet-stream")] public static const xmlFile:Class; 
	
		private var m_tXmlData:XML;
		
		static public var m_aForenames:Array;
		static public var m_aSurnames:Array;
		static public var m_aYearStartText:Array;
		
		public function XmlData() 
		{
			m_aForenames = new Array;
			m_aSurnames = new Array;
			m_aYearStartText = new Array;
			
			processXML();
		}
		
		private function processXML():void
		{
			var file:ByteArray = new xmlFile;
			var str:String = file.readUTFBytes( file.length );
			m_tXmlData = new XML(str);
			
			for (var i:int = 0; i < 50; i++)
			{
				var iNameIndex:int = FlxU.random() * m_tXmlData.Names.Forename.length();
				m_aForenames.push(m_tXmlData.Names.Forename[iNameIndex]);
				
				iNameIndex = FlxU.random() * m_tXmlData.Names.Surname.length();
				m_aSurnames.push(m_tXmlData.Names.Surname[iNameIndex]);
			}
			
			for (i = 0; i < m_tXmlData.YearStartText.Text.length(); i++)
			{
				m_aYearStartText.push(m_tXmlData.YearStartText.Text[i]);
			}
		}
	}
}