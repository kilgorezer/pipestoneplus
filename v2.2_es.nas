using allow_include

// ----------------
// Custom Functions
// ----------------

#Plus:Y+
if dir|=|"Y-" quit
set Pipes.line{Pipes.index}.ceased false
set dir Y+
jump #Pipes:Y+

#Plus:Y-
if dir|=|"Y+" quit
set Pipes.line{Pipes.index}.ceased false
set dir Y-
jump #Pipes:Y-

#Plus:X+
if dir|=|"X-" quit
set Pipes.line{Pipes.index}.ceased false
set dir X+
jump #Pipes:X+

#Plus:X-
if dir|=|"X+" quit
set Pipes.line{Pipes.index}.ceased false
set dir X-
jump #Pipes:X-

#Plus:Z+
if dir|=|"Z-" quit
set Pipes.line{Pipes.index}.ceased false
set dir Z+
jump #Pipes:Z+

#Plus:Z-
if dir|=|"Z+" quit
set Pipes.line{Pipes.index}.ceased false
set dir Z-
jump #Pipes:Z-

#Plus:TeleS
// Example Usage: jump #Plus.TeleS|X|-|5
if runArg2|=|"-" set Plus.OPP +
if runArg2|=|"+" set Plus.OPP -
if dir|=|"{runArg1}{Plus.OPP}" quit
set Pipes.line{Pipes.index}.ceased false
set dir {runArg1}{runArg2}
setadd Pipes.line{Pipes.index}.{runArg1} {runArg2}{runArg3}
//msg %aDEBUG:%f {Pipes.line{Pipes.index}.{runArg1}}
set Pipes.line{Pipes.index}.dir {runArg1}{runArg2}
setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Plus:GetTeleS
set Plus.TX {X}
set Plus.TY {Y}
set Plus.TZ {Z}
set Plus.dist 0
// Set Variables
if dir|=|"X+" set Plus.dir X
if dir|=|"X-" set Plus.dir X
if dir|=|"Y+" set Plus.dir Y
if dir|=|"Y-" set Plus.dir Y
if dir|=|"Z+" set Plus.dir Z
if dir|=|"Z-" set Plus.dir Z
if dir|=|"X+" set Plus.sgn + 
if dir|=|"Y+" set Plus.sgn +
if dir|=|"Z+" set Plus.sgn +
if dir|=|"X-" set Plus.sgn -
if dir|=|"Y-" set Plus.sgn -
if dir|=|"Z-" set Plus.sgn -
// Begin while loop.
#Plus:TeleLoop
setadd Plus.dist 1
// Check if the next block out is the right one.
if dir|=|"X+" setadd Plus.TX 1
if dir|=|"X-" setsub Plus.TX 1
if dir|=|"Y+" setadd Plus.TY 1
if dir|=|"Y-" setsub Plus.TY 1
if dir|=|"Z+" setadd Plus.TZ 1
if dir|=|"Z-" setsub Plus.TZ 1
setblockid Plus.TEID {Plus.TX} {Plus.TY} {Plus.TZ}
if Plus.TEID|>|767 msg &mAdvertencia: %fEl teletransportador en {X} {Y} {Z} que envió una señal en la dirección {dir} no pudo encontrar un receptor. Saliendo de la sucursal...
if Plus.TEID|>|767 quit
//msg %aCurrent ID (Debugging): %f{Plus.TEID}
// End of while loop.
ifnot Plus.TEID|=|717 jump #Plus:TeleLoop
jump #Plus:TeleS|{Plus.dir}|{Plus.sgn}|{Plus.dist}

#Plus:Get
set Plus.PROPVALUE 0
set TEMP1 {Y}
setadd TEMP1 1
// Double-check that the packages are created. Note that these should be changed to match the map MOTD.

// Types:
// Integer (basically just JMPV): an integer
// Boolean (most of them): + or -
// Float (values that accept fractions): any positive number or zero

