package entities;

import entities.Tile;
import com.haxepunk.graphics.Image;

import com.haxepunk.HXP; //for debug;

class Border extends Tile {

	//A child of Tile needs its own copy of the static vars it will use 
	static public var rockImage:Image;
	static public var borderImage:Image;
	static private var graphicInit:Bool = false;
	
	public override function new(x:Int, y:Int, picture:String){
		super(x,y);
		if(!graphicInit) {
			Border.borderImage = new Image("graphics/rock.png");
			graphicInit = true;
		}
		
		if( picture == "border" ){
			graphic = borderImage;
		}
		type = "border";
	}	
}