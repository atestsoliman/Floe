package entities;

import entities.Tile;
import com.haxepunk.graphics.Image;



class GroundTile extends Tile
{
	static public var commonImage:Image;
	static private var graphicInit:Bool = false;
	
	public function new(x:Int, y:Int)
	{
		super(x, y);
		//need to reset graphic
		if(!graphicInit) {
			GroundTile.commonImage = new Image("graphics/Ground_Basic.png");
			graphicInit = true;
		}
		graphic = commonImage;
		type = "groundTile";
	}

}