ifnot Plus.ENAV set Plus.THRV +
ifnot Plus.ENAV set Plus.FLYV +
ifnot Plus.ENAV set Plus.NOCV +
ifnot Plus.ENAV set Plus.SPDV +
ifnot Plus.ENAV set Plus.PSHV +
ifnot Plus.ENAV set Plus.SPNV +
ifnot Plus.ENAV set Plus.HGTV 1.0
ifnot Plus.ENAV set Plus.JMPV 1
ifnot Plus.ENAV set Plus.HORV 1.0
ifnot Plus.ENAV set Plus.MAXV 1.0
set Plus.ENAV true
#GetSub
// Get Block ID.
setblockid BlockID {X} {TEMP1} {Z}
// Check if there is Riveted Iron.
if BlockID|=|238 setadd Plus.PROPVALUE 1
if BlockID|=|238 setadd TEMP1 1
// If there is, account for it and repeat.
if BlockID|=|238 jump #GetSub
// If it is not, make sure the value is not too big and quit.
if Plus.PROPVALUE|>|1023 set Plus.PROPVALUE 1023
quit

#Plus:SpawnerGet
set TEMP1 {Y}
setsub TEMP1 1
setblockid Plus.PROPVALUE {X} {TEMP1} {Z}
setadd TEMP1 2
setblockid Plus.TOPVALUE {X} {TEMP1} {Z}
setsub Plus.TOPVALUE 484
quit

#Plus:Apply
motd {Plus.THRV}thirdperson {Plus.FLYV}fly {Plus.NOCV}noclip {Plus.SPDV}speed {Plus.PSHV}push {Plus.SPNV}respawn jumpheight={Plus.HGTV} jumps={Plus.JMPV} horspeed={Plus.HORV} maxspeed={Plus.MAXV}
jump #Pipes:gizmo[756]

#Plus:Resume
set Pipes.gizmo{X},{Y},{Z}
quit

#Plus:Display
if Plus.bot.{X}.{Y}.{Z}.text cmd tempbot remove {X}_{Y}_{Z}
// No need wasting actions, so dropped code was commented out
//set TEMP1 {Y}
//setsub TEMP1 0.032
cmd tempbot add {X}_{Y}_{Z} {X} {Y} {Z} 0 0 + &f{runArg1}+
// If it was 1.32 blocks further down: 6.5125 / 16.25 ~ 4.01
cmd tempbot model {X}_{Y}_{Z} kilgorezer+display|0.4
if Plus.VERBOSE msg &9Verbose: &fThe message "{runArg1}&f" has been displayed at {X} {Y} {Z}, with an input going in the direction {dir}.
ifnot Plus.bot.{X}.{Y}.{Z}.text set Plus.bot.{X}.{Y}.{Z}.text true
set Plus.block.{X}.{Y}.{Z}.value {runArg1}
quit

#Plus:RDisplay
if Plus.bot.{X}.{Y}.{Z}.text cmd tempbot remove
if Plus.bot.{X}.{Y}.{Z}.text resetdata packages Plus.bot.{X}.{Y}.{Z}.*
quit

// ----
// Main
// ----

#Pipes:version
// (no arguments)
	msg &fEjecutando Pipestone+ &a2.2&f, basado en Pipes &a2.2
quit

// runs the pipestone at the message block
#Pipes:messageblock
// (message block) (no arguments)
	allowmbrepeat
	set X {MBX}
	set Y {MBY}
	set Z {MBZ}
	set coords {MBCoords}
	set dir ?
	setblockid id {coords}
	// prerun
	if label #Pipes:prerun[{id}] call #Pipes:prerun[{id}]
	// adds the lines
	call #Pipes:softbox
	if Pipes.inprogress quit
	set Pipes.tick 0
	set Pipes.maxtick 0
jump #Pipes:doalllines

// runs the pipestone at the click event
#Pipes:clickevent
// (clickevent block) (no arguments)
	allowmbrepeat
	set coords {click.coords}
	setsplit coords " "
	set X {coords[0]}
	set Y {coords[1]}
	set Z {coords[2]}
	set dir ?
	setblockid id {coords}
	// prerun
	if label #Pipes:prerun[{id}] call #Pipes:prerun[{id}]
	// adds the lines
	call #Pipes:softbox
	if Pipes.inprogress quit
	set Pipes.tick 0
	set Pipes.maxtick 0
jump #Pipes:doalllines

// delays are 1 indexed
#Pipes:schedulebox
// X, Y, Z, in
	set Pipes.temp {Pipes.tick}
	setadd Pipes.temp {runArg1}
	if Pipes.maxtick|<|{Pipes.temp} set Pipes.maxtick {Pipes.temp}
	setadd Pipes.delay{Pipes.temp}.length 1
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].X {X}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].Y {Y}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].Z {Z}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].dir {dir}
quit

