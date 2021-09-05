/*
  Author: kenoxite

  Description:
	Returns whether the vehicle class has weapons or not.


  Parameter (s):
  _this select 0: _class or object

  Returns:
	BOOL with result of check

  Examples:

*/

params [["_class", "", ["", objNull]]];
if (typeName _class == "OBJECT") then {
    _class = typeOf _class;
};
if (_class == "") exitWith { diag_log format ["DMORBAT: isVehicleArmed --- ERROR --- No unit class or object has been passed"]; "" };

private _parents = [configFile >> "CfgVehicles" >> _class, false] call BIS_fnc_returnParents;
// diag_log format ["DMORBAT: _parents: %1", _parents];

_checkMags = {
    params ["_uniqueMags"];
    // diag_log format ["DMORBAT: _uniqueMags: %1", _uniqueMags];

    private _ignoredAmmo = [
            "FakeAmmo",
            "Laserbeam"
        ];
    private _armed = false;
    private _checkAmmoParent = true;
    {
        if (_armed) exitWith { [_armed, _checkAmmoParent] };
        // diag_log format ["DMORBAT: _mag: %1", _x];
        private _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
        // diag_log format ["DMORBAT: _ammo: %1", _ammo];
        private _ammoParents = [configFile >> "CfgAmmo" >> _ammo, false] call BIS_fnc_returnParents;
        // diag_log format ["DMORBAT: _ammoParents: %1", _ammoParents];    
        _checkAmmoParent = true;
        {
            if (_armed || !_checkAmmoParent) exitWith { [_armed, _checkAmmoParent] };
            private _hitStr = str (_x >> "hit");
            // diag_log format ["DMORBAT: _hitStr: %1", _hitStr];
            _checkAmmoParent = if (_hitStr == "") then { true } else { false };
            private _hit = getNumber (_x >> "hit");
            // diag_log format ["DMORBAT: _ammo: %1 _hit: %2", _x, _hit];
            if (_hit > 1 && !((configName _x) in _ignoredAmmo)) then {
                _armed = true;
            };

        } forEach _ammoParents;  
    } forEach _uniqueMags;

    [_armed, _checkAmmoParent]
};

// Check main weapons
// diag_log format ["DMORBAT: isVehicleArmed -- Checking main weapons of %1", _class];
private _armed = false;
private _checkAmmoParent = true;
{
    if (_armed || !_checkAmmoParent) exitWith { true };
    // diag_log format ["DMORBAT: _class: %1", _x];
    private _mags = getArray (_x >> "magazines");
    private _uniqueMags = [];
    { _uniqueMags pushBackUnique _x} forEach _mags;
    if (count _uniqueMags == 0) exitWith { true };
    private _checkMags = [_uniqueMags] call _checkMags;
    _armed = _checkMags select 0;
    _checkAmmoParent = _checkMags select 1;
} forEach _parents;

if (!_armed) then {
    // diag_log format ["DMORBAT: isVehicleArmed -- Checking turrets of %1", _class];
    // Check turrets
    private _turretsWithMags = -1;
    {
        if (_armed || _turretsWithMags == 0) exitWith { _armed }; // Exit if parent class has turrets but no mags, meaning that the class being checked is also unarmed
        // diag_log format ["DMORBAT: _class: %1", _x];
        {
            if (_armed || _turretsWithMags == 0) exitWith { _armed };
            _turretsWithMags = 0;
            {
                if (_armed) exitWith { _armed };
                // diag_log format ["DMORBAT: turretConfig: %1", _x];
                private _mags = getArray (_x >> "magazines");
                private _uniqueMags = [];
                { _uniqueMags pushBackUnique _x} forEach _mags;
                if (count _uniqueMags > 0) then { _turretsWithMags = _turretsWithMags + 1; };
                // diag_log format ["DMORBAT: _turretsWithMags: %1", _turretsWithMags];
                private _checkMags = [_uniqueMags] call _checkMags;
                _armed = _checkMags select 0;
                _checkAmmoParent = _checkMags select 1;
            } forEach ("true" configClasses _x);
        } forEach ("configName _x == 'Turrets'" configClasses _x);
    } forEach _parents;
};

_armed
