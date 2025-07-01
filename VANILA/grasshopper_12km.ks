function _countdown{
    declare parameter _liftoff_throttle.
    declare parameter _main_engine_ignition_AG.
    declare parameter _is_staticfire.
    declare parameter _will_skip_countdown.

    set grasshopper to vessel("grasshopper").
    set liftoffsign to false.
    sas off.
    rcs off.
    set g to kerbin:mu / (altitude + kerbin:radius)^2.
    lock steering to up.
    lock throttle to _liftoff_throttle.
    clearScreen.
    set _hold to false.
    if _main_engine_ignition_AG = 1{
            ag1 on.
    }
    if _main_engine_ignition_AG = 2{
        ag2 on.
    }
    if _main_engine_ignition_AG = 3{
        ag3 on.
    }
    if _main_engine_ignition_AG = 4{
        ag4 on.
    }
    if _main_engine_ignition_AG = 5{
        ag5 on.
    }
    if _main_engine_ignition_AG = 6{
        ag6 on.
    }
    if _main_engine_ignition_AG = 7{
        ag7 on.
    }
    if _main_engine_ignition_AG = 8{
        ag8 on.
    }
    if _main_engine_ignition_AG = 9{
        ag9 on.
    }
    if _main_engine_ignition_AG = 10{
        ag10 on.
    }
    set _stage1_thrust to availableThrust.
    if _main_engine_ignition_AG = 1{
        ag1 off.
    }
    if _main_engine_ignition_AG = 2{
        ag2 off.
    }
    if _main_engine_ignition_AG = 3{
        ag3 off.
    }
    if _main_engine_ignition_AG = 4{
        ag4 off.
    }
    if _main_engine_ignition_AG = 5{
        ag5 off.
    }
    if _main_engine_ignition_AG = 6{
        ag6 off.
    }
    if _main_engine_ignition_AG = 7{
        ag7 off.
    }
    if _main_engine_ignition_AG = 8{
        ag8 off.
    }
    if _main_engine_ignition_AG = 9{
        ag9 off.
    }
    if _main_engine_ignition_AG = 10{
        ag10 off.
    }
    if _will_skip_countdown = false {
        set _timer to 10.
        until _timer = 3 {
            print "Launch Director is GO for launch".
            print "T - " + _timer.
            set _max_twr to _stage1_thrust / (g * mass).
            if _max_twr <= 1.0 {
                set _hold to true.
                break.
            }
            wait 1.
            set _timer to _timer - 1.
            clearScreen.
        }
        //exit at T-3s
    }
    else {
        set _timer to 3.
    }
    if _hold = false {
        if _main_engine_ignition_AG = 1{
            ag1 on.
        }
        if _main_engine_ignition_AG = 2{
            ag2 on.
        }
        if _main_engine_ignition_AG = 3{
            ag3 on.
        }
        if _main_engine_ignition_AG = 4{
            ag4 on.
        }
        if _main_engine_ignition_AG = 5{
            ag5 on.
        }
        if _main_engine_ignition_AG = 6{
            ag6 on.
        }
        if _main_engine_ignition_AG = 7{
            ag7 on.
        }
        if _main_engine_ignition_AG = 8{
            ag8 on.
        }
        if _main_engine_ignition_AG = 9{
            ag9 on.
        }
        if _main_engine_ignition_AG = 10{
            ag10 on.
        }
        lock throttle to _liftoff_throttle.
        until _timer = 0 {
            print "Ignition sequence start".
            print "ALT (sea): " + altitude.
            print "ALT (terrain): " + alt:radar.
            set _max_twr to availableThrust / (g * mass).
            print "TWR (max): " + _max_twr.
            set _set_twr to (throttle * availableThrust) / (g * mass).
            print "TWR (set): " + _set_twr.
            print "THROTTLE: " + _liftoff_throttle.
            print "THRUST (max): " + availableThrust.
            print "THRUST (set): " + (availableThrust * throttle).
            print "MASS (wet): " + mass.
            print "MASS (dry): " + grasshopper:drymass.
            print "ACCELATION: " + g.
            print "T - " + _timer.
            set _max_twr to availableThrust / (g * mass).
            set _set_twr to throttle*availableThrust / (g*mass).
            if _set_twr <= 1.0 {
                set _hold to true.
                break.
            }
            if _max_twr <= 1.0{
                set _hold to true.
                break.
            }
            if _liftoff_throttle = 0 {
                set _hold to true.
                break.
            }
            wait 1.
            set _timer to _timer - 1.
            clearScreen.
        }
        clearScreen.
        if _is_staticfire = true and _hold = false {
            if _main_engine_ignition_AG = 1{
            ag1 off.
            }
            if _main_engine_ignition_AG = 2{
                ag2 off.
            }
            if _main_engine_ignition_AG = 3{
                ag3 off.
            }
            if _main_engine_ignition_AG = 4{
                ag4 off.
            }
            if _main_engine_ignition_AG = 5{
                ag5 off.
            }
            if _main_engine_ignition_AG = 6{
                ag6 off.
            }
            if _main_engine_ignition_AG = 7{
                ag7 off.
            }
            if _main_engine_ignition_AG = 8{
                ag8 off.
            }
            if _main_engine_ignition_AG = 9{
                ag9 off.
            }
            if _main_engine_ignition_AG = 10{
                ag10 off.
            }
            lock throttle to 0.
            print "Static Fire Test COMPLETE!".
            print "------------------------------".
            print "Static Fire log->".
            print "ALT (sea): " + altitude.
            print "ALT (terrain): " + alt:radar.
            set _max_twr to maxThrust / (g * mass).
            print "TWR (max): " + _max_twr.
            set _set_twr to (_liftoff_throttle * availableThrust) / (g * mass).
            print "TWR (set): " + _set_twr.
            print "THROTTLE: " + _liftoff_throttle.
            print "THRUST (max): " + maxThrust.
            print "THRUST (set): " + (availableThrust * _liftoff_throttle).
            print "MASS (wet): " + mass.
            print "MASS (dry): " + grasshopper:drymass.
            print "ACCELATION: " + g.
        }
        else if _is_staticfire = false and _hold = false{
            lock steering to up.
            stage.
            set liftoffsign to true.
            print "Lift off!".
            return liftoffsign.
        }
    }
    //ignition sequence start
    if _hold = true {
        if _main_engine_ignition_AG = 1{
            ag1 on.
        }
        if _main_engine_ignition_AG = 2{
            ag2 on.
        }
        if _main_engine_ignition_AG = 3{
            ag3 on.
        }
        if _main_engine_ignition_AG = 4{
            ag4 on.
        }
        if _main_engine_ignition_AG = 5{
            ag5 on.
        }
        if _main_engine_ignition_AG = 6{
            ag6 on.
        }
        if _main_engine_ignition_AG = 7{
            ag7 on.
        }
        if _main_engine_ignition_AG = 8{
            ag8 on.
        }
        if _main_engine_ignition_AG = 9{
            ag9 on.
        }
        if _main_engine_ignition_AG = 10{
            ag10 on.
        }
        clearScreen.
        lock throttle to _liftoff_throttle.
        print "HOLD HOLD HOLD".
        print "T - " + _timer.
        print "------------------------------".
        print "hold log->".
        print "ALT (sea): " + altitude.
        print "ALT (terrain): " + alt:radar.
        set _max_twr to availableThrust / (g * mass).
        print "TWR (max): " + _max_twr.
        set _set_twr to (throttle * availableThrust) / (g * mass).
        print "TWR (set): " + _set_twr.
        print "THROTTLE: " + throttle.
        print "THRUST (max): " + availableThrust.
        print "THRUST (set): " + (availableThrust * throttle).
        print "MASS (wet): " + mass.
        print "MASS (dry): " + grasshopper:drymass.
        print "ACCELATION: " + g.
        lock throttle to 0.
        if _main_engine_ignition_AG = 1{
            ag1 off.
        }
        if _main_engine_ignition_AG = 2{
            ag2 off.
        }
        if _main_engine_ignition_AG = 3{
            ag3 off.
        }
        if _main_engine_ignition_AG = 4{
            ag4 off.
        }
        if _main_engine_ignition_AG = 5{
            ag5 off.
        }
        if _main_engine_ignition_AG = 6{
            ag6 off.
        }
        if _main_engine_ignition_AG = 7{
            ag7 off.
        }
        if _main_engine_ignition_AG = 8{
            ag8 off.
        }
        if _main_engine_ignition_AG = 9{
            ag9 off.
        }
        if _main_engine_ignition_AG = 10{
            ag10 off.
        }
    }
    return false.
}

