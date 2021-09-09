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
private _eligiblePatrols = [];
private _eligiblePatrolsJustRifles = [];
// Select infantry groups with _unitCount units or less
private _eligiblePatrolsAll = +_infGroups select { (count (_x select 0)) <= _unitCount };
if (count _eligiblePatrolsAll > 0) then {
    // Select patrols without AT, AA, officers, hacker, assistant, diver, sniper
    _eligiblePatrolsJustRifles = +_eligiblePatrolsAll select {!((_x select 1) select 0) && !((_x select 1) select 1) && !((_x select 1) select 10) && !((_x select 1) select 11) && !((_x select 1) select 12) && !((_x select 1) select 14) && !((_x select 1) select 16)};
    if (count _eligiblePatrolsJustRifles > 0) then {
        _eligiblePatrols = +_eligiblePatrolsJustRifles;
    } else {
        _eligiblePatrols = +_eligiblePatrolsAll;
    };
} else {
    _eligiblePatrols = +_infGroups;
};

_eligiblePatrols