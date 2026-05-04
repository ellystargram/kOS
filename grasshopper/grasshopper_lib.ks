GLOBAL standard_scalar_step TO FALSE.
GLOBAL standard_timeStamp_terminalCount0Time TO TIME.
GLOBAL standard_scalar_merlin1DEngineSpoolTime TO 2.6.
GLOBAL standard_scalar_SpoolTimeMargin TO 0.5.
GLOBAL standard_string_stage1EngineMode TO "OFF". // "OFF", "9", "3", "1"
GLOBAL standard_scalar_targetThrottle TO 0.0.
GLOBAL standard_direction_targetDirection TO UP.

GLOBAL LOCK standard_scalar_gAcceleration TO CONSTANT:G * BODY:MASS / (BODY:RADIUS + SHIP:ALTITUDE)^2.

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

FUNCTION standard_part_getPartByTag {
    PARAMETER param_string_tag.

    LOCAL list_parts TO SHIP:PARTSTAGGED(param_string_tag).
    IF (list_parts:LENGTH > 0) {
        RETURN list_parts[0].
    } ELSE {
        PRINT "No part found with tag: " + param_string_tag + ".".
        RETURN.
    }
}

FUNCTION standard_engine_getEngineByTag {
    PARAMETER param_string_tag.

    LOCAL part_engines TO SHIP:PARTSTAGGED(param_string_tag).
    IF (part_engines:LENGTH > 0) {
        RETURN part_engines[0].
    } ELSE {
        PRINT "No engine found with tag: " + param_string_tag + ".".
        RETURN.
    }
}

FUNCTION standard_scalar_getEngineAvailableThrustByTag {
    PARAMETER param_string_tag.

    RETURN standard_engine_getEngineByTag(param_string_tag):AVAILABLETHRUST.
}

FUNCTION standard_scalar_getEngineCurrentThrustByTag {
    PARAMETER param_string_tag.

    RETURN standard_engine_getEngineByTag(param_string_tag):THRUST.
}

FUNCTION standard_void_setStage1EngineMode {
    PARAMETER param_string_mode. // "OFF", "9", "3", "1"

    LOCAL part_stage1Engine1 TO SHIP:PARTSTAGGED("S1E1")[0].
    LOCAL part_stage1Engine2 TO SHIP:PARTSTAGGED("S1E2")[0].
    LOCAL part_stage1Engine3 TO SHIP:PARTSTAGGED("S1E3")[0].
    LOCAL part_stage1Engine4 TO SHIP:PARTSTAGGED("S1E4")[0].
    LOCAL part_stage1Engine5 TO SHIP:PARTSTAGGED("S1E5")[0].
    LOCAL part_stage1Engine6 TO SHIP:PARTSTAGGED("S1E6")[0].
    LOCAL part_stage1Engine7 TO SHIP:PARTSTAGGED("S1E7")[0].
    LOCAL part_stage1Engine8 TO SHIP:PARTSTAGGED("S1E8")[0].
    LOCAL part_stage1Engine9 TO SHIP:PARTSTAGGED("S1E9")[0].

    SET standard_string_stage1EngineMode TO param_string_mode.

    IF (param_string_mode = "OFF") {
        part_stage1Engine1:SHUTDOWN().
        part_stage1Engine2:SHUTDOWN().
        part_stage1Engine3:SHUTDOWN().
        part_stage1Engine4:SHUTDOWN().
        part_stage1Engine5:SHUTDOWN().
        part_stage1Engine6:SHUTDOWN().
        part_stage1Engine7:SHUTDOWN().
        part_stage1Engine8:SHUTDOWN().
        part_stage1Engine9:SHUTDOWN().
    } ELSE IF(param_string_mode = "1") {
        part_stage1Engine1:ACTIVATE().
        part_stage1Engine2:SHUTDOWN().
        part_stage1Engine3:SHUTDOWN().
        part_stage1Engine4:SHUTDOWN().
        part_stage1Engine5:SHUTDOWN().
        part_stage1Engine6:SHUTDOWN().
        part_stage1Engine7:SHUTDOWN().
        part_stage1Engine8:SHUTDOWN().
        part_stage1Engine9:SHUTDOWN().
    } ELSE IF(param_string_mode = "3") {
        part_stage1Engine1:ACTIVATE().
        part_stage1Engine2:SHUTDOWN().
        part_stage1Engine3:SHUTDOWN().
        part_stage1Engine4:SHUTDOWN().
        part_stage1Engine5:ACTIVATE().
        part_stage1Engine6:SHUTDOWN().
        part_stage1Engine7:SHUTDOWN().
        part_stage1Engine8:SHUTDOWN().
        part_stage1Engine9:ACTIVATE().
    } ELSE IF (param_string_mode = "9") {
        part_stage1Engine1:ACTIVATE().
        part_stage1Engine2:ACTIVATE().
        part_stage1Engine3:ACTIVATE().
        part_stage1Engine4:ACTIVATE().
        part_stage1Engine5:ACTIVATE().
        part_stage1Engine6:ACTIVATE().
        part_stage1Engine7:ACTIVATE().
        part_stage1Engine8:ACTIVATE().
        part_stage1Engine9:ACTIVATE().
    }
}

