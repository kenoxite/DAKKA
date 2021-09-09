/*
  Author: kenoxite

  Description:
  Creates custom faction groups


  Parameter (s):
  _groupsType: "Air"

  Returns:


  Examples:

*/

params [["_groupsType", []], ["_faction", ""]];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - _groupsType: %1", _groupsType] };

if (count _groupsType == 0) exitWith { [] };

// Check faction for suitable land units
private _factionAir = [_faction, "Air"] call DMORBAT_fnc_categorizeUnits;
private _airGroups = [];
{
    private _grps = _x select 1;
    {
        _airGroups pushBack _x;
    } forEach _grps;
} forEach _factionAir;

// If faction comes in several versions (Woodland, Arid, etc) check this exception list and try to use the vehicles from the main faction
private _usingParentFaction = [
    ["BLU_W_F", "BLU_F"]
];
private _parentFactionIndex = [_usingParentFaction, _faction] call DMORBAT_fnc_findFirstNested;
if (_parentFactionIndex >= 0) then {
    private _parentFaction = (_usingParentFaction select _parentFactionIndex) select 1;
    private _factionAir = [_parentFaction, "Air"] call DMORBAT_fnc_categorizeUnits;
    {
        private _grps = _x select 1;
        {
            _airGroups pushBack _x;
        } forEach _grps;
    } forEach _factionAir;
};

// if (count _airGroups == 0) exitWith { [] };

// Categorize all the air vehicles
private _planes = [];
private _planes_unarmed = [];
private _helos = [];
private _helos_unarmed = [];
private _planeDrones = [];
private _heloDrones = [];

private _planesAll = [];
private _validPlanes = [];
private _helosAll = [];
private _validHelos = [];

private _customPlaneGroups = [];
private _customHeloGroups = [];
private _customTransportHeloGroups = [];

{
    private _unitClass = _x select 0;
    private _type = [_unitClass, true] call DMORBAT_fnc_vehicleType;

    if (_type == "Plane") then { _planes pushBack _unitClass; };
    if (_type == "Drone Plane") then { _planeDrones pushBack _unitClass; };
    if (_type == "Helicopter") then { _helos pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Helicopter (unarmed)") then { _helos_unarmed pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Helicopter") then { _heloDrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
} forEach _airGroups;

// Add to air groups array
if (_groupsType == "Plane" || _groupsType == "Air") then {
    _planesAll append _planes;
    _planesAll append _planeDrones;

    // -------------------------------------------------------------------------------------
    // FIGHTER PLANE 1
    private _group = [];
    // Form fighter plane in format: 1x plane
    _validPlanes = _planesAll;
    if (count _validPlanes > 0) then {
        // Plane
        _group pushBack (selectRandom _validPlanes);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - plane 1: %1", _group] };
        _customPlaneGroups pushBack [_group];
    };

    // -------------------------------------------------------------------------------------
    // FIGHTER PLANE 2
    private _group = [];
    // Form fighter plane in format: 1x plane
    _validPlanes = _planesAll;
    if (count _validPlanes > 0) then {
        // Plane
        _group pushBack (selectRandom _validPlanes);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - plane 2: %1", _group] };
        _customPlaneGroups pushBack [_group];
    };

    // -------------------------------------------------------------------------------------
    // FIGHTER PLANE 3
    private _group = [];
    // Form fighter plane in format: 1x plane
    _validPlanes = _planesAll;
    if (count _validPlanes > 0) then {
        // Plane
        _group pushBack (selectRandom _validPlanes);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - plane 3: %1", _group] };
        _customPlaneGroups pushBack [_group];
    };
};

if (_groupsType == "Helo" || _groupsType == "Air") then {
    _helosAll = [];
    _helosAll append _helos;
    _helosAll append _heloDrones;

    // -------------------------------------------------------------------------------------
    // ATTACK HELO 1
    private _group = [];
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll;
    if (count _validHelos > 0) then {
        // Helo
        _group pushBack ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - helo 1: %1", _group] };
        _customHeloGroups pushBack [_group];
    };

    // -------------------------------------------------------------------------------------
    // ATTACK HELO 2
    private _group = [];
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll;
    if (count _validHelos > 0) then {
        // Helo
        _group pushBack ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - helo 2: %1", _group] };
        _customHeloGroups pushBack [_group];
    };

    // -------------------------------------------------------------------------------------
    // ATTACK HELO 3
    private _group = [];
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll;
    if (count _validHelos > 0) then {
        // Helo
        _group pushBack ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - helo 3: %1", _group] };
        _customHeloGroups pushBack [_group];
    };
};

if (_groupsType == "Transport Helo" || _groupsType == "Air") then {
    _helosAll = [];
    _helosAll append _helos;
    _helosAll append _heloDrones;
    _helosAll append _helos_unarmed;

    // -------------------------------------------------------------------------------------
    // TRANSPORT HELO 1
    // ***** Beware that we will use a 1D array for the transports, so we will just concatename their name classes *****
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll select { (_x select 1) >= 1 };
    if (count _validHelos > 0) then {
        // Helo
        private _helo = ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - transport helo 1: %1", _helo] };
        _customTransportHeloGroups pushBack _helo;
    };

    // -------------------------------------------------------------------------------------
    // TRANSPORT HELO 2
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll select { (_x select 1) >= 1 };
    if (count _validHelos > 0) then {
        // Helo
        private _helo = ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - transport helo 2: %1", _helo] };
        _customTransportHeloGroups pushBack _helo;
    };

    // -------------------------------------------------------------------------------------
    // TRANSPORT HELO 3
    // Form attack helo in format: 1x helo
    _validHelos = _helosAll select { (_x select 1) >= 1 };
    if (count _validHelos > 0) then {
        // Helo
        private _helo = ((selectRandom _validHelos) select 0);

        // Add to air groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomAirGroups - transport helo 3: %1", _helo] };
        _customTransportHeloGroups pushBack _helo;
    };
};


[_customPlaneGroups, _customHeloGroups, _customTransportHeloGroups]