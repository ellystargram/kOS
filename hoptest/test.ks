RUNPATH("0:/hoptest/std_lib.ks").
RUNPATH("0:/hoptest/landing/lib.ks"). // Load landing library
RUNPATH("0:/hoptest/landing/steps.ks"). // Load landing steps script

standard_void_runStep("test/Landing Guide", landing_step_landingGuide@).