FUNCTION standard_scalar_stage1AvailableThrust {
    LOCAL scalar_totalStage1Thrust TO 0.

    LOCAL part_stage1Engine1 TO SHIP:PARTSTAGGED("S1E1")[0].
    LOCAL part_stage1Engine2 TO SHIP:PARTSTAGGED("S1E2")[0].
    LOCAL part_stage1Engine3 TO SHIP:PARTSTAGGED("S1E3")[0].
    LOCAL part_stage1Engine4 TO SHIP:PARTSTAGGED("S1E4")[0].
    LOCAL part_stage1Engine5 TO SHIP:PARTSTAGGED("S1E5")[0].
    LOCAL part_stage1Engine6 TO SHIP:PARTSTAGGED("S1E6")[0].
    LOCAL part_stage1Engine7 TO SHIP:PARTSTAGGED("S1E7")[0].
    LOCAL part_stage1Engine8 TO SHIP:PARTSTAGGED("S1E8")[0].
    LOCAL part_stage1Engine9 TO SHIP:PARTSTAGGED("S1E9")[0].

    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine1:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine2:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine3:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine4:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine5:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine6:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine7:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine8:AVAILABLETHRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine9:AVAILABLETHRUST.

    RETURN scalar_totalStage1Thrust.
}

FUNCTION standard_scalar_stage1CurrentThrust {
    LOCAL scalar_totalStage1Thrust TO 0.

    LOCAL part_stage1Engine1 TO SHIP:PARTSTAGGED("S1E1")[0].
    LOCAL part_stage1Engine2 TO SHIP:PARTSTAGGED("S1E2")[0].
    LOCAL part_stage1Engine3 TO SHIP:PARTSTAGGED("S1E3")[0].
    LOCAL part_stage1Engine4 TO SHIP:PARTSTAGGED("S1E4")[0].
    LOCAL part_stage1Engine5 TO SHIP:PARTSTAGGED("S1E5")[0].
    LOCAL part_stage1Engine6 TO SHIP:PARTSTAGGED("S1E6")[0].
    LOCAL part_stage1Engine7 TO SHIP:PARTSTAGGED("S1E7")[0].
    LOCAL part_stage1Engine8 TO SHIP:PARTSTAGGED("S1E8")[0].
    LOCAL part_stage1Engine9 TO SHIP:PARTSTAGGED("S1E9")[0].

    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine1:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine2:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine3:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine4:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine5:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine6:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine7:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine8:THRUST.
    SET scalar_totalStage1Thrust TO scalar_totalStage1Thrust + part_stage1Engine9:THRUST.

    RETURN scalar_totalStage1Thrust.
}

LOCK THROTTLE TO standard_scalar_targetThrottle.
LOCK STEERING TO standard_direction_targetDirection.
standard_void_setStage1EngineMode("OFF").