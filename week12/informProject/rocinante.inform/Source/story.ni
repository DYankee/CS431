"Rocinante - Deck Layout" by Zack

[ --- THE MAP --- ]

The Bridge is a room. "The command center of the ship. The central ladder well begins here, dropping down into the belly of the ship."

[ Floor 2 ]
The Armory is below the Bridge. "A secure room filled with MCRN-issue lockers. The airlock to the north leads to the vacuum of space."
The Airlock is north of the Armory. "The transition point between the ship and the void."

[ Floor 3 ]
The Third floor hallway is below the Armory. "A narrow corridor connecting the scientific and medical wings."
The Med bay is west of the Third floor hallway. "Clean, white, and smelling of antiseptic."
The Lab is east of the Third floor hallway. "Workstations are bolted to the floor here."

[ Floor 4 ]
The Fourth floor hallway is below the Third floor hallway. "The lowermost section of the habitated decks."
The Galley is west of the Fourth floor hallway. "The smell of recycled air and synthesized coffee hangs heavy here."
The Captains Quarters are east of the Fourth floor hallway. "A small, private cabin."

[ --- THE LADDER SYSTEM --- ]

The central ladder is a backdrop. It is in the Bridge, the Armory, the Third floor hallway, and the Fourth floor hallway.
Understand "ladder" or "rungs" or "well" as the central ladder.

[ 5. Flavor text for standard navigation ]
Before going down when the central ladder is in the location:
	if a room is down from the location:
		say "You slide down the rungs to the deck below...";
		move the player to the room down from the location;
	otherwise:
		say "You're already at the bottom of the ladder well." instead.

Before going up when the central ladder is in the location:
	if a room is up from the location:
		say "You pull yourself up the rungs to the deck above...";
		move the player to the room up from the location;
	otherwise:
		say "You're already at the top of the ladder well." instead.