"The Expanse - Coffee Time on the Rocinante" by Zachary Geary

[ --- THE MAP --- ]
[Floor 1]
The Bridge is a room. The description is "Description."

[Floor 2]
The Armory is below the Bridge. The description is "Description."
The Airlock is north of the Armory. The description is "Description."

[Floor 3]
The Third floor hallway is below the Armory. The description is "Description."
The Med bay is west of the Third floor hallway. The description is "Description."
The Lab is east of the Third floor hallway. The description is "Description."

[Floor 4]
The Fourth floor hallway is below the Third floor hallway. The description is "Description."
The Galley is west of the Fourth floor hallway. The description is "Description."
The Captains Quarters is east of the Fourth floor hallway. The description is "Description."

[Floor 5]
The Fifth floor hallway is below the Fourth floor hallway. The description is "Description."
The Crew quarters is west of the Fifth floor hallway. The description is "Description."
The Equipment room is east of the Fifth floor hallway. The description is "Description."

[Floor 6]
The Engineering shop is below the Fifth floor hallway. The description is "Description."

[Floor 7]
The Cargo bay is below the Engineering shop. The description is "Description."

[Floor 8]
The Reactor core is below the Cargo bay. The description is "Description."

[ --- CONTAINERS & ITEMS --- ]
[Coffee maker]
The coffee machine is a container in the Galley. It is fixed in place. The description is "Description."
The coffee machine is open and unopenable.
The coffee machine can be filled or empty. The coffee machine is empty.

Instead of inserting the bag of coffee grounds into the coffee machine:
    now the coffee machine is filled;
	remove the bag of coffee grounds from play;
    say "You fill the coffee machine with the grounds."

[Supply crate]
The supply crate is a container in the Cargo bay. The description is "Description." 

[Coffee grounds]
The bag of coffee grounds is in the Supply crate. The description is "Description." 

[Coffee bulb]
The coffee bulb is in the Captains Quarters. The description is "Description."

[ --- THE LADDER SYSTEM --- ]
The central ladder is a backdrop. it is in the Bridge, the Armory, the Third floor hallway, and the Fourth floor hallway,
the Fifth floor hallway, the Engineering shop, the Cargo bay, and the Reactor core. The description is "A ladder that runs up/down the spine of the ship."
Understand "ladder" or "rungs" or "well" as the central ladder.

[Flavor text for standard navigation]
Before going down when the central ladder is in the location:
	if a room is down from the location:
		say "You slide down the rungs to the deck below...";
	otherwise:
		say "You're already at the bottom of the ladder well." instead.

Before going up when the central ladder is in the location:
	if a room is up from the location:
		say "You pull yourself up the rungs to the deck above...";
	otherwise:
		say "You're already at the top of the ladder well." instead.

[ --- ACTION DEFINITIONS --- ]
Using is an action applying to one thing.
Understand "use [something]" as using.

[ Brewing coffee ]
Instead of using the coffee machine:
	if the coffee machine is empty:
		say "The machine is out of coffee, I need to get some more.";
	otherwise if the player does not carry the coffee bulb:
		say "I need something to put my coffee in. I think I left my bulb in my quarters.";
	otherwise:
		say "you brew yourself a coffee";
		end the story saying "Now thats a good cup of coffee"

[ --- MAP COMMAND --- ]
Mapping is an action applying to nothing.
Understand "map" as mapping.

[ --- Common text inserts --- ]
[convert line to fixed letter spacing]
to say fl:
	say "[fixed letter spacing]";

[custom indent]
to say indent:
	say "[fl]     "

Instead of mapping:
	say "
	[line break]
	==================== ROCINANTE DECK PLAN ====================[line break]
	[fl][line break]
	[fl][indent][indent][indent][bold type]FLOOR 1[roman type][line break]
	[fl][indent][indent] +-----------+[line break]
	[fl][indent][indent]|   BRIDGE  |[line break]
	[fl][indent][indent]+-----+-----+[line break]
	[fl][indent][line break]
	[fl][indent][indent][bold type]FLOOR 2[roman type][line break]
	[fl][indent][indent]+-----------+----East---+[line break]
	[fl][indent][indent]|   ARMORY  |  AIRLOCK  |[line break]
	[fl][indent][indent]+-----+-----+-----------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 3[roman type][line break]
	[fl][indent]+---West---+-----+------+---East---+[line break]
	[fl][indent]| MED BAY  | 3RD FLOOR  |   LAB    |[line break]
	[fl][indent]|          |  HALLWAY   |          |[line break]
	[fl][indent]+----------+------------+----------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 4[roman type][line break]
	[fl][indent]+----------+-----+------+----------+[line break]
	[fl][indent]| GALLEY   | 4TH FLOOR  | CAPTAIN  |[line break]
	[fl][indent]|          | HALLWAY    | QUARTERS |[line break]
	[fl][indent]+----------+-----+------+----------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 5[roman type][line break]
	[fl][indent]+----------+-----+------+----------+[line break]
	[fl][indent]|   CREW   | 5TH FLOOR  |EQUIPMENT |[line break]
	[fl][indent]| QUARTERS | HALLWAY    |   ROOM   |[line break]
	[fl][indent]+----------+-----+------+----------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 6[roman type][line break]
	[fl][indent]+------------+[line break]
	[fl][indent]|ENGINEERING |[line break]
	[fl][indent]|    SHOP    |[line break]
	[fl][indent]+-----+------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 7[roman type][line break]
	[fl][indent]+------------+[line break]
	[fl][indent]| CARGO BAY  |[line break]
	[fl][indent]+-----+------+[line break]
	[fl][indent][line break]
	[fl][indent][bold type]FLOOR 8[roman type][line break]
	[fl][indent]+------------+[line break]
	[fl][indent]|  REACTOR   |[line break]
	[fl][indent]|    CORE    |[line break]
	[fl][indent]+------------+[line break]
	[fl][indent][line break]
	[fl][indent]============================================================[line break]
	[fl][indent]Central ladder runs through floors 1-8[line break]
	[fl][indent]Use UP/DOWN to navigate the ladder | Use compass directions for rooms[line break]
	".

[ --- Game Start --- ]
When play begins:
    say "You are Jim Holden, Captain of the infamous Rocinante. You sit on 
		the bridge, head aching and mouth tasting of sour copper. Standing with a groan you say, 
		'Alex, bridge is yours I need a coffee. Want me to grab you one?'
		Alex replies, 'Copy that cap, but I'll pass on the cuppa, thanks'";
