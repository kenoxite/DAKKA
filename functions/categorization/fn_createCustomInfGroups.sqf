/*
  Author: kenoxite

  Description:
  Creates custom faction groups


  Parameter (s):
  _this select 0: 

  Returns:


  Examples:

*/

params [["_groupsType", []], ["_faction", ""]];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - _groupsType: %1", _groupsType] };

if (count _groupsType == 0) exitWith { [] };

private _customGroups = [];
private _isRegular = if !(_groupsType == "SF") then { true } else { false };

// [_squadLeaders, _teamLeaders, _riflemen, _riflemenAT, _riflemenHAT, _riflemenAA, _grenadiers, _autoriflemen, _medics, _marksmen, _officers, _drivers, _crewmen, _snipers, _spotters, _JTACs, _engineers, _explosiveSpecialists, _heavyGunners, _pilots]
private _catInf = [];
if (isNil (call compile format ["'DMORBAT_%1_%2'", _groupsType, _faction])) then {
    private _factionInfantry = [_faction, "Infantry"] call DMORBAT_fnc_categorizeUnits;
    private _infGroups = [];
    {
        private _grps = _x select 1;
        {
            _infGroups pushBack _x;
        } forEach _grps;
    } forEach _factionInfantry;

    if (count _infGroups == 0) exitWith { [] };

    _catInf = [_infGroups, _isRegular] call DMORBAT_fnc_categorizeInf;
    missionNamespace setVariable [format ["DMORBAT_%1_%2", _groupsType, _faction], _catInf];
} else {
    _catInf = call compile format ["DMORBAT_%1_%2", _groupsType, _faction];
};

if (count _catInf == 0) exitWith { [] };

private _squadLeaders = _catInf select 0;
private _teamLeaders = _catInf select 1;
private _riflemen = _catInf select 2;
private _riflemenAT = _catInf select 3;
private _riflemenHAT = _catInf select 4;
private _riflemenAA = _catInf select 5;
private _grenadiers = _catInf select 6;
private _autoriflemen = _catInf select 7;
private _medics = _catInf select 8;
private _marksmen = _catInf select 9;
private _officers = _catInf select 10;
private _drivers = _catInf select 11;
private _crewmen = _catInf select 12;
private _snipers = _catInf select 13;
private _spotters = _catInf select 14;
private _JTACs = _catInf select 15;
private _engineers = _catInf select 16;
private _explosiveSpecialists = _catInf select 17;
private _heavyGunners = _catInf select 18;
private _pilots = _catInf select 19;

