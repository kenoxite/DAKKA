// TASK 2
// Init

#include "..\..\control_defines.hpp";

private _display = findDisplay IDC_LOADING_SCREEN;
private _ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

[] spawn DAKKA_fnc_cameraIntro;
cutText ["", "BLACK IN", 999];
enableRadio false;

// Make group icons visible
setGroupIconsVisible [true, false]; 

// Mission global variables
DAKKA_task2_locPos = [];
DAKKA_task2_locDir = 0;
DAKKA_startPos_O = [];
DAKKA_B_InfGrps = [];
DAKKA_B_LandGrps = [];
DAKKA_B_AirGrps = [];
DAKKA_O_InfGrps = [];
DAKKA_O_LandGrps = [];
DAKKA_O_AirGrps = [];

// Select a random AO location
_ctrl ctrlSetText format ["Choosing AO location...", ""]; 
_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_categoryData = _locationsData select 0;
_categoryLocations = _categoryData select 1;
_locationIndex = if (count _categoryLocations > 1) then {
                [0, (count _categoryLocations) - 1] call BIS_fnc_randomInt;
            } else {
                0;
            };
DAKKA_task2_locPos = (_categoryLocations select _locationIndex) select 0;
DAKKA_task2_locDir = (_categoryLocations select _locationIndex) select 1;
if (count DAKKA_task2_locPos < 3) then { DAKKA_task2_locPos pushBack 0 };
_txt = format ["Initializing Location %1", _locationIndex + 1];
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Task 2 - %1", _txt];

// FUNCTIONS
DAKKA_relPosRefObj = "Flag_BI_F" createVehicle DAKKA_task2_locPos;
DAKKA_relPosRefObj setDir DAKKA_task2_locDir;
DAKKA_relPosRefObj setPos DAKKA_task2_locPos;
DAKKA_relPosRefObj hideObject true;
// Return relative position at the given distance and at the sides of the location center
_fnc_getSpawnPos = {
    params ["_posLoc", "_relDist", "_distLoc", "_relDir"];
    // private _relDir = if (_relDist > 0) then { 90 } else { -90 };
    // private _relPosH = [_posLoc, _relDist, _relDir] call BIS_fnc_relPos;
    DAKKA_relPosRefObj setPos DAKKA_task2_locPos;
    private _relPosH = DAKKA_relPosRefObj getRelPos [_relDist, _relDir];
    DAKKA_relPosRefObj setPos _relPosH;
    // [_relPosH, _distLoc, DAKKA_task2_locDir] call BIS_fnc_relPos
    // _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_relposH", _relPosH, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 1, ""] call BIS_fnc_stringToMarker;
    DAKKA_relPosRefObj getRelPos [_distLoc, 0]
};

_fnc_getcitylimits =
// finds citylimits for the position given
// if 2nd param is true, script will concentrate more on actual houses
// returns the radius of the city limits and the house count within that
{
private ["_locpos","_countonlyhouses","_oldringshousecount","_rads","_houses","_dummyhouses","_ringhousecount","_allhousecount", "_finalhousecount", "_myradius", "_rings", "_foundhouses", "_myhouse", "_excludedbuildings", "_exitit", "_previousringhousecount", "_excludedcount",  "_previousringhousecount", "_excludedcount"];
params ["_locpos", "_countonlyhouses"];
_locpos set [2,0];
_ringhousecount = 0;_oldringshousecount = 0;_previousringhousecount = 0;_rads = 300;_finalhousecount = 0; _excludedcount = 0;
_excludedbuildings = ["Land_TTowerSmall_1_F", "Land_Dome_Big_F", "Cargo_Patrol_base_F", "Cargo_House_base_F", "Cargo_Tower_base_F", "Cargo_HQ_base_F","Piers_base_F", "PowerLines_base_F", "PowerLines_Wires_base_F", "PowerLines_Small_base_F", "Land_PowerPoleWooden_L_F",  /*"Lamps_base_F",*/ "Land_Research_HQ_F", "Land_Research_house_V1_F", "Land_MilOffices_V1_F", "Land_TBox_F", "Land_Chapel_V1_F","Land_Chapel_Small_V2_F",  "Land_Chapel_Small_V1_F", "Land_BellTower_01_V1_F", "Land_BellTower_02_V1_F", "Land_fs_roof_F","Land_fs_feed_F", "Land_Windmill01_ruins_F", "Land_d_Windmill01_F", "Land_i_Windmill01_F","Land_i_Barracks_V2_F", "Land_spp_Transformer_F", "Land_dp_smallFactory_F", "Land_Shed_Big_F", "Land_Metal_Shed_F","Land_i_Shed_Ind_F","Land_Communication_anchor_F", "Land_TTowerSmall_2_F", "Land_Communication_F","Land_cmp_Shed_F", "Land_cmp_Tower_F", "Land_u_Shed_Ind_F", "Land_TBox_F"];
for "_myradius" from 75 to 450 step 75 do
    {
    _houses = []; _excludedcount = 0;
    _dummyhouses = (_locpos nearObjects ["House_F", _myradius]);
        {
        if (_countonlyhouses) then
            {
            _myhouse = _x;_exitit = false;
                {

                if (_myhouse isKindOf _x) exitWith {_exitit = true};
                } foreach _excludedbuildings;
            if (_exitit) then {/*diag_log format ["%1 excluded because is %2", typeof _myhouse, _x];*/ _excludedcount = _excludedcount +1;} else {_houses pushBack _myhouse;};

            } else {_houses = _dummyhouses};
        } foreach _dummyhouses;

    _allhousecount = (count _houses);
    _ringhousecount = _allhousecount - _oldringshousecount;
    //diag_log format ["houses count = %1 at ring %2 meters", _ringhousecount, _myradius];
    if ((_ringhousecount < _previousringhousecount) and (_myradius > 99)) exitWith {_rads = _myradius; _finalhousecount = _ringhousecount; };
    _oldringshousecount = _oldringshousecount +  _ringhousecount;
    _previousringhousecount = _ringhousecount;
    };
[_rads, _finalhousecount]
};

