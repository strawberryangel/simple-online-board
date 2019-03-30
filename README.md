# Simple Online Board

This is for a simple online board for SecondLife. 
This is designed for an account UUID, an online texture and an offline texture. 

## Setup & Compiling

This will *not* work right out of the box. 
It's designed to be compiled with Firestorm's script enchancements
with the assumption you can edit `#define` and `#include` statements.

This assumes one of the faces will have the the online/offline textures. 
Which face is controlled with the `TEXTURE_FACE` definition.

The entire script looks like:

```c
#define TEXTURE_FACE 3
#include "online-board/online-board-simple.lsl"
```

## Use

This expects three comma-separated UUIDs in the object's description: 
*   UUID of the agent to monitor. 
*   UUID of the online texture.
*   UUID of the offline texture. 

If any of these are missing, 
or if there are extra spaces around the UUIDs, 
hover text will inform about the failure. 

The texture UUIDs can be obtained by 
right clicking on a full permission texture and choosing `Copy Asset UUID`.