// keep in mind, lines are 1-indexed
#Pipes:pushline
// X, Y, Z, Direction
	ifnot Pipes.line{Pipes.lines}.ceased setadd Pipes.lines 1
	set Pipes.line{Pipes.lines}.X {runArg1}
	set Pipes.line{Pipes.lines}.Y {runArg2}
	set Pipes.line{Pipes.lines}.Z {runArg3}
	setblockid Pipes.line{Pipes.lines}.id {runArg1} {runArg2} {runArg3}
	set Pipes.line{Pipes.lines}.dir {runArg4}
	set Pipes.line{Pipes.lines}.ceased false
quit

#Pipes:doalllines
// (no arguments)
	set Pipes.inprogress true
	set Pipes.index 0
	set Pipes.validlines false
	#Pipes:lineloop
	// (no arguments)
		// spin up a new thread if action count is running high
		if actionCount|>|50000 jump #Pipes:failsafe|#Pipes:lineloop
		setadd Pipes.index 1
		if Pipes.line{Pipes.index}.ceased jump #Pipes:skip
		set Pipes.validlines true
		// unwrap once
		set id {Pipes.line{Pipes.index}.id}
		// if pipes move in pipe direction
		if id|=|550 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|551 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|552 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		// if box then do box
		if id|=|238 jump #Pipes:box
		// if delay do delay
		if id|=|485 jump #Pipes:delay|1
		if id|=|486 jump #Pipes:delay|2
		if id|=|487 jump #Pipes:delay|3
		if id|=|488 jump #Pipes:delay|4
		if id|=|489 jump #Pipes:delay|5
		if id|=|490 jump #Pipes:delay|6
		if id|=|491 jump #Pipes:delay|7
		if id|=|492 jump #Pipes:delay|8
		if id|=|493 jump #Pipes:delay|9
		if id|=|484 jump #Pipes:delay|10
		// not a box or a pipe so set packages
		set X {Pipes.line{Pipes.index}.X}
		set Y {Pipes.line{Pipes.index}.Y}
		set Z {Pipes.line{Pipes.index}.Z}
		set dir {Pipes.line{Pipes.index}.dir}
		set coords {X} {Y} {Z}
		set type {Pipes.line{Pipes.index}.type}
		set message {Pipes.line{Pipes.index}.message}
		// cease line
		set Pipes.line{Pipes.index}.ceased true
		// and call gizmo if its not been called yet
		if Pipes.gizmo{X},{Y},{Z} jump #Pipes:skip
		set Pipes.gizmo{X},{Y},{Z} true
		if label #Pipes:gizmo[{id}] call #Pipes:gizmo[{id}]
		set Pipes.line{Pipes.index}.type {type}
		set Pipes.line{Pipes.index}.message {message}
		#Pipes:skip
		if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
	if Pipes.validlines jump #Pipes:doalllines
	// erase everything
	resetdata packages Pipes.line*
	resetdata packages Pipes.gizmo*
	resetdata packages Pipes.box*
	// loop increment tick and delay 100ms until maxticks hit
	#Pipes:tickloop
		setadd Pipes.tick 1
		if Pipes.tick|>|Pipes.maxtick jump #Pipes:cleanup
		delay 100
		// next iteration if it doesnt exist
		if Pipes.delay{Pipes.tick}.length|=|"" jump #Pipes:tickloop
		// loop through all and do boxes
		set Pipes.temp 0
		#Pipes:delayloop
			if actionCount|>|50000 jump #Pipes:failsafe|#Pipes:delayloop
			setadd Pipes.temp 1
			set X {Pipes.delay{Pipes.tick}[{Pipes.temp}].X}
			set Y {Pipes.delay{Pipes.tick}[{Pipes.temp}].Y}
			set Z {Pipes.delay{Pipes.tick}[{Pipes.temp}].Z}
			set dir {Pipes.delay{Pipes.tick}[{Pipes.temp}].dir}
			call #Pipes:softbox
			// oh god did ave cause a memory leak??????
			resetdata packages Pipes.delay{Pipes.tick}*
		if Pipes.temp|<|Pipes.delay{Pipes.tick}.length jump #Pipes:delayloop
	jump #Pipes:doalllines
	// cleanup
	#Pipes:cleanup
	resetdata packages Pipes.delay*
	// Patch to prevent infinite loops
	resetdata packages Pipes.line*
	resetdata packages Pipes.gizmo*
	resetdata packages Pipes.box*
	set type
	set message
	// End of patch
	if Pipes.threads|>|0 msg &eSe utilizaron {Pipes.threads} subprocesos y acciones {actionCount}.
	set Pipes.threads 0
	set Pipes.inprogress false
