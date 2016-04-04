package stringify 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import stringify.BitmapDataHelper;
	/**
	 * @author Ionut Ghenade
	 * 
	 * Takes a bitmap font and parse it for use
	 */
	public class FontTexture 
	{
		private var _face:String;
		private var _size:uint;
		private var _texture:BitmapData;
		
		private var _charPositions:Dictionary;
		private var _charPixelWeights:Dictionary;
		private var _charAlphaWeights:Dictionary;
		
		private var _rect:Rectangle;
		private var _point:Point;		
		
		public function FontTexture(texture:BitmapData, data:XML) 
		{
			_rect = new Rectangle();
			_point = new Point();
			
			inflateTexture(texture, data);
		}
		
		public function getTexture():BitmapData	{ return _texture; }
		
		public function getSize():uint { return _size; }
		
		public function getCharTexture(char:String, color:uint = 0xffffff, alpha:Number = 1):BitmapData
		{
			var charTexture:BitmapData = new BitmapData(_size, _size, true, 0x00ffffff);
			
			var position:Point = _charPositions[char];
						
			_rect.x = position.x;
			_rect.y = position.y;
			_rect.width = _rect.height = _size;
			
			_point.x = _point.y = 0;
			
			charTexture.copyPixels(_texture, _rect, _point);
			
			BitmapDataHelper.colorize(charTexture, color, alpha);
			
			return charTexture;
		}
		
		public function getCharTextureWithAlphaWeight(value:Number, color:uint, alpha:Number = 1):BitmapData
		{
			return getCharTexture(getClosestCharWithAlphaWeigth(value), color, alpha);
		}
		
		// inflates the input texture generated BMFont generator as a monospaced font		
		private function inflateTexture(texture:BitmapData, data:XML):void
		{						
			_face = data.info.@face;
			_size = uint(data.info.@size);
			
			var charNums:uint = uint(data.chars.@count);
			
			var inflatedTextureSize:uint = 2;
			while (inflatedTextureSize * inflatedTextureSize < charNums * _size * _size) { inflatedTextureSize = inflatedTextureSize << 1; }
						
			_texture = new BitmapData(inflatedTextureSize, inflatedTextureSize, true, 0x00ffffff);
			_charPositions = new Dictionary();
			_charPixelWeights = new Dictionary();
			_charAlphaWeights = new Dictionary();			
			
			var col:uint = 0;
			var row:uint = 0;
			
			for each(var charInfo:XML in data.chars.children()) {				
				_rect.x = uint(charInfo.@x);
				_rect.y = uint(charInfo.@y);
				_rect.width = uint(charInfo.@width);
				_rect.height = uint(charInfo.@height);
				
				_point.x = col * _size + uint(charInfo.@xoffset);
				_point.y = row * _size + uint(charInfo.@yoffset);
								
				_texture.copyPixels(texture, _rect, _point);
				
				var char:String = String.fromCharCode(uint(charInfo.@id));				
				
				_rect.x = _point.x;
				_rect.y = _point.y;
				_rect.width = _rect.height = _size;
				
				_charPositions[char] = new Point(col * _size, row * _size);
				_charPixelWeights[char] = BitmapDataHelper.getPixelWeight(_texture, _rect);
				_charAlphaWeights[char] = BitmapDataHelper.getAlphaWeight(_texture, _rect);
				
				if(col < texture.width / _size - 1) {
					col++;
				} else {
					row++;
					col = 0;
				}							
			}
		}	
		
		private function getClosestCharWithAlphaWeigth(value:Number):String
		{
			var char:String = " ";
			
			var diff:Number = 1;
			for (var key:String in _charAlphaWeights) {
				var currentDiff:Number = Math.abs(value - _charAlphaWeights[key]);
				if (currentDiff < diff) { diff = currentDiff; char = key; }
				
			}
			
			return char;		
		}			
	}
}