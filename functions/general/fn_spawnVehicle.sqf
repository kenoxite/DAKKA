/*
  Author: kenoxite

  Description:
  Spawns a vehicle and its crew.


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
private ["_veh", "_side", "_canFloat", "_crew"];

// Create group if needed
_side = sideUnknown;
if (typeName _grp == "SIDE") then {
  if (_grp == sideUnknown) then {
    _side = side player;
  } else {
    _side = _grp;
  };
  _grp = createGroup [_side, _autoDelete];
} else {
  if (isNull _grp) then {
    _side = side player;
    _grp = createGroup [_side, _autoDelete];
  } else {
    _side = side _grp;
  };
};

// Check for global group limit reached
if (isNull _grp) exitWith { diag_log format ["DMORBAT: --- ERROR --- spawnVehicle VEHICLE %1 COULDN'T BE SPAWNED. GLOBAL GROUP LIMIT FOR SIDE %2 HAS BEEN REACHED!", _unitClass, _side]; objNull };

// Adjust position when over water or if vehicle can float
_canFloat = getNumber (configFile >> "CfgVehicles" >> _unitClass >> "canFloat");
if ((surfaceIsWater _pos || _canFloat == 1) && (count _pos) > 2) then {
  _pos set [2, 0];
};

// Create vehicle
_veh = createVehicle [_unitClass, _pos, _markers, _radius, _special];
if (isNull _veh) exitWith { diag_log format ["DMORBAT: --- ERROR --- spawnVehicle UNIT %1 COULDN'T BE SPAWNED. Class name not recognized!", _unitClass]; objNull };
if (!_enableRandom) then {
  _veh setVariable ["BIS_enableRandomization", false];
};

// Create crew
createVehicleCrew _veh;
_crew = crew _veh;
{
  if (!_enableRandom) then {
    _x setVariable ["BIS_enableRandomization", false];
  };
} forEach _crew;
_crew joinSilent _grp;
_grp addVehicle _veh;

// diag_log format ["DMORBAT: spawnVehicle %1 side: %2", _veh, side _veh ];

_veh
