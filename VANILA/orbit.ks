clearScreen.

set launcher to ship.
set planet to kerbin.

set _default_throttle to 1.0.
set _accel_limit to 15.0.

lock throttle to _default_throttle.

if countdown(false, 1, 750) = true{
    lock steering to heading(90,80,180).
    lock throttle to _default_throttle.
    until altitude > 1000{
        if launcher:sensors:acc:mag <= _accel_limit{
            lock throttle to _default_throttle.
        }
        else{
            set _default_throttle to _default_throttle - 0.1.
        }
        lock throttle to _default_throttle.
    }
}



function countdown{
    declare parameter _is_staticfire.
    declare parameter _engine_ignition_ag.
    declare parameter _srb_thrust.

    set planet_g to planet:mu / (altitude + planet:radius)^2.

    set _throttle_backup to throttle.
    lock throttle to 0.

    main_engine_controler(true, _engine_ignition_ag).

    set _go_for_liftoff to false.

    set _liftoff_thrust to _srb_thrust+(launcher:availablethrust * _throttle_backup).
    if(_liftoff_thrust>launcher:mass*planet_g){
        set _go_for_liftoff to true.
    }
    else{
        set _go_for_liftoff to false.
    }

    main_engine_controler(false, _engine_ignition_ag).
    
    lock throttle to _throttle_backup.

    set _countdown to 10.
    until _countdown = 0{
        print "T - "+ _countdown AT(0,1).
        if _countdown = 3{
            main_engine_controler(true, _engine_ignition_ag).
        }
        if _countdown <=3{
            if launcher:availableThrust+_srb_thrust>launcher:mass*planet_g{
                set _go_for_liftoff to true.
            }
            else{
                set _go_for_liftoff to false.
            }
        }
        else{
            if _liftoff_thrust>launcher:mass*planet_g{
                set _go_for_liftoff to true.
            }
            else{
                set _go_for_liftoff to false.
            }
        }
        if _go_for_liftoff = true{
            print "THROTTLE: "+ throttle at(0,2).
        }
        else{
            break.
        }
        set _countdown to _countdown - 1.
        wait 1.
        print "T -            " AT(0,1).
    }
    if _go_for_liftoff = true and _countdown = 0{
        if _is_staticfire = false{
            print "T - 0" at(0,1).
            stage.
            print "LIFT OFF" at(0,2).
            return true.
        }
        else{
            print "T - 0" at(0,1).
            main_engine_controler(false,_engine_ignition_ag).
            print "static fire complete" at(0,2).
            return false.
        }
    }
    else{
        main_engine_controler(false, _engine_ignition_ag).
        print "ABORT" at(0,2).
        return false.
    }
}
function main_engine_controler{
    declare parameter _engine_ignite.
    declare parameter _engine_ignition_ag.
    if _engine_ignite = true{
        if _engine_ignition_ag = 1{
            ag1 on.
        }
        if _engine_ignition_ag = 2{
            ag2 on.
        }
        if _engine_ignition_ag = 3{
            ag3 on.
        }
        if _engine_ignition_ag = 4{
            ag4 on.
        }
        if _engine_ignition_ag = 5{
            ag5 on.
        }
        if _engine_ignition_ag = 6{
            ag6 on.
        }
        if _engine_ignition_ag = 7{
            ag7 on.
        }
        if _engine_ignition_ag = 8{
            ag8 on.
        }
        if _engine_ignition_ag = 9{
            ag9 on.
        }
        if _engine_ignition_ag = 10{
            ag10 on.
        }
    }
    else if _engine_ignite = false{
        if _engine_ignition_ag = 1{
            ag1 off.
        }
        if _engine_ignition_ag = 2{
            ag2 off.
        }
        if _engine_ignition_ag = 3{
            ag3 off.
        }
        if _engine_ignition_ag = 4{
            ag4 off.
        }
        if _engine_ignition_ag = 5{
            ag5 off.
        }
        if _engine_ignition_ag = 6{
            ag6 off.
        }
        if _engine_ignition_ag = 7{
            ag7 off.
        }
        if _engine_ignition_ag = 8{
            ag8 off.
        }
        if _engine_ignition_ag = 9{
            ag9 off.
        }
        if _engine_ignition_ag = 10{
            ag10 off.
        }
    }
}
