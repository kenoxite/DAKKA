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
private _grp = grpNull;
private _oldGrp = grpNull;
private _unit = objNull;
private _isMan = true;
private _isAir = false;
private _emptyPos = [];
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
    _oldGrp = _grp;
    if (!isNull _grp && !alive vehicle (leader _grp)) then {
        diag_log format ["DAKKA: spawnGroup LEADER OF GROUP %1 (%2) IS DEAD! Next unit (%3) is now the leader", (leader _oldGrp), _oldGrp, _unitClass];
        _grp = grpNull;
    };

    if (_isMan) then {
        _unit = ([_unitClass, _pos, if (isNull _grp) then { _side } else { _grp }, [], _maxDist, "NONE", _enableRandom, _checkManPos] call DAKKA_fnc_spawnMan);
    } else {
        _isAir = [_unitClass] call DAKKA_fnc_isAir;
        _unit = ([_unitClass, _pos, if (isNull _grp) then { _side } else { _grp }, [], _maxDist max ((sizeOf _unitClass) + 20), if (_isAir && _fly) then { "FLY" } else { "NONE" }, _enableRandom, true, true, if (_isDefaultVeh) then { false } else { true }, if (_isDefaultVeh) then { _faction } else { "" }] call DAKKA_fnc_spawnVehicle);
    };
    _unit setCaptive true;
    _unit disableAI "TARGET";
    _unit disableAI "AUTOTARGET";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "CHECKVISIBLE";
    _unit disableAI "MOVE";
    _unit stop true;
    if (_forEachIndex == 0) then {
        _grp = group _unit;
    };
    if (_isMan) then {
        _groupPassengers pushBack _unit;
    } else {
        {
            _x setCaptive true;
            _x disableAI "TARGET";
            _x disableAI "AUTOTARGET";
            _x disableAI "AUTOCOMBAT";
            _x disableAI "CHECKVISIBLE";
            _x disableAI "MOVE";
             _x stop true;
        } forEach (crew vehicle _unit);
        _groupVehicles pushBack _unit;
        _grp addVehicle _unit;
        if (DAKKA_debug) then { diag_log format ["DAKKA: spawnGroup - Vehicle group %1 is side %2", _grp, side _grp ] };
        if (!_isAir || (_isAir && !_fly)) then {
            [_unit, [], _fly] call DAKKA_fnc_placeUnit;
        };
    };
    _unit setUnitRank _unitRank;

    [_unit, _unitLoadout, _unitSkill] call DAKKA_fnc_prepareUnit;
} forEach _presentUnits;

// Add units of old group to new group if old group leader is dead
if (!isNull _oldGrp) then {
    {
        [_x] joinSilent grpNull; 
        [_x] joinSilent _grp; 
    } forEach (units _oldGrp);
};

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
{
    _x enableAI "TARGET";
    _x enableAI "AUTOTARGET";
    _x enableAI "AUTOCOMBAT";
    _x enableAI "CHECKVISIBLE";
    _x enableAI "MOVE";
    _x setCaptive false;
    _x stop false;
    {
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "AUTOCOMBAT";
        _x enableAI "CHECKVISIBLE";
        _x enableAI "MOVE";
        _x setCaptive false;
        _x stop false;
    } forEach (crew vehicle _x);
} forEach (units _grp);

_grp