parameter apo.

function vis_viva {
    parameter my_apoaps.
    parameter my_periaps.
    parameter my_body.

    SET semi to ((my_apoaps + my_periaps) / 2) + my_body:radius.

    SET square to my_body:MU * ((2/(my_apoaps+my_body:radius)) - (1/semi)).
    return SQRT(square).
}

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
}

lock throttle to 0.

wait until ship:altitude >70000. //wait until we are out of the atmosphere and our apoapsis is not dropping

LIST PARTS in my_parts.
for my_part in my_parts {
    if my_part:hasmodule("ModuleDeployableAntenna") {
        set m to my_part:getmodule("ModuleDeployableAntenna").
        if m:hasevent("extent antenna") {
            m:doevent("extend antenna").
        }
    }
    if my_part:hasmodule("ModuleDeployableSolarPanel") {
        set m to my_part:getmodule("ModuleDeployableSolarPanel").
        if m:hasevent("extend solar panel") {
            m:doevent("extend solar panel").
        }
    }
}

SET vc to vis_viva(ship:obt:apoapsis, ship:obt:periapsis, ship:body).
SET vt to vis_viva(ship:obt:apoapsis, ship:obt:apoapsis, ship:body).

ADD NODE(eta:apoapsis + TIME:SECONDS, 0, 0, vt-vc). 
run run_node.
