// PLAY NOW - TASK 2

#include "..\..\control_defines.hpp";

params ["_playerFaction", "_enemyFaction", "_factionGroupsFriendly", "_factionGroupsEnemy", "_display", "_ctrl"];

// Retrieve data for this task
_task = DAKKA_Task;
_taskData = DAKKA_TaskData select (_task - 1);

// -------------------------------------------------------------------------------------
// FRIENDLY GROUPS - CATEGORIZATION
_txt = "Categorizing groups for the friendly faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];

// _categorizeFactionGroups = [_infGroups, _SFGroups, _sniperGroups, _motGroups, _mechGroups, _artilleryGroups, _armorGroups, _airGroups, _waterGroups]
_factionGroups = _factionGroupsFriendly;
_infGroups = _factionGroups select 0;
_SFGroups = _factionGroups select 1;
_sniperGroups = _factionGroups select 2;
_motGroups = _factionGroups select 3;
_mechGroups = _factionGroups select 4;
_artilleryGroups = _factionGroups select 5;
_armorGroups = _factionGroups select 6;
_airGroups = _factionGroups select 7;
_waterGroups = _factionGroups select 8;

DAKKA_friendlyInfEdCat = "";

// Create custom groups
// [_customInfGroups, _customSFGroups, _customMotoGroups, _customMechGroups, _customArmorGroups, _customPlaneGroups, _customHeloGroups, _customTransportHeloGroups]
diag_log format ["DAKKA: Creating custom groups for faction %1...", _playerFaction];
_allGroupsCustom = [_playerFaction, "All"] call DAKKA_fnc_createFactionGroups;
_infGroupsCustom =  _allGroupsCustom select 0;
_infGroups append _infGroupsCustom;
_SFGroupsCustom =  _allGroupsCustom select 1;
_SFGroups append _SFGroupsCustom;
_motGroupsCustom =  _allGroupsCustom select 2;
_motGroups append _motGroupsCustom;
_mechGroupsCustom =  _allGroupsCustom select 3;
_mechGroups append _mechGroupsCustom;
_armorGroupsCustom =  _allGroupsCustom select 4;
_armorGroups append _armorGroupsCustom;
_planeGroupsCustom =  _allGroupsCustom select 5;
_airGroups append _planeGroupsCustom;
_heloGroupsCustom =  _allGroupsCustom select 6;
_airGroups append _heloGroupsCustom;

// -------------------------------------------------------------------------------------
// PLAYER GROUP
_txt = "Assigning player group...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];

_playerGroup = [];
_eligiblePlayerGroups = [];

// Pick a group with 8 or more members
_eligiblePlayerGroups = _infGroups select { (count (_x select 0)) >= 8 };
if (count _eligiblePlayerGroups > 0) then {
    _playerGroup = selectRandom _eligiblePlayerGroups;
} else {
    // Otherwise pick one randomly
    _playerGroup = selectRandom _infGroups;
};

