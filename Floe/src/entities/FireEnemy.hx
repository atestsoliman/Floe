package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MovingActor; //This actually just for the Direction enum, I think.
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class FireEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	
	// Graphic asset-holding variables
	private static var idleAnim:Image;
	
	private static var assetsInitialized:Bool = false; 
	
	private var currentScene:GameScene; 


	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		
		frameDelay = 15; 
		moveSpeed = 2;
		recalcTime = 120;
		maxEndurance = 16; // moves once before resting.
		restTime = 60;	   // rests for 60 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;
		specialLoad = 5;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "fireEnemy";
		
		if( assetsInitialized == false ){
			idleAnim = new Image("graphics/fireEnemy.png");
			assetsInitialized = true;
		}
		
		graphic = idleAnim;
		currentScene = cast(HXP.scene, GameScene);
		
	}
	
	
	///////////////////////////////////////////
	//             ENEMY ACTIONS             //
	///////////////////////////////////////////
	
	// These functions are exactly what the title says: enemy actions.
	// It serves as a catch-all for methods that aren't strictly related to movement,
	// collisions, or direction selection.
	
	
	// calcDestination()
	//
	// Sets the destinationX and destinationY
	
	private override function calcDestination(){
		destinationX = cast(currentScene.PC.x - (currentScene.PC.x % 32), Int);
		destinationY = cast(currentScene.PC.y - (currentScene.PC.y % 32), Int);
		
		//HXP.console.log(["My destination is: ", destinationX, ", ", destinationY]);
		
		super.calcDestination();
	};
	
	
	
	///////////////////////////////////////////
	//    BACKGROUND COLLISION FUNCTIONS     //
	///////////////////////////////////////////
	
	// These functions will be called when SampleEnemy finishes moving onto a tile.
	// They should set in motion any behavior that occurs after landing on that particular tile,
	// e.g. move again while on a water tile, or stop when on a ground tile.
	
	
	// waterTileCollision( e:Entity )
	//
	// SampleEnemy's movement ends.
	
	private override function waterTileCollision( e:Entity ){
		stopMovement();
		var w:WaterTile = cast(e, WaterTile);
		if(w.isFrozen()){
			specialLoad++;
			if(specialLoad % 5 == 0){
				w.thaw();
				var tempX:Int = (-1);
				while(tempX < 2){
					var tempY:Int = (-1);
					while(tempY < 2){
						e = w.collide("waterTile", x + tempX, y + tempY);
						if( e != null ){
							if( (cast e).isFrozen() == true){
								(cast e).thaw();
							}
						}
						tempY++;
					}
					tempX++;
				}
				
				//this section was my attempt at hard coding the parts that wont freeze//
				/*
				e = w.collide("waterTile", x-1, y-1);
				if( e != null ){
					if( (cast e).isFrozen() == true){
						(cast e).thaw();
					}
				}
				
				e = w.collide("waterTile", x+1, y-1);
				if( e != null ){
					if( (cast e).isFrozen() == true){
						(cast e).thaw();
					}
				}
				e = w.collide("waterTile", x-1, y+1);
				if( e != null ){
					if( (cast e).isFrozen() == true){
						(cast e).thaw();
					}
				}*/
			}
		}
	}
	
	// groundTileCollision( e:Entity )
	//
	// SampleEnemy's movement ends.
	
	private override function groundTileCollision( e:Entity ){
		stopMovement();
	}
	
	
	///////////////////////////////////////////
	//       MOVE COLLISION FUNCTIONS        //
	///////////////////////////////////////////
	
	
	// obstacleCollision( e:Entity )
	//
	// Prevent the sampleEnemy from moving into it.
	
	private override function obstacleCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	
	// playerCollision( e:Entity )
	//
	// Prevent the sampleEnemy from moving into it.
	
	private override function playerCollision( e:Entity ){
		cast(e, Player).takeDamage(attackDamage);
		//scene.remove(this)
	}
	
	
	// sampleEnemyCollision( e:Entity )
	//
	// Prevent the sampleEnemy from moving into it.
	
	private override function fireEnemyCollision( e:Entity ){
		moveWasBlocked = true;
		stopMovement();
	}
	
	///////////////////////////////////////////
	//      GENERAL COLLISION FUNCTIONS      //
	///////////////////////////////////////////
	
	
	//Nothing here yet. Useful for handling things like getting hit by a fireball.
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	//The Sample Enemy simply uses Enemy's update function.

}