/*
  Author: kenoxite

  Description:
  Spawns a unit of class man.


  Parameter (s):
  _this select 0: _unitClass
  _this select 1: _pos
  _this select 2: _grp
  _this select 3: _markers
  _this select 4: _radius
  _this select 5: _special
  _this select 6: _enableRandom
  _this select 7: _autoDelete

  Returns:


  Examples:

*/
params ["_unitClass", ["_pos", position player], ["_grpOrSide", grpNull, [grpNull, sideUnknown]], ["_markers", []], ["_radius", 0], ["_special", "NONE"], ["_enableRandom", true], ["_checkPos", true], ["_autoDelete", true]];  

// Create group if needed
private _grp = grpNull;
private _side = sideUnknown;
if (typeName _grpOrSide == "SIDE") then {
  if (_grpOrSide == sideUnknown) then {
    _side = west;
  } else {
    _side = _grpOrSide;
  };
  _grp = createGroup [_side, _autoDelete];
} else {
  if (isNull _grpOrSide) then {
    _side = west;
    _grp = createGroup [_side, _autoDelete];
  } else {
    _side = side _grpOrSide;
    _grp = _grpOrSide;
  };
};

// Check for global group limit reached
if (isNull _grp) exitWith { diag_log format ["DAKKA: --- ERROR --- spawnMan UNIT %1 COULDN'T BE SPAWNED. GLOBAL GROUP LIMIT FOR SIDE %2 HAS BEEN REACHED!", _unitClass, _side]; objNull };

// Create unit
private _unit = (group player) createUnit [_unitClass, _pos, _markers, _radius, _special];
if (isNull _unit) exitWith { diag_log format ["DAKKA: --- ERROR --- spawnMan UNIT %1 COULDN'T BE SPAWNED. Class name not recognized!", _unitClass]; objNull };
// _unit setPos [random 100, random 100, 10000];
[_unit] join grpNull;
[_unit] joinSilent _grp;  // Fix for wrong side when using createUnit

_unit setVariable ["BIS_enableRandomization", [false, true] select _enableRandom];


// Temptative fix to avoid units spawning inside things
if (_checkPos) then {
    [_unit, _pos] call DAKKA_fnc_placeUnit;
} else {
    _unit setVariable ["DAKKA_UnitReady", true];
};

// if (DAKKA_debug) then { diag_log format ["DAKKA: spawnMan %1 side: %2", _unit, side _unit ] };
// if (DAKKA_debug) then { diag_log format ["DAKKA: spawnMan %1 side grp: %2", _grp, side _grp ] };
_unit