terminate

#Pipes:failsafe
// (no arguments)
	if Pipes.threads|=|0 msg &eAdvertencia: las acciones superaron los 50 000 ({actionCount}), utilizando subprocesos para completar...
	setadd Pipes.threads 1
	if Pipes.threads|=|5 msg &eAdvertencia: las acciones superaron las 250.000. Considere optimizar su pipestone.
	if Pipes.threads|=|9 msg &eAdvertencia: las acciones superaron las 450.000. Pipestone+ recomienda encarecidamente optimizar su pipestone.
	if Pipes.threads|>=|10 msg &cError: las acciones excedieron los 500 000 en total (10 subprocesos y {actionCount} acciones), los pipes no se pueden completar, se cancela...
	if Pipes.threads|>=|10 jump #Pipes:cleanup
	newthread {runArg1}
terminate

#Pipes:X+
// (no arguments)
	setadd Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:X-
// (no arguments)
	setsub Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:terminate
call #Pipes:cleanup
terminate

#Pipes:delay
// in
	// set generic packages
	set X {Pipes.line{Pipes.index}.X}
	set Y {Pipes.line{Pipes.index}.Y}
	set Z {Pipes.line{Pipes.index}.Z}
	set dir {Pipes.line{Pipes.index}.dir}
	// schedule the delay for the runarg
	call #Pipes:schedulebox|{runArg1}
	// cease the line
	set Pipes.line{Pipes.index}.ceased true
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:box
// (no arguments)
	// set generic packages
	set X {Pipes.line{Pipes.index}.X}
	set Y {Pipes.line{Pipes.index}.Y}
	set Z {Pipes.line{Pipes.index}.Z}
	set dir {Pipes.line{Pipes.index}.dir}
	set id {Pipes.line{Pipes.index}.id}
	// cease the line
	set Pipes.line{Pipes.index}.ceased true
	call #Pipes:softbox
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:softbox
// (no arguments)
	if Pipes.box{X},{Y},{Z} quit
	set Pipes.box{X},{Y},{Z} true
	//
	// check X+
	setadd X 1
	setblockid id {X} {Y} {Z}
	if dir|=|"X-" set id 0
	call #Plus:CheckX|+
	// check X-
	setsub X 2
	setblockid id {X} {Y} {Z}
	if dir|=|"X+" set id 0
	call #Plus:CheckX|-
	// reset X
	setadd X 1
	//
	// check Z+
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Z-" set id 0
	call #Plus:CheckZ|+
	// check Z-
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Z+" set id 0
	call #Plus:CheckZ|-
	// reset Z
	setadd Z 1
	//
	// check Y+
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Y-" set id 0
	call #Plus:CheckY|+
	// check Y-
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Y+" set id 0
	call #Plus:CheckY|-
	// reset Y
	setadd Y 1
quit

#Plus:CheckX
if id|=|551 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
if id|=|720 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
if id|=|721 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
if id|=|718 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
if id|=|76 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
if id|=|715 call #Pipes:pushline|{X}|{Y}|{Z}|X{runArg1}
quit

#Plus:CheckY
if id|=|550 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|656 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|719 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|720 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|721 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|718 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|75 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
if id|=|715 call #Pipes:pushline|{X}|{Y}|{Z}|Y{runArg1}
quit

#Plus:CheckZ
if id|=|552 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
if id|=|720 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
if id|=|721 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
if id|=|718 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
if id|=|77 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
if id|=|715 call #Pipes:pushline|{X}|{Y}|{Z}|Z{runArg1}
quit

// ------
// Gizmos
// ------

// Print version number
#onJoin
jump #Pipes:version

// Prevent every map ever from breaking
#run
jump #Pipes:messageblock

// White
#Pipes:prerun[36]
	if id|=|36 msg &cWhite no se puede utilizar como interruptor.
	if id|=|36 jump #Pipes:terminate
quit

// Sign
#Pipes:prerun[171]
	if id|=|171 msg &cSign no se puede utilizar como interruptor.
	if id|=|171 jump #Pipes:terminate
