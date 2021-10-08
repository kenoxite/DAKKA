// PLAY NOW - TASK 1

#include "..\..\control_defines.hpp";

params ["_playerFaction", "_enemyFaction", "_factionGroupsFriendly", "_factionGroupsEnemy", "_display", "_ctrl"];

// Retrieve data for this task
_task = DAKKA_Task;
_taskData = DAKKA_TaskData select (_task - 1);

// -------------------------------------------------------------------------------------
// FRIENDLY GROUPS
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
_transportHeloGroupsCustom =  _allGroupsCustom select 6;

// -------------------------------------------------------------------------------------
// PLAYER GROUP
_playerGroup = [];
_eligiblePlayerGroups = [];
if (count _SFGroups > 0) then {
    // Select SF group
    // Pick a group with 6 or more members
    _eligiblePlayerGroups = _SFGroups select { (count (_x select 0)) >= 6 && (count (_x select 0)) <= 9 };
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
        _eligiblePlayerGroups = _infGroups select { (count (_x select 0)) >= 6 && (count (_x select 0)) <= 9 };
        if (count _eligiblePlayerGroups > 0) then {
            _playerGroup = selectRandom _eligiblePlayerGroups;
        } else {
            // Otherwise pick one randomly
            _playerGroup = selectRandom _infGroups;
        };
    };
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

// Pick a getaway car
    _fnc_filterGetawayCarGroups = {
    params ["_unitCount", "_motGroups"];
    private _eligibleGetawayCars = [];
    // Select motorized groups with _unitCount vehicle
    private _eligibleGetawayCarsAll = +_motGroups;
    private _eligibleGetawayCarsValid = [];
    {
        private _group = _x;
        private _units = _x select 0;
        private _vehCount = 0;
        {
            if !([_x] call DAKKA_fnc_isMan) then { _vehCount = _vehCount + 1 };
        } forEach _units;
        if (_vehCount <= _unitCount) then {
            _eligibleGetawayCarsValid pushBack _group;
        };
    } forEach _eligibleGetawayCarsAll;
    _eligibleGetawayCarsAll = +_eligibleGetawayCarsValid;
    if (count _eligibleGetawayCarsAll > 0) then {
         _eligibleGetawayCars = +_eligibleGetawayCarsAll;
    } else {
        _eligibleGetawayCars = +_motGroups;
    };

    _eligibleGetawayCars
    };
_eligibleGetawayCars = [1, _motGroups] call _fnc_filterGetawayCarGroups;
if (count _eligibleGetawayCars > 0) then {
    // [/*_sideType*/ "Friendly groups",/*_groupType*/ "Patrols",/*_groupsPool*/ _eligiblePatrolCars,/*_groupsAmount*/ 0.5 + floor (random (1.5)),/*_maxUnits*/ 2,/*_limitPresence*/ true,/*_minUnits*/ 1,/*_skill*/ 0,/*_sameEdCat*/ false] call DAKKA_fnc_addGroupsToTaskData;
};

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

    _artyLimit = 1;
    _artyGroupData set [0, [_artyLimit]];
    _thisArtyGroupData = ["Artillery Group", [], []];
    {
        (_thisArtyGroupData select 1) pushBack [_x, if (_forEachIndex == 0) then {"SERGEANT"} else {"PRIVATE"}, [], 1, 2];
    } forEach _selectedArtyGroup;
    _artyGroupData set [1, [_thisArtyGroupData]];
};

