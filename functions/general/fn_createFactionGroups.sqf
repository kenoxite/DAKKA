/*
  Author: kenoxite

  Description:
  Creates custom faction groups


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/
params ["_faction", ["_groupType", "Infantry"]];

private _customGroups = [];

if (_groupType == "Infantry") then {
    private _factionInfantry = [_faction, "Infantry"] call DMORBAT_fnc_categorizeUnits;
    // diag_log format ["_factionInfantry: %1", _factionInfantry];
    private _infGroups = [];
    {
        private _grps = _x select 1;
        {
            _infGroups pushBack _x;
        } forEach _grps;
    } forEach _factionInfantry;

    private _squadLeaders = [];
    private _teamLeaders = [];
    private _riflemen = [];
    private _riflemenAT = [];
    private _riflemenAA = [];
    private _grenadiers = [];
    private _autoriflemen = [];
    private _medics = [];
    private _marksmen = [];
    private _officers = [];
    private _crewmen = [];
    {
        private _assigned = false;
        private _unit = _x select 0;
        // diag_log format ["DMORBAT: createFactionGroups - Checking unit %1", _unit];
        private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
        if (_roles select 0) then { _riflemenAT pushBackUnique _unit; _assigned = true; };
        if (_roles select 1) then { _riflemenAA pushBackUnique _unit; _assigned = true; };
        if (_roles select 2) then { _medics pushBackUnique _unit; _assigned = true; };
        if (_roles select 3) then { _autoriflemen pushBackUnique _unit; _assigned = true; };
        if (_roles select 4) then { _grenadiers pushBackUnique _unit; _assigned = true; };
        if (_roles select 5) then { _marksmen pushBackUnique _unit; _assigned = true; };
        if (_roles select 9 && !(_roles select 10) && !(_roles select 15)) then { _squadLeaders pushBackUnique _unit; _assigned = true; };
        if (_roles select 9 && !(_roles select 10) && !(_roles select 15) && _roles select 4) then { _teamLeaders pushBackUnique _unit; _assigned = true; };
        if (_roles select 10) then { _officers pushBackUnique _unit; _assigned = true; };
        if (_roles select 15) then { _crewmen pushBackUnique _unit; _assigned = true; };
        if (!_assigned && !(_roles select 7) && !(_roles select 8) && !(_roles select 11) && !(_roles select 12) && !(_roles select 13) && !(_roles select 14)) then { _riflemen pushBackUnique _unit; _assigned = true; };
    } forEach _infGroups;

    // If no riflemen, everyone is a rifleman
    if (count _riflemen == 0) then {
        diag_log format ["DMORBAT: createFactionGroups - No riflemen found. Everybody is a rifleman now for faction %1", _faction];
        _riflemen append _squadLeaders; 
        _riflemen append _teamLeaders; 
        _riflemen append _riflemenAT; 
        _riflemen append _riflemenAA; 
        _riflemen append _grenadiers; 
        _riflemen append _autoriflemen; 
        _riflemen append _medics; 
        _riflemen append _marksmen; 
        _riflemen append _officers; 
    };
    diag_log format ["DMORBAT: createFactionGroups - _squadLeaders: %1", _squadLeaders];
    diag_log format ["DMORBAT: createFactionGroups - _teamLeaders: %1", _teamLeaders];
    diag_log format ["DMORBAT: createFactionGroups - _riflemen: %1", _riflemen];
    diag_log format ["DMORBAT: createFactionGroups - _riflemenAT: %1", _riflemenAT];
    diag_log format ["DMORBAT: createFactionGroups - _riflemenAA: %1", _riflemenAA];
    diag_log format ["DMORBAT: createFactionGroups - _grenadiers: %1", _grenadiers];
    diag_log format ["DMORBAT: createFactionGroups - _autoriflemen: %1", _autoriflemen];
    diag_log format ["DMORBAT: createFactionGroups - _medics: %1", _medics];
    diag_log format ["DMORBAT: createFactionGroups - _marksmen: %1", _marksmen];
    diag_log format ["DMORBAT: createFactionGroups - _officers: %1", _officers];
    diag_log format ["DMORBAT: createFactionGroups - _crewmen: %1", _crewmen];

    // SQUAD
    // Form regular squad in vanilla format: squad leader, rifle, AT, marksman, team leader, autorifleman, ammo bearer, medic
    private _group = [];
    // Squad leader
    if (count _squadLeaders > 0) then {
        _group pushBack (selectRandom _squadLeaders);
    } else {
        if (count _teamLeaders > 0) then {
            _group pushBack (selectRandom _teamLeaders);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Rifleman
    _group pushBack (selectRandom _riflemen);
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Marksman
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Autorifleman
    if (count _autoriflemen > 0) then {
        _group pushBack (selectRandom _autoriflemen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman (we won't check for ammo bearers)
    _group pushBack (selectRandom _riflemen);
    // Medic
    if (count _medics > 0) then {
        _group pushBack (selectRandom _medics);
    } else {
        _group pushBack (selectRandom _riflemen);
    };

    // Add to infantry groups array
    // diag_log format ["DMORBAT: createFactionGroups - _group: %1", _group];
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];

    // FIRE TEAM
    // Form fire team in vanilla format: team leader, autorifleman, grenadier, rifleman AT
    private _group = [];
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Autorifleman
    if (count _autoriflemen > 0) then {
        _group pushBack (selectRandom _autoriflemen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Grenadier
    if (count _grenadiers > 0) then {
        _group pushBack (selectRandom _grenadiers);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };

    // Add to infantry groups array
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];

    // SENTRY
    // Form sentry team in vanilla format: grenadier, soldier
    private _group = [];
    // Grenadier
    if (count _grenadiers > 0) then {
        _group pushBack (selectRandom _grenadiers);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman
    _group pushBack (selectRandom _riflemen);

    // Add to infantry groups array
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];

    // PATROL
    // Form patrol team in vanilla format: team leader, marksman, medic, soldier
    private _group = [];
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Marksman
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Medic
    if (count _medics > 0) then {
        _group pushBack (selectRandom _medics);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman
    _group pushBack (selectRandom _riflemen);

    // Add to infantry groups array
    diag_log format ["DMORBAT: createFactionGroups - patrol team: %1", _group];
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];

    // TEAM AT
    // Form team AT in vanilla format: team leader, rifleman AT, rifleman AT, assistant AT
    private _group = [];
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // (we won't check for assistnat AT)

    // Add to infantry groups array
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];

    // TEAM AA
    // Form team AA in vanilla format: team leader, rifleman AA, rifleman AA, assistant AA
    private _group = [];
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Rifleman AA
    if (count _riflemenAA > 0) then {
        _group pushBack (selectRandom _riflemenAA);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman AA
    if (count _riflemenAA > 0) then {
        _group pushBack (selectRandom _riflemenAA);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // (we won't check for assistnat AA)

    // Add to infantry groups array
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];
};

_customGroups