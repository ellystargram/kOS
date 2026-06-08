GLOBAL standard_scalar_step TO FALSE.
GLOBAL standard_scalar_launchDirectorGoPoll TO FALSE.
GLOBAL standard_scalar_launchDirectorDenyPoll TO FALSE.

GLOBAL standard_bool_launchEnabled TO FALSE.
GLOBAL standard_timeStamp_terminalCount0Time TO TIME.
GLOBAL standard_scalar_countDownDuration TO 10.0.
GLOBAL standard_scalar_merlin1DEngineSpoolTime TO 2.6.
GLOBAL standard_scalar_SpoolTimeMargin TO 0.5.
GLOBAL standard_string_stage1EngineMode TO "OFF". // "OFF", "9", "3", "1"
GLOBAL standard_scalar_targetThrottle TO 0.0.
GLOBAL standard_direction_targetDirection TO UP.

GLOBAL LOCK standard_scalar_gAcceleration TO CONSTANT:G * BODY:MASS / (BODY:RADIUS + SHIP:ALTITUDE)^2.

GLOBAL standard_engine_stage1Engine1 TO FALSE.
GLOBAL standard_engine_stage1Engine2 TO FALSE.
GLOBAL standard_engine_stage1Engine3 TO FALSE.
GLOBAL standard_engine_stage1Engine4 TO FALSE.
GLOBAL standard_engine_stage1Engine5 TO FALSE.
GLOBAL standard_engine_stage1Engine6 TO FALSE.
GLOBAL standard_engine_stage1Engine7 TO FALSE.
GLOBAL standard_engine_stage1Engine8 TO FALSE.
GLOBAL standard_engine_stage1Engine9 TO FALSE.
GLOBAL standard_part_stage1FuelTank TO FALSE.
GLOBAL standard_part_stage1LandingGear1 TO FALSE.
GLOBAL standard_part_stage1LandingGear2 TO FALSE.
GLOBAL standard_part_stage1LandingGear3 TO FALSE.
GLOBAL standard_part_stage1LandingGear4 TO FALSE.
GLOBAL standard_part_stage1GridFin1 TO FALSE.
GLOBAL standard_part_stage1GridFin2 TO FALSE.
GLOBAL standard_part_stage1GridFin3 TO FALSE.
GLOBAL standard_part_stage1GridFin4 TO FALSE.
GLOBAL standard_part_stage1RCS1 TO FALSE.
GLOBAL standard_part_stage1RCS2 TO FALSE.
GLOBAL standard_part_stage1IS TO FALSE.

GLOBAL standard_engine_stage2Engine1 TO FALSE.

FUNCTION standard_void_runStep {
    PARAMETER param_string_stepName.
    PARAMETER param_function_stepFunction.

    PRINT "Running step: " + param_string_stepName + ".".
    IF (standard_scalar_step = FALSE) {
        SET standard_scalar_step TO param_string_stepName.
    }
    IF (standard_scalar_step = param_string_stepName) {
        UNTIL (standard_scalar_step = FALSE) {
            param_function_stepFunction:call().
        }
    }
    CLEARSCREEN.
}

