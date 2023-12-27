# Custom A* Pathfinding for GameMaker

This is a demo of custom pathfinding for GMS2.3 using A* and bitshifting by Chloroken.

### • [Click here for download links (current release v1.0)](https://github.com/chloroken/astargms/releases/tag/1.0)

This program features custom pathfinding for GMS 2.3+ using an A* algorithm and bitwise operations.

The demo is heavily annotated with comments on nearly every line to help you understand the various systems and logic involved. If you have any questions about the code or need help implementing custom pathfinding into your project, I'm happy to help. Email me (chloroken@gmail.com) or DM me on Twitter (https://twitter.com/chloroken) and I'll get back to you.

https://user-images.githubusercontent.com/72576960/96370672-aa665b00-112c-11eb-9580-f4949b64eef3.gif
*Blue squares represent 'scanned' tiles, pink squares represent an 'ideal' path*

# DEMO FEATURES:

There are three main components of this custom A* Pathfinding logic.

1) A ds_list containing '**blocked**' locations (i.e. walls, obstacles) for the algorithm to construct a path around. The list contains pairs of coordinates (each representing a wall) bitshifted on single 32-bit integers, which we call *pointers*. This component is the **link between the pathfinding functions and the obstacles on your map**. The 'create' step in the provided 'oWall' object demonstrates how to configure wall objects to automatically add their respective pointer to this list. Adding nodes to the blocked list can be accomplished in a number of ways, having the wall objects add themselves is merely one example.

2) A script named '**aStar**', which algorithmically calculates an ideal path. It's designed to **replace the default GMS 'motion planning' (*mp_*) functions**. If you're not familiar with A* pathfinding, we use the word *ideal* here instead of *best* because A-Star pathfinding is a *logical compromise between speed and precision*. A shorter path might exist, but calculating it may take too long to be practical, especially when multiple objects are using the logic simultaneously, or when many obstacles are present in a large map. The aStar script takes a number of arguments and outputs a ds_list ('path') of pointers along an ideal path from the player object to the mouse, like a trail of breadcrumbs.

3) The '**pathing**' logic, located on the 'oPlayer' object's 'step' event, follows the trail of breadcrumbs stored in the (*path*) ds_list generated above. **This logic is designed to replace the default GMS 'pathing' (*path_*) functions**. Similar to how there are many methods capable of adding objects to the 'blocked' list, utilizing the trail of breadcrumbs (left from the aStar script) to move an object can be accomplished in a variety of ways. The logic found within the player object is one such example, where we skip any bread crumb that doesn't change direction in order to increase our max speed.

# DEMO RESOURCES:
* **'oWall' (object)**
  * Create: *Add this wall to 'blocked' list.* (component #1)
* **'aStar' (script)** (component #2)
  * Initialization: *Macros, variables, and data structures.*
  * Pathfinding Logic: *Solve for an ideal path.*
    * Neighbor-Graph Function: *Scan neighboring tiles.*
    * Path-Selection Heuristic: *Choose best neighbor tile.*
    * Solution Protocol: *Last breadcrumb, data structure cleanup.*
  * Path Creation Logic: *Follow breadcrumbs backwards.*
  * Cleanup: *Destroy data structures.*
* **'oPlayer' (object)**
  * Create: *Configure demo variables.*
  * Begin Step: *Left click to path (aStar), right click to teleport.*
  * Step: *Path-following logic and physics.* (component #3)
  * Draw: *Draw demo tiles & strings*
* **'rDemo' (room)**
  * 1x 'oPlayer' object
  * 456x 'oWall' object
* **Tiles (sprites)**: 'sPlayer', 'sWall', 'sStart', 'sGoal', 'sScan', 'sPath'.

# FUTURE DEVELOPMENT:

• This logic currently only allows for **four-way movement**. In the future, I'll be adding diagonal movement and support for hexagonal and octagonal tiles. Furthermore, different terrain will be added in a future release which can allow objects to move at different speeds. These changes will require scaling of the 'movecost' variable and modifications to the graph function in the aStar script. Other logic will remain mostly the same.

• Since we bitshift the coordinates of nodes onto pointer integers, because of the limitations of binary integers, neither the X nor Y coordinates can surpass a particular number roughly equivalent to the maximum number that can be stored in half (i.e. bits 1 through 32 of a 64-bit integer) of a binary integer. Remember that this limit is 'div' the size of a single *tile*, so the actual maximum size of a map, in pixels, ends up being *N* * *tile*, which when accounted for, more than suffices for most games interested in this kind of pathfinding.

• The object pathfinding point detection is pixel perfect. **This causes issues when the speed of the object is too high**. Could create an equation to balance the object's speed and distance from the next pointer, essentially creating a 'soft cap', to rectify this.

# DEMO INSTRUCTIONS:

• Download the [standalone .zip](https://github.com/chloroken/astargms/files/5397894/astargms.zip) and run the .exe (*or grab the source code below and open it with GMS*)
• **Left click** to instruct the player object to **path** to the cursor
• **Right click** to instantly **teleport** the player object to the cursor
