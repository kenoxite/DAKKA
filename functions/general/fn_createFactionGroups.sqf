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

// Functions
_fnc_createInfGroup = {
    params ["_groupsType"];
    diag_log format ["DMORBAT: createFactionGroups - _groupsType: %1", _groupsType];
    private _isRegular = if !(_groupsType == "SF") then { true } else { false };

    private _squadLeaders = [];
    private _squadLeaders_SF = [];
    private _teamLeaders = [];
    private _teamLeaders_SF = [];
    private _riflemen = [];
    private _riflemen_SF = [];
    private _riflemenAT = [];
    private _riflemenAT_SF = [];
    private _riflemenAA = [];
    private _riflemenAA_SF = [];
    private _grenadiers = [];
    private _grenadiers_SF = [];
    private _autoriflemen = [];
    private _autoriflemen_SF = [];
    private _medics = [];
    private _medics_SF = [];
    private _marksmen = [];
    private _marksmen_SF = [];
    private _officers = [];
    private _officers_SF = [];
    private _crewmen = [];
    private _crewmen_SF = [];
    private _snipers = [];
    private _snipers_SF = [];
    private _spotters = [];
    private _spotters_SF = [];
    private _JTACs = [];
    private _JTACs_SF = [];
    private _explosiveSpecialists = [];
    private _explosiveSpecialists_SF = [];
    {
        private _assigned = false;
        private _unit = _x select 0;
        // private _unit = toLowerANSI (_x select 0);
        // diag_log format ["DMORBAT: createFactionGroups - Checking unit %1", _unit];
        // [_hasAT, _hasAA, _hasMedic, _hasMG, _hasGrenadier, _hasMarksman, _hasUnarmed, _hasEngi, _hasDemo, _hasLeader, _hasOfficer, _hasHacker, _hasDiver, _hasSF, _hasSniper, _hasCrew, _hasAssistant, _hasRadio, _hasDriver, _hasPilot, _hasJTAC, _hasSpotter]
        private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
        if (!_assigned && _roles select 0) then { if !(_roles select 13) then { _riflemenAT pushBackUnique _unit } else { _riflemenAT_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 1) then { if !(_roles select 13) then { _riflemenAA pushBackUnique _unit } else { _riflemenAA_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 2) then { if !(_roles select 13) then { _medics pushBackUnique _unit } else { _medics_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 3) then { if !(_roles select 13) then { _autoriflemen pushBackUnique _unit } else { _autoriflemen_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 5) then { if !(_roles select 13) then { _marksmen pushBackUnique _unit } else { _marksmen_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 9 && !(_roles select 10) && !(_roles select 15) && (_roles select 4)) then { if !(_roles select 13) then { _teamLeaders pushBackUnique _unit } else { _teamLeaders_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 9 && !(_roles select 10) && !(_roles select 15)) then { if !(_roles select 13) then { _squadLeaders pushBackUnique _unit } else { _squadLeaders_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 4) then { if !(_roles select 13) then { _grenadiers pushBackUnique _unit } else { _grenadiers_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 10) then { if !(_roles select 13) then { _officers pushBackUnique _unit } else { _officers_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 15) then { if !(_roles select 13) then { _crewmen pushBackUnique _unit } else { _crewmen_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 14) then { if !(_roles select 13) then { _snipers pushBackUnique _unit } else { _snipers_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 21) then { if !(_roles select 13) then { _spotters pushBackUnique _unit } else { _spotters_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 20) then { if !(_roles select 13) then { _JTACs pushBackUnique _unit } else { _JTACs_SF pushBackUnique _unit }; _assigned = true; };
        if (!_assigned && _roles select 8) then { if !(_roles select 13) then { _explosiveSpecialists pushBackUnique _unit } else { _explosiveSpecialists_SF pushBackUnique _unit }; _assigned = true; };
        // Regular infantry
        if (!_assigned && !(_roles select 6) && !(_roles select 7) && !(_roles select 11) && !(_roles select 12) && !(_roles select 16) && !(_roles select 17) && !(_roles select 18) && !(_roles select 19) && !("angelina" in _unit)) then { if !(_roles select 13) then { _riflemen pushBackUnique _unit } else { _riflemen_SF pushBackUnique _unit }; _assigned = true; };
    } forEach _infGroups;

    if !(_isRegular) then {
        _squadLeaders =+ _squadLeaders_SF;
        _teamLeaders =+ _teamLeaders_SF;
        _riflemen =+ _riflemen_SF;
        _riflemenAT =+ _riflemenAT_SF;
        _riflemenAA =+ _riflemenAA_SF;
        _grenadiers =+ _grenadiers_SF;
        _autoriflemen =+ _autoriflemen_SF;
        _medics =+ _medics_SF;
        _marksmen =+ _marksmen_SF;
        _officers=+ _officers_SF;
        _snipers =+ _snipers_SF;
        _spotters =+ _spotters_SF;
        _JTACs =+ _JTACs_SF;
        _explosiveSpecialists =+ _explosiveSpecialists_SF;
        _crewmen =+ _crewmen_SF;
    };

    // If there's no riflemen, everyone is a rifleman
    if (count _riflemen == 0) then {
        diag_log format ["DMORBAT: createFactionGroups - No riflemen found. Everybody is now a rifleman for faction %1", _faction];
        _riflemen append _squadLeaders; 
        _riflemen append _teamLeaders; 
        _riflemen append _riflemenAT; 
        _riflemen append _riflemenAA; 
        _riflemen append _grenadiers; 
        _riflemen append _autoriflemen; 
        _riflemen append _medics; 
        _riflemen append _marksmen; 
        _riflemen append _officers; 
        _riflemen append _snipers;
        _spotters append _spotters;
        _riflemen append _JTACs;
        _riflemen append _explosiveSpecialists;
    };

    // Pick the editor subcategory all units will belong to
    private _editorSubCat = getText (configFile >> "CfgVehicles" >> (selectRandom _riflemen) >> "editorSubcategory");

    if (isNil "_editorSubCat") exitWith { false };

    private _fnc_trimUnits = {
        params ["_arr", "_editorSubCat"];
        if (count _arr == 0) exitWith { [] };
        
        private _excludedUnits = [
            "cwr3_b_soldier_at_carlgustaf",
            "cwr3_b_soldier_aat_carlgustaf",
            "cwr3_b_soldier_hg",
            "cwr3_b_soldier_g36",
            "cwr3_b_soldier_steyr",
            "cwr3_b_soldier_xms",
            "cwr3_b_soldier_m14",
            "cwr3_b_soldier_backpack",
            "cwr3_b_soldier_light",
            "cwr3_o_soldier_at4",
            "cwr3_o_soldier_aat4",
            "cwr3_o_soldier_hg",
            "cwr3_o_soldier_backpack",
            "cwr3_o_soldier_light"
            ];
        private _excludedSubCats = [
            "CUP_EdSubcat_Personel_Chedaki_ArmedCiv"
            ];
        _arr select { 
            private _thisESubCat = getText (configFile >> "CfgVehicles" >> _x >> "editorSubcategory");
            (_thisESubCat == _editorSubCat && !(_thisESubCat in _excludedSubCats) && !(_x in _excludedUnits))
        }
    };
    _squadLeaders = [_squadLeaders, _editorSubCat] call _fnc_trimUnits;
    _teamLeaders = [_teamLeaders, _editorSubCat] call _fnc_trimUnits;
    _riflemen = [_riflemen, _editorSubCat] call _fnc_trimUnits;
    _riflemenAT = [_riflemenAT, _editorSubCat] call _fnc_trimUnits;
    _riflemenAA = [_riflemenAA, _editorSubCat] call _fnc_trimUnits;
    _grenadiers = [_grenadiers, _editorSubCat] call _fnc_trimUnits;
    _autoriflemen = [_autoriflemen, _editorSubCat] call _fnc_trimUnits;
    _medics = [_medics, _editorSubCat] call _fnc_trimUnits;
    _marksmen = [_marksmen, _editorSubCat] call _fnc_trimUnits;
    _officers = [_officers, _editorSubCat] call _fnc_trimUnits;
    _snipers = [_snipers, _editorSubCat] call _fnc_trimUnits;
    _spotters = [_spotters, _editorSubCat] call _fnc_trimUnits;
    _JTACs = [_JTACs, _editorSubCat] call _fnc_trimUnits;
    _explosiveSpecialists = [_explosiveSpecialists, _editorSubCat] call _fnc_trimUnits;
    _crewmen = [_crewmen, _editorSubCat] call _fnc_trimUnits;

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
    diag_log format ["DMORBAT: createFactionGroups - _snipers: %1", _snipers];
    diag_log format ["DMORBAT: createFactionGroups - _spotters: %1", _spotters];
    diag_log format ["DMORBAT: createFactionGroups - _JTACs: %1", _JTACs];
    diag_log format ["DMORBAT: createFactionGroups - _explosiveSpecialists: %1", _explosiveSpecialists];

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
            if (count _grenadiers > 0) then {
                _group pushBack (selectRandom _grenadiers);
            } else {
                _group pushBack (selectRandom _riflemen);
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
    diag_log format ["DMORBAT: createFactionGroups - %2 squad: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
                _group pushBack (selectRandom _riflemen);
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
    diag_log format ["DMORBAT: createFactionGroups - %2 fire team: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
    diag_log format ["DMORBAT: createFactionGroups - %2 sentry: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
    diag_log format ["DMORBAT: createFactionGroups - %2 patrol team: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
    // Rifleman
    _group pushBack (selectRandom _riflemen);

    // Add to infantry groups array
    diag_log format ["DMORBAT: createFactionGroups - %2 team AT: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
    diag_log format ["DMORBAT: createFactionGroups - %2 team AA: %1", _group, if (_isRegular) then { "" } else { "SF" }];
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
    diag_log format ["DMORBAT: createFactionGroups - %2 sniper team: %1", _group, if (_isRegular) then { "" } else { "SF" }];
    private _roles = [_group] call DMORBAT_fnc_groupRoles;
    _customGroups pushBack [_group, _roles];
};

// INFANTRY GROUPS
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

    // Regular infantry
    "regular" call _fnc_createInfGroup;
};

// SPECIAL FORCES GROUPS
if (_groupType == "SF") then {
    private _factionInfantry = [_faction, "Infantry"] call DMORBAT_fnc_categorizeUnits;
    // diag_log format ["_factionInfantry: %1", _factionInfantry];
    private _infGroups = [];
    {
        private _grps = _x select 1;
        {
            _infGroups pushBack _x;
        } forEach _grps;
    } forEach _factionInfantry;
    
    // Special Forces
    "SF" call _fnc_createInfGroup;
};

_customGroups