/*
  Author: kenoxite

  Description:
  Creates custom faction groups


  Parameter (s):
  _faction: 
  _groupType: "Infantry", "SF", "Motorized", "Mechanized", "Armor", "Land", Air", "All"

  Returns:


  Examples:

*/
params ["_faction", ["_groupType", "Infantry"]];

private _customInfGroups = [];
private _customSFGroups = [];
private _customMotoGroups = [];
private _customMechGroups = [];
private _customArmorGroups = [];
private _customLandGroups = [];
private _customPlaneGroups = [];
private _customHeloGroups = [];
private _customAirGroups = [];

// REGULAR INFANTRY & SF GROUPS
if (_groupType == "Infantry") then {
    _customInfGroups = ["Infantry", _faction] call DMORBAT_fnc_createCustomInfGroups;
};
if (_groupType == "SF") then {
    _customSFGroups = ["SF", _faction] call DMORBAT_fnc_createCustomInfGroups;
};

// LAND VEHICLE GROUPS
if (_groupType == "Motorized") then {
    _customMotoGroups = (["Motorized", _faction] call DMORBAT_fnc_createCustomLandGroups) select 0;
};
if (_groupType == "Mechanized") then {
    _customMechGroups = (["Mechanized", _faction] call DMORBAT_fnc_createCustomLandGroups) select 1;
};
if (_groupType == "Armor") then {
    _customArmorGroups = (["Armor", _faction] call DMORBAT_fnc_createCustomLandGroups) select 2;
};
if (_groupType == "Land") then {
    _customLandGroups = ["Land", _faction] call DMORBAT_fnc_createCustomLandGroups;
    if (count _customLandGroups > 0) then {
        _customMotoGroups = _customLandGroups select 0;
        _customMechGroups = _customLandGroups select 1;
        _customArmorGroups = _customLandGroups select 2;
    };
};

// AIR VEHICLE GROUPS
if (_groupType == "Plane") then {
    _customPlaneGroups = (["Plane", _faction] call DMORBAT_fnc_createCustomAirGroups) select 0;
};
if (_groupType == "Helo") then {
    _customPlaneGroups = (["Helo", _faction] call DMORBAT_fnc_createCustomAirGroups) select 1;
};
if (_groupType == "Air") then {
    _customAirGroups = ["Air", _faction] call DMORBAT_fnc_createCustomAirGroups;
    if (count _customAirGroups > 0) then {
        _customPlaneGroups = _customAirGroups select 0;
        _customHeloGroups = _customAirGroups select 1;
    };
};

// ALL
if (_groupType == "All") then {
    _customInfGroups = ["Infantry", _faction] call DMORBAT_fnc_createCustomInfGroups;
    _customSFGroups = ["SF", _faction] call DMORBAT_fnc_createCustomInfGroups;
    _customLandGroups = ["Land", _faction] call DMORBAT_fnc_createCustomLandGroups;
    if (count _customLandGroups > 0) then {
        _customMotoGroups = _customLandGroups select 0;
        _customMechGroups = _customLandGroups select 1;
        _customArmorGroups = _customLandGroups select 2;
    };
    _customAirGroups = ["Air", _faction] call DMORBAT_fnc_createCustomAirGroups;
    if (count _customAirGroups > 0) then {
        _customPlaneGroups = _customAirGroups select 0;
        _customHeloGroups = _customAirGroups select 1;
    };
};

[_customInfGroups, _customSFGroups, _customMotoGroups, _customMechGroups, _customArmorGroups, _customPlaneGroups, _customHeloGroups]