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
private _eligibleDefenders = [];
private _eligibleDefendersJustRifles = [];
// Select infantry groups with _unitCount or more units
private _eligibleDefendersAll = +_infGroups select { (count (_x select 0)) >= _unitCount };
if (count _eligibleDefendersAll > 0) then {
    // Select defenders without AT or AA
    _eligibleDefendersJustRifles = _eligibleDefendersAll select {!((_x select 1) select 0) && !((_x select 1) select 1)};
    if (count _eligibleDefendersJustRifles > 0) then {
        _eligibleDefenders = +_eligibleDefendersJustRifles;
    } else {
        _eligibleDefenders = +_eligibleDefendersAll;
    };
} else {
    _eligibleDefenders = +_infGroups;
};

_eligibleDefenders