_nearestLocations = nearestLocations [DAKKA_task2_locPos, ["CityCenter","NameCityCapital", "NameCity", "NameVillage"], 300];
_inTown = if (count _nearestLocations > 0) then { true } else { false };

// COMPOSITIONS
_compositions = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_thisWorldCompositions = [_compositions, worldName] call BIS_fnc_getFromPairs;
_compAmount = 0;
if (DAKKA_automated || (!DAKKA_automated && isNil "_thisWorldCompositions")) then {
    _txt = "Generating compositions...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DAKKA: Task 2 - %1", _txt];
    // Delete existing ones first
    [true] call DAKKA_fnc_compositionRemove;
    waitUntil {DAKKA_compositionsRemoved};
    // Load default compositions
    #include "..\..\compositions_default.hpp";
    #include "..\..\compositions_CUP.hpp";
    // Use CUP compositions if that mod is loaded
    _fnc_CUPcheck = {
        private _CUPtest = "FlagCarrierTakistanKingdom_EP1" createVehicle [0,0,0];
        private _CUP = if (!isNull _CUPtest) then { true } else { false };
        [_CUPtest] spawn { deleteVehicle (_this select 0) };
        _CUP
    };
    _compositionsPredefined = [];
    if (call _fnc_CUPcheck) then { _compositionsPredefined = +_compositions_CUP } else { 
    _compositionsPredefined = +_compositions_default };

    _locationsPredefined = DAKKA_locations_Task2;
    // Amount of compositions should match amount of predefined locations
    _taskLocations = [_locationsPredefined, "Contested Areas"] call BIS_fnc_getFromPairs;
    _compAmount = if (_inTown) then { 3 } else { 5 };
    _selectedCompositions = [];
    {
        for [{private _i = 0}, {_i < _compAmount}, {_i = _i + 1}] do
        {
            private _coords = _x select 0;
            // if (DAKKA_debug) then { diag_log format ["_coords: %1", _coords] };
            private _dir = _x select 1;
            private _comp = +selectRandom _compositionsPredefined;
            private _compName = _comp select 0;
            private _newName = format ["%1 %2", _compName, _forEachIndex + 1];
            _comp set [0, _newName];
            // if (DAKKA_debug) then { diag_log format ["_selectedComposition: %1", _compName] };
            private _compData = _comp select 1;
            private _ref = _compData select 0;
            private _refPosOriginal = [_coords select 0, _coords select 1, 0];
            _ref set [1, _refPosOriginal];
            _ref set [2, _dir];
            // _ref set [2, floor(random 360)];
            _selectedCompositions pushBack _comp;
        };
    } forEach _taskLocations;

    // Add compositions data to tasks array
    // _compositions = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    // _thisWorldCompositions = [_compositions, worldName] call BIS_fnc_getFromPairs;
    if (isNil "_thisWorldCompositions") then {
        // Add terrain data and include the predefined compositions
        _newArr = [worldName, _selectedCompositions];
        [_taskData, "Compositions", [_newArr]] call BIS_fnc_addToPairs;
    } else {
        // Add predefined compositions to current terrain
        [_compositions, worldName, _selectedCompositions] call BIS_fnc_setToPairs
    };

    // {
    //     if (DAKKA_debug) then { diag_log format ["%1: %2", _x select 0, _x select 1] };
    // } forEach _selectedCompositions;

    // Load compositions
    _compPos = [[[DAKKA_task2_locPos, 50]],["water"], {!isOnRoad _this}] call BIS_fnc_randomPos;
    if (count _compPos < 3) then { _compPos = DAKKA_task2_locPos };
    [_compAmount, _compPos] call DAKKA_fnc_compositionLoad;

    // Enable simulation for all composition objects
