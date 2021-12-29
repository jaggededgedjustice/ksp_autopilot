Parameter WillWarp is True.
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
SAS off.
LOCK STEERING TO n:BURNVECTOR.
WAIT UNTIL VANG(SHIP:FACING:VECTOR, n:BURNVECTOR) < 2.
SET a0 TO ship:maxthrust / mass. 
LIST engines IN my_engines.
FOR eng IN my_engines {
SET eIsp TO eIsp + eng:maxthrust / ship:maxthrust * eng:isp. 
}
SET Ve TO eIsp * 9.82.
SET final_mass TO mass*CONSTANT():e^(-1*n:BURNVECTOR:MAG/Ve).
SET a1 TO maxthrust / final_mass.
SET t TO n:BURNVECTOR:MAG / ((a0 + a1) / 2).
SET start_time TO TIME:SECONDS + n:ETA - t/2.
SET end_time TO TIME:SECONDS + n:ETA + t/2.
If WillWarp {
warpto(start_time - 10).
}
WAIT UNTIL TIME:SECONDS >= start_time.
LOCK throttle TO 1.
WAIT UNTIL TIME:SECONDS >= end_time.
unlock steering.
remove n.
LOCK throttle TO 0.
