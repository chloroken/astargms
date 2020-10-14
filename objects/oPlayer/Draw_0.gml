/// @desc Draw demo grid

// Draw demo grid with sprites/steps
draw_set_color(c_white);
for (var h=0;h<ROWS;h++){
	for (var w=0;w<COLS;w++){
		if SPRITE[#w,h]!=0{
			draw_sprite(SPRITE[#w,h],0,w*SIZE,h*SIZE);
			if STEPS[#w,h]>0{
				draw_text(w*SIZE,h*SIZE,string(STEPS[#w,h]));
			}
		}
	}
}

// Draw instructional string
stringz="CONTROLS: Left click to path, right click to relocate.";
draw_text(32,room_height-string_height(stringz)-6,stringz);

// Draw debugging stat strings
if nodes!=0{
	lengthstring=string("Found a "+string(length)+"-tile long path ");
	timestring=string("in "+string(time/1000)+" milliseconds, ");
	scanstring=string("analyzing "+string(nodes)+"total nodes, ");
	wallstring=string("avoiding "+string(walls)+" walls.");
	debugstring=string(lengthstring)+string(timestring)+string(scanstring)+string(wallstring);
	draw_text(32,6,debugstring);
}

// Draw demo credit string
creditstring="CREDIT: Custom A* by Chloroken (Ken Koepplinger) 10.14.2020";
draw_text(room_width-string_width(creditstring)-32,room_height-string_height(creditstring)-6,creditstring);

// Draw player object
draw_self();

// Change color if player is pathing
if pathing image_index=1;
else image_index=0;