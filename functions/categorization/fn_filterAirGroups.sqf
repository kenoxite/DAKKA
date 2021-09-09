/*
  Author: kenoxite

  Description:
	Returns the generic vehicle type.


  Parameter (s):
  _this select 0: _class or object

  Returns:
	BOOL with result of check

  Examples:

*/

params ["_airGroups"];
private _eligibleAir = [];
private _eligibleAirAll = +_airGroups;
private _eligibleAirFiltered = [];
{
    diag_log format ["DMORBAT: _eligibleAirAll - x: %1", _x];
    private _units = _x select 0;
    private _isMissile = false;
    private _airClass = "";
    private _group = _x;
    private _groupIndex = _forEachIndex;
    {
        _airClass = _x;
        if ([_airClass] call DMORBAT_fnc_isAir) then {
            private _testUnit = [_airClass, [0,random 500,0]] call DMORBAT_fnc_spawnVehicle;
            private _pylonLoadout = getPylonMagazines _testUnit;
            private _nul = [_testUnit] spawn { [_this select 0] call DMORBAT_fnc_deleteVehicle };
            _isMissile = false;
            {
                private _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
                private _ammoParents = [configFile >> "CfgAmmo" >> _ammo, true] call BIS_fnc_returnParents;
                _isMissile = "MissileCore" in _ammoParents;
                if (_isMissile) exitWith { if (DMORBAT_debug) then { diag_log format ["%1 - %2 is a missile? %3", _airClass, _x, _isMissile] }; };
            } forEach _pylonLoadout;
        };
    } forEach _units;
    if (_isMissile) then {
        _eligibleAirFiltered pushBackUnique _group;
    };
} forEach _eligibleAirAll;

_eligibleAirAll = +_eligibleAirFiltered;
if (count _eligibleAirAll > 0) then {
    _eligibleAir = +_eligibleAirAll;
} else {
    _eligibleAir = +_airGroups;
};

_eligibleAir