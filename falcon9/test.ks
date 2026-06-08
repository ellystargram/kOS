RUNPATH("0:/falcon9/falcon9_lib.ks").

SET standard_scalar_targetThrottle TO 0.01.

standard_void_setStage1EngineMode("9", "SOFT").
PRINT "Engines set to 9, soft start.".

WAIT 5.

standard_void_setStage1EngineMode("5", "SOFT").
PRINT "Engines set to 5, soft start.".

WAIT 5.

standard_void_setStage1EngineMode("3", "SOFT").
PRINT "Engines set to 3, soft start.".

WAIT 5.

standard_void_setStage1EngineMode("1", "SOFT").
PRINT "Engines set to 1, soft start.".
WAIT 5.

standard_void_setStage1EngineMode("OFF", "SOFT").
PRINT "Engines set to OFF, soft start.".
WAIT 5.

standard_void_setStage1EngineMode("9", "SOFT").
PRINT "Engines set to 9, soft start.".

WAIT 5.
standard_void_setStage1EngineMode("OFF", "SOFT").
PRINT "Engines set to OFF, soft start.".

WAIT 5.
standard_void_setStage1EngineMode("1", "HARD").
PRINT "Engines set to 1, hard start.".

WAIT 5.
standard_void_setStage1EngineMode("3", "SOFT").
PRINT "Engines set to 3, soft start.".

WAIT 5.
standard_void_setStage1EngineMode("1", "HARD").
PRINT "Engines set to 1, hard start.".

WAIT 5.
standard_void_setStage1EngineMode("OFF", "HARD").
PRINT "Engines set to OFF, hard start.".

WAIT 5.
standard_void_setStage1EngineMode("3", "SOFT").
PRINT "Engines set to 3, soft start.".