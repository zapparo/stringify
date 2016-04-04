#stringify

Tranform any image into a stringified version of it using an 8bit monospaced bitmap font.

[![original](http://i.imgur.com/EG49dGz.jpg)](#)
## Usage
``` actionscript
// top left corner - monochrome
var stringified1:Bitmap = new Bitmap(StringifyBmp.monochromed(original, bmpFont, 0xffffff, false));
// top right corner - monochrome with alpha weigth
var stringified2:Bitmap = new Bitmap(StringifyBmp.monochromed(original, bmpFont, 0xffffff, true));
// bottom left corner - colorized
var stringified3:Bitmap = new Bitmap(StringifyBmp.colorized(original, bmpFont, 0x000000, false));
// bottom right corner - colorized with alpha weigth
var stringified4:Bitmap = new Bitmap(StringifyBmp.colorized(original, bmpFont, 0x000000, true));	
```
[![stringified](http://i.imgur.com/ZgrH4bt.png)](#)