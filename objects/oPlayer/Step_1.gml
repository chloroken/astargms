/// @desc Player inputs (A* script)

// If player object isn't currently moving along a path
if !pathing{
	
	// Check for 'PATH' keybind input
	if mouse_check_button_pressed(PATH){
		
			// Generate path using astar script
			path=aStar(
			x div SIZE,y div SIZE,
			round(mouse_x div SIZE),
			round(mouse_y div SIZE),
			COLS,ROWS,SIZE,SIDES,
			global.BLOCKED,1000);
			
			// Ensure a path exists
			if path&&ds_list_size(path){
				
				// Get first 'pointer' from the path
				var pointer=ds_list_find_value(path,0);
				
				// Snap player to  'pointer' coordinates
				x=(pointer>>SHIFT)*SIZE;y=(pointer&MASK)*SIZE;
				
				// Flip object 'pathing' boolean
				pathing=true;
			}
	}
	
	// Check for 'MOVE' keybind input
	else if mouse_check_button_pressed(MOVE){
		
		// Get coordinates 'destx' & 'desty' from mouse functions
		var destx=round(mouse_x div SIZE);
		var desty=round(mouse_y div SIZE);
		
		// Bitwise 'destination' pointer from 'destx' & 'desty'
		var destination=destx<<SHIFT|desty;
		
		// Check if 'destination' is blocked
		if !ds_list_find_index(global.BLOCKED,destination){
			
			// Move player to 'destination' coordinates
			x=destx*SIZE;y=desty*SIZE;
		}
	}
}