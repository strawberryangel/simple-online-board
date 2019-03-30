// Comment out the next line if you don't have a tool file like this.
#include "lib/debug.lsl"
#ifndef DEBUG
#define debug(a)
#endif

// Hover text while initializing.
#define HOVER_TEXT_COLOR <1.0, 1.0, 0.0>

#ifndef TEXTURE_FACE
#define TEXTURE_FACE 1
#endif

// Default texture keys.
#define DEFAULT_ONLINE_KEY  "f9b8b7ae-8308-d934-744c-3a2bd90ddf3f"
#define DEFAULT_OFFLINE_KEY "d41c30f1-6443-7599-9219-ee4cd6fc534f"
// Texture keys in use
key online_key;
key offline_key;

// Look in the description for a UUID.
// If there is not one, use llGetOwner().
// This will allow a manager to set up multiple boards for staff.
string last_object_description;
key agent_key;

// How often should the board update the user's status?
float update_interval; // Seconds
key onlinerequest;

// I cannot see any automatic LSL trigger for changed descriptions.
// This substitutes for one.
string error_text = "";
check_description(integer force)
{
    // See if the description has changed.
	string description = llGetObjectDesc();
	if(!force && description == last_object_description) return;

	debug("Reading UUID from description.");
	last_object_description = description;
    error_text = "";

    // Split the description into pieces:
    // Agent UUID, Online Image UUID, Offline Image UUID
    list parts = llParseString2List(description, ["|", ","], []);

	// Get the agent's key.
	key new_key = llList2Key(parts, 0);
	if(new_key)
	{
		debug("Found a valid UUID (" + string(new_key) + "). Assuming it is an avatar's.");
		agent_key = new_key;
	}
	else
	{
		debug("No valid UUID was found. Using object owner.");
        error_text = error_text + "Invalid person UUID.\n";
		agent_key = NULL_KEY;
	}

    // Get the online texture.
	new_key = llList2Key(parts, 1);
	if(new_key)
	{
		debug("Found a valid UUID (" + string(new_key) + "). Assuming it is an online texture.");
		online_key = new_key;
	}
	else
	{
		debug("No valid UUID was found. Using default online texture.");
        error_text = error_text + "Invalid online texture UUID.\n";
		online_key = DEFAULT_ONLINE_KEY;
	}

    // Get the offline texture.
	new_key = llList2Key(parts, 2);
	if(new_key)
	{
		debug("Found a valid UUID (" + string(new_key) + "). Assuming it is an online texture.");
		offline_key = new_key;
	}
	else
	{
		debug("No valid UUID was found. Using default offline texture.");
        error_text = error_text + "Invalid offline texture UUID.\n";
		offline_key = DEFAULT_OFFLINE_KEY;
	}

    if(error_text != "")
        error_text = error_text + "Ensure there are no spaces before or after UUID.\n";
}

init()
{
	llSetText("Initializing...", HOVER_TEXT_COLOR, 1);
    set_update_interval();
	check_description(TRUE);
	onlinerequest = llRequestAgentData(agent_key, DATA_ONLINE);
}

// Add a random factor so multiple boards aren't all firing at the same time.
set_update_interval()
{
    float interval = 5.0 + llFrand(2.0);
	llSetTimerEvent(interval);
}

default
{
	on_rez(integer param)
	{
		llResetScript();
	}

	state_entry()
	{
		init();
	}

	timer()
	{
		check_description(FALSE);
		onlinerequest = llRequestAgentData(agent_key, DATA_ONLINE);
	}

	touch_start(integer touch_num)
	{
        check_description(TRUE);
		onlinerequest = llRequestAgentData(agent_key, DATA_ONLINE);
	}

	dataserver(key request, string data)
	{
		llSetText(error_text, HOVER_TEXT_COLOR, 1);
		if (data == "1")
			llSetTexture(online_key, TEXTURE_FACE);
		else
			llSetTexture(offline_key, TEXTURE_FACE);
	}
}