/*        _nul = [_compAmount] spawn {
            params ["_compAmount"];
            _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
            _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
            _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
            if (!isNil "_compositionsData") then {
                waitUntil { DAKKA_compositionsLoaded == _compAmount };

                {
                    _compObjects = +_x select 1;
                    _compObjects deleteAt 0;
                    {
                        _obj = _x select 0;
                        _obj enableSimulation true;
                        // _obj setVelocity [0, 0, 0];
                        _obj allowDamage true;
                    } forEach _compObjects;
                } forEach _compositionsData;
            };
        }; */

    if (DAKKA_debug) then {
        call DAKKA_fnc_mapDisplayCompositions;
    };
};

// Find a start position
_txt = "Finding starting positions....";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Task 2 - %1", _txt];
_startPos_B = DAKKA_task2_locPos getPos [-500, DAKKA_task2_locDir];
_startPos_O = DAKKA_task2_locPos getPos [500, DAKKA_task2_locDir];
DAKKA_startPos_O = _startPos_O;

_txt = "Spawning player group...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Task 2 - %1", _txt];
_dir = [_startPos_B, DAKKA_task2_locPos] call BIS_fnc_dirTo;
p1 setPos _startPos_B;
DAKKA_PlayerNewGroup = [_startPos_B] call DAKKA_fnc_setPlayerGroup; 
if (isNull DAKKA_PlayerNewGroup) then { diag_log ["DAKKA: Task 2 --- ERROR --- Could not create DAKKA_PlayerNewGroup!", ""]; terminate _thisScript};
// Reposition land vehicles in player group to friendly land vehicles spawn area
_playerIsInf = true;
_playerIsLand = false;
_playerIsAir = false;
{
    private _veh = vehicle _x;
    // Player in land vehicle
    if (!([_veh] call DAKKA_fnc_isMan) && !([_veh] call DAKKA_fnc_isAir)) then {
        // private _pos = [DAKKA_task2_locPos, -750, DAKKA_task2_locDir] call BIS_fnc_relPos;
        private _pos = [DAKKA_task2_locPos, round(random 500), -750, 90 * (selectRandom [0,1]*2-1)] call _fnc_getSpawnPos;
        if (_x == effectiveCommander _veh) then {
            _veh setVehiclePosition [_pos, [], (sizeOf (typeOf _veh) + 100), "NONE"];
        };
        _playerIsInf = false;
        _playerIsLand = true;
    };
} forEach (units DAKKA_PlayerNewGroup);

if (_playerIsInf) then {
    // Reposition air vehicles in player group to friendly air vehicles spawn area
    {
        private _veh = vehicle _x;
        if ([_veh] call DAKKA_fnc_isAir) then {

            private _pos = [(DAKKA_task2_locPos select 0) + (floor random 200), (DAKKA_task2_locPos select 1), 2000] getPos [-5000, DAKKA_task2_locDir];
            if (_x == effectiveCommander _veh) then {
                _veh setVehiclePosition [[_pos select 0, _pos select 1, 5000], [], (sizeOf (typeOf _veh) + 100), "FLY"];
                [_veh] spawn {
                    params ["_veh"];
                    _veh allowDamage false;
                    while {visibleMap} do {
                        _veh setVelocity [0,0,0];
                        sleep 0.01;
                    };
                    _veh allowDamage true;
                };
            };
            _playerIsInf = false;
            _playerIsAir = true;
        };
    } forEach (units DAKKA_PlayerNewGroup);
};

{ (vehicle _x) setDir _dir; (vehicle _x) lookAt DAKKA_task2_locPos;} forEach (units DAKKA_PlayerNewGroup);
p1 lookAt DAKKA_task2_locPos;
if (_playerIsInf) then {
    DAKKA_B_InfGrps pushBack DAKKA_PlayerNewGroup;
};
if (_playerIsLand) then {
    DAKKA_B_LandGrps pushBack DAKKA_PlayerNewGroup;
};
deleteWaypoint [DAKKA_PlayerNewGroup, 0];
[p1, [], 2] call DAKKA_fnc_prepareUnit;

// CREATE TASKS
_ctrl ctrlSetText format ["Creating tasks...", ""];
// Task 2 (main)
_title = call compile format ["DAKKA_Task%1_Title", DAKKA_Task];
_description = call compile format ["DAKKA_Task%1_Desc_Short", DAKKA_Task];
_marker = "";
_task2 = [DAKKA_PlayerNewGroup, "DAKKA_Task2", [_description, _title, _marker], objNull, "ASSIGNED", -1, false, "move2", false] call BIS_fnc_taskCreate;
// Task 2-1
_title = "Stop the enemy";
_description = "Force the enemy to retreat from the <marker name='DAKKA_mrkr_Task2_location_area'>contested area</marker>";
_marker = "";
_task2_1 = [DAKKA_PlayerNewGroup, ["DAKKA_Task2_1", "DAKKA_Task2"], [_description, _title, _marker], DAKKA_task2_locPos, "CREATED", -1, false, "attack", false] call BIS_fnc_taskCreate;