FUNCTION standard_void_setStage1EngineMode {
    PARAMETER param_string_engineMode. // "OFF", "9", "5", "3", "1"
    PARAMETER param_string_controlSequence TO "SOFT". // "HARD", "SOFT"

    SET standard_string_stage1EngineMode TO param_string_engineMode.

    IF (param_string_controlSequence = "HARD") {
        IF(param_string_engineMode = "OFF") {
            standard_engine_stage1Engine1:SHUTDOWN().
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine3:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            standard_engine_stage1Engine5:SHUTDOWN().
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine7:SHUTDOWN().
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine9:SHUTDOWN().
        } ELSE IF(param_string_engineMode = "9") {
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine2:ACTIVATE().
            standard_engine_stage1Engine3:ACTIVATE().
            standard_engine_stage1Engine4:ACTIVATE().
            standard_engine_stage1Engine5:ACTIVATE().
            standard_engine_stage1Engine6:ACTIVATE().
            standard_engine_stage1Engine7:ACTIVATE().
            standard_engine_stage1Engine8:ACTIVATE().
            standard_engine_stage1Engine9:ACTIVATE().
        } ELSE IF (param_string_engineMode = "5") {
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine3:ACTIVATE().
            standard_engine_stage1Engine4:SHUTDOWN().
            standard_engine_stage1Engine5:ACTIVATE().
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine7:ACTIVATE().
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine9:ACTIVATE().
        } ELSE IF (param_string_engineMode = "3") {
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine3:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            standard_engine_stage1Engine5:ACTIVATE().
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine7:SHUTDOWN().
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine9:ACTIVATE().
        } ELSE IF (param_string_engineMode = "1") {
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine3:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            standard_engine_stage1Engine5:SHUTDOWN().
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine7:SHUTDOWN().
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine9:SHUTDOWN().
        }
    } ELSE IF (param_string_controlSequence = "SOFT") {
        IF(param_string_engineMode = "OFF") {
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine2:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine7:SHUTDOWN().
            standard_engine_stage1Engine3:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine9:SHUTDOWN().
            standard_engine_stage1Engine5:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine1:SHUTDOWN().
        } ELSE IF(param_string_engineMode = "9") {
            standard_engine_stage1Engine9:ACTIVATE().
            standard_engine_stage1Engine2:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine3:ACTIVATE().
            standard_engine_stage1Engine8:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine1:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine4:ACTIVATE().
            standard_engine_stage1Engine7:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine5:ACTIVATE().
            standard_engine_stage1Engine6:ACTIVATE().
        } ELSE IF (param_string_engineMode = "5") {
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine8:SHUTDOWN().
            WAIT 0.2.
            //1 3 5 7 9
            standard_engine_stage1Engine3:ACTIVATE().
            standard_engine_stage1Engine9:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine7:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine5:ACTIVATE().
        } ELSE IF (param_string_engineMode = "3") {
            standard_engine_stage1Engine2:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine8:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine3:SHUTDOWN().
            standard_engine_stage1Engine7:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine1:ACTIVATE().
            standard_engine_stage1Engine9:ACTIVATE().
            WAIT 0.1.
            standard_engine_stage1Engine5:ACTIVATE().
        } ELSE IF (param_string_engineMode = "1") {
            standard_engine_stage1Engine6:SHUTDOWN().
            standard_engine_stage1Engine2:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine8:SHUTDOWN().
            standard_engine_stage1Engine4:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine7:SHUTDOWN().
            standard_engine_stage1Engine3:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine9:SHUTDOWN().
            standard_engine_stage1Engine5:SHUTDOWN().
            WAIT 0.2.
            standard_engine_stage1Engine1:ACTIVATE().
        }
    }
}

FUNCTION standard_scalar_stage1AvailableThrust {
    LOCAL scalar_totalStage1Thrust TO 0.

    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine1:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine2:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine3:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine4:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine5:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine6:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine7:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine8:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine9:AVAILABLETHRUST.

    RETURN scalar_totalStage1Thrust.
}

FUNCTION standard_scalar_stage1CurrentThrust {
    LOCAL scalar_totalStage1Thrust TO 0.

    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine1:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine2:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine3:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine4:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine5:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine6:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine7:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine8:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + standard_engine_stage1Engine9:THRUST.

    RETURN scalar_totalStage1Thrust.
}

FUNCTION standard_void_stage1PartSearch {
    IF (SHIP:PARTSTAGGED("S1E1"):LENGTH = 1){
        SET standard_engine_stage1Engine1 TO SHIP:PARTSTAGGED("S1E1")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E2"):LENGTH = 1){
        SET standard_engine_stage1Engine2 TO SHIP:PARTSTAGGED("S1E2")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E3"):LENGTH = 1){
        SET standard_engine_stage1Engine3 TO SHIP:PARTSTAGGED("S1E3")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E4"):LENGTH = 1){
        SET standard_engine_stage1Engine4 TO SHIP:PARTSTAGGED("S1E4")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E5"):LENGTH = 1){
        SET standard_engine_stage1Engine5 TO SHIP:PARTSTAGGED("S1E5")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E6"):LENGTH = 1){
        SET standard_engine_stage1Engine6 TO SHIP:PARTSTAGGED("S1E6")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E7"):LENGTH = 1){
        SET standard_engine_stage1Engine7 TO SHIP:PARTSTAGGED("S1E7")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E8"):LENGTH = 1){
        SET standard_engine_stage1Engine8 TO SHIP:PARTSTAGGED("S1E8")[0].
    }
    IF (SHIP:PARTSTAGGED("S1E9"):LENGTH = 1){
        SET standard_engine_stage1Engine9 TO SHIP:PARTSTAGGED("S1E9")[0].
    }
}

standard_void_stage1PartSearch().

LOCK THROTTLE TO standard_scalar_targetThrottle.
LOCK STEERING TO standard_direction_targetDirection.
standard_void_setStage1EngineMode("OFF", "HARD").