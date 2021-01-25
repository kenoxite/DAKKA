// TASK 2
// Init

#include "..\..\control_defines.hpp";

private _display = findDisplay IDC_LOADING_SCREEN;
private _ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

[] spawn DMORBAT_fnc_cameraIntro;
cutText ["", "BLACK IN", 999];
enableRadio false;

// Make group icons visible
setGroupIconsVisible [true, false]; 

// Mission global variables
DMORBAT_task2_locPos = [];
DMORBAT_task2_locDir = 0;
DMORBAT_startPos_O = [];
DMORBAT_B_InfGrps = [];
DMORBAT_B_LandGrps = [];
DMORBAT_B_AirGrps = [];
DMORBAT_O_InfGrps = [];
DMORBAT_O_LandGrps = [];
DMORBAT_O_AirGrps = [];

// Select a random AO location
_ctrl ctrlSetText format ["Choosing AO location...", ""]; 
_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_categoryData = _locationsData select 0;
_categoryLocations = _categoryData select 1;
_locationIndex = if (count _categoryLocations > 1) then {
                floor ([0, (count _categoryLocations) - 1] call BIS_fnc_randomInt);
            } else {
                0;
            };
DMORBAT_task2_locPos = (_categoryLocations select _locationIndex) select 0;
DMORBAT_task2_locDir = (_categoryLocations select _locationIndex) select 1;
if (count DMORBAT_task2_locPos < 3) then { DMORBAT_task2_locPos pushBack 0 };
diag_log format ["DMORBAT: Task 2 - Initializing Location %1", _locationIndex + 1];

// CREATE MARKERS
_ctrl ctrlSetText format ["Creating markers...", ""];
// Contested area
_pos = DMORBAT_task2_locPos;
_txt = "Contested Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DMORBAT_mrkr_Task2_location_area", _pos, "empty", "RECTANGLE", [500, 250], DMORBAT_task2_locDir, "FDiagonal", "ColorEAST", 0.8, _txt] call BIS_fnc_stringToMarker;
// Friendly spawn
_posB = [DMORBAT_task2_locPos, -500, DMORBAT_task2_locDir] call BIS_fnc_relPos;
_txt = "Friendly Spawn Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DMORBAT_mrkr_Task2_location_area_friendly", _posB, "empty", "RECTANGLE", [500, 500], DMORBAT_task2_locDir, "Border", "ColorWEST", 1, _txt] call BIS_fnc_stringToMarker;
// Enemy spawn
_posO = [DMORBAT_task2_locPos, 500, DMORBAT_task2_locDir] call BIS_fnc_relPos;
_txt = "Enemy Spawn Area";
_mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DMORBAT_mrkr_Task2_location_area_enemy", _posO, "empty", "RECTANGLE", [500, 500], DMORBAT_task2_locDir, "Border", "ColorEAST", 1, _txt] call BIS_fnc_stringToMarker;

// Find a start position
_ctrl ctrlSetText format ["Finding starting positions...", ""];
_startPos_B = _posB;
_startPos_O = _posO;
DMORBAT_startPos_O = _startPos_O;

diag_log "DMORBAT: Task 2 - Spawning player group";
_ctrl ctrlSetText format ["Spawning player group...", ""];
_dir = [_startPos_B, DMORBAT_task2_locPos] call BIS_fnc_dirTo;
p1 setPos _startPos_B;
DMORBAT_PlayerNewGroup = [_startPos_B] call DMORBAT_fnc_setPlayerGroup; 
if (isNull DMORBAT_PlayerNewGroup) then { diag_log ["DMORBAT: Task 1 --- ERROR --- Could not create DMORBAT_PlayerNewGroup!", ""]; terminate _thisScript};
// Reposition land vehicles in player group to friendly land vehicles spawn area
_playerIsInf = true;
_playerIsLand = false;
_playerIsAir = false;
{
    private _veh = vehicle _x;
    if (!([_veh] call DMORBAT_fnc_isMan) && !([_veh] call DMORBAT_fnc_isAir)) then {
        private _pos = [DMORBAT_task2_locPos, -750, DMORBAT_task2_locDir] call BIS_fnc_relPos;
        if (_x == effectiveCommander _veh) then {
            _veh setVehiclePosition [_pos, [], (sizeOf (typeOf _veh) + 100), "NONE"];
        };
        _playerIsInf = false;
        _playerIsLand = true;
    };
} forEach (units DMORBAT_PlayerNewGroup);