quit

// Pressure plate
#Pipes:prerun[766]
	if id|=|766 setsub Y 1
quit

// Lamp Off
#Pipes:gizmo[764]
	placeblock 62 {X} {Y} {Z}
quit

// Lamp
#Pipes:gizmo[62]
	placeblock 764 {X} {Y} {Z}
quit

// Light Off
#Pipes:gizmo[765]
	placeblock 215 {X} {Y} {Z}
quit

// Light
#Pipes:gizmo[215]
	placeblock 765 {X} {Y} {Z}
quit

// White
#Pipes:gizmo[36]
	cmd m {X} {Y} {Z}
quit

// Sign
#Pipes:gizmo[171]
	cmd m {X} {Y} {Z}
quit

// Block placer-N
#Pipes:gizmo[758]
	set TEMP {Z}
	setadd TEMP 1
	setblockid tempid {X} {Y} {TEMP}
	if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
	if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

// Block placer-N
#Pipes:gizmo[759]
	set TEMP {Z}
	setsub TEMP 1
	setblockid tempid {X} {Y} {TEMP}
	if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
	if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

// Block placer-E
#Pipes:gizmo[760]
	set TEMP {X}
	setsub TEMP 1
	setblockid tempid {TEMP} {Y} {Z}
	if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
	if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

// Block placer-W
#Pipes:gizmo[761]
	set TEMP {X}
	setadd TEMP 1
	setblockid tempid {TEMP} {Y} {Z}
	if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
	if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

// Block placer-U
#Pipes:gizmo[762]
	set TEMP {Y}
	setsub TEMP 1
	setblockid tempid {X} {TEMP} {Z}
	if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
	if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

// Block placer-D
#Pipes:gizmo[763]
	set TEMP {Y}
	setadd TEMP 1
	setblockid tempid {X} {TEMP} {Z}
	if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
	if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

// Passthrough
#Pipes:gizmo[756]
	call #Plus:Resume
	jump #Plus:{dir}
	if dir|=|"X+" jump #Plus:X+
	if dir|=|"X-" jump #Plus:X-
	if dir|=|"Y+" jump #Plus:Y+
	if dir|=|"Y-" jump #Plus:Y-
	if dir|=|"Z+" jump #Plus:Z+
	if dir|=|"Z-" jump #Plus:Z-
quit

// Swapper-UD
#Pipes:gizmo[755]
	if dir|=|"Y+" quit
	if dir|=|"Y-" quit
	set TEMP1 {Y}
	setadd TEMP1 1
	setblockid tempid1 {X} {TEMP1} {Z}
	set TEMP2 {Y}
	setsub TEMP2 1
	setblockid tempid2 {X} {TEMP2} {Z}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {X} {TEMP2} {Z}
	placeblock {tempid2} {X} {TEMP1} {Z}
quit

// Swapper-NS
#Pipes:gizmo[754]
	if dir|=|"Z+" quit
	if dir|=|"Z-" quit
	set TEMP1 {Z}
	setadd TEMP1 1
	setblockid tempid1 {X} {Y} {TEMP1}
	set TEMP2 {Z}
	setsub TEMP2 1
	setblockid tempid2 {X} {Y} {TEMP2}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {X} {Y} {TEMP2}
	placeblock {tempid2} {X} {Y} {TEMP1}
quit

// Swapper-WE
#Pipes:gizmo[753]
	if dir|=|"X+" quit
	if dir|=|"X-" quit
	set TEMP1 {X}
	setadd TEMP1 1
	setblockid tempid1 {TEMP1} {Y} {Z}
	set TEMP2 {X}
	setsub TEMP2 1
	setblockid tempid2 {TEMP2} {Y} {Z}
	if tempid1|>|767 quit
	if tempid2|>|767 quit
	placeblock {tempid1} {TEMP2} {Y} {Z}
	placeblock {tempid2} {TEMP1} {Y} {Z}
quit

// -------------
// Custom Gizmos
// -------------

// Data Types
#Plus:Float
setdiv Plus.PROPVALUE 8
quit
#Plus:Bool
if Plus.PROPVALUE|>|0 jump #Plus:BoolTrue
if Plus.PROPVALUE|<=|0 jump #Plus:BoolFalse
#Plus:BoolTrue
set Plus.PROPVALUE +
quit
#Plus:BoolFalse
set Plus.PROPVALUE -
quit

