/// @desc Follow path
// If player object isn't currently moving along a path
// If path has at least one waypoint left
if pathing&&!ds_list_empty(path){
	
	// Fetch current waypoint
	var waypoint=ds_list_find_value(path,0);
	
	// Translate binary waypoint into coordinates using bitwise
	var px=(waypoint>>SHIFT)*SIZE;
	var py=(waypoint&MASK)*SIZE;
	
	// If player object is at current waypoint
	if x=px&&y=py{
		
		// Stop player movement
		speed=0;
		
		// Delete current waypoint from list
		ds_list_delete(path,0);
		
		// If path has at least one waypoint left
		if !ds_list_empty(path){
			var nextwaypoint=ds_list_find_value(path,0);
			var npx=(nextwaypoint>>SHIFT)*SIZE;
			var npy=(nextwaypoint&MASK)*SIZE;
			var go=false;
			
			// check if new node is sharing x or y with current node
			while px==npx^^py==npy&&ds_list_size(path)>1{
				var lastwaypoint=nextwaypoint;
				
				// skip waypoints until both are different
				ds_list_delete(path,0);
				var nextwaypoint=ds_list_find_value(path,0);
				var npx=(nextwaypoint>>SHIFT)*SIZE;
				var npy=(nextwaypoint&MASK)*SIZE;
				go=true;
			}
			
			// then set new node to the node right before the difference
			if go ds_list_insert(path,0,lastwaypoint);
		}
		else{
			
			pathing=false;
			exit;
		}
	}
	
	// If player isn't touching a waypoint
	else{
		
		// If near the waypoint
		if point_distance(x,y,px,py)<spd{
			
			// Reduce speed
			move_towards_point(px,py,spd/10);
		}
		
		// If not near the waypoint
		else{
			
			// Move at max speed towards the waypoint
			move_towards_point(px,py,spd);
		}
	}
}