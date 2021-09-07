// PLAY NOW

#include "..\control_defines.hpp";

cutText ["", "BLACK IN", 999];
enableRadio false;

// Start loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

// Flag this process as automated
DMORBAT_automated = true;

// Reset tasks data to default
DMORBAT_TaskData = +DMORBAT_TaskData_default;

// Retrieve data for this task
_task = DMORBAT_Task;
_taskData = DMORBAT_TaskData select (_task - 1);

// FRIENDLY GROUPS
_txt = "Categorizing groups for the player faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
_playerFaction = DMORBAT_PlayerFactions select (_task - 1);
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _playerFaction: %1", _playerFaction] };
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

DMORBAT_friendlyInfEdCat = "";

_txt = "Assigning player group...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];

// if (count _mechGroups == 0 || count _motGroups == 0) then {
//     diag_log "DMORBAT: Play Now - No mechanized or motorized groups found. Creating custom ones...";
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
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _motGroups pushBack [[_x],[]];
            };
        } forEach _factionMot;

        {
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _mechGroups pushBack [[_x],[]];
            };
        } forEach _factionMech;

        {
            private _grp = [];
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _grp pushBack _x;
            };
            _armorGroups pushBack [_grp];
        } forEach _factionArmor;
    };
// };

// Create custom infantry groups
diag_log format ["DMORBAT: Creating custom groups for faction %1...", _playerFaction];
_infGroupsCustom = [_playerFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
_infGroups append _infGroupsCustom;
// _infGroups = +_infGroupsCustom;
_SFGroupsCustom = [_playerFaction, "SF"] call DMORBAT_fnc_createFactionGroups;
_SFGroups append _SFGroupsCustom;
// _SFGroups = +_SFGroupsCustom;

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
    // Pick a group with 8 or more members
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
_playerGroupCount = count (_playerGroup select 0);
// Add to tasks array
[_taskData, "Player group", [_playerGroupData]] call BIS_fnc_addToPairs;

// Assign random unit as playable
_playableUnit = floor (random ((count (_playerGroup select 0)) - 1));
// _playableUnit = 0;
_playerData = [_playableUnit, 0, []];
[_taskData, "Player data", _playerData] call BIS_fnc_setToPairs;

// Check for NVG
_playerUnitClass = (_playerGroup select 0) select _playableUnit;
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _playerUnitClass: %1", _playerUnitClass] };
_playerGear = [];
_playerLinkedItems =  getArray (configFile >> "CfgVehicles" >> _playerUnitClass >> "linkedItems");
_playerGear append _playerLinkedItems;
_playerItems =  getArray (configFile >> "CfgVehicles" >> _playerUnitClass >> "Items");
_playerGear append _playerItems;
_playerBackpack = getText (configFile >> "CfgVehicles" >> _playerUnitClass >> "backpack");
if !(isNil "_playerBackpack") then {
    if (_playerBackpack != "") then {
        _playerBackpackItems = getArray (configFile >> "CfgVehicles" >> _playerBackpack >> "TransportItems");
        _playerGear append _playerBackpackItems;
    };
};
_hasNVG = false;
{
    if (_x isKindOf ["NVGoggles", configFile >> "CfgWeapons"]) then {
        _hasNVG = true;
    };
} forEach _playerGear;
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _playerGear: %1", _playerGear] };
if (!_hasNVG) then {
};
DMORBAT_noNightAuto = if (!_hasNVG) then { true } else { false };

DMORBAT_friendlyInfEdCat = getText (configFile >> "CfgVehicles" >> _playerUnitClass >> "editorSubcategory");
if (DMORBAT_debug) then { diag_log format ["DMORBAT: player group leader: %1, editor subcat: %2", _playerUnitClass, DMORBAT_friendlyInfEdCat] };

// FUNCTIONS
/*
  Parameter (s):
  _sideType: "Friendly groups" or "Enemy groups", string
  _groupType: type of group as defined in the categorized faction groups, string
  _groupsPool: groups to be chosen from, array
  _groupsAmount: amount of groups of this type to be generated, number
  _maxUnits: amount of units to be assigned to each group, 0 to use the whole group as defined, number
  _limitPresence: establish a presence chance to units beyond a given threshold, with decremental chance of presence, bool
  _minUnits: amount of units with a 100% chance of presence if _limitPresence was true, number
  _skill: 0: default skill, 1: untrained (below average skills, no FSM), 2: elite (exceptional stats, will never flee), number
  _sameEdCat: force all groups of the same type to belong to the same editor subcategory, bool
  _edCat: editor subcategory to check for if _sameEdCat was true, string

  Returns:
  true
        
  Examples:
  ["Enemy groups","Air Vehicles",_airGroups,1] call _fnc_addGroupsToTaskData;       
*/
_fnc_addGroupsToTaskData = {
    params ["_sideType", "_groupType", "_groupsPool", ["_groupsAmount", 1], ["_maxUnits", 0], ["_limitPresence", false], ["_minUnits", 3], ["_skill", 0], ["_sameEdCat", true], ["_edCat", ""]];
    // if (DMORBAT_debug) then { diag_log format ["_sideType: %1 _groupType: %2 _groupsPool: %3 _groupsAmount: %4 _maxUnits: %5 _limitPresence: %6 _minUnits: %7 _skill: %8 _sameEdCat: %9 _edCat: %10", _sideType, _groupType, (_groupsPool select 0) select 0, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, _sameEdCat, _edCat] };

    private _task = DMORBAT_Task;
    private _taskData = DMORBAT_TaskData select (_task - 1);

    private _groupsDataIndex = [_taskData, _sideType] call BIS_fnc_findInPairs;
    private _groupsData = (_taskData select _groupsDataIndex) select 1;
    private _selectedGroup = [];
    private _presenceChance = 1;
    for [{private _i = 0}, {_i < _groupsAmount}, {_i = _i + 1}] do 
    {
        // if (_sameEdCat && _sideType == "Friendly groups" && _groupType == "Infantry") then {
        if (_sameEdCat && (_groupType == "Infantry" || _groupType == "Patrols" || _groupType == "Defenders") && _edCat != "") then {
        // Pick only teams of the same editor category
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now -_fnc_addGroupsToTaskData - Filtering provided groups by category for %1, %2: %3", _sideType, _groupType, _edCat] };
            _groupsPoolTemp = _groupsPool select {
                _thisESubCat = getText (configFile >> "CfgVehicles" >> ((_x select 0) select 0) >> "editorSubcategory");
                // _playerESubCat = getText (configFile >> "CfgVehicles" >> ((_playerGroup select 0) select 0) >> "editorSubcategory");
                // _thisESubCat == _playerESubCat
                _thisESubCat == _edCat
            };
            if (count _groupsPoolTemp == 0) exitWith {
                diag_log format ["DMORBAT: --- WARNING --- Couldn't find groups of the same editor category for %1! Trying again without category limits...", _sideType];
                [_sideType, _groupType, _groupsPool, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, false] call _fnc_addGroupsToTaskData
            };
            _groupsPool = +_groupsPoolTemp;
        };
        _selectedGroup = selectRandom _groupsPool;
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - _fnc_addGroupsToTaskData - _thisGroupData: %1", ((_selectedGroup select 0) select 0)] };

        // Set side editor category if it wasn't set already
        if (_sameEdCat && (_groupType == "Infantry" || _groupType == "Patrols" || _groupType == "Defenders") && _edCat == "") exitWith {
            private _groupEdCat = getText (configFile >> "CfgVehicles" >> ((_selectedGroup select 0) select 0) >> "editorSubcategory");
            if (_sideType == "Friendly groups") then {
                DMORBAT_friendlyInfEdCat = _groupEdCat;
            } else {
                DMORBAT_enemyInfEdCat = _groupEdCat;
            };
            diag_log format ["DMORBAT: --- WARNING --- Editor category wasn't set. Trying again with: %1", _groupEdCat];
            [_sideType, _groupType, _groupsPool, _groupsAmount, _maxUnits, _limitPresence, _minUnits, _skill, true, _groupEdCat] call _fnc_addGroupsToTaskData
        };

        private _thisGroupData = [format ["%1 Group %2", _groupType, _i + 1], [], []];
        {
            if (_maxUnits > 0 && _forEachIndex == _maxUnits) exitWith { true };
            if (_limitPresence && {_forEachIndex > _minUnits}) then { _presenceChance = (_presenceChance - 0.25) max 0.25 };
            (_thisGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], _presenceChance, _skill];
        } forEach (_selectedGroup select 0);
        // Add to tasks array
        [_groupsData, _groupType, [_thisGroupData]] call BIS_fnc_addToPairs;
        if (_limitPresence) then { _presenceChance = (1 - (0.1 * _i)) max 0.25 };
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
            // _selectedTransportUnit = (selectRandom _transportGroups) select 0;
            _availableTransportUnits = [];
            // Check that the amount of passenger seats is enough to carry the player group
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - _transportGroups: %1", _transportGroups] };
            {
                //["_unitClass", ["_pos", position player], ["_grp", grpNull, [grpNull, sideUnknown]], ["_markers", []], ["_radius", 0], ["_special", "NONE"], ["_enableRandom", true], ["_autoDelete", true]];
                private _testUnit = [_x select 0, [0,0,0]] call DMORBAT_fnc_spawnVehicle;
                _passengerSeats = (fullCrew [_testUnit, "", true]) select {isNull (_x select 0)};
                _nul = [_testUnit] spawn { [_this select 0] call DMORBAT_fnc_deleteVehicle };
                diag_log format ["DMORBAT: Play Now - %1 has %2 passenger seats and the player group is %3", (_x select 0), count _passengerSeats, _playerGroupCount];
                if (count _passengerSeats >= _playerGroupCount) then {
                    _availableTransportUnits pushBack (_x select 0);
                };
            } forEach _transportGroups;
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - _availableTransportUnits: %1", _availableTransportUnits] };

            if (count _availableTransportUnits > 0) then {
                _selectedTransportUnit = selectRandom _availableTransportUnits;
                _selectedTransportGroup pushBack _selectedTransportUnit;
            };
        };
    };

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
    _eligibleInfAll = +_infGroups select { (count (_x select 0)) >= 8 };
    if (count _eligibleInfAll > 0) then {
        _eligibleInf = +_eligibleInfAll;
    } else {
        _eligibleInf = +_infGroups;
    };
    [/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleInf,/*_groupsAmount*/ 2,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 9,/*_skill*/ 2,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_friendlyInfEdCat] call _fnc_addGroupsToTaskData;

    // AT Teams
    _eligibleAT = [];
    _eligibleATAll = [];
    // Pick a group with 4 or less members and at least 2 AT
    _eligibleATAll = +_infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 0) };
    private _i = 0;
    private _ATgroupsCount = [];
    private _ATremove = [];
    {  
        private _ATcount = 0;
        private _group = _x select 0;
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - AT team check - _group: %1",_group] };
        {
            private _unit = _x;
            // if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - AT team check - _unit: %1", _unit] };
            private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
            if (_roles select 0) then { _ATcount = _ATcount + 1 };
        } forEach _group;
        _ATgroupsCount pushBack [_i, _ATcount];
        _i = _i + 1;
     } forEach _eligibleATAll;
     { if ((_x select 1) < 2) then { _eligibleATAll deleteAt (_x select 0)}; } forEach _ATgroupsCount;

    if (count _eligibleATAll > 0) then {
        _eligibleAT = +_eligibleATAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleATAll = +_infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleATAll > 0) then {
            _eligibleAT = +_eligibleATAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAT = +_infGroups;
        };
    };
    [/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAT,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 2,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_friendlyInfEdCat] call _fnc_addGroupsToTaskData;

    // AA Teams
    _eligibleAA = [];
    _eligibleAAAll = [];
    // Pick a group with 4 or less members and AA
    _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 1)};
    if (count _eligibleAAAll > 0) then {
        _eligibleAA = +_eligibleAAAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleAAAll > 0) then {
            _eligibleAA = +_eligibleAAAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAA = +_infGroups;
        };
    };
    [/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAA,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 2,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_friendlyInfEdCat] call _fnc_addGroupsToTaskData;

    // LAND
    // Armor
    _eligibleArmor = [];
    _eligibleArmorAll = [];
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: _armorGroups friendly: %1", _armorGroups] };
    if (count _armorGroups > 0) then {
        // Pick a tank group and resize it
        _eligibleArmorAll = +_armorGroups select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType;  (_type == "Tank" || _type == "Drone Tank") };
        { (_x select 0) resize 1 } forEach _eligibleArmorAll;
        if (count _eligibleArmorAll > 0) then {
            _eligibleArmor = +_eligibleArmorAll;
        } else {
            // Otherwise pick any tank group
            _eligibleArmorAll = +_armorGroups;
            if (count _eligibleArmorAll > 0) then {
                _eligibleArmor = +_eligibleArmorAll;
            };
        };
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligibleArmor friendly: %1", _eligibleArmor] };
        if (count _eligibleArmor > 0) then {
            [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleArmor,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 1,/*_skill*/ 2] call _fnc_addGroupsToTaskData;
        };
    };

    // Mechanized infantry
    if (count _mechGroups > 0) then {
        _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 3 } else { 1 };
        ["Friendly groups", "Land Vehicles", _mechGroups, _amount] call _fnc_addGroupsToTaskData;
        [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _mechGroups,/*_groupsAmount*/ _amount,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 2,/*_skill*/ 2] call _fnc_addGroupsToTaskData;
    };

    // Motorized infantry, if there's no mech inf
    if (count _motGroups > 0 && count _mechGroups == 0) then {
        _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 4 } else { 1 };
        ["Friendly groups", "Land Vehicles", _motGroups, _amount] call _fnc_addGroupsToTaskData;
        [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _motGroups,/*_groupsAmount*/ _amount,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 3,/*_skill*/ 2] call _fnc_addGroupsToTaskData;
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

        _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 2 } else { 1 };
        if (count _airGroups > 0) then {
            [/*_sideType*/ "Friendly groups",/*_groupType*/ "Air Vehicles",/*_groupsPool*/ _airGroups,/*_groupsAmount*/ _amount,/*_maxUnits*/ 1,/*_limitPresence*/ false,/*_minUnits*/ 1,/*_skill*/ 2] call _fnc_addGroupsToTaskData;
        };
    };


    // SUPPORT 2
    // Allow Air Support if there's no friendly armor
    if (count _eligibleArmor == 0) then {
        // CAS
        // Only if player is leader
        _selectedCASGroup = [];
        // Check faction units for suitable CAS
        _factionCAS = [_playerFaction, "CAS"] call DMORBAT_fnc_categorizeUnits;
        private _CASGroups = [];
        {
            private _grps = _x select 1;
            {
                _CASGroups pushBack _x;
            } forEach _grps;
        } forEach _factionCAS;

        if (!isNil "_factionCAS") then {
            if (count _CASGroups > 0) then {
                // Pick one type randomly
                _selectedCASUnit = (selectRandom _CASGroups) select 0;
                _selectedCASGroup pushBack _selectedCASUnit;
            };
        };

        if (count _selectedCASGroup > 0) then {
            _supportGroupsDataIndex = [_taskData, "Support groups"] call BIS_fnc_findInPairs;
            _supportGroupsData = (_taskData select _supportGroupsDataIndex) select 1;
            _CASGroupDataIndex = [_supportGroupsData, "CAS"] call BIS_fnc_findInPairs;
            _CASGroupData = (_supportGroupsData select _CASGroupDataIndex) select 1;

            _CASLimit = 1;
            _CASGroupData set [0, [_CASLimit]];
            _thisCASGroupData = ["CAS Group", [], []];
            {
                (_thisCASGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
            } forEach _selectedCASGroup;
            _CASGroupData set [1, [_thisCASGroupData]];
        };
    };
};


