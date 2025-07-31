FUNCTION liftOffPrep_step_countdownHold {
    ON AG9 { //LD Confirm KEY
        SET standard_scalar_step TO FALSE.
    } 
    UNTIL (standard_scalar_step = FALSE) {}
    PRINT "CountDown Hold Released.".
}

FUNCTION liftOffPrep_step_clockSet {
    LOCAL timestamp_currentTime TO TIME:SECONDS.
    LOCAL scalar_countDownSeconds TO 3 + 1.
    SET liftOffPrep_scalar_liftOffTargetTime TO timestamp_currentTime + scalar_countDownSeconds.
    PRINT "Clock Set to " + liftOffPrep_scalar_liftOffTargetTime + ".".
    SET standard_scalar_step TO FALSE.
}

FUNCTION liftOffPrep_step_countDown {
    LOCAL timestamp_currentTime TO TIME:SECONDS.
    LOCAL scalar_deltaTime TO liftOffPrep_scalar_liftOffTargetTime - timestamp_currentTime.
    PRINT "Count Down: " + scalar_deltaTime + " seconds remaining.".
    IF (scalar_deltaTime - (liftOffPrep_scalar_engineIgnitionTime + liftOffPrep_scalar_engineIgnitionTimeMargin) <= 0 AND liftOffPrep_boolean_engineIgnitionEnabled = FALSE) {
        standard_void_setStage1EngineMode("1").
        SET standard_scalar_throttle TO 1.0.
        SET liftOffPrep_boolean_engineIgnitionEnabled TO TRUE.
    }

    IF (timestamp_currentTime >= liftOffPrep_scalar_liftOffTargetTime) {
        PRINT "Count Down Complete.".
        SET standard_scalar_step TO FALSE.
    }
}