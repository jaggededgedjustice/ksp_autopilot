// taken from https://www.troyfawkes.com/adventures-in-ksp-kos-math/ ?
// via https://github.com/Petruchio96/KOS-Scripts/blob/master/ExecNode.ks

Parameter WillWarp is True.  //Optional parameter to warp to the manuever node

Declare Local n TO NEXTNODE.
Declare Local a0 to 0.0.
Declare Local a1 to 0.0.
Declare Local eIsp to 0.0.
Declare Local Ve to 0.0.
Declare Local final_mass to 0.0.
Declare Local t to 0.0.
Declare Local start_time to 0.0.
Declare Local end_time to 0.0.
Declare Local my_engines to List().

// Point at the node.
SAS off.
LOCK STEERING TO n:BURNVECTOR.
WAIT UNTIL VANG(SHIP:FACING:VECTOR, n:BURNVECTOR) < 2.

// Get initial acceleration.
SET a0 TO ship:maxthrust / mass. 

// In the pursuit of a1...
// What's our effective ISP?
LIST engines IN my_engines.
FOR eng IN my_engines {
SET eIsp TO eIsp + eng:maxthrust / ship:maxthrust * eng:isp. 
}

// What's our effective exhaust velocity?
SET Ve TO eIsp * 9.82.

// What's our final mass?
SET final_mass TO mass*CONSTANT():e^(-1*n:BURNVECTOR:MAG/Ve).

// Get our final acceleration.
SET a1 TO maxthrust / final_mass.
// All of that ^ just to get a1..

// Get the time it takes to complete the burn.
SET t TO n:BURNVECTOR:MAG / ((a0 + a1) / 2).

// Set the start and end times.
SET start_time TO TIME:SECONDS + n:ETA - t/2.
SET end_time TO TIME:SECONDS + n:ETA + t/2.

//Warp to 10 seconds before the burn time
If WillWarp {
    warpto(start_time - 10).
}

// Execute the burn.
WAIT UNTIL TIME:SECONDS >= start_time.
LOCK throttle TO 1.
WAIT UNTIL TIME:SECONDS >= end_time.

unlock steering.
remove n.
 
LOCK throttle TO 0.
