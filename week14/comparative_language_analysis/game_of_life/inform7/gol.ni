"Conway's Game of Life" by Zack

The Laboratory is a room.

Section - Configuration

The grid width is a number that varies. The grid width is 10.
The grid height is a number that varies. The grid height is 10.
The frame count limit is a number that varies. The frame count limit is 500.
The current frame is a number that varies. The current frame is 0.

Section - Grid Storage

Table of Current Grid
y-coord	x-coord	cell-state
a number	a number	a number
with 100 blank rows

Table of Next Grid
y-coord	x-coord	cell-state
a number	a number	a number
with 100 blank rows

Section - Grid Initialization

To initialize the grid:
	let row-num be 1;
	while row-num <= grid height:
		let col-num be 1;
		while col-num <= grid width:
			choose a blank row in Table of Current Grid;
			now y-coord entry is row-num;
			now x-coord entry is col-num;
			now cell-state entry is 0;
			choose a blank row in Table of Next Grid;
			now y-coord entry is row-num;
			now x-coord entry is col-num;
			now cell-state entry is 0;
			increment col-num;
		increment row-num.

Section - Grid Access

To decide what number is cell state at row (Y - a number) column (X - a number):
	repeat through Table of Current Grid:
		if y-coord entry is Y and x-coord entry is X:
			decide on cell-state entry;
	decide on 0.

To set cell at row (Y - a number) column (X - a number) to (S - a number):
	repeat through Table of Current Grid:
		if y-coord entry is Y and x-coord entry is X:
			now cell-state entry is S;
			stop.

To decide what number is next cell state at row (Y - a number) column (X - a number):
	repeat through Table of Next Grid:
		if y-coord entry is Y and x-coord entry is X:
			decide on cell-state entry;
	decide on 0.

To set next cell at row (Y - a number) column (X - a number) to (S - a number):
	repeat through Table of Next Grid:
		if y-coord entry is Y and x-coord entry is X:
			now cell-state entry is S;
			stop.

Section - Neighbor Counting

To decide what number is the neighbor count at row (Y - a number) column (X - a number):
	let total be 0;
	let dy be -1;
	while dy <= 1:
		let dx be -1;
		while dx <= 1:
			unless dy is 0 and dx is 0:
				let ny be Y plus dy;
				let nx be X plus dx;
				[Wrap around edges]
				if ny < 1:
					now ny is grid height;
				if ny > grid height:
					now ny is 1;
				if nx < 1:
					now nx is grid width;
				if nx > grid width:
					now nx is 1;
				let state be cell state at row ny column nx;
				increase total by state;
			increment dx;
		increment dy;
	decide on total.

Section - Update Logic

To update the simulation:
	[Calculate next generation and store in Next Grid]
	let row-num be 1;
	while row-num <= grid height:
		let col-num be 1;
		while col-num <= grid width:
			let neighbors be neighbor count at row row-num column col-num;
			let current be cell state at row row-num column col-num;
			let new-state be 0;
			if current is 1:
				[Alive cell]
				if neighbors is 2 or neighbors is 3:
					now new-state is 1;
			otherwise:
				[Dead cell]
				if neighbors is 3:
					now new-state is 1;
			[Update Next Grid]
			set next cell at row row-num column col-num to new-state;
			increment col-num;
		increment row-num;
	[Copy Next Grid to Current Grid]
	let copy-row be 1;
	while copy-row <= grid height:
		let copy-col be 1;
		while copy-col <= grid width:
			let new-val be next cell state at row copy-row column copy-col;
			set cell at row copy-row column copy-col to new-val;
			increment copy-col;
		increment copy-row.

Section - Display

To display the grid:
	let output-text be "";
	let row-num be 1;
	while row-num <= grid height:
		let col-num be 1;
		let line-text be "";
		while col-num <= grid width:
			let state be cell state at row row-num column col-num;
			if state is 1:
				now line-text is "[line-text]O ";
			otherwise:
				now line-text is "[line-text]. ";
			increment col-num;
		now output-text is "[output-text][line-text][line break]";
		increment row-num;
	say "[fixed letter spacing][output-text][variable letter spacing]";
	say "[line break]";
	say "════════════════════════════[line break]";
	say "FRAME: [current frame][line break]";
	say "════════════════════════════[line break]".

Section - Seeding (Simple Glider Example)

To seed the grid:
	[Place a glider at position 3,3]
	set cell at row 3 column 4 to 1;
	set cell at row 4 column 5 to 1;
	set cell at row 5 column 3 to 1;
	set cell at row 5 column 4 to 1;
	set cell at row 5 column 5 to 1.

Section - Commands

Advancing is an action applying to nothing.
Understand "advance" or "next" or "step" or "go" as advancing.

Carry out advancing:
	if current frame >= frame count limit:
		say "Simulation has reached the frame limit.";
		stop the action;
	increment current frame;
	update the simulation;
	display the grid.

Section - Main Loop

When play begins:
	initialize the grid;
	seed the grid;
	say "╔════════════════════════════╗[line break]";
	say "║  CONWAY'S GAME OF LIFE     ║[line break]";
	say "╚════════════════════════════╝[line break]";
	say "[line break]Commands: ADVANCE, NEXT, STEP, or GO[line break][line break]";
	display the grid.