// -------------------------------------------------------------------------------------
// SQUAD
private _group = [];
if (_isRegular) then {
    // Form regular squad in vanilla format: squad leader, rifle, AT, marksman, team leader, autorifleman, ammo bearer, medic
    // Squad leader
    if (count _squadLeaders > 0) then {
        _group pushBack (selectRandom _squadLeaders);
    } else {
        if (count _teamLeaders > 0) then {
            _group pushBack (selectRandom _teamLeaders);
        } else {
            if (count _officers > 0) then {
                _group pushBack (selectRandom _officers);
            } else {
                _group pushBack (selectRandom _riflemen);
            };
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
        if (count _heavyGunners > 0) then {
            _group pushBack (selectRandom _heavyGunners);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Grenadier (we won't check for ammo bearers)
    if (count _grenadiers > 0) then {
        _group pushBack (selectRandom _grenadiers);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Medic
    if (count _medics > 0) then {
        _group pushBack (selectRandom _medics);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
} else {
    // Form SF squad in vanilla format: team leader, marksman, medic, rifle, AT, JTAC, demo, sharpshooter
    // Team leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _squadLeaders > 0) then {
            _group pushBack (selectRandom _squadLeaders);
        } else {
            if (count _grenadiers > 0) then {
                _group pushBack (selectRandom _grenadiers);
            } else {
                if (count _officers > 0) then {
                    _group pushBack (selectRandom _officers);
                } else {
                    _group pushBack (selectRandom _riflemen);
                };
            };
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
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // JTAC
    if (count _JTACs > 0) then {
        _group pushBack (selectRandom _JTACs);
    } else {
        if (count _autoriflemen > 0) then {
            _group pushBack (selectRandom _autoriflemen);
        } else {
            if (count _grenadiers > 0) then {
                _group pushBack (selectRandom _grenadiers);
            } else {
                _group pushBack (selectRandom _riflemen);
            };
        };
    };
    // Demo Specialist
    if (count _explosiveSpecialists > 0) then {
        _group pushBack (selectRandom _explosiveSpecialists);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Marksman
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
};

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 squad: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// FIRE TEAM
private _group = [];
if (_isRegular) then {
    // Form fire team in vanilla format: team leader, autorifleman, grenadier, rifleman AT
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
        if (count _heavyGunners > 0) then {
            _group pushBack (selectRandom _heavyGunners);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
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
} else {
    // Form SF team in vanilla format: team leader, marksman, medic, AT, JTAC, demo
    // Team Leader
    if (count _teamLeaders > 0) then {
        _group pushBack (selectRandom _teamLeaders);
    } else {
        if (count _squadLeaders > 0) then {
            _group pushBack (selectRandom _squadLeaders);
        } else {
            if (count _grenadiers > 0) then {
                _group pushBack (selectRandom _grenadiers);
            } else {
                _group pushBack (selectRandom _riflemen);
            };
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
    // Rifleman AT
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // JTAC
    if (count _JTACs > 0) then {
        _group pushBack (selectRandom _JTACs);
    } else {
        if (count _autoriflemen > 0) then {
            _group pushBack (selectRandom _autoriflemen);
        } else {
            if (count _heavyGunners > 0) then {
                _group pushBack (selectRandom _heavyGunners);
            } else {
                _group pushBack (selectRandom _riflemen);
            };
        };
    };
    // Demo Specialist
    if (count _explosiveSpecialists > 0) then {
        _group pushBack (selectRandom _explosiveSpecialists);
    } else {
        _group pushBack (selectRandom _riflemen);
    };

};

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 fire team: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// SENTRY
private _group = [];
if (_isRegular) then {
    // Form sentry team in vanilla format: grenadier, rifle
    // Grenadier
    if (count _grenadiers > 0) then {
        _group pushBack (selectRandom _grenadiers);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
    // Rifleman
    _group pushBack (selectRandom _riflemen);
} else {
    // Form SF sentry team in vanilla format: marksman, rifle
    // Marksman
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
    // Rifleman
    _group pushBack (selectRandom _riflemen);
};

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 sentry: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// PATROL
private _group = [];
// Form patrol team in vanilla format: team leader, marksman, medic, rifle
// Team Leader
if (count _teamLeaders > 0) then {
    _group pushBack (selectRandom _teamLeaders);
} else {
    if (count _squadLeaders > 0) then {
        _group pushBack (selectRandom _squadLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
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
if (DMORBAT_debug) then {  format ["DMORBAT: createCustomInfGroups - %2 patrol team: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// TEAM AT
private _group = [];
// Form team AT in vanilla format: team leader, rifleman AT, rifleman AT, assistant AT
// Team Leader
if (count _teamLeaders > 0) then {
    _group pushBack (selectRandom _teamLeaders);
} else {
    if (count _squadLeaders > 0) then {
        _group pushBack (selectRandom _squadLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
    };
};
// Rifleman HAT
if (count _riflemenHAT > 0) then {
    _group pushBack (selectRandom _riflemenHAT);
} else {
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
};
// Rifleman HAT
if (count _riflemenHAT > 0) then {
    _group pushBack (selectRandom _riflemenHAT);
} else {
    if (count _riflemenAT > 0) then {
        _group pushBack (selectRandom _riflemenAT);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
};
// (we won't check for assistnat AT)
// Rifleman
_group pushBack (selectRandom _riflemen);

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 team AT: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// TEAM AA
private _group = [];
// Form team AA in vanilla format: team leader, rifleman AA, rifleman AA, assistant AA
// Team Leader
if (count _teamLeaders > 0) then {
    _group pushBack (selectRandom _teamLeaders);
} else {
    if (count _squadLeaders > 0) then {
        _group pushBack (selectRandom _squadLeaders);
    } else {
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };
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
// Rifleman
_group pushBack (selectRandom _riflemen);

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 team AA: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

// -------------------------------------------------------------------------------------
// SNIPER TEAM
private _group = [];
// Form sniper team in vanilla format: sniper, spotter
// Team Leader
if (count _snipers > 0) then {
    _group pushBack (selectRandom _snipers);
} else {
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
};
// Spotter
if (count _spotters > 0) then {
    _group pushBack (selectRandom _spotters);
} else {
    if (count _marksmen > 0) then {
        _group pushBack (selectRandom _marksmen);
    } else {
        _group pushBack (selectRandom _riflemen);
    };
};

// Add to infantry groups array
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomInfGroups - %2 sniper team: %1", _group, if (_isRegular) then { "" } else { "SF" }] };
private _roles = [_group] call DMORBAT_fnc_groupRoles;
_customGroups pushBack [_group, _roles];

_customGroups