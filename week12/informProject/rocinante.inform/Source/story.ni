"rocinante" by "Zachary Geary"

[ Floor 1 ]
The Bridge is a room. "Description"

[ Floor 2 ]
The Armory is below the Bridge. "Description"

The Airlock is north of the Armory. "Description"

[ Floor 3 ]
The Third floor hallway is below the Armory. "Description"

The Med bay is west of the Third floor hallway. "Description"

The Lab is east of the Third floor hallway. "Description" 

[ Floor 4 ]
The Fourth floor hallway is below the third floor hallway. "Description"

The Galley is west of the Fourth floor hallway. "Description"

The Captains Quarters are east of the Fourth floor hallway. "Description"

[Section: Ladder System]

The central ladder is a backdrop. It is in the Bridge, The Armory, The Third floor hallway, The Fourth floor hallway.

[Redirecting Actions]
Instead of climbing the central ladder:
	if the room above is a room:
		say "You pull yourself up the rungs to the next deck...";
		try going up;
	otherwise:
		say "You are at the top of the ship. The only way is down.";
		
Instead of jumping off the central ladder:
	if the room below is a room:
		say "you slide down the ladder to the deck below...";
		try going down;
	otherwise:
		say "You're already on the lowest deck";
			
[Allowing 'Go Down Ladder']
Instead of going down when the central ladder is in the location:
	try jumping off the central ladder
	
Instead of going up when the central ladder is in the location:
	try climbing the central ladder