/// @desc Follow path

// If object isn't currently pathing and path isn't empty
if pathing&&!ds_list_empty(path){
	
	// Fetch 'pathpointer' from 'path' list
	var pathpointer=ds_list_find_value(path,0);
	
	// Bitwise binary 'pathpointer' into coordinates 'pathx' & 'pathy'
	var pathx=(pathpointer>>SHIFT)*SIZE,pathy=(pathpointer&MASK)*SIZE;
	
	// If object is at current 'pathpointer' coordinates
	if x=pathx&&y=pathy{
		
		// Stop object movement
		speed=0;
		
		// Delete pointer from 'path' list
		ds_list_delete(path,0);
		
		// If path has at least one pointer left
		if !ds_list_empty(path){
			
			// Fetch 'nextpointer' from 'path' list
			var nextpointer=ds_list_find_value(path,0);
			
			// Bitwise binary 'nextpointer' into coordinates 'nextx' & 'nexty'
			var nextx=(nextpointer>>SHIFT)*SIZE,nexty=(nextpointer&MASK)*SIZE;
			
			// Set break flag for while loop below
			var go=false;
			
			// Check if new node is sharing x or y with current node
			// If 'nextpointer' shares a coordinate with 'pathpointer'
			while pathx==nextx^^pathy==nexty&&ds_list_size(path)>1{
				
				// Set 'lastpointer' to 'nextpointer'
				var lastpointer=nextpointer;
				
				// Skip waypoints until both are different
				ds_list_delete(path,0);
				
				// Fetch 'nextpointer' from the 'path' list
				var nextpointer=ds_list_find_value(path,0);
				
				// Bitwise binary 'nextpointer' into coordinates 'nextx' & 'nexty'
				var nextx=(nextpointer>>SHIFT)*SIZE,nexty=(nextpointer&MASK)*SIZE;
				
				// Flip break flag, indicating we can skip tiles
				go=true;
			}
			
			// If skipping tiles, add 'lastpointer' to 'path' list
			if go ds_list_insert(path,0,lastpointer);
		}
		
		// If path has is empty
		else{
			
			// Flip object pathing boolean
			pathing=false;
			exit;
		}
	}
	
	// If object is not at current 'pathpointer' coordinates
	else{
		
		// If approaching 'pathpointer' coordinates
		if point_distance(x,y,pathx,pathy)<spd{
			
			// Reduce speed
			move_towards_point(pathx,pathy,spd/10);
		}
		
		// If not approaching 'pathpointer' coordinates
		else if speed!=spd{
			
			// Move at max speed towards 'pathpointer' coordinates
			move_towards_point(pathx,pathy,spd);
		}
	}
}