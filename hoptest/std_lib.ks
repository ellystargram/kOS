// STD_LIB version 1.0

//
// Global Variables
//
GLOBAL standard_scalar_step TO FALSE.
GLOBAL standard_string_stage1EngineMode TO "OFF".
GLOBAL standard_scalar_throttle TO 0.0.
GLOBAL standard_scalar_steering TO UP.


//
// initialization
//
LOCK THROTTLE TO standard_scalar_throttle.
LOCK STEERING TO standard_scalar_steering.

FUNCTION standard_scalar_map {
    PARAMETER param_scalar_fromValue.
    PARAMETER param_scalar_fromMin.
    PARAMETER param_scalar_fromMax.
    PARAMETER param_scalar_toMin.
    PARAMETER param_scalar_toMax.

    RETURN (param_scalar_fromValue - param_scalar_fromMin) * (param_scalar_toMax - param_scalar_toMin) / (param_scalar_fromMax - param_scalar_fromMin) + param_scalar_toMin.
}

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
    param_function_stepFunction().
}

FUNCTION standard_void_setStage1EngineMode {
    PARAMETER param_string_mode. // "OFF", "9", "3", "1"

    IF (param_string_mode = standard_string_stage1EngineMode) {
        PRINT "Stage 1 engine mode is already set to " + param_string_mode + ".".
        RETURN.
    }

    LOCAL part_stage1Engine1 TO SHIP:PARTSTAGGED("S1E1")[0].
    LOCAL part_stage1Engine2 TO SHIP:PARTSTAGGED("S1E2")[0].
    LOCAL part_stage1Engine3 TO SHIP:PARTSTAGGED("S1E3")[0].
    LOCAL part_stage1Engine4 TO SHIP:PARTSTAGGED("S1E4")[0].
    LOCAL part_stage1Engine5 TO SHIP:PARTSTAGGED("S1E5")[0].
    LOCAL part_stage1Engine6 TO SHIP:PARTSTAGGED("S1E6")[0].
    LOCAL part_stage1Engine7 TO SHIP:PARTSTAGGED("S1E7")[0].
    LOCAL part_stage1Engine8 TO SHIP:PARTSTAGGED("S1E8")[0].
    LOCAL part_stage1Engine9 TO SHIP:PARTSTAGGED("S1E9")[0].

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

        SET standard_string_stage1EngineMode TO "OFF".
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

        SET standard_string_stage1EngineMode TO "9".
    } ELSE IF (param_string_mode = "3") {
        part_stage1Engine1:ACTIVATE().
        part_stage1Engine5:ACTIVATE().
        part_stage1Engine9:ACTIVATE().

        part_stage1Engine2:SHUTDOWN().
        part_stage1Engine3:SHUTDOWN().
        part_stage1Engine4:SHUTDOWN().
        part_stage1Engine6:SHUTDOWN().
        part_stage1Engine7:SHUTDOWN().
        part_stage1Engine8:SHUTDOWN().

        SET standard_string_stage1EngineMode TO "3".
    } ELSE IF (param_string_mode = "1") {
        part_stage1Engine9:ACTIVATE().

        part_stage1Engine1:SHUTDOWN().
        part_stage1Engine2:SHUTDOWN().
        part_stage1Engine3:SHUTDOWN().
        part_stage1Engine4:SHUTDOWN().
        part_stage1Engine5:SHUTDOWN().
        part_stage1Engine6:SHUTDOWN().
        part_stage1Engine7:SHUTDOWN().
        part_stage1Engine8:SHUTDOWN().

        SET standard_string_stage1EngineMode TO "1".
    } ELSE {
        PRINT "Invalid stage 1 engine mode: " + param_string_mode + ".".
    }
}

// Default Math Functions
FUNCTION standard_scalar_valueRangeSafety {
    PARAMETER param_scalar_value.
    PARAMETER param_scalar_min.
    PARAMETER param_scalar_max.

    RETURN MIN(MAX(param_scalar_value, param_scalar_min), param_scalar_max).
}