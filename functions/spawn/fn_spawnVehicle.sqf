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
params ["_unitClass", ["_pos", position player], ["_grpOrSide", grpNull, [grpNull, sideUnknown]], ["_markers", []], ["_radius", 0], ["_special", "NONE"], ["_enableRandom", true], ["_autoDelete", true], ["_spawnCrew", true], ["_useDefaultCrew", true], ["_faction", ""]];  
private ["_veh", "_side", "_grp", "_canFloat", "_crew"];

// Adjust position when over water or if vehicle can float
_canFloat = getNumber (configFile >> "CfgVehicles" >> _unitClass >> "canFloat");
if ((surfaceIsWater _pos || _canFloat == 1) && (count _pos) > 2) then {
  _pos set [2, 0];
};

// Create vehicle
_veh = createVehicle [_unitClass, _pos, _markers, _radius, _special];
if (isNull _veh) exitWith { diag_log format ["DAKKA: --- ERROR --- spawnVehicle UNIT %1 COULDN'T BE SPAWNED. Class name not recognized!", _unitClass]; objNull };
if (!_enableRandom) then {
  _veh setVariable ["BIS_enableRandomization", false];
};
// Make it invulnerable for now
// _veh setDamage 0;
// _veh allowDamage false;

// Create crew
if (_spawnCrew) then {
    _grp = grpNull;
    _side = sideUnknown;
    if (typeName _grpOrSide == "SIDE") then {
      if (_grpOrSide == sideUnknown) then {
        _side = side player;
      } else {
        _side = _grpOrSide;
      };
      _grp = createGroup [_side, _autoDelete];
    } else {
      if (isNull _grpOrSide) then {
        _side = side player;
        _grp = createGroup [_side, _autoDelete];
      } else {
        _side = side _grpOrSide;
        _grp = _grpOrSide;
      };
    };
    
    // Check for global group limit reached
    if (isNull _grp) exitWith { diag_log format ["DAKKA: --- ERROR --- spawnVehicle GLOBAL GROUP LIMIT FOR SIDE %2 HAS BEEN REACHED!", _unitClass, _side]; objNull };

    _veh = [_veh, _grp, _faction] call DAKKA_fnc_spawnCrew;
    // if (DAKKA_debug) then { diag_log format ["DAKKA: spawnVehicle %1 side: %2", _veh, side _grp ] };
    if (isNull _veh) exitWith { diag_log format ["DAKKA: --- ERROR --- spawnVehicle VEHICLE %1 COULDN'T BE SPAWNED!", _unitClass]; objNull };
};

_veh
