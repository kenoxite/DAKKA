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

params ["_unitCount", "_infGroups"];
private _eligibleAT = [];
// Pick a group with _unitCount or less members
_eligibleATAll = +_infGroups select { (count (_x select 0)) <= _unitCount && ((_x select 1) select 0) };
private _ATgroupsCount = [];
{
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligibleATAll (pre-filter) %1: %2", _forEachIndex, _x select 0] };
} forEach _eligibleATAll;
// Pick a group with at least 2 AT
{  
    private _ATcount = 0;
    private _units = _x select 0;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - AT team check - _units: %1",_units] };
    {
        private _unit = _x;
        private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
        if (_roles select 0) then { _ATcount = _ATcount + 1 };
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - AT team check - _unit: %1 isAT: %2", _unit, _roles select 0] };
    } forEach _units;
    _ATgroupsCount pushBack [_forEachIndex, _ATcount];
} forEach _eligibleATAll;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - AT team check - _ATgroupsCount: %1",_ATgroupsCount] };
private _eligibleATAllValid = [];
{ if ((_x select 1) >= 2) then { _eligibleATAllValid pushBackUnique (_eligibleATAll select (_x select 0)) }; } forEach _ATgroupsCount;
_eligibleATAll = +_eligibleATAllValid;
_eligibleATAllValid = nil;
{
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligibleATAll (post-filter) %1: %2", _forEachIndex, _x select 0] };
} forEach _eligibleATAll;

if (count _eligibleATAll > 0) then {
    _eligibleAT = +_eligibleATAll;
} else {
    // Pick a group with 4 or less members
    _eligibleATAll = +_infGroups select { (count (_x select 0)) <= 4 };
    if (count _eligibleATAll > 0) then {
        _eligibleAT = +_eligibleATAll;
    } else {
        // Otherwise pick one randomly
        _eligibleAT = +_infGroups;
    };
};

_eligibleAT