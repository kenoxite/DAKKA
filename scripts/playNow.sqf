// PLAY NOW

#include "..\control_defines.hpp";

[] spawn DMORBAT_fnc_cameraIntro;
cutText ["", "BLACK IN", 999];
enableRadio false;

// Start loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

// Flag this process as automated
DMORBAT_automated = true;

// Reset tasks data to default
DMORBAT_TaskData =+ DMORBAT_TaskData_default;

// Retrieve data for this task
_task = DMORBAT_Task;
_taskData = DMORBAT_TaskData select (_task - 1);

// FRIENDLY GROUPS
_txt = "Categorizing groups for the player faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
_playerFaction = DMORBAT_PlayerFactions select (_task - 1);
diag_log format ["DMORBAT: _playerFaction: %1", _playerFaction];
_factionGroups = [_playerFaction] call DMORBAT_fnc_categorizeGroups;
// _categorizeGroups = [_infGroups, _SFGroups, _sniperGroups, _motGroups, _mechGroups, _artilleryGroups, _armorGroups, _airGroups, _waterGroups]
_infGroups = _factionGroups select 0;
_SFGroups = _factionGroups select 1;
_sniperGroups = _factionGroups select 2;
_motGroups = _factionGroups select 3;
_mechGroups = _factionGroups select 4;
_artilleryGroups = _factionGroups select 5;
_armorGroups = _factionGroups select 6;
_airGroups = _factionGroups select 7;
_waterGroups = _factionGroups select 8;

_txt = "Assigning player group...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];

