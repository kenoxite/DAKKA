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
private _eligibleInf = [];
// Pick a group with _unitCount or more members
private _eligibleInfAll = +_infGroups select { (count (_x select 0)) >= _unitCount };
if (count _eligibleInfAll > 0) then {
    _eligibleInf = +_eligibleInfAll;
} else {
    _eligibleInf = +_infGroups;
};

_eligibleInf