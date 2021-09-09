
_damageBuildings = if (count _this > 0) then  { _this select 0 } else { true };

sleep 1;

DMORBAT_postapocalyptic = true;

waitUntil { DMORBAT_playerGroupReady };

_pos = call compile format ["DMORBAT_task%1_locPos", DMORBAT_Task];

diag_log "DMORBAT: Post-apocalyptic: Initializing";

enableEnvironment [false, true];

_overcast = overcast;
_fog = fog;
_wind = wind;
_wind = wind;
_lightnings = lightnings;
// Overcast
skipTime -24;
86400 setOvercast random [0.55, 0.55, 1];
skipTime 24;
0 = [] spawn {
    sleep 0.1;
    simulWeatherSync;
};
_fog_apoc = [0.5, 0, 0];
0 setFog _fog_apoc;
setWind [5, 5];
0 setLightnings 0.1;
sleep 0.5;

_PPeffect_colorC = ppEffectCreate ["ColorCorrections",1500];
_PPeffect_colorC ppEffectAdjust [1,0.986928,0,[0,0,0,0.105764],[0.503981,0.711942,2.34593,1.1085],[0.493404,-0.279027,0.671655,0]];
_PPeffect_colorC ppEffectEnable true;
_PPeffect_colorC ppEffectCommit 0;

_PPeffect_grain = ppEffectCreate ["FilmGrain",1550];
_PPeffect_grain ppEffectAdjust [0.210428,0.5,0,0.2,0.1];
_PPeffect_grain ppEffectEnable true;
_PPeffect_grain ppEffectCommit 0;

// Destroy and wreck
if (_damageBuildings) then {
    diag_log "DMORBAT: Post-apocalyptic: Destroying everything";
    // Exclude compositions
    _compositions = [];
    _taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
    _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
    {
        _thisCompositionData = _x;
        _compObjects = _thisCompositionData select 1;
        _ref = (_compObjects select 0) select 0;
        _compositions pushBack _ref;
    } forEach _compositionsData;

    // Destroy buildings
    { 
        private _building = _x;
        private _allowDestroy = false;
        {
            if (((position _building) distance _x) > 100) then {
                _allowDestroy = true;
            };
        } forEach _compositions;
        if (_allowDestroy || count _compositions == 0) then {
            if ((random 1) > 0.1) then { _building call BIS_fnc_createRuin } else { _building setDamage 0.9 };
        };
    } forEach (_pos nearObjects ["Static", 1000]);

    // Hide or destroy most other elements
    {
        private _obj = _x;
        private _allowDestroy = false;
        {
            if (((position _obj) distance _x) > 100) then {
                _allowDestroy = true;
            };
        } forEach _compositions;
        if (_allowDestroy || count _compositions == 0) then {
            if (str _x find ": t_" > -1 || str _x find ": b_" > -1 || str _x find ": wall_" > -1 || str _x find ": concrete_" > -1 || str _x find ": city" > -1 || str _x find ": wired_" > -1 || str _x find ": stone_" > -1 || str _x find ": church_" > -1 || str _x find ": power" > -1 || str _x find ": lamp" > -1 || str _x find ": highvoltage" > -1) then {
                private _r = random 1;
                if (_r > 0.9) then {
                    _x setDamage 1;
                } else {
                    if (_r > 0.1) then {
                        _x hideObject true;
                    } else {
                        _x setDamage 0.9;
                    };
                };
            };
        };
    } forEach nearestObjects [_pos, [], 1000];

    // Place vehicle wrecks
    diag_log "DMORBAT: Post-apocalyptic: Placing wrecks";
    _wreckTypes = [
        "Land_Wreck_BMP2_F",
        "Land_Wreck_BRDM2_F",
        "Land_Wreck_Car_F",
        "Land_Wreck_Car2_F",
        "Land_Wreck_HMMWV_F",
        "Land_Wreck_Offroad2_F",
        "Land_Wreck_Plane_Transport_01_F",
        "Land_Wreck_Skodovka_F",
        "Land_Wreck_T72_hull_F",
        "Land_Wreck_T72_turret_F",
        "Land_Wreck_Traw_F",
        "Land_Wreck_Traw2_F",
        "Land_Wreck_UAZ_F",
        "Land_Wreck_Ural_F",
        "Land_Boat_05_wreck_F",
        "Land_Boat_06_wreck_F",
        "Land_Boat_06_wreck_F"
    ];
    _roads = _pos nearRoads 1000;
    _wrecksAmount = 50 + (floor (random (count _roads)));
    for [{private _i = 0}, {(_i < _wrecksAmount)}, {_i = _i + 1}] do
    {
        private _wreckPos = if (count _roads > 0 && (random 1) > 0.9) then {
                [[[position (selectRandom _roads), 20]],[]] call BIS_fnc_randomPos;
            } else {
                [[[_pos, 1000]],[]] call BIS_fnc_randomPos;
            };
        private _wreck = selectRandom _wreckTypes;
        private _wreckReference = _wreck createVehicleLocal _wreckPos;
        _wreckReference setDir (random 360);
        private _wreckPosition = getPosWorld _wreckReference;
        _wreckPosition set [2, (_wreckPosition select 2) - 0.1];
        _wreckReference setVectorUp (surfaceNormal (position _wreckReference));
        private _vectorDirUp = [vectorDir _wreckReference, vectorUp _wreckReference];
        private _model = getModelInfo _wreckReference select 1;
        deleteVehicle _wreckReference;
        _simpleWreck = createSimpleObject [_model, _wreckPosition];
        _simpleWreck setVectorDirAndUp _vectorDirUp;

    };
};

// Place crows
[_pos, 1000] call BIS_fnc_crows;

diag_log "DMORBAT: Post-apocalyptic: Started";
while { DMORBAT_postapocalyptic } do {
    ["ChromAberration", 200, [0.008, 0.008, true]] spawn { 
     params ["_name", "_priority", "_effect", "_handle"]; 
     while { 
      _handle = ppEffectCreate [_name, _priority]; 
      _handle < 0 
     } do { 
      _priority = _priority + 1; 
     }; 
     _handle ppEffectEnable true; 
     _handle ppEffectAdjust _effect; 
     _handle ppEffectCommit 5; 
     waitUntil {ppEffectCommitted _handle}; 
     uiSleep (random 2); 
     _handle ppEffectEnable false; 
     ppEffectDestroy _handle; 
    };

    if ((random 1) > 0.5) then {
        diag_log "DMORBAT: Post-apocalyptic: Changing weather";
        10 setOvercast random [0.55, 0.55, 1];
        0 setFog _fog_apoc;
        0 setLightnings 0.1;
        setWind [random [1,5,10], random [1,5,10]];
    };

    // Wait for the next round
    private _wait = 10 + (random 180);
    for [{private _i = 0}, {(_i < _wait) && DMORBAT_postapocalyptic}, {_i = _i + 1}] do
    {
        sleep 1;
    };
};

ppEffectDestroy _PPeffect_colorC;
ppEffectDestroy _PPeffect_grain;

skipTime -24;
86400 setOvercast _overcast;
skipTime 24;
0 = [] spawn {
    sleep 0.1;
    simulWeatherSync;
};
0 setFog _fog;
setWind [_wind select 0, _wind select 1];
0 setLightnings _lightnings;
enableEnvironment DMORBAT_environment;


diag_log "DMORBAT: Post-apocalyptic: End";