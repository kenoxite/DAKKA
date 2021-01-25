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
params ["_unitClass", ["_pos", position player], ["_grp", grpNull, [grpNull, sideUnknown]], ["_markers", []], ["_radius", 0], ["_special", "NONE"], ["_enableRandom", true], ["_autoDelete", true]];  
private ["_unit", "_side"];

// Create group if needed
_side = sideUnknown;
if (typeName _grp == "SIDE") then {
  if (_grp == sideUnknown) then {
    // _side = side player;
    _side = west;
  } else {
    _side = _grp;
  };
  _grp = createGroup [_side, _autoDelete];
} else {
  if (isNull _grp) then {
    // _side = side player;
    _side = west;
    _grp = createGroup [_side, _autoDelete];
  } else {
    _side = side _grp;
  };
};

// Check for global group limit reached
if (isNull _grp) exitWith { diag_log format ["DMORBAT: --- ERROR --- spawnMan UNIT %1 COULDN'T BE SPAWNED. GLOBAL GROUP LIMIT FOR SIDE %2 HAS BEEN REACHED!", _unitClass, _side]; objNull };

// Create unit
_unit = _grp createUnit [_unitClass, _pos, _markers, _radius, _special];
if (isNull _unit) exitWith { diag_log format ["DMORBAT: --- ERROR --- spawnMan UNIT %1 COULDN'T BE SPAWNED. Class name not recognized!", _unitClass]; objNull };
[_unit] joinSilent _grp;  // Fix for wrong side when using createUnit
if (!_enableRandom) then {
  _unit setVariable ["BIS_enableRandomization", false];
};

// Temptative fix to avoid units spawning inside things
_nul = [_unit] spawn {
    _unit = _this select 0;
    _unitPos = getPos _unit;
    _unitClass = typeOf _unit;
    _nearTerrObj = nearestTerrainObjects [_unitPos, ["ROCK", "ROCKS", "BUILDING", "HOUSE"], 15, true, true];
    _nearestBuilding = nearestBuilding _unit;
    _nearestBuildingPos = _nearestBuilding buildingPos 1;
    if ((count _nearTerrObj) > 0) then {
        diag_log format ["DMORBAT: spawnMan - Unit %1 (%2) too close to rocks or non enterable buildints. Trying to relocate it to a safer position...", _unit, _unitClass];
        _dist = 7;
        if !(_nearestBuilding in _nearTerrObj) then {
            _dist = _unit distance (_nearTerrObj select 0);
        } else {
            if (_nearestBuilding in _nearTerrObj && {_nearestBuildingPos isEqualTo [0,0,0]}) then {
                _dist = _unit distance _nearestBuilding;
            };
        };
        _newPos = [_unitPos, 0, 50, _dist, 0, 0.5, 0] call BIS_fnc_findSafePos;
        _unit setPos _newPos;
    };

    // _unit allowDamage false;
    // _pos = getPosATL _unit;
    // _start = +_pos;
    // _start set [2, 2];
    // while { (lineIntersects [ATLToASL _start, ATLToASL _pos]) } do {
    //     _pos set [2, ((_pos select 2) + 0.25)]
    // };
    // _unit setPosATL _pos;
    // _unit allowDamage true;
};

// diag_log format ["DMORBAT: spawnMan %1 side: %2", _unit, side _unit ];
// diag_log format ["DMORBAT: spawnMan %1 side grp: %2", _grp, side _grp ];
_unit