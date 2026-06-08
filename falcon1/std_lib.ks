GLOBAL standard_scalar_step TO FALSE.

GLOBAL standard_timestamp_terminalCount0 TO TIME + 30.
GLOBAL LOCK standard_timestamp_terminalCountDown TO TIME - standard_timestamp_terminalCount0.

GLOBAL standard_boolean_isPolling TO FALSE.
GLOBAL standard_string_pollingTopic TO "".
GLOBAL standard_string_lastPollingTopic TO "".
GLOBAL standard_boolean_lastPollingResult TO FALSE.
GLOBAL standard_timestamp_pollingEndTerminalCount TO standard_timestamp_terminalCountDown.

GLOBAL LOCK standard_scalar_gAcceleration TO CONSTANT:G * BODY:MASS / (BODY:RADIUS + SHIP:ALTITUDE)^2.

LOCAL standard_scalar_vehicleRadarAltitudeOffset TO ALT:RADAR.
GLOBAL LOCK standard_scalar_vehicleRadarAltitude TO ALT:RADAR - standard_scalar_vehicleRadarAltitudeOffset.

GLOBAL standard_scalar_merlin1CEngineSpoolTime TO 2.4.
GLOBAL standard_scalar_spoolTimeMargin TO 0.5.
GLOBAL standard_string_stage1EngineMode TO "OFF". // "OFF", "1"

GLOBAL standard_direction_targetDirection TO UP.
GLOBAL standard_scalar_targetThrottle TO 0.0.

LOCK STEERING TO standard_direction_targetDirection.
LOCK THROTTLE TO standard_scalar_targetThrottle.

RUNONCEPATH("0:/falcon1/gui.ks").

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
            gui_void_updateContent().
        }
    }
    CLEARSCREEN.
}

FUNCTION standard_void_startPolling {
    PARAMETER param_string_pollingTopic.
    PARAMETER param_scalar_pollingDuration TO 0.

    SET standard_boolean_isPolling TO TRUE.
    SET standard_string_pollingTopic TO param_string_pollingTopic.

    IF (param_scalar_pollingDuration > 0) {
        SET standard_timestamp_pollingEndTerminalCount TO standard_timestamp_terminalCountDown + param_scalar_pollingDuration.
        WHEN (standard_timestamp_terminalCountDown:SECONDS >= standard_timestamp_pollingEndTerminalCount:SECONDS) THEN {
            IF (standard_boolean_isPolling = TRUE) {
                SET standard_boolean_isPolling TO FALSE.
                SET standard_boolean_lastPollingResult TO FALSE.
                SET standard_string_lastPollingTopic TO standard_string_pollingTopic.
            }
        }
    } ELSE {
        UNTIL (standard_boolean_isPolling = FALSE).
    }
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

FUNCTION standard_void_setStage1Engine{
    PARAMETER param_boolean_activate.
    LOCAL engine_stage1engine1 TO standard_part_getPartByTag("S1E1").
    IF ((param_boolean_activate = TRUE) AND (standard_string_stage1EngineMode = "OFF")) {
        SET standard_string_stage1EngineMode TO "1".
        engine_stage1engine1:ACTIVATE().
    } ELSE IF ((param_boolean_activate = FALSE) AND (standard_string_stage1EngineMode = "1")) {
        SET standard_string_stage1EngineMode TO "OFF".
        engine_stage1engine1:SHUTDOWN().
    }
}

FUNCTION standard_scalar_scalarProjection {
	PARAMETER param_vector_vector1.
	PARAMETER param_vector_vector2.
	IF (param_vector_vector2:MAG = 0) { PRINT "sProj: Divide by 0. Returning 1". RETURN 1. }
	RETURN VDOT(param_vector_vector1, param_vector_vector2) * (1/param_vector_vector2:MAG).
}

FUNCTION standard_vector_divideVector {
    PARAMETER param_vector_vector.
	LOCAL vector_eastVector IS VCRS(NORTH:VECTOR, UP:VECTOR).
	LOCAL scalar_eastComp IS standard_scalar_scalarProjection(param_vector_vector, vector_eastVector).
	LOCAL scalar_northComp IS standard_scalar_scalarProjection(param_vector_vector, NORTH:VECTOR).
	LOCAL scalar_upComp IS standard_scalar_scalarProjection(param_vector_vector, UP:VECTOR).
	RETURN V(scalar_eastComp, scalar_northComp, scalar_upComp).
}