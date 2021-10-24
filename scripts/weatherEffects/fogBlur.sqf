
sleep 2;

K_fogBlur_enabled = true;
K_fog = false;
K_wasUnderwater = false;
K_wasInBuilding = false;
K_wasInsideVehicle = false;
k_lastAltitude = (getPosASL (vehicle player)) select 2;
k_lastFogParams = fogParams;
k_soundVolume = soundVolume;
k_environmentVolume = environmentVolume;
k_speechVolume = speechVolume;
k_radioVolume = radioVolume;

// 0 setFog [random [0.1, 0.25, 0.35], 0.03, 70];
// 0 setFog [0.35, 0.03, 70];

while {K_fogBlur_enabled} do {
    private _altitude = (getPosASL (vehicle player)) select 2;
    // private _inBuilding = [false, true] select (count (lineIntersectsWith [ getPosASL player, (getPosASL player) vectorAdd [0, 0, 20], player]) > 0);
    private _inBuilding = false;
    private _isOnFoot = isNull objectParent player;
    private _insideVehicle = [false, true] select (!_isOnFoot && !isTurnedOut player && cameraView != "EXTERNAL" && cameraView != "GROUP" && cameraView != "GUNNER" && count (lineIntersectsWith [ getPosASL player, (getPosASL player) vectorAdd [0, 0, 20], player]) > 0);
    private _fogParams = fogParams;
    private _fogValue = _fogParams select 0;
    private _fogDecay = _fogParams select 1;
    private _fogBase = (_fogParams select 2) + ((fogParams select 2) * ((_fogValue * 10) / (_fogDecay * 500)));
    K_effect = -(((_altitude - _fogBase) * (0.003 + (_fogDecay / 10)))) min ([0.5, 0.2] select _insideVehicle);

    private _currentFog = K_fog;
    private _isUnderwater = eyePos player select 2 < 0;
    K_fog = [false, true] select (_altitude < _fogBase && !_isUnderwater && !_inBuilding);

    if (K_fog && !_currentFog) then {
        private _delay = [3, 0] select ((!_isUnderwater && K_wasUnderwater) || (K_wasInBuilding && !_inBuilding));
        K_fog_handle = ppEffectCreate ["DynamicBlur", 401];
        K_fog_handle ppEffectEnable true;
        K_fog_handle ppEffectAdjust [K_effect];
        K_fog_handle ppEffectCommit _delay;
        k_soundVolume = soundVolume;
        k_environmentVolume = environmentVolume;
        k_speechVolume = speechVolume;
        k_radioVolume = radioVolume;
        _delay fadeSound (k_soundVolume - (K_effect * 2)) max 0.05;
        _delay fadeEnvironment (k_environmentVolume - (K_effect * 3)) max 0;
        _delay fadeSpeech (k_speechVolume - (K_effect * 3)) max 0.05;
        _delay fadeRadio k_radioVolume;
        waitUntil {ppEffectCommitted K_fog_handle};
        systemchat "Fog blur enabled";
    };

    if (K_fog && _currentFog && (abs(_altitude - k_lastAltitude) > 1 || !(k_lastFogParams isEqualTo _fogParams)) || (K_wasInsideVehicle != _insideVehicle)) then {
        private _delay = 1;
        K_fog_handle ppEffectAdjust [K_effect];
        K_fog_handle ppEffectCommit _delay;
        _delay fadeSound (k_soundVolume - (K_effect * 2)) max 0.05;
        _delay fadeEnvironment (k_environmentVolume - (K_effect * 3)) max 0;
        _delay fadeSpeech (k_speechVolume - (K_effect * 3)) max 0.05;
        _delay fadeRadio k_radioVolume;
        k_lastAltitude = _altitude;
        waitUntil {ppEffectCommitted K_fog_handle};
        systemchat format ["Fog blur tweaked - altitude: %1, limit altitude: %2, effect: %3", _altitude, _fogBase, K_effect];
    };

    if (!K_fog && _currentFog) then {
        private _delay = [3, 0] select (_isUnderwater || _inBuilding);
        _delay fadeSound k_soundVolume;
        _delay fadeEnvironment k_environmentVolume;
        _delay fadeSpeech k_speechVolume;
        _delay fadeRadio k_radioVolume;
        uiSleep _delay;
        K_fog_handle ppEffectEnable false;
        ppEffectDestroy K_fog_handle;   
        systemchat "Fog blur disabled";
    };

    K_wasUnderwater = _isUnderwater;
    K_wasInBuilding = _inBuilding;
    K_wasInsideVehicle = _insideVehicle;
    k_lastFogParams = _fogParams;

    uiSleep 0.5;
};


private _delay = 0;
_delay fadeSound k_soundVolume;
_delay fadeEnvironment k_environmentVolume;
_delay fadeSpeech k_speechVolume;
_delay fadeRadio k_radioVolume;
uiSleep _delay;
K_fog_handle ppEffectEnable false;
ppEffectDestroy K_fog_handle;   
systemchat "Fog blur disabled";