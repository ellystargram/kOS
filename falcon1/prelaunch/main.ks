RUNONCEPATH("0:/falcon1/std_lib.ks").
RUNONCEPATH("0:/falcon1/prelaunch/steps.ks").

standard_void_runStep("VERIFY LD GO", prelaunch_step_verifyLaunchDirectorGo@).
standard_void_runStep("SET T-0", prelaunch_step_setTerminalCount0@).
standard_void_runStep("STRONGBACK RETRACT", prelaunch_step_strongbackRetract@).
standard_void_runStep("COUNTDOWN", prelaunch_step_countDown@).

IF ((standard_string_lastPollingTopic = "Confirm LiftOff") AND (standard_boolean_lastPollingResult = TRUE)) {
    standard_void_runStep("RELEASE HOLD DOWN CLAMPS", prelaunch_step_releaseHoldDownClamps@).
    RUNPATH("0:/falcon1/ascent/main.ks").
} ELSE {
    standard_void_runStep("STRONGBACK RAISE", prelaunch_step_strongbackRaise@).
}