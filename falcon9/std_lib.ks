GLOBAL string_standardLibraryVersion TO "1".

GLOBAL boolean_clockRollingEnabled TO FALSE.

GLOBAL scalar_radarAltError TO ALT:RADAR.
GLOBAL LOCK scalar_radarAltitude TO ALT:RADAR - scalar_radarAltError.

FUNCTION scalar_map {
    PARAMETER param_scalar_fromValue.
    PARAMETER param_scalar_fromMin.
    PARAMETER param_scalar_fromMax.
    PARAMETER param_scalar_toMin.
    PARAMETER param_scalar_toMax.

    RETURN (param_scalar_fromValue - param_scalar_fromMin) * (param_scalar_toMax - param_scalar_toMin) / (param_scalar_fromMax - param_scalar_fromMin) + param_scalar_toMin.
}