// Form custom infantry groups if faction doesn't have any defined
// if (count _infGroups == 0) then {
//     diag_log format ["DMORBAT: No infantry groups found for player faction %1. Creating custom ones...", _playerFaction];
//     _infGroups = [_playerFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
// };
// Always create custom faction groups. Most mods either don't bother, know or want to create proper groups anyway so even if they have them they probably will be useless or lacking
diag_log format ["DMORBAT: Creating custom groups for faction %1...", _playerFaction];
_infGroupsCustom = [_playerFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
// _infGroups append _infGroupsCustom;
_infGroups =+ _infGroupsCustom;
_SFGroupsCustom = [_playerFaction, "SF"] call DMORBAT_fnc_createFactionGroups;
_SFGroups append _SFGroupsCustom;
// _SFGroups =+ _SFGroupsCustom;

// PLAYER GROUP
_playerGroup = [];
_eligiblePlayerGroups = [];
if (_task == 1) then {
    if (count _SFGroups > 0) then {
        // Select SF group
        // Pick a group with 6 or more members
        _eligiblePlayerGroups = _SFGroups select { (count (_x select 0)) >= 6 };
        if (count _eligiblePlayerGroups > 0) then {
            _playerGroup = selectRandom _eligiblePlayerGroups;
        } else {
            // Otherwise pick one randomly
            _playerGroup = selectRandom _SFGroups;
        };
    } else {
        // Select regular infantry if not SF group
        if (count _infGroups > 0) then {
            // Pick a group with 6 or more members
            _eligiblePlayerGroups = _infGroups select { (count (_x select 0)) >= 6 };
            if (count _eligiblePlayerGroups > 0) then {
                _playerGroup = selectRandom _eligiblePlayerGroups;
            } else {
                // Otherwise pick one randomly
                _playerGroup = selectRandom _infGroups;
            };
        };
    };
};

if (_task == 2) then {
    // Pick a group with 6 or more members
    _eligiblePlayerGroups = _infGroups select { (count (_x select 0)) >= 8 };
    if (count _eligiblePlayerGroups > 0) then {
        _playerGroup = selectRandom _eligiblePlayerGroups;
    } else {
        // Otherwise pick one randomly
        _playerGroup = selectRandom _infGroups;
    };
};

// No suitable player group found
if (count _eligiblePlayerGroups == 0) then {
    diag_log format ["DMORBAT: No suitable player group found in faction %1!", _playerFaction];
};
// Create proper group array
// [[<group name>, [[<unit1 class>, <unit1 rank>, <unit1 loadout>, <unit1 presence>, <unit1 skill>], [<unit2 class>, ...], ...], [<group mod dependencies>]]]
_playerGroupData = ["Custom Player Group", [], []];
{
    (_playerGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
} forEach (_playerGroup select 0);
// Add to tasks array
[_taskData, "Player group", [_playerGroupData]] call BIS_fnc_addToPairs;

// Assign random unit as playable
_playableUnit = floor (random ((count (_playerGroup select 0)) - 1));
_playerData = [_playableUnit, 0, []];
[_taskData, "Player data", _playerData] call BIS_fnc_setToPairs;

diag_log format ["DMORBAT: player group leader: %1, editor subcat: %2", ((_playerGroup select 0) select 0), getText (configFile >> "CfgVehicles" >> ((_playerGroup select 0) select 0) >> "editorSubcategory")];

// FUNCTIONS
_fnc_addGroupsToTaskData = {
    params ["_dataType1", "_dataType2", "_groupsPool", ["_groupsAmount", 1], ["_unitsAmount", 0], ["_variablePresence", false], ["_presenceThreshold", 3], ["_skill", 0]];
    // diag_log format ["_dataType1: %1 _dataType2: %2 _groupsPool: %3", _dataType1, _dataType2, _groupsPool];
    private _task = DMORBAT_Task;
    private _taskData = DMORBAT_TaskData select (_task - 1);

    private _groupsDataIndex = [_taskData, _dataType1] call BIS_fnc_findInPairs;
    private _groupsData = (_taskData select _groupsDataIndex) select 1;
    private _selectedGroup = [];
    private _presenceChance = 1;
    for [{private _i = 0}, {_i < _groupsAmount}, {_i = _i + 1}] do 
    {
        if (_dataType1 == "Friendly groups" && _dataType2 == "Infantry") then {
        // Pick only friendly teams of the same editor category as the player team
            _groupsPool = _groupsPool select {
                _thisESubCat = getText (configFile >> "CfgVehicles" >> ((_x select 0) select 0) >> "editorSubcategory");
                _playerESubCat = getText (configFile >> "CfgVehicles" >> ((_playerGroup select 0) select 0) >> "editorSubcategory");
                _thisESubCat == _playerESubCat
            };
        };
        _selectedGroup = selectRandom _groupsPool;
        private _thisGroupData = [format ["%1 Group %2", _dataType2, _i + 1], [], []];
        {
            if (_unitsAmount > 0 && _forEachIndex == _unitsAmount) exitWith { true };
            if (_variablePresence && {_forEachIndex > _presenceThreshold}) then { _presenceChance = (_presenceChance - 0.25) max 0.25 };
            (_thisGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], _presenceChance, _skill];
        } forEach (_selectedGroup select 0);
        // Add to tasks array
        [_groupsData, _dataType2, [_thisGroupData]] call BIS_fnc_addToPairs;
        if (_variablePresence) then { _presenceChance = (1 - (0.1 * _i)) max 0.25 };
    };

    true
};


// SUPPORT
_txt = "Generating support options...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
// Artillery
_selectedArtyGroup = [];
if (count _artilleryGroups > 0) then {
    // If there's artillery groups select one randomly
    _selectedArtyGroup = selectRandom (_artilleryGroups select 0);
} else {
    // Check faction units for suitable artillery
    _factionArtillery = [_playerFaction, "Artillery"] call DMORBAT_fnc_categorizeUnits;
    private _artilleryGroups = [];
    {
        private _grps = _x select 1;
        {
            _artilleryGroups pushBack _x;
        } forEach _grps;
    } forEach _factionArtillery;
    if (count _artilleryGroups > 0) then {
        // Pick one type randomly
        _selectedArtyUnit = (selectRandom _artilleryGroups) select 0;
        // Create a new arty group
        for [{private _i = 0}, {_i < 3}, {_i = _i + 1}] do 
        {
            _selectedArtyGroup pushBack _selectedArtyUnit;
        };
    };
};

if (count _selectedArtyGroup > 0) then {
    _supportGroupsDataIndex = [_taskData, "Support groups"] call BIS_fnc_findInPairs;
    _supportGroupsData = (_taskData select _supportGroupsDataIndex) select 1;
    _artyGroupDataIndex = [_supportGroupsData, "Artillery"] call BIS_fnc_findInPairs;
    _artyGroupData = (_supportGroupsData select _artyGroupDataIndex) select 1;

    _artyLimit = if (_task == 1) then { 1 } else { 3 };
    _artyGroupData set [0, [_artyLimit]];
    _thisArtyGroupData = ["Artillery Group", [], []];
    {
        (_thisArtyGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
    } forEach _selectedArtyGroup;
    _artyGroupData set [1, [_thisArtyGroupData]];
};

// Transport
// Only if player is leader
if (_task == 1 && _playableUnit == 0) then {
    _selectedTransportGroup = [];
    // Check faction units for suitable air transport
    _factionTransport = [_playerFaction, "Air Transport"] call DMORBAT_fnc_categorizeUnits;
    private _transportGroups = [];
    {
        private _grps = _x select 1;
        {
            _transportGroups pushBack _x;
        } forEach _grps;
    } forEach _factionTransport;

    if (!isNil "_factionTransport") then {
        if (count _transportGroups > 0) then {
            // Pick one type randomly
            _selectedTransportUnit = (selectRandom _transportGroups) select 0;
            _selectedTransportGroup pushBack _selectedTransportUnit;
        };
    };
    
    // TO DO: Check that the amount of passenger seats is enough to carry the player gorup

    if (count _selectedTransportGroup > 0) then {
        _supportGroupsDataIndex = [_taskData, "Support groups"] call BIS_fnc_findInPairs;
        _supportGroupsData = (_taskData select _supportGroupsDataIndex) select 1;
        _transportGroupDataIndex = [_supportGroupsData, "Air Transport"] call BIS_fnc_findInPairs;
        _transportGroupData = (_supportGroupsData select _transportGroupDataIndex) select 1;

        _transportLimit = 1;
        _transportGroupData set [0, [_transportLimit]];
        _thisTransportGroupData = ["Transport Group", [], []];
        {
            (_thisTransportGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
        } forEach _selectedTransportGroup;
        _transportGroupData set [1, [_thisTransportGroupData]];
    };
};

// FRIENDLY GROUPS
if (_task == 2) then {
    _txt = "Assigning friendly groups...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DMORBAT: Play Now - %1", _txt];

    // INFANTRY
    // Regular squads
    _eligibleInf = [];
    _eligibleInfAll = [];
    // Pick a group with 8 or more members
    _eligibleInfAll =+ _infGroups select { (count (_x select 0)) >= 8 };
    if (count _eligibleInfAll > 0) then {
        _eligibleInf =+ _eligibleInfAll;
    } else {
        _eligibleInf =+ _infGroups;
    };
    ["Friendly groups", "Infantry", _eligibleInf, 2] call _fnc_addGroupsToTaskData;

    // AT Teams
    _eligibleAT = [];
    _eligibleATAll = [];
    // Pick a group with 4 or less members and AT
    _eligibleATAll =+ _infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 0)};
    if (count _eligibleATAll > 0) then {
        _eligibleAT =+ _eligibleATAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleATAll =+ _infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleATAll > 0) then {
            _eligibleAT =+ _eligibleATAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAT =+ _infGroups;
        };
    };
    ["Friendly groups", "Infantry", _eligibleAT, 1, 0, true, 4] call _fnc_addGroupsToTaskData;

    // AA Teams
    _eligibleAA = [];
    _eligibleAAAll = [];
    // Pick a group with 4 or less members and AA
    _eligibleAAAll =+ _infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 1)};
    if (count _eligibleAAAll > 0) then {
        _eligibleAA =+ _eligibleAAAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleAAAll =+ _infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleAAAll > 0) then {
            _eligibleAA =+ _eligibleAAAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAA =+ _infGroups;
        };
    };
    ["Friendly groups", "Infantry", _eligibleAA, 1, 0, true, 4] call _fnc_addGroupsToTaskData;

    // LAND
    if (count _mechGroups == 0 && count _motGroups == 0) then {
        diag_log "DMORBAT: Play Now - No mechanized or motorized groups found. Creating custom ones...";
        // Check faction for suitable land units
        _factionLand = [_playerFaction, "Land"] call DMORBAT_fnc_categorizeUnits;
        private _landGroups = [];
        {
            private _grps = _x select 1;
            {
                _landGroups pushBack _x;
            } forEach _grps;
        } forEach _factionLand;

        // Categorize each vehicle for all the land groups
        if (count _landGroups > 0) then {
            private _factionMot = [];
            private _factionMech = [];
            private _factionArmor = [];
            {
                private _unit = _x select 0;
                private _type = [_unit, true] call DMORBAT_fnc_vehicleType;

                if (_type == "Wheeled APC") then { _factionMot pushBack _unit };
                if (_type == "Truck") then { _factionMot pushBack _unit };
                if (_type == "Car") then { _factionMot pushBack _unit };
                if (_type == "Drone Wheeled APC") then { _factionMot pushBack _unit };
                if (_type == "Drone Truck") then { _factionMot pushBack _unit };
                if (_type == "Drone Car") then { _factionMot pushBack _unit };

                if (_type == "Tracked APC") then { _factionMech pushBack _unit };
                if (_type == "Drone Tracked APC") then { _factionMech pushBack _unit };

                if (_type == "Tank") then { _factionArmor pushBack _unit };
                if (_type == "Drone Tank") then { _factionArmor pushBack _unit };
            } forEach _landGroups;

            // Add to the vehicles pool
            {
                for [{private _i = 0}, {_i < 1}, {_i = _i + 1}] do 
                {
                    _motGroups pushBack [[_x],[]];
                };
            } forEach _factionMot;

            {
                _mechGroups pushBack [[_x],[]];
            } forEach _factionMech;

            {
                private _grp = [];
                for [{private _i = 0}, {_i < 1}, {_i = _i + 1}] do 
                {
                    _grp pushBack _x;
                };
                _armorGroups pushBack [_grp];
            } forEach _factionArmor;
        };
    };

    // Armor
    _eligibleArmor = [];
    _eligibleArmorAll = [];
    diag_log format ["DMORBAT: _armorGroups friendly: %1", _armorGroups];
    if (count _armorGroups > 0) then {
        // Pick a tank group and resize it
        _eligibleArmorAll =+ _armorGroups select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType;  (_type == "Tank" || _type == "Drone Tank") };
        { (_x select 0) resize 1 } forEach _eligibleArmorAll;
        if (count _eligibleArmorAll > 0) then {
            _eligibleArmor =+ _eligibleArmorAll;
        } else {
            // Otherwise pick any tank group
            _eligibleArmorAll =+ _armorGroups;
            if (count _eligibleArmorAll > 0) then {
                _eligibleArmor =+ _eligibleArmorAll;
            };
        };
        diag_log format ["DMORBAT: _eligibleArmor friendly: %1", _eligibleArmor];
        if (count _eligibleArmor > 0) then {
            ["Friendly groups", "Land Vehicles", _eligibleArmor, 1, 2, true, 2] call _fnc_addGroupsToTaskData;
        };
    };

    // Mechanized infantry
    if (count _mechGroups > 0) then {
        _amount = if (count _eligibleArmor == 0) then { 2 } else { 1 };
        ["Friendly groups", "Land Vehicles", _mechGroups, _amount] call _fnc_addGroupsToTaskData;
    };

    // Motorized infantry, if there's no mech inf
    if (count _motGroups > 0 && count _mechGroups == 0) then {
        _amount = if (count _eligibleArmor == 0) then { 3 } else { 1 };
        ["Friendly groups", "Land Vehicles", _motGroups, _amount] call _fnc_addGroupsToTaskData;
    };

    // AIR
    // Check faction for suitable air units
    _factionAir = [_playerFaction, "Air"] call DMORBAT_fnc_categorizeUnits;
    private _airGroupsVeh = [];
    {
        private _grps = _x select 1;
        {
            _airGroupsVeh pushBack _x;
        } forEach _grps;
    } forEach _factionAir;

    // Categorize each vehicle for all the land groups
    if (count _airGroupsVeh > 0) then {
        _factionAirVeh = [];
        {
            private _unit = _x select 0;
            private _type = [_unit, true] call DMORBAT_fnc_vehicleType;

            if (_type == "Plane") then { _factionAirVeh pushBack _unit };
            if (_type == "Helicopter") then { _factionAirVeh pushBack _unit };
            if (_type == "Drone Plane") then { _factionAirVeh pushBack _unit };
            if (_type == "Drone Helicopter") then { _factionAirVeh pushBack _unit };
        } forEach _airGroupsVeh;

        // Add to the vehicles pool
        {
            _airGroups pushBack [[_x]];
        } forEach _factionAirVeh;
    };

    if (count _airGroups > 0) then {
        ["Friendly groups", "Air Vehicles", _airGroups, 1, 1] call _fnc_addGroupsToTaskData;
    };
};


