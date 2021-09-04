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

params ["_unitsArr", "_pos", "_side", ["_maxDist", 30], ["_fly", true]]; 

private _grp = grpNull;
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
if (count _presentUnits == 0) exitWith { diag_log format ["DMORBAT: spawnGroup GROUP NOT SPAWNED. All units failed probability check!", ""]; grpNull };

// Spawn the group
{
    _unitClass = _x select 0;
    _unitRank = _x select 1;
    _unitLoadout = _x select 2;
    _unitSkill = _x select 4;
    _isMan = [_unitClass] call DMORBAT_fnc_isMan;
    _unit = if (_isMan) then {
            ([_unitClass, _pos, if (isNull _grp) then { _side } else { _grp }, [], _maxDist, "NONE", true] call DMORBAT_fnc_spawnMan);
          } else {
            _isAir = [_unitClass] call DMORBAT_fnc_isAir;
            ([_unitClass, _pos, if (isNull _grp) then { _side } else { _grp }, [], _maxDist max ((sizeOf _unitClass) + 20), if (_isAir && _fly) then { "FLY" } else { "NONE" }, true] call DMORBAT_fnc_spawnVehicle);
          };
    _unit setCaptive true;
    _unit disableAI "TARGET";
    _unit disableAI "AUTOTARGET";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "CHECKVISIBLE";
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
        } forEach (crew vehicle _unit);
        _groupVehicles pushBack _unit;
        _grp addVehicle _unit;
        if (!_isAir || (_isAir && !_fly)) then {
            _nul = [_unit, _isAir, _fly] spawn {
                _unit = _this select 0;
                _isAir = _this select 1;
                _fly = _this select 2;
                _unitPos = getPos _unit;
                _unitClass = typeOf _unit;
                // Reposition if objects are too close
                _tries = 3;
                _distMod = 50;
                _safeRadius = 20 + (sizeOf _unitClass);
                _safeSpotFound = false;
                _alowedDamage = isDamageAllowed _unit;
                _unit enableSimulation false;
                _unit setVelocity [0, 0, 0];
                _unit allowDamage false;
                {
                    _x enableSimulation false;
                    _x setVelocity [0, 0, 0];
                    _x allowDamage false;
                } forEach (crew vehicle _unit);
                 for [{private _i = 0}, {_i < _tries && !_safeSpotFound}, {_i = _i + 1}] do 
                {
                    _nearTerrObj = nearestTerrainObjects [_unitPos, [], _safeRadius, false, true];
                    if ((count _nearTerrObj) > 0) then {
                        diag_log format ["DMORBAT: spawnGroup - Vehicle %1 (%2) is dangerously close to terrain objects. Trying to repositioning it to a safer place...", _unit, _unitClass];
                        // Make sure vehicle has spawned in a safe spot
                        _emptyPos = [_unitPos, _safeRadius, 200 max (_safeRadius + _distMod), 20, 0, 0.5, 0, [], [_unitPos, _unitPos]] call BIS_fnc_findSafePos;
                        if (count _emptyPos < 3) then {
                            // _emptyPos = (getPos _unit) findEmptyPosition [_safeRadius, 200, _unitClass];
                            // if (count _emptyPos > 0) then {
                            diag_log format ["DMORBAT: spawnGroup - FOUND safe position for %1 (%2): %3", _unit, _unitClass, _emptyPos];
                            _unit setPos _emptyPos;
                            // _unit setVectorUp (surfaceNormal (position _unit));
                            _safeSpotFound = true;
                        } else {
                            diag_log format ["DMORBAT: spawnGroup - %1: NOT FOUND safe position for %2 (%3)", _i + 1, _unit, _unitClass];
                            if (_isAir && !_fly) then {
                                diag_log "DMORBAT: spawnGroup - Unit can fly but it wasn't spawned flying. Postioning it high so it will try to fly and stay safe.";
                                _unit setPosASL [_unitPos select 0, _unitPos select 1, 1000];
                            };
                        };
                    };
                    _distMod = _distMod * (_i + 2);
                    _unit enableSimulation true;
                    _unit allowDamage _alowedDamage;
                    {
                        _x enableSimulation true;
                        _x allowDamage _alowedDamage;
                    } forEach (crew vehicle _unit);
                };
            };
        };
    };
    _unit setUnitRank _unitRank;

    [_unit, _unitLoadout, _unitSkill] call DMORBAT_fnc_prepareUnit;
} forEach _presentUnits;

// DISABLE AI MODS
// Vcom AI
_grp setVariable ["VCM_Skilldisable",true]; //This command will disable an AI group from being impacted by Vcom AI skill changes.

// Move passengers to vehicles
{
    _passengerSeats = (fullCrew [_x, "", true]) select {isNull (_x select 0)};
    // diag_log format ["DMORBAT: spawnGroup - %1 has %2 passenger seats", typeOf _x, count _passengerSeats];
    for [{private _i = 0}, {_i < count _passengerSeats && (count _groupPassengers) > 0}, {_i = _i + 1}] do {
        // diag_log format ["DMORBAT: spawnGroup - _groupPassengers; %1", _groupPassengers];
        (_groupPassengers select 0) moveInAny _x;
        diag_log format ["DMORBAT: spawnGroup - %1 is moving into %2", _groupPassengers select 0, typeOf _x];
        _groupPassengers deleteAt 0;
    };
    if ((count _groupPassengers) == 0) exitWith { false };
} forEach _groupVehicles;


{
    _x enableAI "TARGET";
    _x enableAI "AUTOTARGET";
    _x enableAI "AUTOCOMBAT";
    _x enableAI "CHECKVISIBLE";
    _x setCaptive false;
    {
        _x enableAI "TARGET";
        _x enableAI "AUTOTARGET";
        _x enableAI "AUTOCOMBAT";
        _x enableAI "CHECKVISIBLE";
        _x setCaptive false;
    } forEach (crew vehicle _x);
} forEach (units _grp);

_grp