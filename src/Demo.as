package 
{
	import stringify.FontTexture;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import stringify.BitmapDataProccesing;
	import stringify.StringifyBmp;
	
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	
	public class Demo extends Sprite
	{
		
		public function Demo() 
		{	
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var b:FontTexture = new FontTexture(Assets.getBitmapData(Assets.ZX_FONT_BMP), Assets.getXML(Assets.ZX_FONT_DATA));	

			var bmp:BitmapData = Assets.getBitmapData(Assets.BATMAN_SUPERMAN_BMP);
												
			var a:StringifyBmp
			var stringifiedV1:Bitmap = new Bitmap(StringifyBmp.monochromed(bmp, b, 0xffffff, false));
			var stringifiedV2:Bitmap = new Bitmap(StringifyBmp.monochromed(bmp, b, 0xffffff, true));
			var stringifiedV3:Bitmap = new Bitmap(StringifyBmp.colorized(bmp, b, 0x000000, false));
			var stringifiedV4:Bitmap = new Bitmap(StringifyBmp.colorized(bmp, b, 0x000000, true));			
			
			stringifiedV1.x = 0;
			stringifiedV1.y = 0;
			
			stringifiedV2.x = 640;
			stringifiedV2.y = 0;			
			
			stringifiedV3.x = 0;
			stringifiedV3.y = 360;
			
			stringifiedV4.x = 640;
			stringifiedV4.y = 360;
			
			addChild(stringifiedV1);
			addChild(stringifiedV2);
			addChild(stringifiedV3);
			addChild(stringifiedV4);			
		}
		
	}

}