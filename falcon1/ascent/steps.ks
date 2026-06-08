RUNONCEPATH("0:/falcon1/std_lib.ks").
RUNONCEPATH("0:/falcon1/ascent/libs.ks").

FUNCTION ascent_step_towerClear {
    SET standard_scalar_targetThrottle TO 1.0.
    IF ((standard_scalar_vehicleRadarAltitude > ascentLibs_scalar_towerClearTargetAltitude) AND (SHIP:VERTICALSPEED > ascentLibs_scalar_towerClearTargetVerticalSpeed)) {
        SET ascentLibs_timestamp_pitchKickStartTime TO standard_timestamp_terminalCountDown.
        SET standard_scalar_step TO FALSE.
    }
}

FUNCTION ascent_step_pitchKick {
    IF (BODY:ATM:ALTITUDEPRESSURE(ALTITUDE) * CONSTANT:ATMTOKPA < ascentLibs_scalar_pitchKickEndAtmosphericKPA) {
        SET standard_scalar_step TO FALSE.
    } 
    LOCAL scalar_timeSincePitchKickStart TO (standard_timestamp_terminalCountDown - ascentLibs_timestamp_pitchKickStartTime):SECONDS.
    LOCAL scalar_targetPitch TO MIN(scalar_timeSincePitchKickStart * ascentLibs_scalar_pitchKickDegreePerSecond, ascentLibs_scalar_pitchKickTargetmAXAngle).

    SET standard_direction_targetDirection TO HEADING(ascent_scalar_getLaunchHeading(), 90 - scalar_targetPitch, 0).
}

