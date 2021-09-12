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

params ["_armorGroups"];
{
    if (DAKKA_debug) then { diag_log format ["DAKKA: _fnc_filterArmorGroups %1: %2", _forEachIndex, _x] };
} forEach _armorGroups;

private _eligibleArmor = [];
// Pick a tank group
private _eligibleArmorAll = +_armorGroups select { _type = [(_x select 0) select 0] call DAKKA_fnc_vehicleType;  (_type == "Tank" || _type == "Drone Tank") };
{ (_x select 0) resize 1 } forEach _eligibleArmorAll;
if (count _eligibleArmorAll > 0) then {
    _eligibleArmor = +_eligibleArmorAll;
} else {
    // Otherwise pick any tank group
    _eligibleArmorAll = +_armorGroups;
    if (count _eligibleArmorAll > 0) then {
        _eligibleArmor = +_eligibleArmorAll;
    };
};

_eligibleArmor