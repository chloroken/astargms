// Add this wall to the blocked grid
blockerX=x div SIZE;
blockerY=y div SIZE;
blockernode=blockerX<<SHIFT|blockerY;
ds_list_add(global.BLOCKED,blockernode);