// ENEMY GROUPS
_txt = "Categorizing groups for the enemy faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
_enemyFaction = DMORBAT_EnemyFactions select (_task - 1);
diag_log format ["DMORBAT: _enemyFaction: %1", _enemyFaction];
_factionGroups = [_enemyFaction] call DMORBAT_fnc_categorizeGroups;

_infGroups = _factionGroups select 0;
_SFGroups = _factionGroups select 1;
_sniperGroups = _factionGroups select 2;
_motGroups = _factionGroups select 3;
_mechGroups = _factionGroups select 4;
_artilleryGroups = _factionGroups select 5;
_armorGroups = _factionGroups select 6;
_airGroups = _factionGroups select 7;
_waterGroups = _factionGroups select 8;

_softAll = [];

_txt = "Assigning enemy groups...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];


if (count _mechGroups == 0 && count _motGroups == 0) then {
    diag_log "DMORBAT: Play Now - No mechanized or motorized groups found. Creating custom ones...";
    // Check faction for suitable land units
    _factionLand = [_enemyFaction, "Land"] call DMORBAT_fnc_categorizeUnits;
    private _landGroups = [];
    {
        private _grps = _x select 1;
        {
            _landGroups pushBack _x;
        } forEach _grps;
    } forEach _factionLand;

    // Categorize each vehicle for all the land groups
    if (count _landGroups > 0) then {
        _factionSoft = [];
        _factionMot = [];
        _factionMech = [];
        _factionArmor = [];
        {
            private _unit = _x select 0;
            private _type = [_unit, true] call DMORBAT_fnc_vehicleType;

            if (_type == "Wheeled APC") then { _factionMot pushBack _unit };
            if (_type == "Truck") then { _factionMot pushBack _unit; _factionSoft pushBack _unit };
            if (_type == "Truck (unarmed)") then { _factionSoft pushBack _unit };
            if (_type == "Car") then { _factionMot pushBack _unit; _factionSoft pushBack _unit };
            if (_type == "Car (unarmed)") then { _factionSoft pushBack _unit };
            if (_type == "Drone Wheeled APC") then { _factionMot pushBack _unit };
            if (_type == "Drone Truck") then { _factionMot pushBack _unit };
            if (_type == "Drone Car") then { _factionMot pushBack _unit };

            if (_type == "Tracked APC") then { _factionMech pushBack _unit };
            if (_type == "Drone Tracked APC") then { _factionMech pushBack _unit };

            if (_type == "Tank") then { _factionArmor pushBack _unit };
            if (_type == "Drone Tank") then { _factionArmor pushBack _unit };
        } forEach _landGroups;

        // Add to the vehicles pool
        {
            for [{private _i = 0}, {_i < 3}, {_i = _i + 1}] do 
            {
                _motGroups pushBack [[_x],[]];
            };
        } forEach _factionMot;

        {
            _mechGroups pushBack [[_x],[]];
        } forEach _factionMech;

        {
            private _grp = [];
            for [{private _i = 0}, {_i < 2}, {_i = _i + 1}] do 
            {
                _grp pushBack _x;
            };
            _armorGroups pushBack [_grp];
        } forEach _factionArmor;

        {
            _softAll pushBack [[_x]];
        } forEach _factionSoft;
    };
};

