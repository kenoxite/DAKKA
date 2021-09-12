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

// Flatten the array
_eligibleAirAllTemp = [];
{

} forEach _eligibleAirAll;

private _eligibleAirFiltered = [];
{
    private _units = _x select 0;
    private _isMissile = false;
    private _isRocket = false;
    private _airClass = "";
    private _group = _x;
    private _groupIndex = _forEachIndex;
    {
        _airClass = _x;
        if (typeName _airClass == "ARRAY") then { _airClass = (_x select 0) select 0 };
        if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAirAll - Looking for missiles and rockets in %1", _airClass] };
        if ([_airClass] call DAKKA_fnc_isAir) then {
            private _testUnit = [_airClass, [0,random 500,0]] call DAKKA_fnc_spawnVehicle;
            private _pylonLoadout = getPylonMagazines _testUnit;
            private _nul = [_testUnit] spawn { [_this select 0] call DAKKA_fnc_deleteVehicle };
            _isMissile = false;
            _isRocket = false;
            {
                private _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
                private _ammoParents = [configFile >> "CfgAmmo" >> _ammo, true] call BIS_fnc_returnParents;
                // if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAirAll - _ammo: %1, _ammoParents: %2", _ammo, _ammoParents] };
                _isMissile = "MissileCore" in _ammoParents;
                _isRocket = "RocketCore" in _ammoParents;
                if (_isMissile || _isRocket) exitWith { if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAirAll - %1 HAS MISSILES OR ROCKETS: %2", _airClass, _x] }; };
            } forEach _pylonLoadout;
        };
    } forEach _units;
    if (_isMissile) then {
        _eligibleAirFiltered pushBackUnique _group;
    } else {
        if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAirAll - %1 DOESN'T HAVE MISSILES OR ROCKETS", _airClass] };
    };
} forEach _eligibleAirAll;

_eligibleAirAll = +_eligibleAirFiltered;
if (count _eligibleAirAll > 0) then {
    _eligibleAir = +_eligibleAirAll;
} else {
    _eligibleAir = +_airGroups;
};

_eligibleAir