// SUPPORT
_txt = "Spawning support groups...";
_ctrl ctrlSetText _txt; 
diag_log format ["DAKKA: Task 2 - %1", _txt];
_basePos = getPos DAKKA_officer;
_friendlyLinesPos = DAKKA_task2_locPos getPos [-750, DAKKA_task2_locDir];
[[
    ["Artillery", _friendlyLinesPos, 10, ["DAKKA_mrkr_Task2_location_area", "DAKKA_mrkr_Task2_location_area_enemy", "DAKKA_mrkr_Task2_location_area_friendly"]],
    ["CAS", [0,0,0]],
    ["Air Transport", _friendlyLinesPos, 1000, ["DAKKA_mrkr_Task2_location_area", "DAKKA_mrkr_Task2_location_area_enemy", "DAKKA_mrkr_Task2_location_area_friendly"]]
]] call DAKKA_fnc_spawnSupport;

DAKKA_playerGroupReady = true;

// CREATE MARKERS
_ctrl ctrlSetText format ["Creating markers...", ""];
// Contested area
_txt = "Contested Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_Task2_location_area", DAKKA_task2_locPos, "empty", "RECTANGLE", [250, 250], DAKKA_task2_locDir, "FDiagonal", "ColorEAST", 0.8, _txt] call BIS_fnc_stringToMarker;
// Friendly spawn area
_posFriednlyMrkr = DAKKA_task2_locPos getPos [-300, DAKKA_task2_locDir];
_txt = "Friendly Spawn Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_Task2_location_area_friendly", _posFriednlyMrkr, "empty", "RECTANGLE", [250, 300], DAKKA_task2_locDir, "Border", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
// Enemy spawn area
_posEnemyMrkr = DAKKA_task2_locPos getPos [300, DAKKA_task2_locDir];
_txt = "Enemy Spawn Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_Task2_location_area_enemy", _posEnemyMrkr, "empty", "RECTANGLE", [250, 300], DAKKA_task2_locDir, "Border", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;
// Enemy advancement
_pos_AdvEnemy = [DAKKA_task2_locPos, 250, 200, 0] call _fnc_getSpawnPos;
_ref = "Flag_BI_F" createVehicle _pos_AdvEnemy;
_ref hideObject true;
_txt = "";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DAKKA_mrkr_Task2_enemy_advancement", _pos_AdvEnemy, "mil_arrow", "ICON", [3, 3], (_ref getRelDir DAKKA_task2_locPos), "Solid", "ColorEAST", 0.5, _txt] call BIS_fnc_stringToMarker;
deleteVehicle _ref;

// Prepare location and time texts
private _infoTextData = [DAKKA_task2_locPos] call DAKKA_fnc_showInfoText;
private _locationStr = _infoTextData select 0;
private _missionTime = _infoTextData select 1;
private _location = format ["Battle of %1", _locationStr];
if (_locationStr == "") then {
    private _location_prefix = selectRandom [
                "",
                "Dashing",
                "Rash",
                "Fierce",
                "Strong",
                "Lame",
                "Hunter",
                "Little",
                "Dank",
                "Lightning",
                "Raw",
                "Slow"
                ];
    private _location_suffix = selectRandom [
                " Ridge",
                " Hill",
                " Road",
                " Rock",
                " Race",
                "bridge",
                "more",
                "land",
                "boar",
                "tiger",
                "dragon",
                "horse",
                "pike"
                ];
    _location = format ["Battle of %1%2", _location_prefix, _location_suffix];
}; 

// BRIEFING
private _playerFaction = DAKKA_PlayerFactions select 1;
private _enemyFaction = DAKKA_EnemyFactions select 1;
private _playerFactionName = getText (configFile >> "CfgFactionClasses" >> _playerFaction >> "displayName");
private _enemyFactionName = getText (configFile >> "CfgFactionClasses" >> _enemyFaction >> "displayName");
private _terrainName = getText (configFile >> "CfgWorlds" >> worldName >> "description");

_enemyForces = format ["<font face='RobotoCondensedBold'>%1</font> forces approach fast and strong in a <font face='RobotoCondensedBold'>combined arms</font> fashion. We can expect anything from <font face='RobotoCondensedBold'>soft to heavy armored</font> vehicles. Air units aren't to be discarded.<br/><br/>This is a force to be reckoned with.", _enemyFactionName];
player createDiaryRecord ["Diary", ["Enemy Forces", _enemyForces], taskNull, "", false];

_situation = format ["<font color='#FF8C00' size='20' face='RobotoCondensedBold'>%1</font><br/><br/><font face='RobotoCondensedBold'>%2</font> forces are making <marker name='DAKKA_mrkr_Task2_enemy_advancement'>hasty advance</marker> towards <marker name='DAKKA_mrkr_Task2_location_area'>%3</marker>. This site is of extremely strategic importance to keep our hold of <font face='RobotoCondensedBold'>%4</font>.<br/><br/>We need to push our way through the contested area and either <font face='RobotoCondensedBold'>eliminate all enemy forces</font> found there or <font face='RobotoCondensedBold'>fully deter their advancement</font>.", toUpper (_location), _enemyFactionName, if (_locationStr == "") then { "this area" } else { _locationStr }, _terrainName];
if (_inTown) then { _situation = format ["%1<br/><br/>Sweep the area for enemies. The enemy will surely try to <font face='RobotoCondensedBold'>garrison some of %2's buildings</font> and mount a defensive position there.", _situation, _locationStr]; };
player createDiaryRecord ["Diary", ["Situation", _situation], taskNull, "", false];