// Door
#Pipes:gizmo[750]
cmd x {X} {Y} {Z}
if Plus.VERBOSE call #Plus:Display|{dir}
quit

// Command Block
#Pipes:gizmo[722]
jump #Pipes:gizmo[750]

// Mark Block
#Pipes:gizmo[739]
if dir|=|"Y-" quit
set TEMP1 {Y}
setadd TEMP1 1
setblockid Plus.blockabove {X} {TEMP1} {Z}
if Plus.blockabove|=|550 jump #Plus:Y+
if Plus.blockabove|=|756 jump #Plus:Y+
if Plus.blockabove|=|739 jump #Plus:Y+
if Plus.blockabove|=|238 jump #Plus:Y+
if Plus.blockabove|=|719 jump #Plus:Y+
if Plus.blockabove|=|656 jump #Plus:Y+
if Plus.blockabove|=|720 jump #Plus:Y+
if Plus.blockabove|=|721 jump #Plus:Y+
cmd x {X} {TEMP1} {Z}
quit

// Teleport Block
#Pipes:gizmo[738]
set TEMPX {X}
set TEMPY {Y}
set TEMPZ {Z}
setsub TEMPX PlayerX
setsub TEMPY PlayerY
setsub TEMPZ PlayerZ
setadd TEMPY 1
cmd reltp {TEMPX} {TEMPY} {TEMPZ}
quit

// Configuration Blocks
#Pipes:gizmo[749]
#Pipes:gizmo[748]
#Pipes:gizmo[747]
#Pipes:gizmo[746]
#Pipes:gizmo[745]
#Pipes:gizmo[744]
#Pipes:gizmo[743]
#Pipes:gizmo[742]
#Pipes:gizmo[741]
#Pipes:gizmo[740]
#Pipes:gizmo[737]
#Pipes:gizmo[736]
#Pipes:gizmo[735]
#Pipes:gizmo[734]
#Pipes:gizmo[733]
#Pipes:gizmo[732]
#Pipes:gizmo[731]
#Pipes:gizmo[730]
#Pipes:gizmo[729]
#Pipes:gizmo[728]
#Pipes:gizmo[726]
call #Plus:Get
setblockid Plus.id {X} {Y} {Z}
if Plus.id|=|749 jump #Plus:Hax
if Plus.id|=|748 jump #Plus:Fly
if Plus.id|=|747 jump #Plus:Noclip
if Plus.id|=|746 jump #Plus:Speed
if Plus.id|=|745 jump #Plus:Push
if Plus.id|=|744 jump #Plus:Spawn
if Plus.id|=|743 jump #Plus:Height
if Plus.id|=|742 jump #Plus:Jumps
if Plus.id|=|741 jump #Plus:Hor
if Plus.id|=|740 reach {Plus.PROPVALUE}
if Plus.id|=|740 quit
if Plus.id|=|737 msg %4Pipestone+ intentó ejecutar un bloque de configuración no válido. Abortando rama...
if Plus.id|=|737 quit
if Plus.id|=|736 jump #Plus:Max
if Plus.id|=|735 jump #Plus:Verbose
msg %4Pipestone+ intentó ejecutar un bloque de configuración no válido. Abortando rama...
quit

// Only Power On
#Pipes:gizmo[751]
tempblock 62 {X} {Y} {Z}
quit

// Clockwise Rotator
#Pipes:gizmo[720]
call #Plus:Resume
if dir|=|"X+" jump #Plus:Z-
if dir|=|"X-" jump #Plus:Z+
if dir|=|"Y+" jump #Plus:Y+
if dir|=|"Y-" jump #Plus:Y-
if dir|=|"Z+" jump #Plus:X+
if dir|=|"Z-" jump #Plus:X-
quit

// Counterclockwise Rotator
#Pipes:gizmo[721]
call #Plus:Resume
if dir|=|"X+" jump #Plus:Z+
if dir|=|"X-" jump #Plus:Z-
if dir|=|"Y+" jump #Plus:Y+
if dir|=|"Y-" jump #Plus:Y-
if dir|=|"Z+" jump #Plus:X-
if dir|=|"Z-" jump #Plus:X+
quit

// Eat Block
#Pipes:gizmo[196]
#Pipes:gizmo[197]
cmd eat
quit

