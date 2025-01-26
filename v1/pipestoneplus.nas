using allow_include

// Stuff that might be modified

#Get
set PROPVALUE 0
set TEMP1 {Y}
setadd TEMP1 1
// Double-check that the packages are created. Note that these should be changed to match the map MOTD.

// Types:
// Integer (basically just JMPV): an integer
// Boolean (most of them): + or -
// Float (values that accept fractions): any positive number or zero

ifnot ENAV set THRV +
ifnot ENAV set FLYV +
ifnot ENAV set NOCV +
ifnot ENAV set SPDV +
ifnot ENAV set PSHV +
ifnot ENAV set SPNV +
ifnot ENAV set HGTV 1.0
ifnot ENAV set JMPV 1
ifnot ENAV set HORV 1.0
ifnot ENAV set MAXV 1.0
set ENAV true
#GetSub
// Get Block ID.
setblockid BlockID {X} {TEMP1} {Z}
// Check if there is Riveted Iron.
if BlockID|=|238 setadd PROPVALUE 1
if BlockID|=|238 setadd TEMP1 1
// If there is, account for it and repeat.
if BlockID|=|238 jump #GetSub
// If it is not, make sure the value is not too big and quit.
if PROPVALUE|>|1023 set PROPVALUE 1023
quit

// Main

#p
cmd mb {runArg1} /oss #run
quit

#run
set X {MBX}
set Y {MBY}
set Z {MBZ}
set b 0
setblockid id {MBCoords}
if label #runoffset call #runoffset
call #dogizmo
setblockid id {X} {Y} {Z}
call #box
resetdata packages box_*
allowmbrepeat
quit

#pipe-aY
set box_lastdir{b} aY
set lastdir aY
setadd Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-aY
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sY
set box_lastdir{b} sY
set lastdir sY
setsub Y 1
setblockid id {X} {Y} {Z}
if id|=|550 jump #pipe-sY
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-aX
set box_lastdir{b} aX
set lastdir aX
setadd X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-aX
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sX
set box_lastdir{b} sX
set lastdir sX
setsub X 1
setblockid id {X} {Y} {Z}
if id|=|551 jump #pipe-sX
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-aZ
set box_lastdir{b} aZ
set lastdir aZ
setadd Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-aZ
if id|=|238 jump #box
jump #dogizmo
quit

#pipe-sZ
set box_lastdir{b} sZ
set lastdir sZ
setsub Z 1
setblockid id {X} {Y} {Z}
if id|=|552 jump #pipe-sZ
if id|=|238 jump #box
jump #dogizmo
quit

#dogizmo
if box_giz_{X}_{Y}_{Z} quit
set box_giz_{X}_{Y}_{Z} true
setblockid id {X} {Y} {Z}
if label #gizmo call #gizmo
quit

#box
// prevent infinite loops
if box_pl_{X}_{Y}_{Z} quit
set box_pl_{X}_{Y}_{Z} true
// save coords of box #
set box_{b}_X {X}
set box_{b}_Y {Y}
set box_{b}_Z {Z}
//
// check add X
// set X {box_{b}_X}
// set Y {box_{b}_Y}
// set Z {box_{b}_Z}
setadd X 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sX" set id 0
setadd b 1
if id|=|551 call #pipe-aX
setsub b 1
//
// check sub X
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub X 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aX" set id 0
setadd b 1
if id|=|551 call #pipe-sX
setsub b 1
//
// check add Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Y 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sY" set id 0
setadd b 1
if id|=|550 call #pipe-aY
setsub b 1
//
// check sub Y
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Y 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aY" set id 0
setadd b 1
if id|=|550 call #pipe-sY
setsub b 1
//
// check add Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setadd Z 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"sZ" set id 0
setadd b 1
if id|=|552 call #pipe-aZ
setsub b 1
//
// check sub Z
set X {box_{b}_X}
set Y {box_{b}_Y}
set Z {box_{b}_Z}
setsub Z 1
setblockid id {X} {Y} {Z}
if box_lastdir{b}|=|"aZ" set id 0
setadd b 1
if id|=|552 call #pipe-sZ
setsub b 1
quit

// Gizmos

#runoffset
if id|=|36 msg &cWhite cannot be used as a switch
if id|=|36 terminate
if id|=|171 msg &cSign cannot be used as a switch
if id|=|171 terminate
if id|=|766 setsub Y 1
quit