// Hide marta markers
DAKKA_martaHide pushBack DAKKA_PlayerNewGroup;
p1 setVariable ["MARTA_hide", DAKKA_martaHide];
// Show map
call DAKKA_fnc_cameraIntroTerminate;
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
_shownHUD = shownHUD;
showHUD [false, false, false, false, false, false, false, false, false];
showWatch false;
showCompass false;
showGPS false;
disableMapIndicators [true, true, true, true];
openMap true;
[[1500, 1500], markerPos "DAKKA_mrkr_Task2_location_area", 0] call BIS_fnc_zoomOnArea;
hintSilent "Close the map to start the task";
// Stop time
_initdate = date;
while {visibleMap} do
{
    setdate _initdate;
    sleep 0.5;
}; 
// waitUntil { !visibleMap };
// deleteMarker "DAKKA_mrkr_Task2_enemy_advancement";
hintSilent "";
cutText ["", "BLACK IN", 5];
// Restart loading screen
_loadingScreen = createDialog "DAKKA_Loading_Screen";
waitUntil {_loadingScreen};
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);
[DAKKA_task2_locPos] call DAKKA_fnc_cameraIntro;
showHUD _shownHUD;
showWatch true;
showCompass true;
showGPS true;
disableMapIndicators [false, false, false, false];
DAKKA_martaHide = DAKKA_martaHide - [DAKKA_PlayerNewGroup];
p1 setVariable ["MARTA_hide", DAKKA_martaHide];

// Music
0 fadeMusic 0.5;

["initialize",
    [
        [ // stealth
            "LeadTrack06_F_EPC",
            "EventTrack03_F_EPB",
            "AmbientTrack04_F",
            "EventTrack03a_F_EPB"
        ],
        [ // combat
            "AmbientTrack01a_F_Tacops",
            "EventTrack01a_F_Tacops",
            "EventTrack01b_F_Tacops",
            "EventTrack02a_F_Tacops",
            "EventTrack02b_F_Tacops",
            "EventTrack03a_F_Tacops",
            "EventTrack03b_F_Tacops"
        ],
        [ // safe
        ],
        0.5, // volume
        5, // transition
        500, // radius
        5, // execution rate
        true // no repeat
    ]
] call BIS_fnc_jukebox;

_startingMusic = selectRandom [
    "LeadTrack04_F_EPC",
    "AmbientTrack01a_F_Tacops",
    "EventTrack01a_F_Tacops",
    "EventTrack01b_F_Tacops",
    "EventTrack02a_F_Tacops",
    "EventTrack02b_F_Tacops",
    "EventTrack03a_F_Tacops",
    "EventTrack03b_F_Tacops"
    ];
// ["playMusic", [_startingMusic]] call BIS_fnc_jukebox;
playMusic _startingMusic;