// No suitable player group found
if (count _eligiblePlayerGroups == 0) then {
    diag_log format ["DAKKA: No suitable player group found in faction %1!", _playerFaction];
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

_playerUnitClass = (_playerGroup select 0) select _playableUnit;
if (DAKKA_debug) then { diag_log format ["DAKKA: _playerUnitClass: %1", _playerUnitClass] };

// If player unit has NVG then allow night missions
_hasNVG = [_playerUnitClass] call DAKKA_fnc_checkNVG;
DAKKA_noNightAuto = if (!_hasNVG) then { true } else { false };

DAKKA_friendlyInfEdCat = getText (configFile >> "CfgVehicles" >> _playerUnitClass >> "editorSubcategory");
if (DAKKA_debug) then { diag_log format ["DAKKA: player group leader: %1, editor subcat: %2", _playerUnitClass, DAKKA_friendlyInfEdCat] };

// -------------------------------------------------------------------------------------
// SUPPORT
_txt = "Generating support options...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];
// Artillery
_selectedArtyGroup = [];
if (count _artilleryGroups > 0) then {
    // If there's artillery groups select one randomly
    _selectedArtyGroup = selectRandom (_artilleryGroups select 0);
} else {
    // Check faction units for suitable artillery
    _factionArtillery = [_playerFaction, "Artillery"] call DAKKA_fnc_categorizeUnits;
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

    _artyLimit = 3;
    _artyGroupData set [0, [_artyLimit]];
    _thisArtyGroupData = ["Artillery Group", [], []];
    {
        (_thisArtyGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
    } forEach _selectedArtyGroup;
    _artyGroupData set [1, [_thisArtyGroupData]];
};

// -------------------------------------------------------------------------------------
// FRIENDLY GROUPS
_txt = "Assigning friendly groups...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];

// INFANTRY
// Regular squads
_eligibleInf = [8, _infGroups] call DAKKA_fnc_filterInfantryGroups;
[/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleInf,/*_groupsAmount*/ 2,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 9,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_friendlyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// AT Teams
_eligibleAT = [4, _infGroups] call DAKKA_fnc_filterATteamGroups;
[/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAT,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_friendlyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// AA Teams
_eligibleAA = [4, _infGroups] call DAKKA_fnc_filterAAteamGroups;
[/*_sideType*/ "Friendly groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAA,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_friendlyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// LAND
// Armor
_eligibleArmor = [];
if (count _armorGroups > 0) then {
    if (DAKKA_debug) then { diag_log format ["DAKKA: _armorGroups friendly: %1", _armorGroups] };
    _eligibleArmor = [_armorGroups] call DAKKA_fnc_filterArmorGroups;
    if (count _eligibleArmor > 0) then {
        if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleArmor friendly: %1", _eligibleArmor] };
        [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleArmor,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 1,/*_skill*/ 1] call DAKKA_fnc_addGroupsToTaskData;
    };
};

// Mechanized infantry
if (count _mechGroups > 0) then {
    _eligibleMech = [_mechGroups] call DAKKA_fnc_filterMechGroups;
    _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 2 } else { 1 };
    // if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleMech friendly: %1", _eligibleMech] };
    [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleMech,/*_groupsAmount*/ _amount,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 2,/*_skill*/ 1] call DAKKA_fnc_addGroupsToTaskData;
};

// Motorized infantry, if there's no mech inf
if (count _motGroups > 0 && count _mechGroups == 0) then {
    _eligibleMot = [_motGroups] call DAKKA_fnc_filterMotGroups;
    _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 3 } else { 1 };
    [/*_sideType*/ "Friendly groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleMot,/*_groupsAmount*/ _amount,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 3,/*_skill*/ 1] call DAKKA_fnc_addGroupsToTaskData;
};

// AIR
// Air units
if (count _airGroups > 0) then {
    _eligibleAir = [_airGroups] call DAKKA_fnc_filterAirGroups;
    if (count _eligibleAir > 0) then {
        if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAir friendly: %1", _eligibleAir] };
        _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 2 } else { 1 };
        [/*_sideType*/ "Friendly groups",/*_groupType*/ "Air Vehicles",/*_groupsPool*/ _eligibleAir,/*_groupsAmount*/ _amount,/*_maxUnits*/ 1,/*_limitPresence*/ false,/*_minUnits*/ 1,/*_skill*/ 1] call DAKKA_fnc_addGroupsToTaskData;
    };
};


// -------------------------------------------------------------------------------------
// SUPPORT 2
// Allow Air Support if there's no friendly armor
if (count _eligibleArmor == 0) then {
    // CAS
    // Only if player is leader
    _selectedCASGroup = [];
    // Check faction units for suitable CAS
    _factionCAS = [_playerFaction, "CAS"] call DAKKA_fnc_categorizeUnits;
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


// -------------------------------------------------------------------------------------
// ENEMY GROUPS
_txt = "Categorizing groups for the enemy faction...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];

_factionGroups = _factionGroupsEnemy;
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

DAKKA_enemyInfEdCat = "";

// Create custom groups
// [_customInfGroups, _customSFGroups, _customMotoGroups, _customMechGroups, _customArmorGroups, _customPlaneGroups, _customHeloGroups, _customTransportHeloGroups]
diag_log format ["DAKKA: Creating custom groups for faction %1...", _enemyFaction];
_allGroupsCustom = [_enemyFaction, "All"] call DAKKA_fnc_createFactionGroups;
_infGroupsCustom =  _allGroupsCustom select 0;
_infGroups append _infGroupsCustom;
_SFGroupsCustom =  _allGroupsCustom select 1;
_SFGroups append _SFGroupsCustom;
_motGroupsCustom =  _allGroupsCustom select 2;
_motGroups append _motGroupsCustom;
_mechGroupsCustom =  _allGroupsCustom select 3;
_mechGroups append _mechGroupsCustom;
_armorGroupsCustom =  _allGroupsCustom select 4;
_armorGroups append _armorGroupsCustom;
_planeGroupsCustom =  _allGroupsCustom select 5;
_airGroups append _planeGroupsCustom;
_heloGroupsCustom =  _allGroupsCustom select 6;
_airGroups append _heloGroupsCustom;


// -------------------------------------------------------------------------------------
// ENEMY INFANTRY

_txt = "Assigning enemy groups...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];

// INFANTRY
// Regular squads
_eligibleInf = [8, _infGroups] call DAKKA_fnc_filterInfantryGroups;
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleInf,/*_groupsAmount*/ 3,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 8,/*_skill*/ [1, 2] call BIS_fnc_randomInt,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_enemyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// AT Teams
_eligibleAT = [4, _infGroups] call DAKKA_fnc_filterATteamGroups;
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAT,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_enemyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// AA Teams
_eligibleAA = [4, _infGroups] call DAKKA_fnc_filterAAteamGroups;
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleAA,/*_groupsAmount*/ 1,/*_maxUnits*/ 0,/*_limitPresence*/ false,/*_minUnits*/ 4,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_enemyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// SF groups
_eligibleSF = [6, _SFGroups, _infGroups] call DAKKA_fnc_filterSFGroups;
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Infantry",/*_groupsPool*/ _eligibleSF,/*_groupsAmount*/ 1,/*_maxUnits*/ 6,/*_limitPresence*/ true,/*_minUnits*/ 4,/*_skill*/ 2,/*_sameEdCat*/ false] call DAKKA_fnc_addGroupsToTaskData;

// LAND
// Armor
_eligibleArmor = [];
if (count _armorGroups > 0) then {
    _eligibleArmor = [_armorGroups] call DAKKA_fnc_filterArmorGroups;
    if (count _eligibleArmor > 0) then {
        [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _eligibleArmor,/*_groupsAmount*/ 1,/*_maxUnits*/ 2,/*_limitPresence*/ true,/*_minUnits*/ 1] call DAKKA_fnc_addGroupsToTaskData;
    };
};

// Mechanized infantry
if (count _mechGroups > 0) then {
    _eligibleMech = [_mechGroups] call DAKKA_fnc_filterMechGroups;
    _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 4 } else { 2 };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _mechGroups,/*_groupsAmount*/ _amount] call DAKKA_fnc_addGroupsToTaskData;
};

// Motorized infantry, if there's no mech inf
if (count _motGroups > 0 && count _mechGroups == 0) then {
    _eligibleMot = [_motGroups] call DAKKA_fnc_filterMotGroups;
    _amount = if (count _eligibleArmor == 0 || count _selectedArtyGroup == 0) then { 5 } else { 1 };
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Land Vehicles",/*_groupsPool*/ _motGroups,/*_groupsAmount*/ _amount] call DAKKA_fnc_addGroupsToTaskData;
};

// AIR
// Air units
if (count _airGroups > 0) then {
    _eligibleAir = [_airGroups] call DAKKA_fnc_filterAirGroups;
    if (count _eligibleAir > 0) then {
        if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleAir enemy: %1", _eligibleAir] };
        [/*_sideType*/ "Enemy groups",/*_groupType*/ "Air Vehicles",/*_groupsPool*/ _eligibleAir,/*_groupsAmount*/ 1,/*_maxUnits*/ 1] call DAKKA_fnc_addGroupsToTaskData;
    };
};


// -------------------------------------------------------------------------------------
// LOCATIONS
_txt = "Picking AO locations...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Play Now - %1", _txt];
_locationsPredefined = call compile format ["DAKKA_locations_Task%1", _task];
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
    if (DAKKA_debug) then { diag_log format ["%1:", _x select 0] };
    {
        if (DAKKA_debug) then { diag_log format ["%1: %2", _forEachIndex, _x] };
    } forEach (_x select 1);
} forEach _taskData;


// -------------------------------------------------------------------------------------
// Initiate task
call DAKKA_fnc_missionEditTerminate;
