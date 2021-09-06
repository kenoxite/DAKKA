/*
  Author: kenoxite

  Description:
  Categorizes units of a given faction.


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/

params ["_faction", ["_filterType", "all"]];

// Create array using editor subcategories
private _bannedVehicles = [
    "Land_Pod_Heli_Transport_04_bench_F",
    "Land_Pod_Heli_Transport_04_covered_F",
    "Land_Pod_Heli_Transport_04_medevac_F",
    "Steerable_Parachute_F",
    "B_Parachute_02_F",
    "I_Parachute_02_F",
    "O_Parachute_02_F",
    "PLP_Dummy_Cargo"
];

private _factionUnits = [];
{ 
    private _unitClass = configName _x;
    private _subcat = getText (_x >> "editorSubcategory"); 
    private _availableForSupportTypes = getArray (_x >> "availableForSupportTypes"); 
    if !(_unitClass in _bannedVehicles) then {
        if (getNumber (_x >> 'scope') == 2) then {
            private _allowUnit = false;
            if (_filterType == "all" || _filterType == "airland" || _filterType == "Infantry") then {
                if (_unitClass isKindOf 'Man') then {
                    _allowUnit = true;
                };
            };
            if (!_allowUnit) then {
                if (_unitClass isKindOf 'LandVehicle') then {
                    if (_filterType == "all" || _filterType == "airland" ||  _filterType == "Land") then {
                        if !(_unitClass isKindOf 'StaticWeapon') then {
                            _allowUnit = true;
                        };
                    } else {
                        if (_filterType == "turret") then {
                            if (_unitClass isKindOf 'StaticWeapon') then {
                                _allowUnit = true;
                            };
                        };
                        if (_filterType == "artillery") then {
                            if (_unitClass isKindOf 'StaticMortar') then {
                                _allowUnit = true;
                            } else {
                                if (_subcat == "EdSubcat_Artillery") then {
                                    _allowUnit = true;
                                };
                            };
                        };
                    };
                };
            };
            if (!_allowUnit) then {
                if (_unitClass isKindOf 'Air') then {
                    if (_filterType == "all" || _filterType == "airland" ||  _filterType == "Air") then {
                         _allowUnit = true;
                    } else {
                        if (_filterType == "CAS") then {
                            if ("CAS_Heli" in _availableForSupportTypes) then {
                                _allowUnit = true;
                            };
                            if ("CAS_Bombing" in _availableForSupportTypes) then {
                                _allowUnit = true;
                            };
                        };
                        if (_filterType == "Air Transport") then {
                            if ("Transport" in _availableForSupportTypes) then {
                                _allowUnit = true;
                            };
                        };
                    };
                };
            };
            if (!_allowUnit) then {
                if (_unitClass isKindOf 'Ship') then {
                    if (_filterType == "all" || _filterType == "water") then {
                        _allowUnit = true;
                    };
                };
            };
            if (_allowUnit) then {
                private _catName = getText (configFile >> "CfgEditorSubcategories" >> _subcat >> "displayName"); 
                private _catIndex = [_factionUnits, _catName] call DMORBAT_fnc_findFirstNested;
                private _unitName = getText (_x >> "displayname");
                if (_catIndex >= 0) then {
                    _catUnits = (_factionUnits select _catIndex) select 1;
                    _catUnits pushback [_unitClass, _unitName];
                } else {
                    _factionUnits pushback [_catName, [[_unitClass, _unitName]]];
                };
            };
        };
    };
} forEach ("getText (_x >> 'faction') == _faction" configClasses (configfile >> "CfgVehicles")); 

_factionUnits sort true;

// {
//     if (DMORBAT_debug) then { diag_log format ["DMORBAT: _factionUnits %2: %1", _x, _forEachIndex] };
// } forEach _factionUnits;

_factionUnits