/*
  Author: kenoxite

  Description:
  Returns the VEHICLE of the unit present at index.
  Unlike a normal units iteration, it ignores the rest of the vehicle crews that would cause the return of the wrong unit. 


  Parameter (s):
  _this select 0: _grp
  _this select 1: _index

  Returns:


  Examples:

*/
params ["_grp", "_index"];
private ["_unit", "_veh", "_i", "_tmpIndex"];
_unit = objNull;
_i = 0;
_tmpIndex = _index;
{
if (isNull _unit) then {
  _veh = vehicle _x;
  if (_i == _tmpIndex) then {
    if (_veh == _x) then {
      _unit = _x;
    } else {
      if (_x == effectiveCommander _veh) then {
        _unit = _veh;
      };
    };
  };
  if (_x != effectiveCommander _veh) then {
    _tmpIndex = _tmpIndex + 1;
  };
  _i = _i + 1;
};
} forEach units _grp;  
_unit