// ENEMY INFANTRY
// Form custom infantry groups if faction doesn't have any defined
// if (count _infGroups == 0) then {
//     diag_log format ["DMORBAT: No infantry groups found for enemy faction %1. Creating custom ones...", _enemyFaction];
//     _infGroups = [_enemyFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
// };
// Always create custom faction groups. Most mods either don't bother, know or want to create proper groups anyway so even if they have them they probably will be useless or lacking
diag_log format ["DMORBAT: Creating custom groups for faction %1...", _enemyFaction];
_infGroupsCustom = [_enemyFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
// _infGroups append _infGroupsCustom;
_infGroups =+ _infGroupsCustom;
_SFGroupsCustom = [_enemyFaction, "SF"] call DMORBAT_fnc_createFactionGroups;
_SFGroups append _SFGroupsCustom;
// _SFGroups =+ _SFGroupsCustom;

if (_task == 1) then {
    // PATROLS
    _eligiblePatrols = [];
    _eligiblePatrolsAll = [];
    _eligiblePatrolsJustRifles = [];
    // Select infantry groups with 4 units or less
    _eligiblePatrolsAll =+ _infGroups select { (count (_x select 0)) <= 4 };
    // diag_log format ["DMORBAT: Play Now - _eligiblePatrolsAll: %1", _eligiblePatrolsAll];
    if (count _eligiblePatrolsAll > 0) then {
        // Select patrols without AT, AA, officers, hacker, assistant, diver, sniper
        _eligiblePatrolsJustRifles =+ _eligiblePatrolsAll select {!((_x select 1) select 0) && !((_x select 1) select 1) && !((_x select 1) select 10) && !((_x select 1) select 11) && !((_x select 1) select 12) && !((_x select 1) select 14) && !((_x select 1) select 16)};
        if (count _eligiblePatrolsJustRifles > 0) then {
            _eligiblePatrols =+ _eligiblePatrolsJustRifles;
        } else {
            _eligiblePatrols =+ _eligiblePatrolsAll;
        };
    } else {
        _eligiblePatrols =+ _infGroups;
    };
    diag_log format ["DMORBAT: _eligiblePatrols: %1", _eligiblePatrols];
    // ["_dataType1", "_dataType2", "_groupsPool", ["_groupsAmount", 1], ["_unitsAmount", 0], ["_variablePresence", false], ["_presenceThreshold", 3], ["_skill", 0]];
    ["Enemy groups", "Patrols", _eligiblePatrols, 3 + (floor (random 3)), 4, true, 1] call _fnc_addGroupsToTaskData;

    // Pick a car as another patrol
    _eligiblePatrolsCars = [];
    if (count _motGroups > 0) then {
        // Select the car of a motorized group
        {
            private _units = _x select 0;
            {
                if (([_x] call DMORBAT_fnc_vehicleType) == "car") exitWith {
                    _eligiblePatrolsCars pushBack [[_x]];
                };
            } forEach _units;
        } forEach _motGroups;
    } else {
        diag_log format ["DMORBAT: _softAll: %1", _softAll];
        if (count _softAll > 0) then {
            // _eligiblePatrolsCars = _softAll select { ((_x select 0) select 0) isKindOf "Car" };
            _eligiblePatrolsCars =+ _softAll select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType; (_type == "Car" || _type == "Drone Car") };
        };
    };
    // diag_log format ["_eligiblePatrolsCars: %1", _eligiblePatrolsCars];
    if (count _eligiblePatrolsCars > 0) then {
        _patrolCar = ((selectRandom _eligiblePatrolsCars) select 0) select 0;
        _patrolCarGroup = [_patrolCar];
        // Assign more units to the car if it's not armed
        _patrolCarArmed = [_patrolCar] call DMORBAT_fnc_isVehicleArmed;
        if (!_patrolCarArmed) then {
            _patrolCarAmount = 1 + (floor (random 1));
            _patrolCarInf = ((_infGroups select 0) select 0) select 0;
            diag_log format ["_patrolCarInf: %1", _patrolCarInf];
            for [{private _i = 0}, {_i < _patrolCarAmount}, {_i = _i + 1}] do 
            {
                _patrolCarGroup pushBack _patrolCarInf;
            };
        };
        ["Enemy groups", "Patrols", [[_patrolCarGroup]], 0.5 + (random 0.5), 0, true, 1] call _fnc_addGroupsToTaskData;
    };

    // DEFENDERS
    _eligibleDefenders = [];
    // Select infantry groups with 6 or more units
    _eligibleDefendersAll =+ _infGroups select { (count (_x select 0)) >= 6 };
    if (count _eligibleDefendersAll > 0) then {
        // Select defenders without AT or AA
        _eligibleDefendersJustRifles = _eligibleDefendersAll select {!((_x select 1) select 0) && !((_x select 1) select 1)};
        if (count _eligibleDefendersJustRifles > 0) then {
            _eligibleDefenders =+ _eligibleDefendersJustRifles;
        } else {
            _eligibleDefenders =+ _eligibleDefendersAll;
        };
    } else {
        _eligibleDefenders =+ _infGroups;
    };
    diag_log format ["DMORBAT: _eligibleDefenders: %1", _eligibleDefenders];
    ["Enemy groups", "Defenders", _eligibleDefenders, 1 + (floor (random 2)), 0, true, 1] call _fnc_addGroupsToTaskData;
};

