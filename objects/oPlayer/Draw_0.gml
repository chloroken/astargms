/// @desc Draw demo grid
// draw grid of sprites/steps for the demo
for (var h=0;h<ROWS;h++){
	for (var w=0;w<COLS;w++){
		if SPRITE[#w,h]!=0{
			draw_sprite(SPRITE[#w,h],0,w*SIZE,h*SIZE);
			if STEPS[#w,h]>0{
				draw_set_color(c_white);
				draw_text(w*SIZE,h*SIZE,string(STEPS[#w,h]));
			}
		}
	}
}

stringz="[CONTROLS] Left click to path, right click to relocate.";
draw_text(0,0,stringz);

if nodes!=0{
	var stringz=string("[DEBUGGING] Nodes Scanned: "+string(nodes));
	draw_text(0,room_height-string_height(stringz),stringz);
	var offset=string_width(stringz);
	
	stringz=string(" | Path Length: "+string(length));
	draw_text(offset,room_height-string_height(stringz),stringz);
	offset+=string_width(stringz);
	
	stringz=string(" | Walls Touched: "+string(walls));
	draw_text(offset,room_height-string_height(stringz),stringz);
	offset+=string_width(stringz);
	
	stringz=string(" | Path Generation Time: "+string(time/1000)+"ms");
	draw_text(offset,room_height-string_height(stringz),stringz);
	offset+=string_width(stringz);
}

stringz="[CREDIT] Custom A* — Chloroken (Ken Koepplinger) — 10.8.2020";
draw_text(room_width-string_width(stringz),room_height-string_height(stringz),stringz);

// draw player object
if pathing image_index=1;
else image_index=0;
draw_self();