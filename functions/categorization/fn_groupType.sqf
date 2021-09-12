/*
  Author: kenoxite

  Description:
  Returns the type of group based on the vehicles it consists of. 


  Parameter (s):
  _this select 0: group or array of classes

  Returns:


  Examples:

*/
params [["_grp", grpNull, [grpNull, []]], ["_specific", false]];

private _units = [];
private _unitClasses = [];
if (typeName _grp == "GROUP") then {
    _units = units _grp;
    {
      _unitClasses pushBackUnique (typeOf vehicle _x);
    } forEach _units;
} else {
    _unitClasses = _grp;
};
if (count _unitClasses == 0) exitWith { diag_log format ["DAKKA: groupType --- ERROR --- No unit classes or group has been passed"]; "" };

// if (DAKKA_debug) then { diag_log format ["DAKKA: _unitClasses: %1 _specific: %2", _unitClasses, _specific] };

private _return = "Inf";
private _land = [];
private _infCount = 0;
{
    if (_specific && {_x isKindOf "Man"}) then {
        _infCount = _infCount + 1;
    };
    if (_x isKindOf "LandVehicle") then {
        if (!_specific) exitWith { _return = "Land" };
        _land pushBackUnique _x;
    };
    // if (_x isKindOf "Air" && _forEachIndex == 0) exitWith { _return = "Air" };
    if (_x isKindOf "Air") exitWith { _return = "Air" };
    if (_x isKindOf "Ship") exitWith { _return = "Ship" };
} forEach _unitClasses;


// if (DAKKA_debug) then { diag_log format ["DAKKA: _land: %1 _infCount: %2", str _land, _infCount] };
// Moto or mech
if (_specific) then {
    if ((count _land) > 0) then {
        if (_infCount > 0) then {
            private _vehType = [_land select 0] call DAKKA_fnc_vehicleType;
            // if (DAKKA_debug) then { diag_log format ["DAKKA: _vehType: %1", _vehType] };
            if (_vehType != "Turret" && _vehType != "Artillery") then {
                if (_vehType == "Car" || _vehType == "Truck") then {
                    _return = "Motorized";
                } else {
                    _return = "Mechanized";
                };
            };
        } else {
            _return = "Armor";
        };
    };
};

// Artillery
if (_specific && {(count _land) > 0 && _infCount == 0}) then {
    private _vehType = [_land select 0] call DAKKA_fnc_vehicleType;
    if (_vehType == "Artillery" || _vehType == "Drone Artillery") then {
        _return = "Artillery";
    };
};

// if (DAKKA_debug) then { diag_log format ["DAKKA: _return: %1", _return] };

_return
