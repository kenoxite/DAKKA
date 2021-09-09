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

params ["_unitCount", "_SFGroups", "_infGroups"];
private _eligibleSF = [];
if (count _SFGroups > 0) then {
    // Select SF group
    // Pick a group with 6 or less members
    private _eligibleSFAll = +_SFGroups select { (count (_x select 0)) >= _unitCount && (count (_x select 0)) <= 6 };
    if (count _eligibleSFAll > 0) then {
        _eligibleSF = +_eligibleSFAll;
    } else {
        // Otherwise pick one randomly
        _eligibleSF = +_SFGroups;
    };
} else {
    // Select regular infantry if not SF group
    // Pick a group with 6 or less members
    _eligibleSFAll = +_infGroups select { (count (_x select 0)) >= _unitCount && (count (_x select 0)) <= 6 };
    if (count _eligibleSFAll > 0) then {
        _eligibleSF = +_eligibleSFAll;
    } else {
        // Otherwise pick one randomly
        _eligibleSF = +_infGroups;
    };
};  

_eligibleSF