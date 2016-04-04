package stringify 
{
	import stringify.FontTexture;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class StringifyBmp 
	{
		
		public function StringifyBmp() 
		{
			
		}
		
		/**
		 * stingify to a monochrome bitmapdata
		 * @param source source bitmapdata
		 * @param bmpFont font texture to use
		 * @param color the color of the text
		 * @param applyAlphaWeigthToColor if it should take into account the alpha weigth
		 * @return stringified bitmapda
		 */	
		
		public static function monochromed(source:BitmapData, bmpFont:FontTexture, color:uint, applyAlphaWeigthToColor:Boolean = true):BitmapData		
		{			
			var result:BitmapData = BitmapDataProccesing.binarizeWithAlphaRatio(source);
			
			var rect:Rectangle = new Rectangle(0, 0, bmpFont.getSize(), bmpFont.getSize());			
			var dest:Point = new Point();
			
			var bgColor:uint = 0xffffff - color;
			
			rect.width = rect.height = bmpFont.getSize();
			
			for (var row:uint = 0; row < uint(source.height / bmpFont.getSize()); row++ ) {
				for (var col:uint = 0; col < uint(source.width / bmpFont.getSize()); col++ ) {
					var x:uint = col * bmpFont.getSize();
					var y:uint = row * bmpFont.getSize();
					
					rect.x = x;
					rect.y = y;						
					
					var sourceAlphaWeight:Number = BitmapDataHelper.getAlphaWeight(result, rect);
					
					var alphaMultiplier:Number = 1;
					if (applyAlphaWeigthToColor) { alphaMultiplier = sourceAlphaWeight; }
					
					var charTexture:BitmapData = bmpFont.getCharTextureWithAlphaWeight(sourceAlphaWeight, color, alphaMultiplier);					
					var bgTexture:BitmapData = new BitmapData(bmpFont.getSize(), bmpFont.getSize(), false, bgColor);										
										
					dest.x = x;
					dest.y = y;
					
					rect.x = rect.y = 0;					
					
					result.copyPixels(bgTexture, rect, dest, null, null, true);
					result.copyPixels(charTexture, rect, dest, null, null, true);
					
					charTexture.dispose();
					charTexture = null;
				}
			}
			
			rect = null;
			dest = null;			
			
			return result;			
		}
		
		/**
		 * stingify to a colorized bitmapdata
		 * @param source source bitmapdata
		 * @param bmpFont font texture to use
		 * @param bgColor the background color of the text
		 * @param applyAlphaWeigthToColor if it should take into account the alpha weigth
		 * @return stringified bitmapda
		 */			
		
		public static function colorized(source:BitmapData, bmpFont:FontTexture, bgColor:uint = 0x000000, applyAlphaWeigthToColor:Boolean = true):BitmapData		
		{			
			var result:BitmapData = BitmapDataProccesing.binarizeWithAlphaRatio(source);
			
			var rect:Rectangle = new Rectangle(0, 0, bmpFont.getSize(), bmpFont.getSize());			
			var dest:Point = new Point();			
			
			rect.width = rect.height = bmpFont.getSize();
			
			for (var row:uint = 0; row < uint(source.height / bmpFont.getSize()); row++ ) {
				for (var col:uint = 0; col < uint(source.width / bmpFont.getSize()); col++ ) {
					var x:uint = col * bmpFont.getSize();
					var y:uint = row * bmpFont.getSize();
					
					rect.x = x;
					rect.y = y;						
					
					var sourceAlphaWeight:Number = BitmapDataHelper.getAlphaWeight(result, rect);
					
					var alphaMultiplier:Number = 1;
					if (applyAlphaWeigthToColor) { alphaMultiplier = sourceAlphaWeight; }					
					
					var charTexture:BitmapData = bmpFont.getCharTextureWithAlphaWeight(sourceAlphaWeight, BitmapDataHelper.getAverageColor(source, rect), alphaMultiplier);					
					var bgTexture:BitmapData = new BitmapData(bmpFont.getSize(), bmpFont.getSize(), false, bgColor);		
										
					dest.x = x;
					dest.y = y;
					
					rect.x = rect.y = 0;					
					
					result.copyPixels(bgTexture, rect, dest, null, null, true);
					result.copyPixels(charTexture, rect, dest, null, null, true);
					
					charTexture.dispose();
					charTexture = null;
				}
			}
			
			rect = null;
			dest = null;			
			
			return result;			
		}	
		
	}

}