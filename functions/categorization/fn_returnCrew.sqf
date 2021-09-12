/*
  Author: kenoxite

  Description:
  Returns an array of crew positions


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/


params [["_vehClass", ""], ["_includeFFV", false]];

if (_vehClass == "") exitWith { [] };

private _crew = [];
private _config = configFile >> "CfgVehicles" >> _vehClass;
// private _crew = getText (_config >> "crew");
private _hasDriver = getNumber (_config >> "hasDriver");
// private _hasGunner = getNumber (_config >> "hasGunner");
// private _hasCommander = getNumber (_config >> "hasCommander");
if (_hasDriver > 0) then { _crew pushBack true};

// Gunner and turrets
private _turrets = [_vehClass, true] call BIS_fnc_allTurrets;
if (count _turrets > 0) then {
    private _config = configFile >> "CfgVehicles" >> _vehClass;
    private _turretsConfig = _config >> "Turrets";
    private _turretsSubClass = _turretsConfig call BIS_fnc_getCfgSubClasses;
    private _validTurrets = [];
    {
        private _dontAllowAI = if (_includeFFV) then { 0 } else { getNumber( _config >> "Turrets" >> _x >> "dontCreateAI") };
        if (_dontAllowAI == 0) then {
            _validTurrets pushBack (_turrets select _forEachIndex);
        };
    } forEach _turretsSubClass;
    if (count _validTurrets > 0) then { _crew append _validTurrets };
};

_crew