// ENEMY GROUPS
_txt = "Categorizing groups for the enemy faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];
_enemyFaction = DMORBAT_EnemyFactions select (_task - 1);
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _enemyFaction: %1", _enemyFaction] };
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

DMORBAT_enemyInfEdCat = "";

_txt = "Assigning enemy groups...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: Play Now - %1", _txt];


// if (count _mechGroups == 0 || count _motGroups == 0) then {
//     diag_log "DMORBAT: Play Now - No mechanized or motorized groups found. Creating custom ones...";
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
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _motGroups pushBack [[_x],[]];
            };
        } forEach _factionMot;

        {
            private _grp = [];
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _mechGroups pushBack [[_x],[]];
            };
        } forEach _factionMech;

        {
            private _grp = [];
            for [{private _i = 0}, {_i < 4}, {_i = _i + 1}] do 
            {
                _grp pushBack _x;
            };
            _armorGroups pushBack [_grp];
        } forEach _factionArmor;

        {
            _softAll pushBack [[_x]];
        } forEach _factionSoft;
    };
// };

// ENEMY INFANTRY
// Create custom infantry groups
diag_log format ["DMORBAT: Creating custom groups for faction %1...", _enemyFaction];
_infGroupsCustom = [_enemyFaction, "Infantry"] call DMORBAT_fnc_createFactionGroups;
_infGroups append _infGroupsCustom;
// _infGroups = +_infGroupsCustom;
_SFGroupsCustom = [_enemyFaction, "SF"] call DMORBAT_fnc_createFactionGroups;
_SFGroups append _SFGroupsCustom;
// _SFGroups = +_SFGroupsCustom;

