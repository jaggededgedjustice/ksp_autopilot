//wait until ship:airspeed < 600.
//stage.
//wait until ship:airspeed < 250.
//stage.
lock steering to retrograde.
until ship:obt:periapsis < 0 {
    wait 0.01.
}
until ship:airspeed < 1200 {
    wait 0.01.
}

list parts in my_parts.
until ship:airspeed < 200 {
    for part in my_parts {
        if part:hasmodule("moduleParachute") {
            set m to part:getmodule("moduleParachute").
            if m:getfield("safe to deploy?") = "Safe" {
                m:doevent("deploy chute").
            }
        }
    }
}
unlock steering.
