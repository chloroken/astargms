// Add this wall to the blocked grid
var blockerX=x div SIZE;
var blockerY=y div SIZE;
var blockernode=blockerX<<SHIFT|blockerY;
ds_list_add(global.BLOCKED,blockernode);