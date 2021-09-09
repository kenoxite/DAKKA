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

params ["_motGroups"];
private _eligibleMot = [];
private _eligibleMotAll = +_motGroups;
if (count _eligibleMotAll > 0) then {
    _eligibleMot = +_eligibleMotAll;
} else {
    _eligibleMot = +_motGroups;
};

_eligibleMot