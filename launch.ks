parameter apo.

function ascent_pitch {
    local asc_stage is (ship:obt:apoapsis / (apo * 0.75)) * 90.
    return max(0, 90 - asc_stage).
}

sas off.
lock throttle to 1.
lock steering to HEADING(90, ascent_pitch()).

stage.
set thrust_record to ship:MAXTHRUST.

until ship:obt:apoapsis > apo {
    if ship:MAXTHRUST < thrust_record {
        stage.
        set thrust_record to ship:MAXTHRUST.
    }
    wait 0.01.
    clearscreen.
    print "setting pitch to " + ascent_pitch().
    print "thrust record " + thrust_record.
    print "max thrust " + ship:Maxthrust.
}

lock throttle to 0.

until ETA:APOAPSIS < 30 {
    clearscreen.
    print "time to apoapsis " + ETA:Apoapsis.
    wait 0.01.
}

lock throttle to 1.

until (apo - ship:obt:periapsis) < 1000 {
    if ship:MAXTHRUST < thrust_record {
        stage.
        set thrust_record to ship:MAXTHRUST.
    }
    wait 0.01.
    clearscreen.
    print "height to raise " + (apo - ship:obt:periapsis).
}

lock throttle to 0.
print "Done!".
