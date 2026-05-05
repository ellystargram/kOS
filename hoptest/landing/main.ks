RUNPATH("0:/hoptest/landing/lib.ks"). // Load landing library
RUNPATH("0:/hoptest/landing/steps.ks"). // Load landing steps script

standard_void_runStep("Landing Guide", landing_step_landingGuide@).
standard_void_runStep("Touch Down", landing_step_touchDown@).

PRINT "Landing steps executed.".