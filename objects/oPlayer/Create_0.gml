/// @desc Demo configuration

// All-purpose macros
#macro SIZE 32						// The size of a single node.
#macro SHIFT 16						// Bitwise shortcut.
#macro MASK 65535					// Bitwise shortcut.
#macro SIDES 4						// Number of sides of a node. Used in the 'graphing' for loop. Expandable in the future.
#macro COLS 50						// Number of node columns.
#macro ROWS 25						// Number of node rows.

// Keybind macros
#macro PATH mb_left					// Keybind for initiating a path.
#macro MOVE mb_right				// Keybind for teleporting player.

// Data structures
global.BLOCKED=ds_list_create();	// List containing pointers of all blocked nodes.
SPRITE=ds_grid_create(50,25);		// List sprites used for the demo GUI.
STEPS=ds_grid_create(50,25);		// List of steps taken used for the demo GUI.
path=ds_list_create();				// List of pointers, generated by aStar algorithm script.

// Debugging variables
maxscans=1000;						// Change to limit the number of scans. Useful if resources are being heavily taxed.
nodes=0;							// Debugging variable. Total number of nodes scanned.
walls=0;							// Debugging variable. Number of walls bumped into. Includes repeats.
length=0;							// Debugging variable. Length of path.
time=0;								// Debugging variable. Time taken to calculate path.

// Player object configuration
pathing=false;						// Boolean used to gate input and path following logic.
spd=20;								// Speed that the object follows the path at.