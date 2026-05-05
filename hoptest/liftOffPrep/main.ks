RUNPATH("0:/hoptest/liftOffPrep/lib.ks"). // Load lift-off preparation library
RUNPATH("0:/hoptest/liftOffPrep/steps.ks"). // Load lift-off preparation steps

standard_void_runStep("CountDown Hold", liftOffPrep_step_countdownHold@).
standard_void_runStep("Clock Set", liftOffPrep_step_clockSet@).
standard_void_runStep("Count Down", liftOffPrep_step_countDown@).

PRINT "Lift-off preparation steps executed.".