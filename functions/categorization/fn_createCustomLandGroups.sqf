/*
  Author: kenoxite

  Description:
  Creates custom faction groups


  Parameter (s):
  _groupsType: "Motorized", "Mechanized", "Armor", "Land"

  Returns:


  Examples:

*/

params [["_groupsType", []], ["_faction", ""]];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - _groupsType: %1", _groupsType] };

if (count _groupsType == 0) exitWith { [] };

// Check faction for suitable land units
private _factionLand = [_faction, "Land"] call DMORBAT_fnc_categorizeUnits;
private _landGroups = [];
{
    private _grps = _x select 1;
    {
        _landGroups pushBack _x;
    } forEach _grps;
} forEach _factionLand;

// If faction comes in several versions (Woodland, Arid, etc) check this exception list and try to use the vehicles from the main faction
private _usingParentFaction = [
    ["BLU_W_F", "BLU_F"]
];
private _parentFactionIndex = [_usingParentFaction, _faction] call DMORBAT_fnc_findFirstNested;
if (_parentFactionIndex >= 0) then {
    private _parentFaction = (_usingParentFaction select _parentFactionIndex) select 1;
    private _factionLand = [_parentFaction, "Land"] call DMORBAT_fnc_categorizeUnits;
    {
        private _grps = _x select 1;
        {
            _landGroups pushBack _x;
        } forEach _grps;
    } forEach _factionLand;
};

// if (count _landGroups == 0) exitWith { [] };

// Categorize infantry
// [_squadLeaders, _teamLeaders, _riflemen, _riflemenAT, _riflemenHAT, _riflemenAA, _grenadiers, _autoriflemen, _medics, _marksmen, _officers, _drivers, _crewmen, _snipers, _spotters, _JTACs, _engineers, _explosiveSpecialists, _heavyGunners, _pilots]
private _catInf = [];
if (isNil (call compile format ["'DMORBAT_%1_%2'", "Infantry", _faction])) then {
// Check faction for suitable infantry units
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
    missionNamespace setVariable [format ["DMORBAT_%1_%2", "Infantry", _faction], _catInf];
} else {
    _catInf = call compile format ["DMORBAT_%1_%2", "Infantry", _faction];
};

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

// Categorize all the land vehicles
private _cars = [];
private _cars_unarmed = [];
private _trucks = [];
private _trucks_unarmed = [];
private _cars = [];
private _carDrones = [];
private _truckDrones = [];

private _wheeledAPCs = [];
private _trackedAPCs = [];
private _wheeledAPCdrones = [];
private _trackedAPCdrones = [];

private _tanks = [];
private _tankDrones = [];

private _carsAll = [];
private _validCars = [];
private _trucksAll = [];
private _validTrucks = [];
private _APCsAll = [];
private _validAPCs = [];
private _tanksAll = [];
private _validTanks = [];

private _customMotoGroups = [];
private _customMechGroups = [];
private _customArmorGroups = [];