#gizmo
// LEDS
if id|=|765 placeblock 215 {X} {Y} {Z}
if id|=|215 placeblock 765 {X} {Y} {Z}
// Lamps
if id|=|764 placeblock 62 {X} {Y} {Z}
if id|=|62 placeblock 764 {X} {Y} {Z}
// Message Blocks
if id|=|36 cmd m {X} {Y} {Z}
// Signs
if id|=|171 cmd m {X} {Y} {Z}
// Block dispensors
if id|=|758 jump #BP-N
if id|=|759 jump #BP-S
if id|=|760 jump #BP-E
if id|=|761 jump #BP-W
if id|=|762 jump #BP-U
if id|=|763 jump #BP-D
// Passthroughs
if id|=|756 jump #passthrough
// Swappers
if id|=|755 jump #BS-UD
if id|=|754 jump #BS-NS
if id|=|753 jump #BS-WE

// kilgorezer+61 blocks

// Temporary Lamps
if id|=|751 tempblock 62 {X} {Y} {Z}

// Other Lamps

// Doors
if id|=|750 cmd x {X} {Y} {Z}

// Configuration Blocks
set IDVERIFICATION 0
if id|<=|749 setadd IDVERIFICATION 1
if id|>=|740 setadd IDVERIFICATION 1
if IDVERIFICATION|=|2 call #Get
set IDVERIFICATION 0
if id|<=|736 setadd IDVERIFICATION 1
if id|>=|726 setadd IDVERIFICATION 1
if IDVERIFICATION|=|2 call #Get
if id|=|749 jump #Hax
if id|=|748 jump #Fly
if id|=|747 jump #Noclip
if id|=|746 jump #Speed
if id|=|745 jump #Push
if id|=|744 jump #Spawn
if id|=|743 jump #Height
if id|=|742 jump #Jumps
if id|=|741 jump #Hor
if id|=|740 reach {PROPVALUE}
if id|=|737 msg %4Pipestone+ attempted to run an invalid configuration block. Aborting branch...
if id|=|737 quit
if id|=|736 jump #Max
if IDVERIFICATION|=|2 msg %4Pipestone+ attempted to run an invalid configuration block. Aborting branch...
if IDVERIFICATION|=|2 quit

// Special Interaction Blocks
if id|=|739 jump #Mark
if id|=|738 jump #Tele

// Non-Working Delays
// if id|=|752 delay 125
// if id|=|752 jump #passthrough
quit

#passthrough
set box_giz_{X}_{Y}_{Z}
if lastdir|=|"aX" jump #pipe-aX
if lastdir|=|"sX" jump #pipe-sX
if lastdir|=|"aY" jump #pipe-aY
if lastdir|=|"sY" jump #pipe-sY
if lastdir|=|"aZ" jump #pipe-aZ
if lastdir|=|"sZ" jump #pipe-sZ
quit

#BP-W
set TEMP {X}
setadd TEMP 1
setblockid tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-E
set TEMP {X}
setsub TEMP 1
setblockid tempid {TEMP} {Y} {Z}
if tempid|=|0 placeblock 238 {TEMP} {Y} {Z}
if tempid|=|238 placeblock 0 {TEMP} {Y} {Z}
quit

#BP-N
set TEMP {Z}
setadd TEMP 1
setblockid tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

#BP-S
set TEMP {Z}
setsub TEMP 1
setblockid tempid {X} {Y} {TEMP}
if tempid|=|0 placeblock 238 {X} {Y} {TEMP}
if tempid|=|238 placeblock 0 {X} {Y} {TEMP}
quit

#BP-D
set TEMP {Y}
setadd TEMP 1
setblockid tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

#BP-U
set TEMP {Y}
setsub TEMP 1
setblockid tempid {X} {TEMP} {Z}
if tempid|=|0 placeblock 238 {X} {TEMP} {Z}
if tempid|=|238 placeblock 0 {X} {TEMP} {Z}
quit

#BS-UD
if lastdir|=|"aY" quit
if lastdir|=|"sY" quit
set TEMP1 {Y}
setadd TEMP1 1
setblockid tempid1 {X} {TEMP1} {Z}
set TEMP2 {Y}
setsub TEMP2 1
setblockid tempid2 {X} {TEMP2} {Z}
placeblock {tempid1} {X} {TEMP2} {Z}
placeblock {tempid2} {X} {TEMP1} {Z}
quit

#BS-NS
if lastdir|=|"aZ" quit
if lastdir|=|"sZ" quit
set TEMP1 {Z}
setadd TEMP1 1
setblockid tempid1 {X} {Y} {TEMP1}
set TEMP2 {Z}
setsub TEMP2 1
setblockid tempid2 {X} {Y} {TEMP2}
placeblock {tempid1} {X} {Y} {TEMP2}
placeblock {tempid2} {X} {Y} {TEMP1}
quit