clearScreen.
set flag to _countdown(1.0,1,false,false).
if flag=true {
    set _g to kerbin:mu / (altitude + kerbin:radius)^2.
    wait 5.
    clearScreen.
    print "phase 1-1".
    lock steering to heading (90,80).
    wait 5.
    lock steering to heading (90,90).
    clearScreen.
    print "phase 1-2".
    //throttle*maxthrust=g*mass
    lock throttle to 1.
    until verticalSpeed > 200.
    clearScreen.
    print "phase 1-3".
    //2as=-40000
    //as=-20000
    set target_altitude to 12500.
    until altitude > target_altitude-4000{
        clearScreen.
        print "phase 1-4".
        set _hoverable_throttle to _g*mass/availableThrust.
        if verticalSpeed > 199 and verticalSpeed < 201 {
            lock throttle to _hoverable_throttle.
        }
        else if verticalSpeed <= 199 {
            set _additional_thrust to abs(200-verticalSpeed)/100.0.
            lock throttle to _hoverable_throttle+_additional_thrust.
        }
        else if verticalSpeed >= 201 {
            set _additional_thrust to abs(200-verticalSpeed)/100.0.
            lock throttle to _hoverable_throttle-_additional_thrust.
        }
    }
    //-5=f/mass
    //f=-mass*g+throttle*maxthrust
    //-5=(throttle*maxthrust-mass*g)/mass
    //-5=throttle*maxthrust/mass-g
    //(-5+g)*mass/maxthrust=throttle
    until altitude > target_altitude {
        clearScreen.
        print "phase 1-5".
        set target_decel to -5.0.
        set _error to 0.0.
        set _default_throttle to (-5+_g)*mass/maxThrust.
        set left_distance to target_altitude-altitude.
        //2left a = -verticalvelocity sq
        //2as=v*v-v0*v0
        //2a*leftdistance=-verticalspeed*verticalspeed
        //-(verticalspeed*verticalspeed)/(2*leftdistance)=a
        set _must_decel to -((verticalSpeed*verticalSpeed)/(2*left_distance)).
        if _must_decel > target_decel+_error { // must throttle down
            set _range to abs(target_decel - _must_decel)*0.05.
            lock throttle to _default_throttle + _range.
        }
        else if _must_decel < target_decel-_error { // must throttle up
            set _range to abs(target_decel - _must_decel)*0.02.
            lock throttle to _default_throttle - _range.
        }
        else if _must_decel<=target_decel+_error and _must_decel >= target_decel - _error {
            set _range to 0.0.
            lock throttle to _default_throttle.
        }
        print _must_decel.
        print target_decel.
        print _default_throttle.
        print left_distance.
        print _range.
    }
    lock throttle to 0.
    until false {
        set _index to 2.
        clearScreen.
        print "phase 2-1".
        //2as=v*v-v0*v0
        set _default_throttle to 0.9.
        set max_accel to (availableThrust*_default_throttle - mass*_g)/mass.
        //2*maxaccel*s=-vertical*vertical.
        set _ignition_altitude to verticalSpeed*verticalSpeed / (2*max_accel)+_index.
        print max_accel.
        print _ignition_altitude.
        print alt:radar.
        if _ignition_altitude >= alt:radar{
            lock throttle to _default_throttle.
            break.
        }
    }
    set phase to 2.
    until verticalSpeed >= 0 {
        clearScreen.
        print "phase 2-"+phase.
        set _default_throttle to 0.9.
        set max_accel to (availableThrust*_default_throttle - mass*_g)/mass.
        set left_distance to alt:radar-_index.
        set _must_accel to ((verticalSpeed*verticalSpeed)/(2*left_distance)).
        set _error to 0.5.
        if _must_accel > max_accel + _error {
            set _range to abs(target_decel - _must_decel)*0.05.
            lock throttle to _default_throttle + _range.
        }
        else if _must_accel < max_accel - _error {
            set _range to abs(target_decel - _must_decel)*0.02.
            lock throttle to _default_throttle - _range.
        }

        if alt:radar <= 200{
            set _error to 0.1.
            set phase to 3.
            gear on.
            lock steering to up.
        }
        else{
            lock steering to srfRetrograde.
        }
    }
    lock throttle to 0.
}