if (_task == 1) then {
    // PATROLS
    _eligiblePatrols = [];
    _eligiblePatrolsAll = [];
    _eligiblePatrolsJustRifles = [];
    // Select infantry groups with 4 units or less
    _eligiblePatrolsAll = +_infGroups select { (count (_x select 0)) <= 4 };
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: Play Now - _eligiblePatrolsAll: %1", _eligiblePatrolsAll] };
    if (count _eligiblePatrolsAll > 0) then {
        // Select patrols without AT, AA, officers, hacker, assistant, diver, sniper
        _eligiblePatrolsJustRifles = +_eligiblePatrolsAll select {!((_x select 1) select 0) && !((_x select 1) select 1) && !((_x select 1) select 10) && !((_x select 1) select 11) && !((_x select 1) select 12) && !((_x select 1) select 14) && !((_x select 1) select 16)};
        if (count _eligiblePatrolsJustRifles > 0) then {
            _eligiblePatrols = +_eligiblePatrolsJustRifles;
        } else {
            _eligiblePatrols = +_eligiblePatrolsAll;
        };
    } else {
        _eligiblePatrols = +_infGroups;
    };
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligiblePatrols: %1", _eligiblePatrols] };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Patrols",/*_groupsPool*/ _eligiblePatrols,/*_groupsAmount*/ 3 + (floor (random 3)),/*_maxUnits*/ 4,/*_limitPresence*/ true,/*_minUnits*/ 2,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_enemyInfEdCat] call _fnc_addGroupsToTaskData;

    // Pick a car as another patrol
    _eligiblePatrolsCars = [];
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _motGroups count: %1", count _motGroups] };
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
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _softAll: %1", _softAll] };
        if (count _softAll > 0) then {
            // _eligiblePatrolsCars = _softAll select { ((_x select 0) select 0) isKindOf "Car" };
            _eligiblePatrolsCars = +_softAll select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType; (_type == "Car" || _type == "Drone Car") };
        };
    };
    if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligiblePatrolsCars: %1", _eligiblePatrolsCars] };
    if (count _eligiblePatrolsCars > 0) then {
        _patrolCar = ((selectRandom _eligiblePatrolsCars) select 0) select 0;
        _patrolCarGroup = [_patrolCar];
        // Assign more units to the car if it's not armed
        _patrolCarArmed = [_patrolCar] call DMORBAT_fnc_isVehicleArmed;
        if (!_patrolCarArmed) then {
            _patrolCarAmount = 1 + (floor (random 1));
            _patrolCarInf = ((_infGroups select 0) select 0) select 0;
            if (DMORBAT_debug) then { diag_log format ["DMORBAT: _patrolCarInf: %1", _patrolCarInf] };
            for [{private _i = 0}, {_i < _patrolCarAmount}, {_i = _i + 1}] do 
            {
                _patrolCarGroup pushBack _patrolCarInf;
            };
        };
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: Trying to create the patrol car group: %1", _patrolCarGroup] };
        [/*_sideType*/ "Enemy groups",/*_groupType*/ "Patrols",/*_groupsPool*/ [[_patrolCarGroup]],/*_groupsAmount*/ 0.5 + floor (random (1.5)),/*_maxUnits*/ 2,/*_limitPresence*/ true,/*_minUnits*/ 1,/*_skill*/ 1,/*_sameEdCat*/ false] call _fnc_addGroupsToTaskData;
    };

    // DEFENDERS
    _eligibleDefenders = [];
    // Select infantry groups with 6 or more units
    _eligibleDefendersAll = +_infGroups select { (count (_x select 0)) >= 6 };
    if (count _eligibleDefendersAll > 0) then {
        // Select defenders without AT or AA
        _eligibleDefendersJustRifles = _eligibleDefendersAll select {!((_x select 1) select 0) && !((_x select 1) select 1)};
        if (count _eligibleDefendersJustRifles > 0) then {
            _eligibleDefenders = +_eligibleDefendersJustRifles;
        } else {
            _eligibleDefenders = +_eligibleDefendersAll;
        };
    } else {
        _eligibleDefenders = +_infGroups;
    };
    // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _eligibleDefenders: %1", _eligibleDefenders] };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Defenders",/*_groupsPool*/ _eligiblePatrols,/*_groupsAmount*/ 1 + (floor (random 2)),/*_maxUnits*/ 9,/*_limitPresence*/ true,/*_minUnits*/ 4,/*_skill*/ 0,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_enemyInfEdCat] call _fnc_addGroupsToTaskData;
};