// Effect Spawner
#Pipes:gizmo[161]
call #Plus:SpawnerGet
set TEMP1 {Y}
setadd TEMP1 {Plus.TOPVALUE}
setadd TEMP1 2.5
if Plus.PROPVALUE|=|41 effect coin {X} {TEMP1} {Z} 0 1 0 true
if Plus.PROPVALUE|=|656 effect lanternprecise {X} {TEMP1} {Z} 0 -1 0 true
quit

// Unlit Lantern
#Pipes:gizmo[719]
if dir|=|"X+" quit
if dir|=|"X-" quit
if dir|=|"Z+" quit
if dir|=|"Z-" quit
placeblock 656 {X} {Y} {Z}
if dir|=|"Y+" jump #Plus:Y+
if dir|=|"Y-" jump #Plus:Y-
quit

// Lantern
#Pipes:gizmo[656]
if dir|=|"X+" quit
if dir|=|"X-" quit
if dir|=|"Z+" quit
if dir|=|"Z-" quit
placeblock 719 {X} {Y} {Z}
if dir|=|"Y+" jump #Plus:Y+
if dir|=|"Y-" jump #Plus:Y-
quit

// Teleporter
#Pipes:gizmo[718]
jump #Plus:GetTeleS

// Reciever
#Pipes:gizmo[717]
jump #Pipes:gizmo[756]

// Delay 0 (Change Case)
#Pipes:gizmo[723]
call #Plus:Resume
jump #Pipes:softbox

// Debugging Pipe facing Y
#Pipes:gizmo[75]
if dir|=|"X+" quit
if dir|=|"X-" quit
if dir|=|"Z+" quit
if dir|=|"Z-" quit
call #Plus:debug
if dir|=|"Y+" jump #Plus:Y+
if dir|=|"Y-" jump #Plus:Y-
quit

// Debugging Pipe facing X
#Pipes:gizmo[76]
if dir|=|"Y+" quit
if dir|=|"Y-" quit
if dir|=|"Z+" quit
if dir|=|"Z-" quit
call #Plus:debug
if dir|=|"X+" jump #Plus:X+
if dir|=|"X-" jump #Plus:X-
quit

// Debugging Pipe facing Z
#Pipes:gizmo[77]
if dir|=|"X+" quit
if dir|=|"X-" quit
if dir|=|"Y+" quit
if dir|=|"Y-" quit
call #Plus:debug
if dir|=|"Z+" jump #Plus:Z+
if dir|=|"Z-" jump #Plus:Z-
quit

// Debugging Block
#Plus:debug
if Plus.VERBOSE msg %9Detallado: %fEl bloque de depuración en {X} {Y} {Z} frente a {dir} se ha activado. El número actual de acciones ejecutadas es {actionCount} y el número de subprocesos que se utilizan es {Pipes.threads}.
quit

// Debugging Box (Lined Stone)
#Pipes:gizmo[477]
call #Plus:debug
//set type text
//set message test
jump #Pipes:softbox

// Debugging Passthrough (Marker Copy)
#Pipes:gizmo[716]
call #Plus:debug
jump #Pipes:gizmo[756]

// Recieve Message Block (Glass)
#Pipes:gizmo[20]
ifnot type|=|"text" quit
call #Plus:Display|{message}
quit

#Pipes:gizmo[715]
jump #Pipes:softbox

// -------------
// Input Command
// -------------