if (_playerIsInf) then {
    // Reposition air vehicles in player group to friendly air vehicles spawn area
    {
        private _veh = vehicle _x;
        if ([_veh] call DMORBAT_fnc_isAir) then {
            private _pos = [[(DMORBAT_task2_locPos select 0) + (floor random 200), (DMORBAT_task2_locPos select 1), 2000], 5000, DMORBAT_task2_locDir] call BIS_fnc_relPos;
            if (_x == effectiveCommander _veh) then {
                _veh setVehiclePosition [_pos, [], (sizeOf (typeOf _veh) + 100), "FLY"];
            };
            _playerIsInf = false;
            _playerIsAir = true;
        };
    } forEach (units DMORBAT_PlayerNewGroup);
};

{ (vehicle _x) setDir _dir; (vehicle _x) lookAt DMORBAT_task2_locPos;} forEach (units DMORBAT_PlayerNewGroup);
p1 lookAt DMORBAT_task2_locPos;
if (_playerIsInf) then {
    DMORBAT_B_InfGrps pushBack DMORBAT_PlayerNewGroup;
};
if (_playerIsLand) then {
    DMORBAT_B_LandGrps pushBack DMORBAT_PlayerNewGroup;
};
deleteWaypoint [DMORBAT_PlayerNewGroup, 0];
[p1, [], 2] call DMORBAT_fnc_prepareUnit;

// CREATE TASKS
_ctrl ctrlSetText format ["Creating tasks...", ""];
// Task 2 (main)
_title = call compile format ["DMORBAT_Task%1_Title", DMORBAT_Task];
_description = call compile format ["DMORBAT_Task%1_Desc_Short", DMORBAT_Task];
_marker = "";
_task2 = [DMORBAT_PlayerNewGroup, "DMORBAT_Task2", [_description, _title, _marker], objNull, "ASSIGNED", -1, false, "move2", false] call BIS_fnc_taskCreate;
// Task 2-1
_title = "Stop the enemy";
_description = "Force the enemy to retreat from the <marker name='DMORBAT_mrkr_Task2_location_area'>contested area</marker>";
_marker = "";
_task2_1 = [DMORBAT_PlayerNewGroup, ["DMORBAT_Task2_1", "DMORBAT_Task2"], [_description, _title, _marker], DMORBAT_task2_locPos, "CREATED", -1, false, "attack", false] call BIS_fnc_taskCreate;

// SUPPORT
diag_log "DMORBAT: Task 2 - Spawning support groups";
_ctrl ctrlSetText format ["Spawning support groups...", ""];
_basePos = getPos DMORBAT_officer;
_friendlyLinesPos = [DMORBAT_task2_locPos, -750, DMORBAT_task2_locDir] call BIS_fnc_relPos;
[[
    ["Artillery", _friendlyLinesPos, 10, ["DMORBAT_mrkr_Task2_location_area", "DMORBAT_mrkr_Task2_location_area_enemy", "DMORBAT_mrkr_Task2_location_area_friendly"]],
    ["CAS", [0,0,0]],
    ["Air Transport", _friendlyLinesPos, 1000, ["DMORBAT_mrkr_Task2_location_area", "DMORBAT_mrkr_Task2_location_area_enemy", "DMORBAT_mrkr_Task2_location_area_friendly"]]
]] call DMORBAT_fnc_spawnSupport;

DMORBAT_playerGroupReady = true;

