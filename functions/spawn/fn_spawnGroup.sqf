/*
  Author: kenoxite

  Description:
  Creates a series of waypoints for patrolling an area.
  Adapted from BIS function to make use of BIS_fnc_findSafePos when choosing waypoints.


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_unitsArr", "_pos", "_side", ["_maxDist", 30], ["_fly", true], ["_faction", ""], ["_checkManPos", true]]; 
// diag_log format ["DAKKA: spawnGroup - _unitsArr: %1", _unitsArr];
private _grp = createGroup [_side, false];
_grp setVariable ["DAKKA_groupReady", false];
diag_log format ["DAKKA: spawnGroup - grp: %1, side: %2", _grp, side _grp];

0 = [_unitsArr, _pos, _side, _maxDist, _fly, _faction, _checkManPos, _grp] spawn {
    params ["_unitsArr", "_pos", "_side", "_maxDist", "_fly", "_faction", "_checkManPos", "_grp"];
    diag_log format ["DAKKA: spawnGroup -- grp: %1, side: %2", _grp, side _grp];
    // private _oldGrp = grpNull;
    private _unit = objNull;
    private _isMan = true;
    private _isAir = false;
    private _unitClass = "";
    private _unitRank = "";
    private _unitLoadout = [];
    private _unitPresence = 0;
    private _unitSkill = 0;
    private _groupVehicles = [];
    private _groupPassengers = [];

    // Check for presence
    private _presentUnits = [];
    {
        _unitPresence = _x select 3;
        if ((random 1) <= _unitPresence) then {
            _presentUnits pushBack _x;
        };
    } forEach _unitsArr;
    // Exit if no units
    if (count _presentUnits == 0) exitWith { diag_log format ["DAKKA: spawnGroup GROUP NOT SPAWNED. All units failed probability check!", ""]; grpNull };

    // Spawn the group
    {
        _unitClass = _x select 0;
        _unitRank = _x select 1;
        _unitLoadout = _x select 2;
        _unitSkill = _x select 4;
        _isMan = [_unitClass] call DAKKA_fnc_isMan;
        _defaultVehicles = ["C_Offroad_01_F", "C_Van_01_transport_F", "C_Heli_Light_01_civil_F"];
        _isDefaultVeh = _faction != "" && _unitClass in _defaultVehicles;
        _unit = objNull;
        _enableRandom = true;
        // Check if leader is dead due to bad spawning pos
        // _oldGrp = _grp;
        // if (!isNull _grp && !alive vehicle (leader _grp)) then {
        //     diag_log format ["DAKKA: spawnGroup LEADER OF GROUP %1 (%2) IS DEAD! Next unit (%3) is now the leader", (leader _oldGrp), _oldGrp, _unitClass];
        //     _grp = grpNull;
        // };

        if (_isMan) then {
            _unit = ([_unitClass, _pos, _grp, [], _maxDist, "NONE", _enableRandom, _checkManPos] call DAKKA_fnc_spawnMan);
        } else {
            _isAir = [_unitClass] call DAKKA_fnc_isAir;
            private _vehSizeBuffer = (sizeOf _unitClass) + 20;
            private _maxDistVeh = (_maxDist * 2) + _vehSizeBuffer;
            _unit = ([_unitClass, _pos, _grp, [], _maxDistVeh, if (_isAir && _fly) then { "FLY" } else { "NONE" }, _enableRandom, true, true, if (_isDefaultVeh) then { false } else { true }, if (_isDefaultVeh) then { _faction } else { "" }] call DAKKA_fnc_spawnVehicle);
        };

        // sleep 0.001;
        // [_unit] join grpNull;
        // [_unit] joinSilent _grp;  // Fix for wrong side when using createUnit
        
        // Make sure the unit has the correct side
        if (side _unit != _side) then {
            diag_log format ["DAKKA: --- ERROR --- spawnGroup UNIT %1 ISN'T THE CORRECT SIDE. Expected side: %2. Current side: %3", _unitClass, _side, side _unit];
        };
        
        _unit allowDamage false;
        _unit setDamage 0;
        _unit enableSimulation false;
        if (!_isAir) then { _unit setVelocity [0, 0, 0] };
        _unit setCaptive true;
        _unit disableAI "TARGET";
        _unit disableAI "AUTOTARGET";
        _unit disableAI "AUTOCOMBAT";
        _unit disableAI "CHECKVISIBLE";
        _unit disableAI "MOVE";
        if (_isMan) then {
            _groupPassengers pushBack _unit;
        } else {
            if (!_isAir || (_isAir && !_fly)) then {
                [_unit, _pos, _fly] call DAKKA_fnc_placeUnit;
            };
            {
                _x allowDamage false;
                _x setDamage 0;
                _x enableSimulation false;
                _x setCaptive true;
                _x disableAI "TARGET";
                _x disableAI "AUTOTARGET";
                _x disableAI "AUTOCOMBAT";
                _x disableAI "CHECKVISIBLE";
                _x disableAI "MOVE";
            } forEach (crew vehicle _unit);
            _groupVehicles pushBack _unit;
            _grp addVehicle _unit;
            if (DAKKA_debug) then { diag_log format ["DAKKA: spawnGroup - Vehicle group %1 is side %2", _grp, side _grp ] };
        };
        _unit setUnitRank _unitRank;

        [_unit, _unitLoadout, _unitSkill] call DAKKA_fnc_prepareUnit;
    } forEach _presentUnits;

    // Add units of old group to new group if old group leader is dead
    // if (!isNull _oldGrp) then {
    //     {
    //         [_x] joinSilent grpNull; 
    //         [_x] joinSilent _grp; 
    //     } forEach (units _oldGrp);
    // };

    // DISABLE AI MODS
    // Vcom AI
    _grp setVariable ["VCM_Skilldisable",true]; //This command will disable an AI group from being impacted by Vcom AI skill changes.

    // Move passengers to vehicles
    {
        _passengerSeats = [typeOf _x] call DAKKA_fnc_countPassengerSeats;
        for [{private _i = 0}, {_i < _passengerSeats && (count _groupPassengers) > 0}, {_i = _i + 1}] do {
            // if (DAKKA_debug) then { diag_log format ["DAKKA: spawnGroup - _groupPassengers; %1", _groupPassengers] };
            (_groupPassengers select 0) moveInAny _x;
            if (DAKKA_debug) then { diag_log format ["DAKKA: spawnGroup - %1 is moving into %2", _groupPassengers select 0, typeOf _x] };
            _groupPassengers deleteAt 0;
        };
        _x setUnloadInCombat [true, true];
        if ((count _groupPassengers) == 0) exitWith { false };
    } forEach _groupVehicles;


    // Reenable the group units

        private _units = units _grp;
        for "_i" from 0 to (count _units)-1 do
        {
            private _unit = _units select _i;
            waitUntil {sleep 0.001; (_unit getVariable ["DAKKA_UnitReady", false])};
            private _veh = vehicle _unit;
            _unit enableSimulation true;
            _isAir = [_unit] call DAKKA_fnc_isAir;
            if (!_isAir) then {
                _unit setVelocity [0, 0, 0];
            };
            _unit allowDamage true;
            _unit setDamage 0;
            _unit enableAI "TARGET";
            _unit enableAI "AUTOTARGET";
            _unit enableAI "AUTOCOMBAT";
            _unit enableAI "CHECKVISIBLE";
            _unit enableAI "MOVE";
            _unit setCaptive false;
            {
                _x enableSimulation true;
                _x setVelocity [0, 0, 0];
                _x allowDamage true;
                _x setDamage 0;
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "AUTOCOMBAT";
                _x enableAI "CHECKVISIBLE";
                _x enableAI "MOVE";
                _x setCaptive false;
            } forEach (crew _veh);

            _veh enableSimulation true;
            _isAir = [_veh] call DAKKA_fnc_isAir;
            if (!_isAir) then {
                _veh setVectorUp (surfaceNormal (position _veh));
                _veh setVelocity [0, 0, 0];
            };
            _veh allowDamage true;
            _veh setDamage 0;
            _veh enableAI "TARGET";
            _veh enableAI "AUTOTARGET";
            _veh enableAI "AUTOCOMBAT";
            _veh enableAI "CHECKVISIBLE";
            _veh enableAI "MOVE";
            _veh setCaptive false;
        };

    _grp setVariable ["DAKKA_groupReady", true];
};

_grp