if (_task == 2) then {
    // INFANTRY
    // Regular squads
    _eligibleInf = [];
    _eligibleInfAll = [];
    // Pick a group with 8 or more members
    _eligibleInfAll =+ _infGroups select { (count (_x select 0)) >= 8 };
    if (count _eligibleInfAll > 0) then {
        _eligibleInf =+ _eligibleInfAll;
    } else {
        _eligibleInf =+ _infGroups;
    };
    ["Enemy groups", "Infantry", _eligibleInf, 3] call _fnc_addGroupsToTaskData;

    // AT Teams
    _eligibleAT = [];
    _eligibleATAll = [];
    // Pick a group with 4 or less members and AT
    _eligibleATAll =+ _infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 0)};
    if (count _eligibleATAll > 0) then {
        _eligibleAT =+ _eligibleATAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleATAll =+ _infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleATAll > 0) then {
            _eligibleAT =+ _eligibleATAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAT =+ _infGroups;
        };
    };
    ["Enemy groups", "Infantry", _eligibleAT, 1, 0, true, 4] call _fnc_addGroupsToTaskData;

    // AA Teams
    _eligibleAA = [];
    _eligibleAAAll = [];
    // Pick a group with 4 or less members and AA
    _eligibleAAAll =+ _infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 1)};
    if (count _eligibleAAAll > 0) then {
        _eligibleAA =+ _eligibleAAAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleAAAll =+ _infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleAAAll > 0) then {
            _eligibleAA =+ _eligibleAAAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAA =+ _infGroups;
        };
    };
    ["Enemy groups", "Infantry", _eligibleAA, 1, 0, true, 4] call _fnc_addGroupsToTaskData;

    // SF groups
    _eligibleSF = [];
    _eligibleSFAll = [];
    if (count _SFGroups > 0) then {
        // Select SF group
        // Pick a group with 6 or less members
        _eligibleSFAll =+ _SFGroups select { (count (_x select 0)) <= 6 };
        if (count _eligibleSFAll > 0) then {
            _eligibleSF =+ _eligibleSFAll;
        } else {
            // Otherwise pick one randomly
            _eligibleSF =+ _SFGroups;
        };
    } else {
        // Select regular infantry if not SF group
        // Pick a group with 6 or less members
        _eligibleSFAll =+ _infGroups select { (count (_x select 0)) <= 6 };
        if (count _eligibleSFAll > 0) then {
            _eligibleSF =+ _eligibleSFAll;
        } else {
            // Otherwise pick one randomly
            _eligibleSF =+ _infGroups;
        };
    };
    ["Enemy groups", "Infantry", _eligibleSF, 1, 0, true, 6, 2] call _fnc_addGroupsToTaskData;

    // LAND
    // Armor
    _eligibleArmor = [];
    _eligibleArmorAll = [];
    if (count _armorGroups > 0) then {
        // Pick a tank group and resize it
        _eligibleArmorAll =+ _armorGroups select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType;  (_type == "Tank" || _type == "Drone Tank") };
        { (_x select 0) resize 2 } forEach _eligibleArmorAll;
        if (count _eligibleArmorAll > 0) then {
            _eligibleArmor =+ _eligibleArmorAll;
        } else {
            // Otherwise pick any tank group
            _eligibleArmorAll =+ _armorGroups;
            if (count _eligibleArmorAll > 0) then {
                _eligibleArmor =+ _eligibleArmorAll;
            };
        };
        if (count _eligibleArmor > 0) then {
            ["Enemy groups", "Land Vehicles", _eligibleArmor, 1, 2, true, 2] call _fnc_addGroupsToTaskData;
        };
    };

    // Mechanized infantry
    if (count _mechGroups > 0) then {
        _amount = if (count _eligibleArmor == 0) then { 4 } else { 2 };
        ["Enemy groups", "Land Vehicles", _mechGroups, _amount] call _fnc_addGroupsToTaskData;
    };

    // Motorized infantry, if there's no mech inf
    if (count _motGroups > 0 && count _mechGroups == 0) then {
        _amount = if (count _eligibleArmor == 0) then { 4 } else { 3 };
        ["Enemy groups", "Land Vehicles", _motGroups, _amount] call _fnc_addGroupsToTaskData;
    };

    // AIR
    // Check faction for suitable air units
    _factionAir = [_enemyFaction, "Air"] call DMORBAT_fnc_categorizeUnits;
    private _airGroupsVeh = [];
    {
        private _grps = _x select 1;
        {
            _airGroupsVeh pushBack _x;
        } forEach _grps;
    } forEach _factionAir;

    // Categorize each vehicle for all the land groups
    if (count _airGroupsVeh > 0) then {
        _factionAirVeh = [];
        {
            private _unit = _x select 0;
            private _type = [_unit, true] call DMORBAT_fnc_vehicleType;

            if (_type == "Plane") then { _factionAirVeh pushBack _unit };
            if (_type == "Helicopter") then { _factionAirVeh pushBack _unit };
            if (_type == "Drone Plane") then { _factionAirVeh pushBack _unit };
            if (_type == "Drone Helicopter") then { _factionAirVeh pushBack _unit };
        } forEach _airGroupsVeh;

        // Add to the vehicles pool
        {
            _airGroups pushBack [[_x]];
        } forEach _factionAirVeh;
    };

    if (count _airGroups > 0) then {
        ["Enemy groups", "Air Vehicles", _airGroups, 1, 1] call _fnc_addGroupsToTaskData;
    };

};

// LOCATIONS
_txt = "Picking AO locations...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
_locationsPredefined = call compile format ["DMORBAT_locations_Task%1", _task];
// Add locations data to tasks array
_locations = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_thisWorldLocations = [_locations, worldName] call BIS_fnc_getFromPairs;
if (isNil "_thisWorldLocations") then {
    // Add terrain data and include the predefined locations
    _newArr = [worldName, _locationsPredefined];
    [_taskData, "Locations", [_newArr]] call BIS_fnc_addToPairs;
} else {
    // Add predefined locations to current terrain
    [_locations, worldName, _locationsPredefined] call BIS_fnc_setToPairs
};


{
    diag_log format ["%1:", _x select 0];
    {
        diag_log format ["%1: %2", _forEachIndex, _x];
    } forEach (_x select 1);
} forEach _taskData;


// Initiate task
call DMORBAT_fnc_missionEditTerminate;