// Hide marta markers
p1 setVariable ["MARTA_hide", DMORBAT_martaHide];
// Show map
call DMORBAT_fnc_cameraIntroTerminate;
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
_shownHUD = shownHUD;
showHUD [false, false, false, false, false, false, false, false, false];
showWatch false;
showCompass false;
showGPS false;
openMap true;
[markerSize "DMORBAT_mrkr_Task2_location_area", markerPos "DMORBAT_mrkr_Task2_location_area", 0] call BIS_fnc_zoomOnArea;
hintSilent "Close the map to start the task";
waitUntil { !visibleMap };
hintSilent "";
cutText ["", "BLACK IN", 2];
// Restart loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
waitUntil {_loadingScreen};
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);
[DMORBAT_task2_locPos] call DMORBAT_fnc_cameraIntro;
showHUD _shownHUD;
showWatch true;
showCompass true;
showGPS true;

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

_inTown = if (count (nearestLocations [DMORBAT_task2_locPos, ["CityCenter","NameCityCapital", "NameCity", "NameVillage"], 500]) > 0) then { true } else { false };

// Prepare safe empty positions array
// diag_log "DMORBAT: Task 2 - Preparing safe empty positions";
// _ctrl ctrlSetText format ["Looking for safe positions...", ""];
// _ready = DMORBAT_task2_locPos findEmptyPositionReady [250, 1000];
// waitUntil { _ready };

	diag_log "DMORBAT: Task 2 - Spawning enemies";
	_ctrl ctrlSetText format ["Spawning enemy groups...", ""];
    // DMORBAT_Task2_SafePositions = (selectBestPlaces [getMarkerPos "DMORBAT_mrkr_Task2_location_area_enemy", 250, "meadow + 2*hills", 50, 50] apply { _x select 0 }) select { !surfaceIsWater _x && (count (nearestTerrainObjects [_x, [], 10])) < 1; }; 
	_enemyGroups = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;

