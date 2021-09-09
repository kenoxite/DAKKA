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

params ["_mechGroups"];
private _eligibleMech = [];
private _eligibleMechAll = +_mechGroups;
if (count _eligibleMechAll > 0) then {
    _eligibleMech = +_eligibleMechAll;
} else {
    _eligibleMech = +_mechGroups;
};

_eligibleMech