/*
  Author: kenoxite

  Description:
  Categorizes AT infantry between AT and HAT.


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/

params [["_riflemenAT", []]];

if (count _riflemenAT == 0) exitWith { [] };

if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - Categorizing AT units..."] };

private _ATlaunchers = [];
private _LATlaunchers = [];
private _HATlaunchers = [];

private _properUnitClassNames = [];
{
    if ("_lat" in (toLowerANSI _x) || "_hat" in (toLowerANSI _x)) then { _properUnitClassNames pushBackUnique _x };
} forEach _riflemenAT;

if (count _riflemenAT == count _properUnitClassNames) then {
    // If all units classnames include LAT, AT or HAT just use the extensions to categorize them
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - AT units follow proper suffixes. Categorizing..."] };
    // Reassign units based on AT type
    private _tempRiflemenAT = [];
    {
        private _unitAT = _x;
        private _weaponsArr = getArray (configfile >> "CfgVehicles" >> _x >> "weapons");
        private _usedLauncher = "";
        {
            private _parents = [configFile >> "CfgWeapons" >> _x, true] call BIS_fnc_returnParents;
            if ("Launcher" in _parents) exitWith {
                _usedLauncher = _x;
                if ("_lat" in (toLowerANSI _unitAT)) then { _tempRiflemenAT pushBackUnique _unitAT } else { _riflemenHAT pushBackUnique _unitAT };
                true
            };
        } forEach _weaponsArr;
    } forEach _riflemenAT;
    _riflemenAT = +_tempRiflemenAT;
    _tempRiflemenAT = nil;
} else {
    // If units have varied classname suffixes then we must check each launcher and categorize based on hit damage

    // Check for the launcher of each AT unit
    private _ATremove = [];
    {
        private _unitAT = _x;
        private _weaponsArr = getArray (configfile >> "CfgVehicles" >> _x >> "weapons");
        private _usedLauncher = "";
        {
            private _parents = [configFile >> "CfgWeapons" >> _x, true] call BIS_fnc_returnParents;
            // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _weapon: %1, _parents: %2", _x, _parents] };
            if ("Launcher" in _parents) exitWith {
                _usedLauncher = _x;
                if ("_lat" in (toLowerANSI _unitAT)) then { _LATlaunchers pushBackUnique _usedLauncher };
                if ("_hat" in (toLowerANSI _unitAT)) then { _HATlaunchers pushBackUnique _usedLauncher };
                true
            };
        } forEach _weaponsArr;
        if (_usedLauncher != "" && !("_aa" in _x)) then {
            private _mags = getArray (configfile >> "CfgVehicles" >> _x >> "magazines");
            _ATlaunchers pushBackUnique [0, _usedLauncher, _mags];
        } else {
            _ATremove pushBack _x;
        };
    } forEach _riflemenAT;
    _riflemenAT = _riflemenAT - _ATremove;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _riflemenAT (after removing): %1, removed: %2", _riflemenAT, _ATremove] };
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _ATlaunchers: %1", _ATlaunchers] };

    // Check for the hit damage of each launcher
    for [{private _i = 0}, {_i < count _ATlaunchers}, {_i = _i + 1}] do
    {
        private _launcherArr = _ATlaunchers select _i;
        private _launcher = _launcherArr select 1;
        private _unitMags = _launcherArr select 2;
        private _launcherMags = getArray (configfile >> "CfgWeapons" >> _launcher >> "magazines");
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _launcher; %1, _launcherMags: %2", _launcher, _launcherMags] };
        private _usedMags = _unitMags arrayIntersect _launcherMags;
        // Fix for disposable launchers
        private _fakeMags = false;
        { if ("fake" in (toLowerANSI _x) && (count _launcherMags) == 1) exitWith {  _fakeMags = true; false } } forEach _launcherMags;
        if (_fakeMags) then {
            _launcher = format ["%1%2", _launcher,"_Loaded"];
            // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _launcher; %1", _launcher] };
            _launcherMags = getArray (configfile >> "CfgWeapons" >> _launcher >> "magazines");
            _usedMags = _launcherMags;
        };
        if (count _usedMags == 0) then { _usedMags = _launcherMags };
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _launcher: %1, _usedMags: %2", _launcher, _usedMags] };
        private _mag = _usedMags select 0;
        private _ammo = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
        private _hit = getNumber (configFile >> "CfgAmmo" >> _ammo >> "hit");
        _launcherArr set [0, _hit];
        // Check for missile launchers. Those should always be considered HAT
        private _maneuvrability = getNumber (configFile >> "CfgAmmo" >> _ammo >> "maneuvrability");
        if (_maneuvrability > 0) then { _HATlaunchers pushBackUnique _launcher };
    };
    // Remove unit mags from the launchers array
    { _x deleteAt 2; } forEach _ATlaunchers;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _ATlaunchers (dmg): %1", _ATlaunchers] };

    // Sort from greater to lower damage
    _ATlaunchers sort false;
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _ATlaunchers (sorted): %1", _ATlaunchers] };

    // Separate AT from HAT launchers
    private _ATammount = count _ATlaunchers;
    private _ATdmgCut = round(_ATammount / 2);
    private _ATdmg = [];
    { private _dmg = _x select 0; _ATdmg pushBack _dmg; } forEach _ATlaunchers;
    private _ATdmgMean = _ATdmg call BIS_fnc_arithmeticMean;
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _ATammount: %1, _ATdmgCut: %2, _ATdmgMean: %3", _ATammount, _ATdmgCut, _ATdmgMean] };

    private _i = 0;
    // {  if ((_i + 1) > _ATdmgCut) then { _LATlaunchers pushBackUnique (_x select 1) } else { _HATlaunchers pushBackUnique (_x select 1) }; _i = _i + 1; } forEach _ATlaunchers;
    // {  if ((_X select 0) > _ATdmgMean) then { _HATlaunchers pushBackUnique (_x select 1) } else { _LATlaunchers pushBackUnique (_x select 1) }; _i = _i + 1; } forEach _ATlaunchers;

    // Move the least powerful to LAT and the rest to HAT
    private _peashooterAT = (_ATlaunchers select (count _ATlaunchers) - 1) select 1;
    _LATlaunchers pushBackUnique _peashooterAT;
    { if ((_x select 1) != _peashooterAT) then { _HATlaunchers pushBackUnique (_x select 1) } } forEach _ATlaunchers;
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _LATlaunchers: %1", _LATlaunchers] };
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _HATlaunchers: %1", _HATlaunchers] };

    // Reassign units based on AT type
    private _tempRiflemenAT = [];
    private _unitLauncher = [];
    {
        private _weapons = getArray (configfile >> "CfgVehicles" >> _x >> "weapons");
        // _unitLauncher = (_weapons arrayIntersect _HATlaunchers) select 0;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _unitLauncher: %1", _unitLauncher] };
        // if (((count _unitLauncher) > 0 || ("_hat" in (toLowerANSI _x))) && !("_lat" in (toLowerANSI _x))) then { _riflemenHAT pushBackUnique _x };
        _unitLauncher = _weapons arrayIntersect _LATlaunchers;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: categorizeATunits - _unitLauncher: %1", _unitLauncher] };
        if (((count _unitLauncher) > 0 || ("_lat" in (toLowerANSI _x))) && !("_hat" in (toLowerANSI _x))) then { _tempRiflemenAT pushBackUnique _x } else { _riflemenHAT pushBackUnique _x };
    } forEach _riflemenAT;
    _riflemenAT = +_tempRiflemenAT;
    _tempRiflemenAT = nil;

    // While classname suffixes aren't standard there might be some units that follow it. If so, move them to the right spot
    private _LATcount = 0;
    {
        if ("_lat" in (toLowerANSI _x)) then {
            _LATcount = _LATcount + 1;
        };
    } forEach _riflemenAT;

    // If there's some classes with LAT suffix then move all the rest to HAT
    if (_LATcount > 0 && count _riflemenHAT == 0) then {
        {
            if !("_lat" in (toLowerANSI _x)) then {
                _riflemenHAT pushBackUnique _x;
            };
        } forEach _riflemenAT;
        _dupAT = _riflemenAT arrayIntersect _riflemenHAT;
        _riflemenAT = _riflemenAT - _dupAT;
    };
};

[_riflemenAT, _riflemenHAT]