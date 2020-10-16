function aStar(sx,sy,gx,gy,cols,rows,size,blocked){
	
/* CONFIGURATION */
	
	// Demo debug vars
	var us=get_timer();					// Debug timer in microseconds
	scans=0;							// Debug counter that shows total scans
	length=0;						// Debug counter that shows path length
	
	// Logic vars
	var movecost=1;						// The 'cost' of a moving from node to node.
	var tiebreaker=.001;				// A tiebreaker variable used to create more realistic paths.
	
	// Data structures
	var OPEN=ds_priority_create();		// A priority queue of 'open' nodes.
	var COST=ds_map_create();			// A map of cumulative 'cost' of each node in our path.
	var PARENT=ds_map_create();			// A nested map that lets us trace backwards from goal to start.
	
/* INITIALIZATION */
	
	// Translate start/end coordinates 'sx','sy','gx','gy' to pointers 'start' and 'goal'
	var start=sx<<SHIFT|sy,goal=gx<<SHIFT|gy;
	
	// Ensure 'start' isn't 'goal'
	if start==goal return(false);
	
	// Ensure 'start' nor 'goal' is 'blocked'
	if ds_list_find_index(blocked,start)||ds_list_find_index(blocked,goal) return(false);
	
	// Clear grids 'SPRITE' and 'STEPS' used for demo GUI
	ds_grid_clear(SPRITE,0);
	ds_grid_clear(STEPS,0);
	
	// Set 'COST' map's 'start' pointer to 0
	COST[?start]=0;
	
	// Set the initial 'waypoint' to -1 to calibrate to 0 after first run
	var waypoint=-1;
	
	// Add 'start' pointer to 'OPEN' priority queue
	ds_priority_add(OPEN,start,COST[?start]);
	
	// Set a 'loops' limit, configurable in the create step of 'oPlayer'
	var loops=0,maxloops=maxscans;

/* MAIN LOGIC LOOP */
	
	// Run this main loop until 'OPEN' queue is exhausted or 'loops' reaches 'maxloops'
	while !ds_priority_empty(OPEN)&&loops<maxloops{
		
		// Increase 'loops' count
		loops++;

		// Get current pointer 'cur' by removing lowest priority value from 'OPEN' priority queue
		var cur=ds_priority_delete_min(OPEN);
		
		// Check if 'cur' pointer is 'goal' pointer
		if cur==goal{
			
			// Set initial 'waypoint' pointer to 'goal'
			waypoint=goal;
			
			// Clean up 'OPEN' and 'COST' and break out of main loop
			ds_priority_destroy(OPEN);
			ds_map_destroy(COST);
			break;
		}
		
		// Extract current node's coordinates 'cx,cy' from current node (bitwise operators)
		var cx=cur>>SHIFT,cy=cur&MASK;
		
		// 'Graph' neighbors of current node
		for (var i=0;i<SIDES;i++){
			
			// Set neighbor 'i' coordinates 'nx,ny' to current node's coordinates
			var nx=cx,ny=cy;
			
			// Set break flag to avoid scanning out of bounds nodes
			var go=true;
			
			// Adjust neighbor x/y coordinates based on current graph loop iteration 'i'
			switch i{
				case 0: if nx>0	nx--;else go=!go;break;		// Left neighbor
				case 1: if ny>0	ny--;else go=!go;break;		// Top neighbor
				case 2: if nx<cols nx++;else go=!go;break;	// Right neighbor
				case 3: if ny<rows ny++;else go=!go;break;	// Bottom neighbor
			}
			
			// If the neighbor 'i' is out of bounds, break graph loop (trashing neighbor 'i')
			if !go break;
			
			// Convert adjusted coordinates to neighboring node 'neighbor' (bitwise operators)
			var neighbor=nx<<SHIFT|ny;
			
			// If neighbor 'i' isn't on BLOCKED list
			if !ds_list_find_index(blocked,neighbor){
				
				// Set the sprite for the GUI
				SPRITE[#nx,ny]=sScan;
				
				// Set the 'step' for the GUI (the number that appears on each tile)
				if STEPS[#nx,ny]==0&&nx!=sx||ny!=sy STEPS[#nx,ny]=loops;
				
				/* Calculate price by searching cost map for the current node's cumulative
				cost and increasing it by the 'movement cost' of the tile itself */
				var price=COST[?cur]+movecost;
				
				/* If neighbor 'i' isn't in cost map, or its calculated price is lower than
				neighbor 'i's existing value in cost map (allows correction if better path opens) */
				if !ds_map_exists(COST,neighbor)||price<COST[?neighbor]{
					
					// Demo GUI scan count
					scans++;
					
					// Estimated distance to goal
					var hx=abs(gx*size-nx*size),hy=abs(gy*size-ny*size);
					
					// Create a vector from start to goal
					var t1=nx-gx,t1=ny-gy,t2=sx-gx,t2=sy-gy;
					
					// Break ties by following trend vector
					var trend=abs(t1*t2-t2*t1)*tiebreaker;
					
					// Calculate heuristic by combining distance and trend
					var heuristic=hx+hy+trend;
					
					// Calculate neighbor 'i' priority by combining its price with heuristic
					var priority=price+heuristic;
					
					// Add neighbor 'i' to OPEN queue with calculated priority
					ds_priority_add(OPEN,neighbor,priority);
					
					// Set neighbor 'i' cost to the calculated price
					COST[?neighbor]=price;
					
					// Set neighbor 'i' parent to current node
					PARENT[?neighbor]=cur;
				}
			}
		}
	}
	
/* POST-PATHFINDING CHECKS */


	// If max iteration count reached
	if loops>=maxloops return(false);
	
	// If goal is inaccessible
	if !waypoint return(false);
	
/* PATH CREATION - This block adds the pointers from above into a ds_list 'path' */
	
	// Create 'path' list
	var path=ds_list_create();
	
	// Loop this until 'waypoint' pointer matches 'start' pointer
	while waypoint!=start{
		
		// Demo GUI path size string
		length++;
		
		// Add 'waypoint' pointer to 'path' list
		ds_list_insert(path,0,waypoint);
		
		// Get x/y coordinates of 'waypoint' pointer
		var wx=waypoint>>SHIFT,wy=waypoint&MASK;
		
		// GUI Debugging
		SPRITE[#wx,wy]=sPath;
		
		// Set current waypoint to its parent waypoint
		waypoint=PARENT[?waypoint];
		
		// If waypoint is our final waypoint
		if waypoint==start{
			
			// Insert the waypoint in the path list
			ds_list_insert(path,0,waypoint);
			
			// GUI Debugging
			SPRITE[#gx,gy]=sGoal;SPRITE[#sx,sy]=sStart;
			
			// Break out of the path-building loop
			break;
		}
	}
	
/* CLEANUP */
	ds_map_destroy(PARENT);
	var us2=get_timer();
	time=us2-us;
	return(path);
}