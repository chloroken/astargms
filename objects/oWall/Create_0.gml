/// @desc Auto-add to 'blocked' grid

// Add this wall to the blocked grid
var blockerx=x div SIZE,blockery=y div SIZE;
var blockerpointer=blockerx<<SHIFT|blockery;
ds_list_add(global.BLOCKED,blockerpointer);