{
    private _unitClass = _x select 0;
    private _type = [_unitClass, true] call DMORBAT_fnc_vehicleType;

    if (_type == "Car") then { _cars pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Car (unarmed)") then { _cars_unarmed pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Truck") then { _trucks pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Truck (unarmed)") then { _trucks_unarmed pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Car") then { _carDrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Truck") then { _truckDrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };

    if (_type == "Wheeled APC") then { _wheeledAPCs pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Tracked APC") then { _trackedAPCs pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Wheeled APC") then { _wheeledAPCdrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Tracked APC") then { _trackedAPCdrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats];  };

    if (_type == "Tank") then { _tanks pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
    if (_type == "Drone Tank") then { _tankDrones pushBack [_unitClass, [_unitClass] call DMORBAT_fnc_countPassengerSeats]; };
} forEach _landGroups;

// Add to land groups array
if (_groupsType == "Motorized" || _groupsType == "Land") then {
    if (count _cars == 0 && count _cars_unarmed == 0) then { _cars_unarmed = [["C_Offroad_01_F", ["C_Offroad_01_F"] call DMORBAT_fnc_countPassengerSeats]] };
    if (count _trucks == 0 && count _trucks_unarmed == 0) then { _trucks_unarmed = [["C_Van_01_transport_F", ["C_Van_01_transport_F"] call DMORBAT_fnc_countPassengerSeats]] };
    _carsAll append _cars;
    _carsAll append _cars_unarmed;
    _carsAll append _carDrones;
    _trucksAll append _trucks;
    _trucksAll append _trucks_unarmed;
    _trucksAll append _truckDrones;

    // -------------------------------------------------------------------------------------
    // MOTORIZED AIR-DEFENSE TEAM
    private _group = [];
    // Form motorized AA team in vanilla format: unarmed car, AA gunner, AA gunner, assistant AA
    _validCars = _carsAll select { (_x select 1) >= 3 };
    if (count _validCars > 0) then {
        // Car
        _group pushBack ((selectRandom _validCars) select 0);

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

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized AA team: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MOTORIZED ANTI-ARMOR TEAM
    private _group = [];
    // Form motorized AT team in vanilla format: unarmed car, AT gunner, AT gunner, assistant AT
    _validCars = _carsAll select { (_x select 1) >= 3 };
    if (count _validCars > 0) then {
        // Car
        _group pushBack ((selectRandom _validCars) select 0);

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
        // (we won't check for assistnat AA)
        // Rifleman
        _group pushBack (selectRandom _riflemen);

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized AT team: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MOTORIZED PATROL
    private _group = [];
    // Form motorized patrol: car, grenadier
    _validCars = _cars select { (_x select 1) >= 1 };
    if (count _validCars == 0) then {
        _validCars = _cars_unarmed select { (_x select 1) >= 1 };
    };
    if (count _validCars > 0) then {
        // Car
        _group pushBack ((selectRandom _validCars) select 0);

        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
        };

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized patrol: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MOTORIZED TEAM
    private _group = [];
    // Form motorized team in vanilla format: car, autorifleman, rifleman AT
    _validCars = _cars select { (_x select 1) >= 2 };
    if (count _validCars == 0) then {
        _validCars = _cars_unarmed select { (_x select 1) >= 2 };
    };
    if (count _validCars > 0) then {
        // Car
        _group pushBack ((selectRandom _validCars) select 0);

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
        // Rifleman AT
        if (count _riflemenAT > 0) then {
            _group pushBack (selectRandom _riflemenAT);
        } else {
            _group pushBack (selectRandom _riflemen);
        };

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized team: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MOTORIZED REINFORCEMENTS (10 men)
    private _group = [];
    // Form motorized reinforcements in format: truck, 2 x squad
    _validTrucks = _trucksAll select { (_x select 1) >= 10 };
    if (count _validTrucks > 0) then {
        // Truck
        _group pushBack ((selectRandom _validTrucks) select 0);

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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized reinforcements: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MOTORIZED REINFORCEMENTS (12 men)
    private _group = [];
    // Form motorized reinforcements in vanilla format: truck, 2 x squad
    _validTrucks = _trucksAll select { (_x select 1) >= 12 };
    if (count _validTrucks > 0) then {
        // Truck
        _group pushBack ((selectRandom _validTrucks) select 0);

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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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
        // Marksman
        if (count _marksmen > 0) then {
            _group pushBack (selectRandom _marksmen);
        } else {
            _group pushBack (selectRandom _riflemen);
        };

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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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
        // Medic
        if (count _medics > 0) then {
            _group pushBack (selectRandom _medics);
        } else {
            _group pushBack (selectRandom _riflemen);
        };

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - motorized reinforcements: %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMotoGroups pushBack [_group, _roles];
    };
};

if (_groupsType == "Mechanized" || _groupsType == "Land") then {
    _APCsAll append _wheeledAPCs;
    _APCsAll append _trackedAPCs;
    _APCsAll append _wheeledAPCdrones;
    _APCsAll append _trackedAPCdrones;

    // -------------------------------------------------------------------------------------
    // MECHANIZED RIFLE SQUAD (6 men)
    private _group = [];
    // Form mechanized rifle squad in format: APC/IFV, 1x squad
    _validAPCs = _APCsAll select { (_x select 1) >= 6 };
    if (count _validAPCs > 0) then {
        // APC
        _group pushBack ((selectRandom _validAPCs) select 0);
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
        // Heavy Gunner
        if (count _heavyGunners > 0) then {
            _group pushBack (selectRandom _heavyGunners);
        } else {
            if (count _autoriflemen > 0) then {
                _group pushBack (selectRandom _autoriflemen);
            } else {
                _group pushBack (selectRandom _riflemen);
            };
        };

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - mechanized rifle squad (6): %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMechGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MECHANIZED RIFLE SQUAD (8 men)
    private _group = [];
    // Form mechanized rifle squad in vanilla format: APC/IFV, 1x squad
    _validAPCs = _APCsAll select { (_x select 1) >= 8 };
    if (count _validAPCs > 0) then {
        // APC
        _group pushBack ((selectRandom _validAPCs) select 0);
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

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - mechanized rifle squad (8): %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMechGroups pushBack [_group, _roles];
    };

    // -------------------------------------------------------------------------------------
    // MECHANIZED RIFLE SQUAD (9 men)
    private _group = [];
    // Form mechanized rifle squad in Stryker Team format: APC/IFV, 1x squad
    _validAPCs = _APCsAll select { (_x select 1) >= 9 };
    if (count _validAPCs > 0) then {
        // APC
        _group pushBack ((selectRandom _validAPCs) select 0);
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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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
        // Rifleman AT
        if (count _riflemenAT > 0) then {
            _group pushBack (selectRandom _riflemenAT);
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
        // Grenadier
        if (count _grenadiers > 0) then {
            _group pushBack (selectRandom _grenadiers);
        } else {
            _group pushBack (selectRandom _riflemen);
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
        // Marksman
        if (count _marksmen > 0) then {
            _group pushBack (selectRandom _marksmen);
        } else {
            _group pushBack (selectRandom _riflemen);
        };

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - mechanized rifle squad (9): %1", _group] };
        private _roles = [_group] call DMORBAT_fnc_groupRoles;
        _customMechGroups pushBack [_group, _roles];
    };
};

if (_groupsType == "Armor" || _groupsType == "Land") then {
    _tanksAll append _tanks;
    _tanksAll append _tankDrones;

    // -------------------------------------------------------------------------------------
    // TANK PLATOON
    private _group = [];
    // Form tank platoon in format: 4x tank
    _validTanks = _tanksAll;
    if (count _validTanks > 0) then {
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - tank platoon: %1", _group] };
        _customArmorGroups pushBack [_group];
    };

    // -------------------------------------------------------------------------------------
    // TANK SECTION
    private _group = [];
    // Form tank platoon in format: 2x tank
    _validTanks = _tanksAll;
    if (count _validTanks > 0) then {
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);
        // Tank
        _group pushBack ((selectRandom _validTanks) select 0);

        // Add to land groups array
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: createCustomLandGroups - tank section: %1", _group] };
        _customArmorGroups pushBack [_group];
    };
};


[_customMotoGroups, _customMechGroups, _customArmorGroups]