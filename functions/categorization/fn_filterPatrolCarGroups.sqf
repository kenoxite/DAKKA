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

params ["_unitCount", "_motGroups"];
private _eligiblePatrolCars = [];
// Select motorized groups with _unitCount vehicle
private _eligiblePatrolCarsAll = +_motGroups;
private _eligiblePatrolCarsValid = [];
{
    private _group = _x;
    private _units = _x select 0;
    private _vehCount = 0;
    {
        if !([_x] call DAKKA_fnc_isMan) then { _vehCount = _vehCount + 1 };
    } forEach _units;
    if (_vehCount <= _unitCount) then {
        _eligiblePatrolCarsValid pushBack _group;
    };
} forEach _eligiblePatrolCarsAll;
_eligiblePatrolCarsAll = +_eligiblePatrolCarsValid;
if (count _eligiblePatrolCarsAll > 0) then {
     _eligiblePatrolCars = +_eligiblePatrolCarsAll;
} else {
    _eligiblePatrolCars = +_motGroups;
};

_eligiblePatrolCars