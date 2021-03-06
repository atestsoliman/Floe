package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Sfx;

import utilities.DirectionEnum; 
import scenes.GameScene; //Needed to store the reference to the player.

import com.haxepunk.HXP;


class WaterEnemy extends Enemy
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	

	
	private var currentScene:GameScene;
	
	public var submerged = false;
	private var timeLeftSubmerged = 0;
	private var timeLeftEmerged = 100;
	private var initialSubmergeTime = Std.random(200);
	private var initialSubmergeComplete = false;

	
	// new( x:Int, y:Int )
	//
	// Constructor for WaterTile.

	public function new(x:Int, y:Int)
	{
		super(x, y);
		
		// Must set frameDelay, moveSpeed, recalcTime, maxEndurance, restTime, attackDamage
		// and acceptableDestDistance
		layer = 1;
		frameDelay = 15; 
		moveSpeed = 0;
		recalcTime = 120;
		maxEndurance = 0; // moves two times before resting.
		restTime = 60;	   // rests for 60 frames.
		attackDamage = 1;
		acceptableDestDistance = 0;

		
		// Set hitbox size and the collision type
		
		setHitbox(32, 32);
		type = "waterEnemy";

		
		sprite = new Spritemap("graphics/waterEnemy.png", 32,32);
		
		sprite.add("upperSubmerged",[9], 1, false); 
		sprite.add("emerging", [5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
								5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
								5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4], 60, false);
		sprite.add("submerging", [	5,5,5,5,5,5,
									6,6,6,6,6,6,
									7,7,7,7,7,7,
									0,0,0,0,0,0,
									1,1,1,1,1,1,
									2,2,2,2,2,2,
									3,3,3,3,3,3,
									8], 60, false);
		
		sprite.play("emerging");
		sprite.index = 7;
		graphic = sprite;
		currentScene = (cast HXP.scene);
		
	}
	
	
	///////////////////////////////////////////
	//             ENEMY ACTIONS             //
	///////////////////////////////////////////
	
	// These functions are exactly what the title says: enemy actions.
	// It serves as a catch-all for methods that aren't strictly related to movement,
	// collisions, or direction selection.
	
	// When called, tells the water enemy to go under water
	private function submerge(timeToSubmerge:Int){
		timeLeftSubmerged = timeToSubmerge;
		submerged = true;
		sprite.play("submerging");
	}
	
	// When called, tells the water enemy to emerge
	private function emerge(timeToEmerge:Int){
		timeLeftEmerged = timeToEmerge;
		submerged = false;
		sprite.play("emerging");
	}
	
	// Tests if the water enemy is able to emerge or if it is blocked.
	private function emergeTest(){
        var actors = ["lightningEnemy", "sampleEnemy", "player"];
        var canEmergeTest:Bool = true;
        //HXP.console.log(["Testing for collisions at", x, y]);
        if (collideTypes(actors, x, y) != null){
            // if something's on top of the water enemy, prevent emergence
            //HXP.console.log(["There's something above me at", x, y]);
            canEmergeTest = false;
        }
        return canEmergeTest;
    }
	
	// Decrements counters counting to the next emerge/submerge event
	//    and calls the corresponding emerge/submerge function when appropriate
	private function stateDecay(){
		if (submerged){
			timeLeftSubmerged--;
			if (timeLeftSubmerged <= 0){
				if (emergeTest()){
					emerge(200);
				}
			}
		}
		else if (!submerged){
			timeLeftEmerged--;
			if (timeLeftEmerged <= 0){
				submerge(200);
			}
		}
	}
		
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////

	// Called every frame
	public override function update(){
		// enemy does not move, so all we need to do is toggle 'submerged'
		stateDecay();		

		if( timeLeftSubmerged == 60 ){ //1 second before "emerging" animation plays.
			sprite.play("upperSubmerged");
		}
		
	}




}