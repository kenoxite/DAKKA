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
private _eligibleMechAll = +_mechGroups select { _type = [(_x select 0) select 0] call DAKKA_fnc_vehicleType;  (_type == "Tracked APC" || _type == "Drone Tracked APC") };
if (count _eligibleMechAll > 0) then {
    _eligibleMech = +_eligibleMechAll;
} else {
    // Otherwise pick any mech group
    _eligibleMechAll = +_mechGroups;
    if (count _eligibleMechAll > 0) then {
        _eligibleMech = +_eligibleMechAll;
    };
};

_eligibleMech