#BS-WE
if lastdir|=|"aX" quit
if lastdir|=|"sX" quit
set TEMP1 {X}
setadd TEMP1 1
setblockid tempid1 {TEMP1} {Y} {Z}
set TEMP2 {X}
setsub TEMP2 1
setblockid tempid2 {TEMP2} {Y} {Z}
placeblock {tempid1} {TEMP2} {Y} {Z}
placeblock {tempid2} {TEMP1} {Y} {Z}
quit

#NoHax
set THRV -
set FLYV -
set NOCV -
set SPDV -
set PSHV -
set SPNV -
set HGTV 1.0
set JMPV 1
set HORV 1.0
set MAXV 1.0
reach 5
call #Apply2
quit

#Float
setdiv PROPVALUE 8
quit

#Bool
if PROPVALUE|>|0 jump #BoolTrue
if PROPVALUE|<=|0 jump #BoolFalse
#BoolTrue
set PROPVALUE +
quit
#BoolFalse
set PROPVALUE -
quit

#input
if runArg1|=|"" msg %a/input plate
if runArg1|=|"" msg %7Places a pressure plate.
if runArg1|=|"" msg %a/input sign
if runArg1|=|"" msg %7Places a plaque that can activate pipestone.
if runArg1|=|"" msg %a/input config [type]
if runArg1|=|"" msg %7Changes your held block to a configuration block.
if runArg1|=|"" msg %7Lists avalible blocks if the type is missing or invalid.
if runArg1|=|"" msg %7Usable by: %uMember%7+
if runArg1|=|"plate" cmd mb pressureplate /oss #run
if runArg2|=|"plate" jump #Apply
if runArg1|=|"sign" cmd mb plaque /oss #run
if runArg2|=|"sign" jump #Apply
if runArg1|=|"config" call #Config|{runArg2}
quit

#Hax
//Now Third Person
call #Bool
set THRV {PROPVALUE}
jump #Apply

#Fly
call #Bool
set FLYV {PROPVALUE}
jump #Apply

#Noclip
call #Bool
set NOCV {PROPVALUE}
jump #Apply

#Speed
call #Bool
set SPDV {PROPVALUE}
jump #Apply

#Push
call #Bool
set PSHV {PROPVALUE}
jump #Apply

#Spawn
call #Bool
set SPNV {PROPVALUE}
jump #Apply

#Height
call #Float
set HGTV {PROPVALUE}
jump #Apply

#Jumps
set JMPV {PROPVALUE}
jump #Apply

#Hor
call #Float
set HORV {PROPVALUE}
jump #Apply

#Apply
motd {THRV}thirdperson {FLYV}fly {NOCV}noclip {SPDV}speed {PSHV}push {SPNV}spawn jumpheight={HGTV} jumps={JMPV} horspeed={HORV} maxspeed={MAXV}
jump #passthrough

#Apply2
motd {THRV}thirdperson {FLYV}fly {NOCV}noclip {SPDV}speed {PSHV}push {SPNV}spawn jumpheight={HGTV} jumps={JMPV} horspeed={HORV} maxspeed={MAXV}
quit

#Mark
set TEMP1 {Y}
setadd TEMP1 1
setblockid blockabove {X} {TEMP1} {Z}
if blockabove|=|550 jump #pipe-aY
if blockabove|=|756 jump #pipe-aY
if blockabove|=|739 jump #pipe-aY
if blockabove|=|238 jump #pipe-aY
cmd x {X} {TEMP1} {Z}
quit

#Tele
set TEMP1 {Y}
setadd TEMP1 1
cmd tp {X} {TEMP1} {Z}
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
msg %a/input config [type]
msg %7Valid Values for [type]:
// msg %mthirdperson, fly, noclip, speed, push, respawn, %djumpheight, %9jumps, %dhorspeed, %9reach, %dmaxspeed, %7cpemsg
msg %mthirdperson, fly, noclip, speed, push, respawn, %djumpheight, %9jumps, %dhorspeed, %9reach, %dmaxspeed
quit

#Max
call #Float
set MAXV {PROPVALUE}
jump #Apply

#CpemsgData
set TEMP1 {Y}
setadd TEMP1 1
setblockid MSGID {X} {TEMP1} {Z}
setsub MSGID 484
quit

#Cpemsg
call #CpemsgData

quit
