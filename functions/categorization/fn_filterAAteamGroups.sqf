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
private _eligibleAA = [];
// Pick a group with _unitCount or less members and AA
private _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= _unitCount && ((_x select 1) select 1)};
if (count _eligibleAAAll > 0) then {
    _eligibleAA = +_eligibleAAAll;
} else {
    // Pick a group with _unitCount or less members
    _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= _unitCount };
    if (count _eligibleAAAll > 0) then {
        _eligibleAA = +_eligibleAAAll;
    } else {
        // Otherwise pick one randomly
        _eligibleAA = +_infGroups;
    };
};

_eligibleAA