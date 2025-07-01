RUN std_lib.ks.

on AG9 { //LD Confirm KEY
    SET boolean_clockRollingEnabled TO TRUE.
}

on AG10 { //LD Deny KEY
    REBOOT.
}

UNTIL boolean_clockRollingEnabled {}

RUN "launch/landing_test_launch1.ks".