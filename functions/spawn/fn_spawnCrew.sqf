/*
  Author: kenoxite

  Description:
  Spawns crew of the given faction for the given vehicle class.


  Parameter (s):
  _this select 0: _veh

  Returns:


  Examples:

*/
params ["_veh", ["_grp", grpNull], ["_faction", ""], ["_autoDelete", true]];  
// diag_log format ["DAKKA: spawnCrew - _veh: %1, _grp: %2, _faction: %3", typeOf _veh, _grp, _faction ];


private _vehClass = typeOf _veh;
private _vehType = [_vehClass] call DAKKA_fnc_vehicleType;
private _vehLC = toLowerANSI _vehClass;
private _crew = [];

if (_faction == "" || "drone" in _vehLC) then {
    if (DAKKA_debug) then { diag_log format ["DAKKA: spawnCrew Spawning DEFAULT crew for %1: %2", _vehClass, _grp ] };
    createVehicleCrew _veh;
    _crew = crew _veh;
    {
        [_x] joinSilent grpNull;
    } forEach _crew;
    _crew joinSilent _grp;
} else {
    if (DAKKA_debug) then { diag_log format ["DAKKA: spawnCrew Spawning FACTION crew for %1: %2", _veh, _grp ] };
    // Choose crew unit classes
    // [_squadLeaders, _teamLeaders, _riflemen, _riflemenAT, _riflemenHAT, _riflemenAA, _grenadiers, _autoriflemen, _medics, _marksmen, _officers, _drivers, _crewmen, _snipers, _spotters, _JTACs, _engineers, _explosiveSpecialists, _heavyGunners, _pilots]
    private _catInf = [];
    private _factionInfantryGrpsStr = format ["DAKKA_%1_%2", "Infantry", _faction];
    private _factionInfantryGrps = missionNamespace getVariable _factionInfantryGrpsStr;
    if (isNil "_factionInfantryGrps") then {
        // Check faction for suitable infantry units
        private _factionInfantry = [_faction, "Infantry"] call DAKKA_fnc_categorizeUnits;
        private _infGroups = [];
        {
            private _grps = _x select 1;
            {
                _infGroups pushBack _x;
            } forEach _grps;
        } forEach _factionInfantry;

        if (count _infGroups == 0) exitWith { [] };

        _catInf = [_infGroups, _isRegular] call DAKKA_fnc_categorizeInf;
        missionNamespace setVariable [_factionInfantryGrpsStr, _catInf];
    } else {
        _catInf = _factionInfantryGrps;
    };
    private _riflemen = _catInf select 2;
    private _drivers = _catInf select 11;
    private _crewmen = _catInf select 12;
    private _pilots = _catInf select 19;

    private _crewClass = "";
    private _isAir = [_veh] call DAKKA_fnc_isAir;
    if (_isAir) then {
        if (count _pilots > 0) then {
            _crewClass = (selectRandom _pilots);
        } else {
            if (count _crewmen > 0) then {
                _crewClass = (selectRandom _crewmen);
            } else {
                _crewClass = (selectRandom _riflemen);
            };
        };
    } else {
        if ("APC" in _vehLC || "tank" in _vehLC) then {
            if (count _crewmen > 0) then {
                _crewClass = (selectRandom _crewmen);
            } else {
                if (count _drivers > 0) then {
                    _crewClass = (selectRandom _drivers);
                } else {
                    _crewClass = (selectRandom _riflemen);
                };
            };
        } else {
            if (count _drivers > 0) then {
                _crewClass = (selectRandom _drivers);
            } else {
                _crewClass = (selectRandom _riflemen);
            };
        };
    };

    // Spawn crew
    private _pos = getPos _veh;
    // Driver
    private _crewUnit = ([_crewClass, _pos, _grp, [], 30, "NONE", _enableRandom] call DAKKA_fnc_spawnMan);
    _crew pushBack _crewUnit;
    _crewUnit moveInDriver _veh;

    // Gunner and turrets
    private _turrets = [_vehClass, true] call BIS_fnc_allTurrets;
    if (count _turrets > 0) then {
        private _config = configFile >> "CfgVehicles" >> _vehClass;
        private _turretsConfig = _config >> "Turrets";
        private _turretsSubClass = _turretsConfig call BIS_fnc_getCfgSubClasses;
        private _validTurrets = [];
        {
            private _dontAllowAI = getNumber( _config >> "Turrets" >> _x >> "dontCreateAI");
            if (_dontAllowAI == 0) then {
                _validTurrets pushBack (_turrets select _forEachIndex);
            };
        } forEach _turretsSubClass;

        {
            private _crewUnit = ([_crewClass, _pos, _grp, [], 30, "NONE", _enableRandom] call DAKKA_fnc_spawnMan);
            _crew pushBack _crewUnit;
            _crewUnit moveInTurret [_veh, _x];
        } forEach _validTurrets;
    };
};

{
    if (!_enableRandom) then {
        _x setVariable ["BIS_enableRandomization", false];
    };
} forEach _crew;
_grp addVehicle _veh;

_veh