// FUNCTIONS
DMORBAT_relPosRefObj = "Flag_BI_F" createVehicle DMORBAT_task2_locPos;
DMORBAT_relPosRefObj setDir DMORBAT_task2_locDir;
DMORBAT_relPosRefObj setPos DMORBAT_task2_locPos;
DMORBAT_relPosRefObj hideObject true;
// Return relative position at the given distance and at the sides of the location center
_getSpawnPos = {
    params ["_posLoc", "_relDist", "_distLoc", "_relDir"];
    // private _relDir = if (_relDist > 0) then { 90 } else { -90 };
    // private _relPosH = [_posLoc, _relDist, _relDir] call BIS_fnc_relPos;
    DMORBAT_relPosRefObj setPos DMORBAT_task2_locPos;
    private _relPosH = DMORBAT_relPosRefObj getRelPos [_relDist, _relDir];
    DMORBAT_relPosRefObj setPos _relPosH;
    // [_relPosH, _distLoc, DMORBAT_task2_locDir] call BIS_fnc_relPos
    // _mrkr = format ["|%1|%2|%3|%4|%5|%6|%7|%8|%9|%10", "DMORBAT_mrkr_relposH", _relPosH, "mil_dot", "ICON", [1, 1], 0, "Solid", "ColorWEST", 1, ""] call BIS_fnc_stringToMarker;
    DMORBAT_relPosRefObj getRelPos [_distLoc, 0]
};
    
    _maxRowDist = 200;

    // Ememy infantry
	_O_InfGrps =+ (_enemyGroups select 0) select 1;
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
        _spawnDist = if (_inTown) then { 250 } else { 400 };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DMORBAT_task2_locPos, _relDist, _spawnDist, _relDir] call _getSpawnPos;
		_grp = [(_O_InfGrps select _i) select 1, _spawnPos, east, 30] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning enemy infantry #%1 group %2", _i + 1, _grp];
		if (!isNull _grp) then {
			deleteWaypoint [_grp, 0];
            DMORBAT_O_InfGrps pushBack _grp;
            [_grp, [_spawnPos, -(_spawnDist), DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "MOVE", "AWARE", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT""; [getPos this, thisList select [0, (floor (random (count thisList))) max 1], 50, true, true, false, true] call DMORBAT_fnc_occupyHouse;"]] call DMORBAT_fnc_GroupWp;
		};
		sleep 0.001;
	}; 

    // Ememy land vehicles
    _O_LandGrps =+ (_enemyGroups select 1) select 1;
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
        if (count DMORBAT_O_InfGrps == 0) then {
            // Allow to spawn further if there's no inf
            _spawnDist = 400;
        };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DMORBAT_task2_locPos, _relDist, _spawnDist, _relDir] call _getSpawnPos;
        _grp = [(_O_LandGrps select _i) select 1, _spawnPos, east, 50] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning enemy land vehicles #%1 group %2", _i + 1, _grp];
        if (!isNull _grp) then {
            deleteWaypoint [_grp, 0];
            DMORBAT_O_LandGrps pushBack _grp;
            _wpDist = if (count DMORBAT_O_InfGrps == 0) then {
                            150
                        } else {
                            50
                        };
            [_grp, [DMORBAT_task2_locPos, _wpDist, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "COMBAT", "NORMAL", if (_inTown && (count DMORBAT_O_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 100] call DMORBAT_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Ememy air vehicles
    _O_AirGrps =+ (_enemyGroups select 2) select 1;
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
        _spawnPos = [[(DMORBAT_task2_locPos select 0), (DMORBAT_task2_locPos select 1), 2000], _relDist, _spawnDist, _relDir] call _getSpawnPos;
        _grp = [(_O_AirGrps select _i) select 1, _spawnPos, east, 200] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning enemy air vehicles #%1 group %2", _i + 1, _grp];
        if (!isNull _grp) then {
            deleteWaypoint [_grp, 0];
            DMORBAT_O_AirGrps pushBack _grp;
            [_grp, [DMORBAT_task2_locPos, 250, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "COMBAT", "NORMAL", "WEDGE", "RED"] call DMORBAT_fnc_GroupWp;
        };
        sleep 0.001;
    }; 


    diag_log "DMORBAT: Task 2 - Spawning friendlies";
    _ctrl ctrlSetText format ["Spawning friendly groups...", ""];
    // DMORBAT_Task2_SafePositions = (selectBestPlaces [getMarkerPos "DMORBAT_mrkr_Task2_location_area_friendly", 250, "meadow + 2*hills", 50, 50] apply { _x select 0 }) select { !surfaceIsWater _x && (count (nearestTerrainObjects [_x, [], 10])) < 1; }; 
    _friendlyGroups = [_taskData, "Friendly groups"] call BIS_fnc_getFromPairs;

    // Friendly infantry
    _B_InfGrps =+ (_friendlyGroups select 0) select 1;
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
        _spawnPos = [DMORBAT_task2_locPos, _relDist, -_spawnDist, _relDir] call _getSpawnPos;  
        _grp = [(_B_InfGrps select _i) select 1, _spawnPos, west, 30] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning friendly infantry #%1 group %2", _i + 1, _grp];
        if (!isNull _grp) then {
            deleteWaypoint [_grp, 0];
            DMORBAT_B_InfGrps pushBack _grp;
            [_grp, [_spawnPos, _spawnDist + 200, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "AWARE", "NORMAL", if (_inTown) then { "COLUMN" } else { "LINE" }, "RED", 50, "", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT"";"]] call DMORBAT_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Friendly land vehicles
    _B_LandGrps =+ (_friendlyGroups select 1) select 1;
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
        if (count DMORBAT_B_InfGrps == 0) then {
            // Allow to spawn further if there's no inf
            _spawnDist = 700;
        };
        _spawnDist = _spawnDist + (50 * _row);
        _spawnPos = [DMORBAT_task2_locPos, _relDist, -_spawnDist, _relDir] call _getSpawnPos;
        _grp = [(_B_LandGrps select _i) select 1, _spawnPos, west, 50] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning friendly land vehicles #%1 group %2", _i + 1, _grp];
        if (!isNull _grp) then {
            deleteWaypoint [_grp, 0];
            DMORBAT_B_LandGrps pushBack _grp;
            _wpDist = if (count DMORBAT_B_InfGrps == 0) then {
                            50
                        } else {
                            -50
                        };
            [_grp, [DMORBAT_task2_locPos, -_wpDist, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "COMBAT", "NORMAL", if (_inTown && (count DMORBAT_B_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 100] call DMORBAT_fnc_GroupWp;
        };
        sleep 0.001;
    }; 

    // Friendly air vehicles
    _B_AirGrps =+ (_friendlyGroups select 2) select 1;
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
        _spawnPos = [[(DMORBAT_task2_locPos select 0), (DMORBAT_task2_locPos select 1), 2000], _relDist, -_spawnDist, _relDir] call _getSpawnPos;
        _grp = [(_B_AirGrps select _i) select 1, _spawnPos, west, 200] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 2 - Spawning friendly air vehicles #%1 group %2", _i + 1, _grp];
        if (!isNull _grp) then {
            deleteWaypoint [_grp, 0];
            DMORBAT_B_AirGrps pushBack _grp;
            [_grp, [DMORBAT_task2_locPos, -250, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "COMBAT", "NORMAL", "WEDGE", "RED"] call DMORBAT_fnc_GroupWp;
        };
        sleep 0.001;
    }; 


    // PLAYER GROUP - PREPARE
    diag_log "DMORBAT: Task 2 - Preparing player group";
    _ctrl ctrlSetText format ["Preparing player group...", ""];
    // DMORBAT_martaHide pushBack DMORBAT_PlayerNewGroup;
    _wpDist = if (count DMORBAT_B_InfGrps == 0) then {
                    -50
                } else {
                    200
                };
    _battleWp = [DMORBAT_PlayerNewGroup, [DMORBAT_task2_locPos, _wpDist, DMORBAT_task2_locDir] call BIS_fnc_relPos, 100, -1, "", "SAD", "AWARE", "NORMAL", if (_inTown && (count DMORBAT_B_InfGrps > 0)) then { "COLUMN" } else { "LINE" }, "RED", 50, "CLEAR AREA", true, false, [0,0,0], ["true", "(group this) setBehaviour ""COMBAT"";"]] call DMORBAT_fnc_GroupWp;
    _battleWp setWaypointVisible false;
    _battleWp showWaypoint "EASY";

// Reveal units
// - BLUFOR
{
    private _unit = _x;
    p1 reveal _unit;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_B_InfGrps;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_B_LandGrps;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_B_AirGrps;
} forEach (allUnits select { side _x == west });
// - OPFOR
{
    private _unit = _x;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_O_InfGrps;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_O_LandGrps;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_O_AirGrps;
} forEach (allUnits select { side _x == east });

// Hide marta markers
p1 setVariable ["MARTA_hide", DMORBAT_martaHide];

_ctrl ctrlSetText format ["Preparing AO...", ""];

DMORBAT_Task2_done = false;   
DMORBAT_Task2_1_done = false;   
DMORBAT_Task2_init = true; 

sleep 2;

// Close loading screen
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
call DMORBAT_fnc_cameraIntroTerminate;
cutText ["", "BLACK IN", 2];
2 fadeSound 1;
enableRadio true;

// Start time
DMORBAT_missionStartTime = time;
diag_log "DMORBAT: Task 2 - Initialized";

// Control the flow of the task
[] execVM "tasks\Task 2\task2_flow.sqf";

sleep 2;
// Base radio
DMORBAT_officer sideRadio "SentGenCmdDefend";

sleep 3;
saveGame;

sleep 2;
// Show mission info text
private _infoTextData = [DMORBAT_task2_locPos] call DMORBAT_fnc_showInfoText;
private _location = _infoTextData select 0;
private _missionTime = _infoTextData select 1;
if (_location == "") then {
    private _location_prefix = selectRandom [
                "",
                "DASHING",
                "RASH",
                "FIERCE",
                "STRONG",
                "LAME",
                "HUNTER",
                "LITTLE",
                "SNARKY",
                "LIGHTNING",
                "RAW",
                "SLOW"
                ];
    private _location_suffix = selectRandom [
                " CAMINO",
                " RIDGE",
                " HILL",
                "MORE",
                "LAND",
                "BOAR",
                "TIGER",
                "DRAGON",
                "ROAD",
                "PIKE"
                ];
    _location = format ["%1%2", _location_prefix, _location_suffix];
}; 
_location = format ["BATTLE OF %1",_location];
[toUpper (_location), _missionTime] spawn BIS_fnc_infoText;