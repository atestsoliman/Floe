package scenes;

import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.Player;
import entities.WaterTile;
import entities.GroundTile;
import entities.Obstacle;
import com.haxepunk.Sfx;


class GameScene extends Scene
{
	
	private var music:Sfx;
	
	public function new()
	{
		super();
	}
	public override function begin()
	{
		HXP.console.log(["Level is loading..."]);
		
		music = new Sfx("audio/bgm.mp3");
		music.loop();
		
		var dimensionX = 10;
		//var dimensionY = 20
		var placeX = 32;
		var placeY = 32;
		var playerX = 0;
		var playerY = 0;
		var numOfTiles = 60; //controls number of water tiles initially placed.
		
		var PC = new Player(playerX, 0);
		add(PC);
		
		while(numOfTiles > 0){
			if(HXP.random > .1){
				add(new WaterTile(placeX, placeY));
				numOfTiles -= 1;
				
				HXP.engine.gm.waterAdded();
			}
			else{
				if(HXP.random > .5){
					add(new GroundTile(placeX, placeY));
				}
				else{
					add(new Obstacle(placeX, placeY));
				}
			}
			placeX += 32;
			if(placeX > 32 * dimensionX){
				placeX = 32;
				placeY +=32;
			}
		}
		HXP.console.log(["Level has been generated!"]);
	}
	public override function end(){
	
		music.stop();
	
	}
}