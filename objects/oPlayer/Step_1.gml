/// @desc Player inputs

// If player object isn't currently moving along a path
if !pathing{
	
	// Path object to mouse
	if mouse_check_button_pressed(PATH){
		
			// Generate path using astar script
			path=aStar(x div SIZE,y div SIZE,round(mouse_x div SIZE),round(mouse_y div SIZE),COLS,ROWS,SIZE,global.BLOCKED);
			
			// Ensure a path exists
			if path&&ds_list_size(path){
				
				// Get the first pointer from the path
				var pointer=ds_list_find_value(path,0);
				
				// Snap player to the first pointer
				x=(pointer>>SHIFT)*SIZE;
				y=(pointer&MASK)*SIZE;
				
				// Indicate player is now pathing
				pathing=true;
			}
	}
	
	// Relocate object to mouse
	else if mouse_check_button_pressed(MOVE){
		
		// Get coordinates and pointer of destination
		var destx=round(mouse_x div SIZE);
		var desty=round(mouse_y div SIZE);
		var dest=destx<<SHIFT|desty;
		
		// Check if the destination is blocked
		if !ds_list_find_index(global.BLOCKED,dest){
			
			// Move player to the destination node
			x=destx*SIZE;
			y=desty*SIZE;
		}
	}
}