FUNCTION ascent_step_closeLoop {
        // 1. [기존 로직] 목표 관성 방위각 및 목표 궤도 속도 크기 계산
    LOCAL scalar_headingCOSInertial TO COS(ascentLibs_scalar_targetInclination) / COS(SHIP:LATITUDE).
    LOCAL scalar_headingCOS TO MAX(-1, MIN(1, scalar_headingCOSInertial)).
    LOCAL scalar_heading TO ARCCOS(scalar_headingCOS).
    IF (ascentLibs_scalar_targetInclination > 180) {
        SET scalar_heading TO 360 - scalar_heading.
    }

    LOCAL scalar_apWithBodyRadius TO ascentLibs_scalar_targetAP + BODY:RADIUS.
    LOCAL scalar_peWithBodyRadius TO ascentLibs_scalar_targetPE + BODY:RADIUS.
    LOCAL scalar_semiMajorAxis TO (scalar_apWithBodyRadius + scalar_peWithBodyRadius) / 2.
    LOCAL scalar_targetOrbitalVelocityAtPE TO SQRT(BODY:MU * (2 / scalar_peWithBodyRadius - 1 / scalar_semiMajorAxis)).

    LOCAL scalar_targetOrbitalVelocityEast TO scalar_targetOrbitalVelocityAtPE * SIN(scalar_heading).
    LOCAL scalar_targetOrbitalVelocityNorth TO scalar_targetOrbitalVelocityAtPE * COS(scalar_heading).
    
    // 2. [기존 로직] 질문자님의 함수로 현재 속도를 동/북/수직 성분으로 분리
    LOCAL vector_dividedCurrentOrbitalVelocity TO standard_vector_divideVector(VELOCITY:ORBIT).
    LOCAL scalar_currentOrbitalVelocityEast TO vector_dividedCurrentOrbitalVelocity:X.
    LOCAL scalar_currentOrbitalVelocityNorth TO vector_dividedCurrentOrbitalVelocity:Y.
    
    // 수직 속도 성분(Z축)도 피치 제어를 위해 여기서 바로 가져옵니다.
    LOCAL scalar_currentOrbitalVelocityUp TO vector_dividedCurrentOrbitalVelocity:Z.

    // 3. [기존 로직] 좌우(Yaw) 제어를 위한 동/북 델타 V 계산 -> 헤딩 도출
    LOCAL scalar_deltaVelocityEast TO scalar_targetOrbitalVelocityEast - scalar_currentOrbitalVelocityEast.
    LOCAL scalar_deltaVelocityNorth TO scalar_targetOrbitalVelocityNorth - scalar_currentOrbitalVelocityNorth.
    
    // 최종 닫힌 루프 조향에 사용할 헤딩 값 (질문자님의 핵심 로직)
    LOCAL scalar_closedLoopHeading TO ascent_scalar_getLaunchHeading().

    // 4. [신규 확장] 상하(Pitch) 제어를 위한 고도 및 수직 속도 피드백 루프
    // 목표 고도(근지점 반지름)와 현재 기체의 행성 중심 기준 거리를 비교합니다.
    LOCAL scalar_targetRadius TO ascentLibs_scalar_targetPE + BODY:RADIUS.
    LOCAL scalar_currentRadius TO (SHIP:POSITION - SHIP:BODY:POSITION):MAG.
    
    LOCAL scalar_altitudeError TO scalar_targetRadius - scalar_currentRadius.
    LOCAL scalar_verticalSpeedError TO 0 - scalar_currentOrbitalVelocityUp. // 목표 수직속도는 0 m/s

    // 현재 기체가 낼 수 있는 최대 가속도 (m/s^2)
    LOCAL scalar_currentAcc TO SHIP:AVAILABLETHRUST / SHIP:MASS. 
    IF (scalar_currentAcc = 0) { SET scalar_currentAcc TO 1. } // 0 나누기 방지

    // 고도와 속도 오차를 잡기 위해 위쪽 방향으로 추가 제어해야 하는 '요구 가속도'
    LOCAL Kp TO 0.01. // 고도 오차를 반영할 민감도 게인 (테스트 후 조정)
    LOCAL Kd TO 0.08. // 수직속도 오차를 반영할 민감도 게인 (테스트 후 조정)
    LOCAL scalar_requiredVerticalAcc TO (scalar_altitudeError * Kp) + (scalar_verticalSpeedError * Kd).
    
    // 행성이 아래로 당기는 현재 고도에서의 중력 가속도 상쇄 성분
    LOCAL scalar_gravityAcc TO BODY:MU / (scalar_currentRadius^2).
    LOCAL scalar_totalVerticalAcc TO scalar_requiredVerticalAcc + scalar_gravityAcc.

    // 요구되는 수직 가속도를 채우기 위해 기수를 위로 들어 올려야 하는 Pitch 각도 역산
    LOCAL scalar_pitchComponent TO scalar_totalVerticalAcc / scalar_currentAcc.
    SET scalar_pitchComponent TO MAX(-1, MIN(1, scalar_pitchComponent)). // 삼각함수 에러 방지용 범위 제한
    LOCAL scalar_closedLoopPitch TO ARCSIN(scalar_pitchComponent).

    // 5. 계산된 실시간 헤딩과 실시간 피치를 결합하여 조향 명령 최종 하달
    SET standard_direction_targetDirection TO HEADING(scalar_closedLoopHeading, 90 - scalar_closedLoopPitch, 0).

    // 6. 엔진 컷오프(MECO) 조건 감시
    // 동쪽과 북쪽의 남은 속도 오차의 총 크기(합벡터 크기)를 계산합니다.
    LOCAL scalar_remainingHorizontalDV TO SQRT(scalar_deltaVelocityEast^2 + scalar_deltaVelocityNorth^2).
    
    // 목표 속도 수렴 시 엔진을 끄고 다음 스텝으로 탈출합니다.
    IF (scalar_remainingHorizontalDV < 10.0) { 
        SET standard_scalar_targetThrottle TO 0.0.
        SET standard_scalar_step TO FALSE.
        PRINT "목표 궤도 속도 도달. 엔진 차단(MECO).".
    }
}