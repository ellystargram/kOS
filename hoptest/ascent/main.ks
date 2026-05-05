RUNPATH("0:/hoptest/ascent/lib.ks"). // Load ascent library
RUNPATH("0:/hoptest/ascent/steps.ks"). // Load ascent steps

standard_void_runStep("Set Lift-Off Throttle", ascent_step_setLiftOffThrottle@).
standard_void_runStep("Release Clamp", ascent_step_releaseClamp@).
standard_void_runStep("Tower Clear", ascent_step_towerClear@).
standard_void_runStep("Go to Altitude", ascent_step_gotoAltitude@).

PRINT "Ascent steps executed.".