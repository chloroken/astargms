/// @desc Follow path
// If object isn't currently pathing and path isn't empty
if pathing&&!ds_list_empty(path){
	
	// Fetch current pathpointer
	var pathpointer=ds_list_find_value(path,0);
	
	// Translate binary pathpointer into coordinates using bitwise
	var pathx=(pathpointer>>SHIFT)*SIZE,pathy=(pathpointer&MASK)*SIZE;
	
	// If player object is at current pathpointer
	if x=pathx&&y=pathy{
		
		// Stop player movement
		speed=0;
		
		// Delete current pathpointer from list
		ds_list_delete(path,0);
		
		// If path has at least one pathpointer left
		if !ds_list_empty(path){
			var nextpointer=ds_list_find_value(path,0);
			var nextx=(nextpointer>>SHIFT)*SIZE,nexty=(nextpointer&MASK)*SIZE;
			var go=false;
			
			// Check if new node is sharing x or y with current node
			while pathx==nextx^^pathy==nexty&&ds_list_size(path)>1{
				var lastpointer=nextpointer;
				
				// Skip waypoints until both are different
				ds_list_delete(path,0);
				var nextpointer=ds_list_find_value(path,0);
				var nextx=(nextpointer>>SHIFT)*SIZE,nexty=(nextpointer&MASK)*SIZE;
				go=true;
			}
			
			// Re-add 'lastpointer' to 'path' list
			if go ds_list_insert(path,0,lastpointer);
		}
		else{
			
			pathing=false;
			exit;
		}
	}
	   
	// If player isn't touching a pathpointer
	else{
		
		// If near the pathpointer
		if point_distance(x,y,pathx,pathy)<spd{
			
			// Reduce speed
			move_towards_point(pathx,pathy,spd/10);
		}
		
		// If not near the pathpointer
		else if speed!=spd{
			
			// Move at max speed towards the pathpointer
			move_towards_point(pathx,pathy,spd);
		}
	}
}