// Prepare safe empty positions array
// diag_log "DAKKA: Task 2 - Preparing safe empty positions";
// _ctrl ctrlSetText format ["Looking for safe positions...", ""];
// _ready = DAKKA_task2_locPos findEmptyPositionReady [250, 1000];
// waitUntil { _ready };

    _txt = "Spawning enemy groups...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DAKKA: Task 2 - %1", _txt];
    // DAKKA_Task2_SafePositions = (selectBestPlaces [getMarkerPos "DAKKA_mrkr_Task2_location_area_enemy", 250, "meadow + 2*hills", 50, 50] apply { _x select 0 }) select { !surfaceIsWater _x && (count (nearestTerrainObjects [_x, [], 10])) < 1; }; 
	_enemyGroups = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;
    
    _maxRowDist = 200;

    // Ememy infantry
	_O_InfGrps = +(_enemyGroups select 0) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
	for [{private _i = 0}, {_i < count _O_InfGrps}, {_i = _i + 1}] do {
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        // Spawn closer if in town location
        _spawnDist = if (_inTown) then { 200 } else { 400 };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DAKKA_task2_locPos, _relDist, _spawnDist, _relDir] call _fnc_getSpawnPos;
		_grp = [(_O_InfGrps select _i) select 1, _spawnPos, east, 30] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning enemy infantry #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
		if (!isNull _grp) then {
            DAKKA_O_InfGrps pushBack _grp;
            // [_grp, [_spawnPos, -(_spawnDist), DAKKA_task2_locDir] call BIS_fnc_relPos, 0, -1, "", "MOVE", "AWARE", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT""; [getPos this, thisList select [0, (floor (random (count thisList))) max 1], 50, true, true, false, true] call DAKKA_fnc_occupyHouse;"]] call DAKKA_fnc_GroupWp;

            _destination = _spawnPos getPos [100, DAKKA_task2_locDir];
            // Fix for when AI refuses to move
            (units _grp) doFollow (leader _grp);
            (effectiveCommander (vehicle leader _grp)) doMove _destination;

            // Move close to contested
            [_grp, _destination, 0, -1, "", "MOVE", "AWARE", "NORMAL", "LINE", "RED", 25, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, _spawnPos getPos [-(_spawnDist), DAKKA_task2_locDir], 0, -1, "", "MOVE", "COMBAT", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", false, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT""; _unusedUnits = [getPos this, thisList select [0, (floor (random (count thisList))) max 1], 50, true, true, false, true] call DAKKA_fnc_occupyHouse; [getPos this, _unusedUnits, 100, true, true, false, true] call DAKKA_fnc_occupyHouse;"]] call DAKKA_fnc_GroupWp;
		};
		sleep 0.001;
	}; 

    // Ememy land vehicles
    _O_LandGrps = +(_enemyGroups select 1) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
    for [{private _i = 0}, {_i < count _O_LandGrps}, {_i = _i + 1}] do {
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        // Spawn ahead of infantry to try to avoid roadkills
        _spawnDist = if (_inTown) then { 200 } else { 300 };
        if (count DAKKA_O_InfGrps == 0) then {
            // Allow to spawn further if there's no inf
            _spawnDist = 400;
        };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DAKKA_task2_locPos, _relDist, _spawnDist, _relDir] call _fnc_getSpawnPos;
        _grp = [(_O_LandGrps select _i) select 1, _spawnPos, east, 50, true, _enemyFaction] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning enemy land vehicles #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
        if (!isNull _grp) then {
            DAKKA_O_LandGrps pushBack _grp;
            _wpDist = if (count DAKKA_O_InfGrps == 0) then {
                            150
                        } else {
                            50
                        };

            _destination = _spawnPos getPos [-50, DAKKA_task2_locDir];
            // Fix for when AI refuses to move
            (units _grp) doFollow (leader _grp);
            (effectiveCommander (vehicle leader _grp)) doMove _destination;

            // [_grp, [DAKKA_task2_locPos, _wpDist, DAKKA_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "COMBAT", "NORMAL", if (_inTown && (count DAKKA_O_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 100] call DAKKA_fnc_GroupWp;
            // Move close to contested area and dismount cargo
            [_grp, _destination, 0, -1, "", "UNLOAD", "AWARE", "FULL", "LINE", "RED", 50, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, _spawnPos getPos [-300, DAKKA_task2_locDir], 0, -1, "", "MOVE", "COMBAT", "NORMAL", if (_inTown && (count DAKKA_O_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 75, "", false, false, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Ememy air vehicles
    _O_AirGrps = +(_enemyGroups select 2) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
    for [{private _i = 0}, {_i < count _O_AirGrps}, {_i = _i + 1}] do {
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        _spawnDist = 5000;
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [[(DAKKA_task2_locPos select 0), (DAKKA_task2_locPos select 1), 2000], _relDist, _spawnDist, _relDir] call _fnc_getSpawnPos;
        _grp = [(_O_AirGrps select _i) select 1, _spawnPos, east, 200, true, _enemyFaction] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning enemy air vehicles #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
        if (!isNull _grp) then {
            DAKKA_O_AirGrps pushBack _grp;
            // [_grp, [_spawnPos, 150, DAKKA_task2_locDir] call BIS_fnc_relPos, 0, -1, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED"] call DAKKA_fnc_GroupWp;

            // Move close to contested
            _destination = DAKKA_task2_locPos getPos [-100, DAKKA_task2_locDir];
            [_grp, _destination, 0, -1, "", "MOVE", "AWARE", "FULL", "LINE", "RED", 100, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, DAKKA_task2_locPos getPos [500, DAKKA_task2_locDir], 0, -1, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED", 150, "", false, false, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;
        };
        sleep 0.001;
    }; 


    _txt = "Spawning friendly groups...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DAKKA: Task 2 - %1", _txt];
    // DAKKA_Task2_SafePositions = (selectBestPlaces [getMarkerPos "DAKKA_mrkr_Task2_location_area_friendly", 250, "meadow + 2*hills", 50, 50] apply { _x select 0 }) select { !surfaceIsWater _x && (count (nearestTerrainObjects [_x, [], 10])) < 1; }; 
    _friendlyGroups = [_taskData, "Friendly groups"] call BIS_fnc_getFromPairs;
    _compGrps = [];

    // Friendly infantry
    _B_InfGrps = +(_friendlyGroups select 0) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
    for [{private _i = 0}, {_i < count _B_InfGrps}, {_i = _i + 1}] do { 
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        _spawnDist = 500;
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DAKKA_task2_locPos, _relDist, -_spawnDist, _relDir] call _fnc_getSpawnPos;  
        _grp = [(_B_InfGrps select _i) select 1, _spawnPos, west, 30] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning friendly infantry #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
        if (!isNull _grp) then {
            DAKKA_B_InfGrps pushBack _grp;

            // Units of first group will be used for spawning units in compositions
            if (_i == 0) then {
                _compGrps = (_B_InfGrps select _i) select 1;
            };

            // [_grp, [_spawnPos, _spawnDist + 200, DAKKA_task2_locDir] call BIS_fnc_relPos, 0, -1, "", "SAD", "AWARE", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT"";"]] call DAKKA_fnc_GroupWp;

            _destination = _spawnPos getPos [_spawnDist - 200, DAKKA_task2_locDir];
            // Fix for when AI refuses to move
            (units _grp) doFollow (leader _grp);
            (effectiveCommander (vehicle leader _grp)) doMove _destination;

            // Move close to contested
            [_grp, _destination, 0, -1, "", "MOVE", "AWARE", "NORMAL", "LINE", "RED", 25, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, _spawnPos getPos [_spawnDist + 150, DAKKA_task2_locDir], 0, -1, "", "SAD", "COMBAT", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", false, false, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Friendly land vehicles
    _B_LandGrps =+(_friendlyGroups select 1) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
    for [{private _i = 0}, {_i < count _B_LandGrps}, {_i = _i + 1}] do {
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        // Spawn ahead of infantry to try to avoid roadkills
        _spawnDist = 350;
        if (count DAKKA_B_InfGrps == 0) then {
            // Allow to spawn further if there's no inf
            _spawnDist = 700;
        };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DAKKA_task2_locPos, _relDist, -_spawnDist, _relDir] call _fnc_getSpawnPos;
        _grp = [(_B_LandGrps select _i) select 1, _spawnPos, west, 50, true, _playerFaction] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning friendly land vehicles #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
        if (!isNull _grp) then {
            DAKKA_B_LandGrps pushBack _grp;
            _wpDist = if (count DAKKA_B_InfGrps == 0) then {
                            50
                        } else {
                            -50
                        };

            _destination = _spawnPos getPos [_spawnDist-250, DAKKA_task2_locDir];
            // Fix for when AI refuses to move
            (units _grp) doFollow (leader _grp);
            (effectiveCommander (vehicle leader _grp)) doMove _destination;
            
            // Move close to contested area and dismount cargo
            [_grp, _destination, 0, -1, "", "UNLOAD", "AWARE", "FULL", "LINE", "RED", 50, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, _spawnPos getPos [_spawnDist -_wpDist, DAKKA_task2_locDir], 0, -1, "", "MOVE", "COMBAT", "NORMAL", if (_inTown && (count DAKKA_B_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 75, "", false, false, [0,0,0], ["true", "if (behaviour this != ""COMBAT"") then { if (random 1 > 0.9) then { this globalRadio ""SentClear""; }; };"]] call DAKKA_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Friendly air vehicles
    _B_AirGrps = +(_friendlyGroups select 2) select 1;
    _row = 1;
    _relDist = 100;
    _relDir = 0;
    _rowElement = 0;
    for [{private _i = 0}, {_i < count _B_AirGrps}, {_i = _i + 1}] do {
        _relDist = 100 * _rowElement;
        if ((abs _relDist) > _maxRowDist) then {
            _relDist = 0;
            _row = _row + 1;
            _rowElement = 0;
        } else {
            if (_i %2 == 0) then {
                _rowElement = _rowElement + 1;
            };
        };
        _dirMod = if ((_rowElement % 2) == 0) then { 1 } else { -1 };
        _relDir = if (_rowElement == 0) then { 0 } else { 90 * _dirMod };
        _spawnDist = 5000;
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [[(DAKKA_task2_locPos select 0), (DAKKA_task2_locPos select 1), 2000], _relDist, -_spawnDist, _relDir] call _fnc_getSpawnPos;
        _grp = [(_B_AirGrps select _i) select 1, _spawnPos, west, 200, true, _playerFaction] call DAKKA_fnc_spawnGroup;
        _txt = format ["Spawning friendly air vehicles #%1 group %2", _i + 1, _grp];
        if (DAKKA_debug) then { _ctrl ctrlSetText _txt }; 
        diag_log format ["DAKKA: Task 2 - %1", _txt];
        if (!isNull _grp) then {
            DAKKA_B_AirGrps pushBack _grp;
            // [_grp, [_spawnPos, _spawnDist-50, DAKKA_task2_locDir] call BIS_fnc_relPos, 0, -1, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED"] call DAKKA_fnc_GroupWp;

            // Move close to contested
            _destination = DAKKA_task2_locPos getPos [100, DAKKA_task2_locDir];
            [_grp, _destination, 0, -1, "", "MOVE", "AWARE", "FULL", "LINE", "RED", 100, "", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

            // Push and search for enemies
            [_grp, DAKKA_task2_locPos getPos [-500, DAKKA_task2_locDir], 0, -1, "", "SAD", "COMBAT", "FULL", "WEDGE", "RED", 150, "", false, false, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Friendly infantry in compositions
    if (count _compGrps > 0) then {
        _nul = [_compGrps, _compAmount, _ctrl] spawn {
            params ["_compGrps", "_compAmount", "_ctrl"];
            _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
            _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
            _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
            if (!isNil "_compositionsData") then {
                waitUntil { DAKKA_compositionsLoaded == _compAmount };
                _txt = "Spawning infantry in compositions...";
                _ctrl ctrlSetText _txt; 
                diag_log format ["DAKKA: Task 2 - %1", _txt];

                for [{private _i = 0}, {_i < _compAmount}, {_i = _i + 1}] do
                {
                    _refPos = getPos (DAKKA_spawnCompRefs select _i);
                    _compGrpsTrimmed = +_compGrps;
                    _compGrpsTrimmed resize (2 + floor (random 2));
                    { _x set [4, 0] } forEach _compGrpsTrimmed;
                    _grp = [_compGrpsTrimmed, _refPos, west, 10, true, "", false] call DAKKA_fnc_spawnGroup;
                    if (!isNull _grp) then {
                        { _x allowFleeing 0 } forEach (units _grp);
                        _grp setBehaviour "COMBAT";
                        _unusedUnits = [_refPos, units _grp, 50, true, true, false, false] call DAKKA_fnc_occupyHouse;
                        { _x setDamage 1 } forEach _unusedUnits;
                    };
                    sleep 0.001;
                };
            };
        };
    };


    // PLAYER GROUP - PREPARE
    _txt = "Preparing player group...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DAKKA: Task 2 - %1", _txt];
    _wpDist = if (count DAKKA_B_InfGrps == 0) then {
                    -100
                } else {
                    100
                };
    // _battleWp1 = [DAKKA_PlayerNewGroup, [DAKKA_task2_locPos, _wpDist, DAKKA_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "AWARE", "NORMAL", if (_inTown && (count DAKKA_B_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 50, "CLEAR AREA", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT"";"]] call DAKKA_fnc_GroupWp;

    // Move close to contested area
    _battleWp1 = [DAKKA_PlayerNewGroup, DAKKA_task2_locPos getPos [-200, DAKKA_task2_locDir], 0, -1, "", "MOVE", "AWARE", "NORMAL", "LINE", "RED", 25, "MOVE", true, true, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

    // Push and search for enemies
    _battleWp2 = [DAKKA_PlayerNewGroup, DAKKA_task2_locPos getPos [_wpDist, DAKKA_task2_locDir], 0, -1, "", "SAD", "COMBAT", "NORMAL", if (_inTown && (count DAKKA_B_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 50, "CLEAR AREA", false, false, [0,0,0], ["true", ""]] call DAKKA_fnc_GroupWp;

    _battleWp1 setWaypointVisible false;
    _battleWp1 showWaypoint "EASY";
    _battleWp2 setWaypointVisible false;
    _battleWp2 showWaypoint "EASY";

// Reveal units
// - BLUFOR
{
    private _unit = _x;
    p1 reveal _unit;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_B_InfGrps;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_B_LandGrps;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_B_AirGrps;
} forEach (allUnits select { side _x == west });
// - OPFOR
{
    private _unit = _x;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_O_InfGrps;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_O_LandGrps;
    {
        (leader _x) reveal _unit;
    } forEach DAKKA_O_AirGrps;
} forEach (allUnits select { side _x == east });

// Hide marta markers
p1 setVariable ["MARTA_hide", DAKKA_martaHide];

_ctrl ctrlSetText format ["Preparing AO...", ""];

DAKKA_Task2_done = false;   
DAKKA_Task2_1_done = false;   
DAKKA_Task2_init = true; 

sleep 2;

// Close loading screen
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
call DAKKA_fnc_cameraIntroTerminate;
cutText ["", "BLACK IN", 2];
2 fadeSound 1;

if (DAKKA_cinematics) then {
    showHUD [false, false, false, false, false, false, false, false, false];
    enableRadio false;
    // [DAKKA_SupportReq, "Artillery", 0] call BIS_fnc_limitSupport;
} else {
    enableRadio true;
};

// Start time
DAKKA_missionStartTime = time;
diag_log "DAKKA: Task 2 - Initialized";

// Equip NVG to player if night
if ([DAKKA_customDate] call DAKKA_fnc_isNight) then { p1 action ["nvGoggles", p1]; };

// Control the flow of the task
[] execVM "tasks\Task 2\task2_flow.sqf";

sleep 2;
// Base radio
DAKKA_officer sideRadio "SentGenCmdDefend";

sleep 3;
if (!is3DENPreview) then { saveGame };

sleep 2;
// Show mission info text
[toUpper (_location), _missionTime] spawn BIS_fnc_infoText;
// [[toUpper (_location), 0.5, 2], [_missionTime, 0.5, 4, 0.5]] spawn BIS_fnc_EXP_camp_SITREP;
