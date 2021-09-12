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
if (_class == "") exitWith { diag_log format ["DAKKA: vehicleType --- ERROR --- No unit class or object has been passed"]; "" };

// if (DAKKA_debug) then { diag_log format ["DAKKA: _class: %1 _checkWeapons: %2", _class, _checkWeapons] };

private _vehType = "";
private _config = configFile >> "CfgVehicles" >> _class;
private _subCat = getText ( _config >> "editorSubcategory");

// Drones
private _crew = getText (_config >> "crew");
private _txt = if (getText (configFile >> "CfgVehicles" >> _crew >> "simulation") == "UAVPilot") then { "Drone " } else { "" };

private _parentClasses = [ _config, true ] call BIS_fnc_returnParents;
// if (DAKKA_debug) then { diag_log format ["DAKKA: _class: %1 _parentClasses: %2", _class, _parentClasses] };

if (_subCat == "EdSubcat_Artillery" || _subCat == "rhs_EdSubcat_Artillery") exitWith { format ["%1Artillery", _txt] };

if ("StaticWeapon" in _parentClasses) exitWith {
    if (_checkWeapons) then {
        if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Turret", _txt] } else { format ["%1Turret (unarmed)", _txt] }
    } else {
        format ["%1Turret", _txt]
    }
};

if (_subCat == "EdSubcat_AAs" || _subCat == "rhs_EdSubcat_aa") then { _txt = format ["%1 (AA)", _txt] };

if (getNumber (_config >> "attendant") == 1) then { _txt = format ["%1 (ambulance)", _txt] };
if (getNumber (_config >> "transportFuel") > 0) then { _txt = format ["%1 (fuel)", _txt] };
if (getNumber (_config >> "transportAmmo") > 0) then { _txt = format ["%1 (ammo)", _txt] };
if (getNumber (_config >> "transportRepair") > 0) then { _txt = format ["%1 (repair)", _txt] };

if ("LandVehicle" in _parentClasses) then {

    // Wheeled
    if ("Wheeled_APC_F" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then { 
                format ["%1Wheeled APC", _txt]
            } else { format ["%1Wheeled APC (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Wheeled APC", _txt]
        }
    };
    if ("Truck_F" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then {
                format ["%1Truck", _txt]
            } else { format ["%1Truck (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Truck", _txt]
        }
    };
    if ("Car" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then {
                format ["%1Car", _txt]
            } else { format ["%1Car (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Car", _txt]
        }
    };

    // Tracked
    if ("APC_Tracked_01_base_F" in _parentClasses || "APC_Tracked_02_base_F" in _parentClasses || "APC_Tracked_03_base_F" in _parentClasses || "CUP_M113_Base" in _parentClasses || "CUP_MTLB_Base" in _parentClasses || "CUP_AAV_Base" in _parentClasses || "CUP_M2Bradley_Base" in _parentClasses || "CUP_FV432_Bulldog_Base" in _parentClasses || "CUP_FV510_Base" in _parentClasses || "CUP_MCV80_Base" in _parentClasses || "rhs_bmp_base" in _parentClasses || "rhs_bmd_base" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then {
                format ["%1Tracked APC", _txt]
            } else { format ["%1Tracked APC (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Tracked APC", _txt]
        }
    };
    if ("Tank" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then {
                format ["%1Tank", _txt]
            } else { format ["%1Tank (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Tank", _txt]
        }
    };

    // Generic
    if (true) exitWith { 
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Land", _txt] } else { format ["%1Land (unarmed)", _txt] } 
        } else {
            _vehType = format ["%1Land", _txt]
        }
    };
};


if ("Air" in _parentClasses) then {
    if ("Helicopter" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Helicopter", _txt] } else { format ["%1Helicopter (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Helicopter", _txt]
        }
    };
    if ("Plane" in _parentClasses) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Plane", _txt] } else { format ["%1Plane (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Plane", _txt]
        }
    };
    if (true) exitWith {
        if (_checkWeapons) then {
            _vehType = if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Air", _txt] } else { format ["%1Air (unarmed)", _txt] }
        } else {
            _vehType = format ["%1Air", _txt]
        }
    };
};

if ("Ship" in _parentClasses) exitWith {
    if (_checkWeapons) then {
        if ([_class] call DAKKA_fnc_isVehicleArmed) then { format ["%1Boat", _txt] } else { format ["%1Boat (unarmed)", _txt] }
    } else {
        _vehType = format ["%1Boat", _txt]
    }
};

_vehType