if (_task == 2) then {
    // INFANTRY
    // Regular squads
    _eligibleInf = [];
    _eligibleInfAll = [];
    // Pick a group with 8 or more members
    _eligibleInfAll = +_infGroups select { (count (_x select 0)) >= 8 };
    if (count _eligibleInfAll > 0) then {
        _eligibleInf = +_eligibleInfAll;
    } else {
        _eligibleInf = +_infGroups;
    };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleInf,/*_groupsAmount*/ 6,/*_maxUnits*/ 5,/*_limitPresence*/ true,/*_minUnits*/ 3,/*_skill*/ 0,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_enemyInfEdCat] call _fnc_addGroupsToTaskData;

    // AT Teams
    _eligibleAT = [];
    _eligibleATAll = [];
    // Pick a group with 4 or less members and at least 2 AT
    _eligibleATAll = +_infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 0) };
    private _i = 0;
    private _ATgroupsCount = [];
    private _ATremove = [];
    {  
        private _ATcount = 0;
        private _group = _x select 0;
        {
            private _unit = _x;
            private _roles = [[_unit]] call DMORBAT_fnc_groupRoles;
            if (_roles select 0) then { _ATcount = _ATcount + 1 };
        } forEach _group;
        _ATgroupsCount pushBack [_i, _ATcount];
        _i = _i + 1;
     } forEach _eligibleATAll;
     { if ((_x select 1) < 2) then { _eligibleATAll deleteAt (_x select 0)}; } forEach _ATgroupsCount;
    if (count _eligibleATAll > 0) then {
        _eligibleAT = +_eligibleATAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleATAll = +_infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleATAll > 0) then {
            _eligibleAT = +_eligibleATAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAT = +_infGroups;
        };
    };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAT,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 0,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_enemyInfEdCat] call _fnc_addGroupsToTaskData;

    // AA Teams
    _eligibleAA = [];
    _eligibleAAAll = [];
    // Pick a group with 4 or less members and AA
    _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= 4 && ((_x select 1) select 1)};
    if (count _eligibleAAAll > 0) then {
        _eligibleAA = +_eligibleAAAll;
    } else {
        // Pick a group with 4 or less members
        _eligibleAAAll = +_infGroups select { (count (_x select 0)) <= 4 };
        if (count _eligibleAAAll > 0) then {
            _eligibleAA = +_eligibleAAAll;
        } else {
            // Otherwise pick one randomly
            _eligibleAA = +_infGroups;
        };
    };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAA,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 0,/*_sameEdCat*/ true,/*_edCat*/ DMORBAT_enemyInfEdCat] call _fnc_addGroupsToTaskData;

    // SF groups
    _eligibleSF = [];
    _eligibleSFAll = [];
    if (count _SFGroups > 0) then {
        // Select SF group
        // Pick a group with 6 or less members
        _eligibleSFAll = +_SFGroups select { (count (_x select 0)) >= 4 && (count (_x select 0)) <= 6 };
        if (count _eligibleSFAll > 0) then {
            _eligibleSF = +_eligibleSFAll;
        } else {
            // Otherwise pick one randomly
            _eligibleSF = +_SFGroups;
        };
    } else {
        // Select regular infantry if not SF group
        // Pick a group with 6 or less members
        _eligibleSFAll = +_infGroups select { (count (_x select 0)) >= 4 && (count (_x select 0)) <= 6 };
        if (count _eligibleSFAll > 0) then {
            _eligibleSF = +_eligibleSFAll;
        } else {
            // Otherwise pick one randomly
            _eligibleSF = +_infGroups;
        };
    };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleSF,/*_groupsAmount*/ 1,/*_maxUnits*/ 6,/*_limitPresence*/ true,/*_minUnits*/ 4,/*_skill*/ 2,/*_sameEdCat*/ false] call _fnc_addGroupsToTaskData;

    // LAND
    // Armor
    _eligibleArmor = [];
    _eligibleArmorAll = [];
    if (count _armorGroups > 0) then {
        // Pick a tank group and resize it
        _eligibleArmorAll = +_armorGroups select { _type = [(_x select 0) select 0] call DMORBAT_fnc_vehicleType;  (_type == "Tank" || _type == "Drone Tank") };
        { (_x select 0) resize 2 } forEach _eligibleArmorAll;
        if (count _eligibleArmorAll > 0) then {
            _eligibleArmor = +_eligibleArmorAll;
        } else {
            // Otherwise pick any tank group
            _eligibleArmorAll = +_armorGroups;
            if (count _eligibleArmorAll > 0) then {
                _eligibleArmor = +_eligibleArmorAll;
            };
        };
        if (count _eligibleArmor > 0) then {
            [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleArmor,/*_groupsAmount*/ 1,/*_maxUnits*/ 2,/*_limitPresence*/ true,/*_minUnits*/ 1] call _fnc_addGroupsToTaskData;
        };
    };

    // Mechanized infantry
    if (count _mechGroups > 0) then {
        _amount = if (count _eligibleArmor == 0) then { 4 } else { 2 };
        [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _mechGroups,/*_groupsAmount*/ _amount] call _fnc_addGroupsToTaskData;
    };

    // Motorized infantry, if there's no mech inf
    if (count _motGroups > 0 && count _mechGroups == 0) then {
        _amount = if (count _eligibleArmor == 0) then { 4 } else { 3 };
        [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _motGroups,/*_groupsAmount*/ _amount] call _fnc_addGroupsToTaskData;
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

        if (count _airGroups > 0) then {
            [/*_sideType*/ "Enemy groups",/*_groupType*/ "Air Vehicles",/*_groupsPool*/ _airGroups,/*_groupsAmount*/ 1,/*_maxUnits*/ 1] call _fnc_addGroupsToTaskData;
        };
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
    if (DMORBAT_debug) then { diag_log format ["%1:", _x select 0] };
    {
        if (DMORBAT_debug) then { diag_log format ["%1: %2", _forEachIndex, _x] };
    } forEach (_x select 1);
} forEach _taskData;


// Initiate task
call DMORBAT_fnc_missionEditTerminate;
