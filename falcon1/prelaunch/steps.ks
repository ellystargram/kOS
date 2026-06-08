RUNONCEPATH("0:/falcon1/std_lib.ks").

FUNCTION prelaunch_step_verifyLaunchDirectorGo {
    standard_void_startPolling("LD GO FOR LAUNCH").
    UNTIL (standard_boolean_lastPollingResult = TRUE).
    SET standard_scalar_step TO FALSE.
}
    
FUNCTION prelaunch_step_setTerminalCount0 {
    SET standard_timestamp_terminalCount0 TO TIME + 30.
    SET standard_scalar_step TO FALSE.
}

FUNCTION prelaunch_step_strongbackRetract {
    LOCAL stage0 TO standard_part_getPartByTag("S0").
    IF stage0:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Strongback Retract") {
        stage0:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Strongback Retract").
    }
    IF (standard_timestamp_terminalCountDown:SECONDS >= -15){
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION prelaunch_step_strongbackRaise {
    standard_void_setStage1Engine(FALSE).
    SET standard_scalar_targetThrottle TO 0.0.

    LOCAL stage0 TO standard_part_getPartByTag("S0").
    IF stage0:GETMODULE("ModuleAnimateGeneric"):HASEVENT("Raise Strongback") {
        stage0:GETMODULE("ModuleAnimateGeneric"):DOEVENT("Raise Strongback").
    }
    IF (standard_timestamp_terminalCountDown:SECONDS >= 15) {
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION prelaunch_step_countDown {
    IF (standard_boolean_isPolling = FALSE AND standard_string_lastPollingTopic <> "Confirm LiftOff") {
        standard_void_startPolling("Confirm LiftOff", 10).
    }

    IF (standard_timestamp_terminalCountDown:SECONDS >= -(standard_scalar_merlin1CEngineSpoolTime + standard_scalar_spoolTimeMargin)) {
        standard_void_setStage1Engine(TRUE).
        SET standard_scalar_targetThrottle TO 1.0.
    }

    IF (standard_timestamp_terminalCountDown:SECONDS >= 0) {
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION prelaunch_step_releaseHoldDownClamps {
    LOCAL stage0 TO standard_part_getPartByTag("S0").
    stage0:GETMODULE("LaunchClamp"):DOEVENT("Release Clamp").
    SET standard_scalar_step TO FALSE.
}