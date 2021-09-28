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
private _eligibleMotAll = +_motGroups select { _type = [(_x select 0) select 0] call DAKKA_fnc_vehicleType;  (_type == "Wheeled APC" || _type == "Drone Wheeled APC") };
if (count _eligibleMotAll > 0) then {
    _eligibleMot = +_eligibleMotAll;
} else {
    // Otherwise pick any mech group
    _eligibleMotAll = +_motGroups;
    if (count _eligibleMotAll > 0) then {
        _eligibleMot = +_eligibleMotAll;
    };
};

_eligibleMot