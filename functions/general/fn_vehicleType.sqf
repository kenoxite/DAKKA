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
params [["_class", "", ["", objNull]], ["_checkWeapons", false]];
if (typeName _class == "OBJECT") then {
	_class = typeOf _class;
};
if (_class == "") exitWith { diag_log format ["DMORBAT: vehicleType --- ERROR --- No unit class or object has been passed"]; "" };

// if (DMORBAT_debug) then { diag_log format ["DMORBAT: _class: %1 _checkWeapons: %2", _class, _checkWeapons] };

private _vehType = "";
private _subCat = getText (configFile >> "CfgVehicles" >> _class >> "editorSubcategory");

// Drones
private _crew = getText (configFile >> "CfgVehicles" >> _class >> "crew");
private _txt = if (getText (configFile >> "CfgVehicles" >> _crew >> "simulation") == "UAVPilot") then { "Drone " } else { "" };

private _parentClasses = [ configFile >> "CfgVehicles" >> _class, true ] call BIS_fnc_returnParents;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: _class: %1 _parentClasses: %2", _class, _parentClasses] };

if (_subCat == "EdSubcat_Artillery") exitWith { format ["%1Artillery", _txt] };

if ("StaticWeapon" in _parentClasses) exitWith {
    if (_checkWeapons) then {
        if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Turret", _txt] } else { format ["%1Turret (unarmed)", _txt] }
    } else {
        format ["%1Turret", _txt]
    }
};

private _isAA = if (_subCat == "EdSubcat_AAs" || _subCat == "rhs_EdSubcat_aa") then { true } else { false };

if ("LandVehicle" in _parentClasses) then {

    // Wheeled
    if ("Wheeled_APC" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then { 
                if (_isAA) then {
                    format ["%1Wheeled APC (AA)", _txt]
                } else {
                    format ["%1Wheeled APC", _txt]
                }
            } else { format ["%1Wheeled APC (unarmed)", _txt] }
        } else {
            if (_isAA) then {
                _vehType = format ["%1Wheeled APC (AA)", _txt]
            } else {
                _vehType = format ["%1Wheeled APC", _txt]
            }
        }
    };
    if ("Truck" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then {
                if (_isAA) then {
                    format ["%1Truck (AA)", _txt]
                } else {
                    format ["%1Truck", _txt]
                }
            } else { format ["%1Truck (unarmed)", _txt] }
        } else {
            if (_isAA) then {
                _vehType = format ["%1Truck (AA)", _txt]
            } else {
                _vehType = format ["%1Truck", _txt]
            }
        }
    };
    if ("Car" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then {
                if (_isAA) then {
                    format ["%1Car (AA)", _txt]
                } else {
                    format ["%1Car", _txt]
                }
            } else { format ["%1Car (unarmed)", _txt] }
        } else {
            if (_isAA) then {
                _vehType = format ["%1Car (AA)", _txt]
            } else {
                _vehType = format ["%1Car", _txt]
            }
        }
    };

    // Tracked
    if ("APC_Tracked" in _parentClasses || "M113" in _parentClasses || "MTLB" in _parentClasses || "AAV" in _parentClasses || "M2Bradley" in _parentClasses || "FV432_Bulldog" in _parentClasses || "FV510" in _parentClasses || "MCV80" in _parentClasses || "bmp" in _parentClasses || "bmd" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then {
                if (_isAA) then {
                    format ["%1Tracked APC (AA)", _txt]
                } else {
                    format ["%1Tracked APC", _txt]
                }
            } else { format ["%1Tracked APC (unarmed)", _txt] }
        } else {
            if (_isAA) then {
                _vehType = format ["%1Tracked APC (AA)", _txt]
            } else {
                _vehType = format ["%1Tracked APC", _txt]
            }
        }
    };
    if ("Tank" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then {
                if (_isAA) then {
                    format ["%1Tank (AA)", _txt]
                } else {
                    format ["%1Tank", _txt]
                }
            } else { format ["%1Tank (unarmed)", _txt] }
        } else {
            if (_isAA) then {
                _vehType = format ["%1Tank (AA)", _txt]
            } else {
                _vehType = format ["%1Tank", _txt]
            }
        }
    };

    // Generic
    if (true) exitWith { 
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Land", _txt] } else { format ["%1Land (unarmed)", _txt] } 
        } else {
            _vehType = format ["%1Land", _txt]
        }
    };
};


if ("Air" in _parentClasses) then {
    if ("Helicopter" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Helicopter", _txt] } else { format ["%1Helicopter (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Helicopter", _txt]
        }
    };
    if ("Plane" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Plane", _txt] } else { format ["%1Plane (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Plane", _txt]
        }
    };
    if (true) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Air", _txt] } else { format ["%1Air (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Air", _txt]
        }
    };
};

if ("Ship" in _parentClasses) exitWith {
    if (_checkWeapons) then {
        if ([_class] call DMORBAT_fnc_isVehicleArmed) then { format ["%1Boat", _txt] } else { format ["%1Boat (unarmed)", _txt] }
    } else {
        _vehType = format ["%1Boat", _txt]
    }
};

_vehType