// Transport
// Only if player is leader
if (_playableUnit == 0) then {
    _selectedTransportGroup = [];
    // Check faction units for suitable air transport
    _factionTransport = [_playerFaction, "Air Transport"] call DAKKA_fnc_categorizeUnits;
    private _transportGroups = [];
    {
        private _grps = _x select 1;
        {
            _transportGroups pushBack _x;
        } forEach _grps;
    } forEach _factionTransport;

    _transportGroups append _transportHeloGroupsCustom;

    {
        if (DAKKA_debug) then { diag_log format ["DAKKA: Play Now: _transportGroups %1: %2", _forEachIndex, _x select 0] };
    } forEach _transportGroups;

    if (!isNil "_factionTransport" || count _transportGroups > 0) then {
        _availableTransportUnits = [];
        // Check that the amount of passenger seats is enough to carry the player group
        {
            private _vehClass = if (typeName (_x select 0) == "ARRAY") then {
                (_x select 0) select 0
            } else {
                _x select 0
            };
            _passengerSeats = [_vehClass] call DAKKA_fnc_countPassengerSeats;
            diag_log format ["DAKKA: Play Now - %1 has %2 passenger seats and the player group is %3", _vehClass, _passengerSeats, _playerGroupCount];
            if (_passengerSeats >= _playerGroupCount) then {
                _availableTransportUnits pushBackUnique _vehClass;
            };
        } forEach _transportGroups;
        if (DAKKA_debug) then { diag_log format ["DAKKA: Play Now - _availableTransportUnits: %1", _availableTransportUnits] };

        if (count _availableTransportUnits > 0) then {
            _selectedTransportUnit = selectRandom _availableTransportUnits;
            _selectedTransportGroup pushBack _selectedTransportUnit;
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

// PATROLS
_eligiblePatrols = [4, _infGroups] call DAKKA_fnc_filterPatrolGroups;
// if (DAKKA_debug) then { diag_log format ["DAKKA: _eligiblePatrols: %1", _eligiblePatrols] };
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Patrols",/*_groupsPool*/ _eligiblePatrols,/*_groupsAmount*/ 3 + (floor (random 3)),/*_maxUnits*/ 4,/*_limitPresence*/ true,/*_minUnits*/ 2,/*_skill*/ 0,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_enemyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;

// Pick a car as another patrol
_eligiblePatrolCars = [1, _motGroups] call DAKKA_fnc_filterPatrolCarGroups;
// if (DAKKA_debug) then { diag_log format ["DAKKA: _eligiblePatrolCars: %1", _eligiblePatrolCars] };
if (count _eligiblePatrolCars > 0) then {
    [/*_sideType*/ "Enemy groups",/*_groupType*/ "Patrols",/*_groupsPool*/ _eligiblePatrolCars,/*_groupsAmount*/ 0.5 + floor (random (1.5)),/*_maxUnits*/ 2,/*_limitPresence*/ true,/*_minUnits*/ 1,/*_skill*/ 0,/*_sameEdCat*/ false] call DAKKA_fnc_addGroupsToTaskData;
};

// DEFENDERS
_eligibleDefenders = [8, _infGroups] call DAKKA_fnc_filterDefenderGroups;
// if (DAKKA_debug) then { diag_log format ["DAKKA: _eligibleDefenders: %1", _eligibleDefenders] };
[/*_sideType*/ "Enemy groups",/*_groupType*/ "Defenders",/*_groupsPool*/ _eligibleDefenders,/*_groupsAmount*/ 1 + (floor (random 2)),/*_maxUnits*/ 9,/*_limitPresence*/ true,/*_minUnits*/ 4,/*_skill*/ 1,/*_sameEdCat*/ true,/*_edCat*/ DAKKA_enemyInfEdCat] call DAKKA_fnc_addGroupsToTaskData;


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
// call DAKKA_fnc_missionEditTerminate;

// _ctrl ctrlShow false;
// Close main menu
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
call DAKKA_fnc_cameraIntroTerminate;
waitUntil {!DAKKA_cameraIntroPlaying};
_display = findDisplay IDC_MENU_MISSION_EDIT;

{ (_display displayCtrl _x) ctrlShow false } forEach [IDC_GRP_MAINMENU, IDC_BACKG_TASK, IDC_GRP_BACKG_MAIN, IDC_GRP_AO_SELECTION, IDC_GRP_AO_MAP_CONTROLS, IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, IDC_IMG_MAPCROSSHAIR, IDC_BT_PREVIEW, IDC_GRP_BOTTOMBAR_BCKG, IDC_GRP_SUPPORT, IDC_GRP_FACTION_GROUPS, IDC_GRP_CAMERA_PREVIEW, IDC_TXT_TIPS, IDC_GRP_TASK_GROUPS, IDC_TITLE_SAVEDDATAPROFILES];
{ (_display displayCtrl _x) ctrlShow true } forEach [IDC_GRP_TASK_DESCRIPTION, IDC_GRP_LEFTBAR_BCKG, IDC_TITLE_TASK_DESCRIPTION_GROUP, IDC_TXT_TASK_DESCRIPTION_GROUP, IDC_GRP_NAV_BUTTONS];

// TASK DESCRIPTION
_ctrl = (_display displayCtrl IDC_TITLE_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText format ["TASK %1: %2\n%3%4", DAKKA_Task,
    toUpper (call compile format ["DAKKA_Task%1_Title", DAKKA_Task]),
    "→      ",
    "CREATE PLAYER GROUP"
    ];
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TXT_TASK_DESCRIPTION_GROUP);
_ctrl ctrlSetText call compile format ["DAKKA_Task%1_Desc_Editor", DAKKA_Task];
_ctrl ctrlEnable false;

// [] execVM "menuPages\page7.sqf";

[6, true] call DAKKA_fnc_buttonChangePage;