#input
if runArg1|=|"" msg %a/input plate
if runArg1|=|"" msg %7Hace que el siguiente bloque que coloques y/o elimines sea una placa de presión.
if runArg1|=|"" msg %a/input sign
if runArg1|=|"" msg %7Hace que el siguiente bloque que coloques y/o elimines sea una placa que puede activar pipestone.
if runArg1|=|"" msg %a/input config [type]
if runArg1|=|"" msg %7Cambia su bloque retenido a un bloque de configuración.
if runArg1|=|"" msg %7Enumera los bloques disponibles si el tipo falta o no es válido.
if runArg1|=|"" msg %a/input command [comando] <argumentos>
if runArg1|=|"" msg %7Crea un bloque de comando que ejecuta [comando] con <argumentos>
if runArg1|=|"" msg %7Para obtener más comandos, ejecute %a/input pg2%7.
if runArg1|=|"" msg %7Usable by: %uMember%7+
if runArg1|=|"pg1" msg %a/input pg1
if runArg1|=|"pg1" msg %7¿Eres un idiota o un genio? No puedo decirlo.
if runArg1|=|"pg1" msg %7Usable by: %uMember%7+
if runArg1|=|"pg2" msg %a/input text [message]
if runArg1|=|"pg2" msg %7Crea un bloque de comando que muestra [mensaje] con un color predeterminado de %aVerde%7.
if runArg1|=|"pg2" msg %a/input basics
if runArg1|=|"pg2" msg %7Teletransporta al usuario al tutorial de tuberías. Tenga en cuenta que el tutorial está en inglés.
if runArg1|=|"pg2" msg %7Usable by: %uMember%7+
if runArg1|=|"plate" cmd mb pressureplate /oss #run
if runArg1|=|"plate" quit
if runArg1|=|"sign" cmd mb plaque /oss #run
if runArg1|=|"sign" quit
if runArg1|=|"config" call #Config|{runArg2}
if runArg1|=|"command" cmd mb commandblock /{runArg2}
if runArg1|=|"command" quit
if runArg1|=|"text" cmd mb commandblock %a{runArg2}
if runArg1|=|"text" quit
if runArg1|=|"basics" cmd g bravelycowering+9
if runArg1|=|"basics" quit
if runArg1|=|"tut" cmd g kilgorezer+61
if runArg1|=|"tut" cmd x 0 0 0
if runArg1|=|"tut" quit
quit

#Config
if runArg1|=|"thirdperson" cmd hold 749
if runArg1|=|"thirdperson" quit
if runArg1|=|"fly" cmd hold 748
if runArg1|=|"fly" quit
if runArg1|=|"noclip" cmd hold 747
if runArg1|=|"noclip" quit
if runArg1|=|"speed" cmd hold 746
if runArg1|=|"speed" quit
if runArg1|=|"push" cmd hold 745
if runArg1|=|"push" quit
if runArg1|=|"respawn" cmd hold 744
if runArg1|=|"respawn" quit
if runArg1|=|"jumpheight" cmd hold 743
if runArg1|=|"jumpheight" quit
if runArg1|=|"jumps" cmd hold 742
if runArg1|=|"jumps" quit
if runArg1|=|"horspeed" cmd hold 741
if runArg1|=|"horspeed" quit
if runArg1|=|"reach" cmd hold 740
if runArg1|=|"reach" quit
if runArg1|=|"maxspeed" cmd hold 736
if runArg1|=|"maxspeed" quit
if runArg1|=|"cpemsg" cmd hold 724
if runArg1|=|"cpemsg" quit
if runArg1|=|"verbose" cmd hold 735
if runArg1|=|"verbose" quit
msg %a/input config [tipo]
msg %7Valores válidos para [tipo]:
// msg %mthirdperson, fly, noclip, speed, push, respawn, %djumpheight, %9jumps, %dhorspeed, %9reach, %dmaxspeed, %7cpemsg
msg %mthirdperson, fly, noclip, speed, push, respawn, %djumpheight, %9jumps, %dhorspeed, %9reach, %dmaxspeed, %mverbose
quit

// ----------------------
// Configuration Commands
// ----------------------

#Plus:Hax
//Now Third Person
call #Plus:Bool
set Plus.THRV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Fly
call #Plus:Bool
set Plus.FLYV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Noclip
call #Plus:Bool
set Plus.NOCV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Speed
call #Plus:Bool
set Plus.SPDV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Push
call #Plus:Bool
set Plus.PSHV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Spawn
call #Plus:Bool
set Plus.SPNV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Height
call #Plus:Float
set Plus.HGTV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Jumps
set Plus.JMPV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Hor
call #Plus:Float
set Plus.HORV {Plus.PROPVALUE}
jump #Plus:Apply

#Plus:Verbose
call #Plus:Bool
if Plus.PROPVALUE|=|"+" set Plus.Verbose true
if Plus.PROPVALUE|=|"-" set Plus.Verbose false
jump #Pipes:gizmo[756]

#Mark
set TEMP1 {Y}
setadd TEMP1 1
setblockid blockabove {X} {TEMP1} {Z}
if blockabove|=|550 jump #Plus:Y+
if blockabove|=|756 jump #Plus:Y+
if blockabove|=|739 jump #Plus:Y+
if blockabove|=|238 jump #Plus:Y+
cmd x {X} {TEMP1} {Z}
quit
