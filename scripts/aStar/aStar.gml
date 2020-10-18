function aStar(startx,starty,goalx,goaly,cols,rows,size,sides,blocked,maxloops){

/*
CUSTOM A* PATHFINDING FOR GMS - BY CHLOROKEN (KEN KOEPPLINGER)
Github: https://github.com/chloroken/astargms
Twitter: https://twitter.com/chloroken
Email: chloroken@gmail.com

The pathfinding article I used to create this A* algorithm:
http://theory.stanford.edu/~amitp/GameProgramming/AStarComparison.html
*/

/*
TABLE OF CONTENTS
	I. Initialization (macros, variables, and data structures)
	II. Pathfinding Logic (solve for an ideal path)
		• Neighbor-Graph Function (scan neighboring tiles)
		• Path-Selection Heuristic (choose best neighbor tile)
		• Solution protocol (last breadcrumb, data structure cleanup)
	III. Path creation logic (follow breadcrumbs backwards)
	IV.	Cleanup (destroy data structures)
*/

/*
=================
I. INITIALIZATION
=================
*/

// Bitwise shortcut macros
#macro SHIFT 16						// Bitwise extracting X coordinate from a pointer
#macro MASK 65535					// Bitwise extracting Y coordinate from a pointer
	
// DEMO GUI (removable code)
var timer=get_timer();				// Debug timer in microseconds
scans=0;length=0;					// Instance variables on 'oPlayer' for demo tiles GUI
	
// Local lever variables
var movecost=1;						// This can be tied to the tiles themselves, but for demo purposes is set to 1
var tiebreaker=.001;				// A tiebreaker variable used to create more realistic paths
	
// Bitwise given coordinates 'startx' & 'starty' to 'startpointer', and 'goalx' & 'goaly' to 'goalpointer'
var startpointer=startx<<SHIFT|starty,goalpointer=goalx<<SHIFT|goaly;
	
// Ensure possibility of a path
if startpointer==goalpointer||ds_list_find_index(blocked,startpointer)||ds_list_find_index(blocked,goalpointer) return(false);
	
// Local data structures
var OPENQUEUE=ds_priority_create();	// A priority queue of candidate tiles to be analyzed by the algorithm
var COSTMAP=ds_map_create();		// A map of cumulative cost of tiles (used to find better paths when presented)
var PARENTMAP=ds_map_create();		// A breadcrumb trail from the goal, which will ultimately become our path
	
// DEMO GUI (removable code)
ds_grid_clear(SPRITE,0);
ds_grid_clear(STEPS,0);

/*
=====================
II. PATHFINDING LOGIC
=====================
*/
	
// Add 'startpointer' to 'COSTMAP' and 'OPENQUEUE'
var price=0;
COSTMAP[?startpointer]=price;
ds_priority_add(OPENQUEUE,startpointer,price);
   
/* MAIN A* PATHFINDING LOOP */
	
// Set 'loops' count to zero
var loops=0;

// Run until 'OPENQUEUE' is exhausted or 'loops' exceeds 'maxloops')
while !ds_priority_empty(OPENQUEUE)&&loops<maxloops{
		
	// Increase loop count
	loops++;

	// Get 'currentpointer' from 'OPENQUEUE'
	var currentpointer=ds_priority_delete_min(OPENQUEUE);
		
	// If 'currentpointer' and 'goalpointer' pointers don't match
	if currentpointer!=goalpointer{
		
		// Bitwise X and Y coordinates 'currentx' and 'currenty' from 'currentpointer' 
		var currentx=currentpointer>>SHIFT,currenty=currentpointer&MASK;
		
		/* NEIGHBOR-GRAPH FUNCTION */
		
		// Graph loop where 'n' is a side of a tile
		for (var n=0;n<sides;n++){
			
			// Copy current coordinates 'currentx' and 'currenty' onto 'neighborx' and 'neighbory'
			var neighborx=currentx,neighbory=currenty;
			
			// Set a break flag to avoid scanning tiles that are out of bounds
			var go=true;
			
			// Iteration-based neighbor selection (check left, above, right, below)
			switch n{
				case 0: if neighborx>0 neighborx--;else go=!go;break;		// Left
				case 1: if neighbory>0 neighbory--;else go=!go;break;		// Top
				case 2: if neighborx<cols neighborx++;else go=!go;break;	// Right
				case 3: if neighbory<rows neighbory++;else go=!go;break;	// Bottom
			}
			
			// Trash neighbor 'n' if it's out of map bounds
			if !go break;
			
			// Bitwise 'neighborx' and 'neighbory' onto 'neighborpointer'
			var neighborpointer=neighborx<<SHIFT|neighbory;
			
			// If 'neighborpointer' isn't on 'blocked' list
			if !ds_list_find_index(blocked,neighborpointer){
				
				// DEMO GUI (removable code)
				SPRITE[#neighborx,neighbory]=sScan;
				if STEPS[#neighborx,neighbory]==0&&neighborx!=startx||neighbory!=starty STEPS[#neighborx,neighbory]=loops;
				
				// Set 'price' to 'currentpointer' value in 'COSTMAP' plus 'movecost'
				price=COSTMAP[?currentpointer]+movecost;
				
				/* PATH-SELECTION HEURISTIC */
				
				// If 'neighborpointer' isn't in 'COSTMAP', or a cheaper path presents itself
				if !ds_map_exists(COSTMAP,neighborpointer)||price<COSTMAP[?neighborpointer]{
					
					// Use a lengthdir function to get 'distance' component of heuristic (greedy-first pathfinding)
					var distance=abs(goalx-neighborx+goaly-neighbory);
					
					// Create a 'trend' vector for breaking ties
					var trend=abs((neighborx-goalx)*(startx-goalx)-(neighbory-goaly)*(starty-goaly))*tiebreaker;
					
					// Calculate 'heuristic' by combining 'distance' and 'trend' multiplied by 'size' (corrected greedy-first)
					var heuristic=(distance+trend)*size;
					
					// Calculate 'priority' by combining 'price' & 'heuristic' (A* pathfinding)
					var priority=price+heuristic;
					
					// Add 'neighborpointer' to 'OPENQUEUE' with priority 'priority'
					ds_priority_add(OPENQUEUE,neighborpointer,priority);
					
					// Set 'neighborpointer' value in 'COSTMAP' to 'price'
					COSTMAP[?neighborpointer]=price;
					
					// Set 'neighborpointer' value map in 'PARENTMAP' to 'currentpointer'
					PARENTMAP[?neighborpointer]=currentpointer;
					
					// Demo GUI scan count
					scans++;
				}
			}
		}
	}
				
	/* SOLUTION PROTOCOL */
		
	// If 'startpointer' matches 'goalpointer'
	else{
				
		// Set 'pathpointer' (used in path creation section) to 'goalpointer'
		var pathpointer=goalpointer;
			
		// Clean up local data structures (we still need 'PARENTMAP' for path creation)
		ds_priority_destroy(OPENQUEUE);
		ds_map_destroy(COSTMAP);
			
		// Path complete, break out of main pathfinding loop
		break;
	}
}

/*
========================
III. PATH CREATION LOGIC
========================
*/

// If 'loops' exceeds 'maxloop's or 'pathpointer' doesn't exist
if loops>=maxloops||!pathpointer{
	ds_map_destroy(PARENTMAP);
	return(false);
}
	
// Create 'path' list
var path=ds_list_create();
	
// Path creation loop (run until 'pathpointer' matches 'startpointer')
while pathpointer!=startpointer{
		
	// Add 'pathpointer' to 'path' list
	ds_list_insert(path,0,pathpointer);
		
	// Bitwise coordinates 'pathx' & 'pathy' from 'pathpointer'
	var pathx=pathpointer>>SHIFT,pathy=pathpointer&MASK;
		
	// DEMO GUI (removable code)
	length++;
	SPRITE[#pathx,pathy]=sPath;
		
	// Set 'pathpointer' to its value in 'PARENTMAP'
	pathpointer=PARENTMAP[?pathpointer];
		
	// If 'pathpointer' matches 'startpointer'
	if pathpointer==startpointer{
			
		// DEMO GUI (removable code)
		SPRITE[#goalx,goaly]=sGoal;SPRITE[#startx,starty]=sStart;
		
		// Insert 'pathpointer' in 'path' list
		ds_list_insert(path,0,pathpointer);
			
		// Break out of path loop
		break;
	}
}

/*
===========
IV. CLEANUP
===========
*/

// Clean up remaining local data structure 'PARENTMAP'
ds_map_destroy(PARENTMAP);
	
// DEMO GUI (removable code)
time=get_timer()-timer;
	
// Deliver list of pointers 'path' to calling object/script
return(path);
}