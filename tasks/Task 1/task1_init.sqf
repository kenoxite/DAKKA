// TASK 1
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
DMORBAT_task1_locPos = [];
DMORBAT_patrolGrps_task1 = [];
DMORBAT_defendGrps_task1 = [];
DMORBAT_Task1_detected = false;

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
DMORBAT_task1_locPos = (_categoryLocations select _locationIndex) select 0;
if (count DMORBAT_task1_locPos < 3) then { DMORBAT_task1_locPos pushBack 0 };
diag_log format ["DMORBAT: Task 1 - Initializing Location %1", _locationIndex + 1];

// CREATE MARKERS
_ctrl ctrlSetText format ["Creating markers...", ""];
// Marker: Suggested search area for the outpost
_searchPos = [[[DMORBAT_task1_locPos, 175]], []] call BIS_fnc_randomPos; 
[_searchPos, [200, 200], "ColorEAST", "empty", "FDiagonal", "ELLIPSE", 0.3, ["DMORBAT_mrkr_Task1_searchArea"]] call BIS_fnc_markerCreate;

// Display suggested location on map
DMORBAT_task1_location = createLocation ["o_installation", _searchPos, 30, 30];
DMORBAT_task1_location setText "Enemy Outpost?";
DMORBAT_task1_location setSide east;	

// Find a start position
_ctrl ctrlSetText format ["Finding a start position...", ""];
_startPos_B = [DMORBAT_task1_locPos, 700, 1000, 1, 0, 0.7, 0, ["DMORBAT_mrkr_Task1_searchArea"]] call BIS_fnc_findSafePos;

diag_log "DMORBAT: Task 1 - Spawning player group";
_ctrl ctrlSetText format ["Spawning player group...", ""];
_dir = [_startPos_B, _searchPos] call BIS_fnc_dirTo;
p1 setPos _startPos_B;
DMORBAT_PlayerNewGroup = [_startPos_B] call DMORBAT_fnc_setPlayerGroup; 
if (isNull DMORBAT_PlayerNewGroup) then { diag_log ["DMORBAT: Task 1 --- ERROR --- Could not create DMORBAT_PlayerNewGroup!", ""]; terminate _thisScript};
{ (vehicle _x) setDir _dir; } forEach (units DMORBAT_PlayerNewGroup);
deleteWaypoint [DMORBAT_PlayerNewGroup, 0];

// CREATE TASKS
diag_log "DMORBAT: Task 1 - Creating tasks";
_ctrl ctrlSetText format ["Creating tasks...", ""];
// Task 1 (main)
_title = call compile format ["DMORBAT_Task%1_Title", DMORBAT_Task];
_description = format ["%1<br /><br />We've managed to intercept the enemy radio channel, so you will be up to date of their whereabouts.", call compile format ["DMORBAT_Task%1_Desc_Short", DMORBAT_Task]];
_marker = "";
_task1 = [DMORBAT_PlayerNewGroup, "DMORBAT_Task1", [_description, _title, _marker], objNull, "ASSIGNED", -1, false, "move1", false] call BIS_fnc_taskCreate;
// Task 1-1
_title = "Locate the outpost";
_description = "Search the <marker name='DMORBAT_mrkr_Task1_searchArea'>suggested area</marker> and locate the outpost.";
_marker = "";
_task1_1 = [DMORBAT_PlayerNewGroup, ["DMORBAT_Task1_1", "DMORBAT_Task1"], [_description, _title, _marker], objNull, "CREATED", -1, false, "scout", false] call BIS_fnc_taskCreate;

// SUPPORT
diag_log "DMORBAT: Task 1 - Spawning support groups";
_ctrl ctrlSetText format ["Spawning support groups...", ""];
_basePos = getPos DMORBAT_officer;
[[
    ["Artillery", DMORBAT_task1_locPos, 300, ["DMORBAT_mrkr_Task1_searchArea"]],
    ["CAS", [0,0,0]],
    ["Air Transport", DMORBAT_task1_locPos, 1000, ["DMORBAT_mrkr_Task1_searchArea"]]
]] spawn DMORBAT_fnc_spawnSupport;

DMORBAT_playerGroupReady = true;

// Hide marta markers
p1 setVariable ["MARTA_hide", DMORBAT_martaHide];

// Show map
call DMORBAT_fnc_cameraIntroTerminate;
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
_shownHUD = shownHUD;
showHUD [false, false, false, false, false, false, false, false, false];
// waitUntil { !(shownHUD select 0) };
showWatch false;
showCompass false;
showGPS false;
openMap true;
[markerSize "DMORBAT_mrkr_Task1_searchArea", markerPos "DMORBAT_mrkr_Task1_searchArea", 0] call BIS_fnc_zoomOnArea;
hintSilent "Close the map to start the task";
waitUntil { !visibleMap };
hintSilent "";
cutText ["", "BLACK IN", 2];
// Restart loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
waitUntil {_loadingScreen};
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);
[DMORBAT_task1_locPos] call DMORBAT_fnc_cameraIntro;
showHUD _shownHUD;
showWatch true;
showCompass true;
showGPS true;

// Music
0 fadeMusic 0.5;
// playMusic selectRandom [
//     "LeadTrack06_F_EPC",
//     "EventTrack03_F_EPB",
//     "EventTrack03a_F_EPB"
//     ];

/*["initialize",
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
] call BIS_fnc_jukebox;*/
            // "AmbientTrack01_F",
            // "AmbientTrack01_F_EPB",
            // "Fallout",
            // "Wasteland",
            // "SkyNet",
            // "MAD",
            // "AmbientTrack01a_F_Tacops",
            // "AmbientTrack02a_F_Tacops",
            // "AmbientTrack03a_F_Tacops",
            // "AmbientTrack04a_F_Tacops"

_startingMusic = selectRandom [
    "LeadTrack06_F_EPC",
    "EventTrack03_F_EPB",
    "EventTrack03a_F_EPB"
    ];
// ["playMusic", [_startingMusic]] call BIS_fnc_jukebox;
playMusic _startingMusic;

// Prepare safe empty positions array
// diag_log "DMORBAT: Task 1 - Preparing safe empty positions";
// _ctrl ctrlSetText format ["Looking for safe positions...", ""];
// _ready = DMORBAT_task1_locPos findEmptyPositionReady [0, 1000];
// waitUntil { _ready };

	diag_log "DMORBAT: Task 1 - Spawning enemies";
	_ctrl ctrlSetText format ["Spawning enemy groups...", ""];
	_enemyGroups = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;
	_patrolGroups =+ (_enemyGroups select 0) select 1;
	for [{private _i = 0}, {_i < count _patrolGroups}, {_i = _i + 1}] do {
		_grp = [(_patrolGroups select _i) select 1, DMORBAT_task1_locPos, east, 100] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 1 - Spawning enemy patrol #%1 group %2", _i + 1, _grp];
		if (!isNull _grp) then {
			deleteWaypoint [_grp, 0];
			DMORBAT_patrolGrps_task1 pushBack _grp;
            _grp setBehaviour "AWARE";
            // DMORBAT_martaHide pushBack _grp;
            // Patrol the area
            sleep 0.1;
			[_grp, DMORBAT_task1_locPos, if ((count ([_grp, true] call BIS_fnc_groupVehicles)) > 0) then { 500 } else { 300 }, ["true", "if (behaviour this != ""COMBAT"") then { if (random 1 > 0.9) then { this globalRadio ""SentClear""; }; };"], [[DMORBAT_task1_locPos, 50]], true] call DMORBAT_fnc_patrolArea;

            // Notify of enemy deaths on global radio
            {
                _x addEventHandler ["Killed", {
                    _this spawn {
                        params ["_unit", "_killer", "_instigator", "_useEffects"];
                        private _leader = leader _unit;
                        sleep (random 5);
                        if (alive _leader) then {
                            _leader globalRadio "SentUnitKilled";
                        };
                    };
                }];
            } forEach (units _grp);
		};
		sleep 0.001;
	}; 

	_defendGroups =+ (_enemyGroups select 1) select 1;
	for [{private _i = 0}, {_i < count _defendGroups}, {_i = _i + 1}] do {
		_grp = [(_defendGroups select _i) select 1, DMORBAT_task1_locPos, east, 30] call DMORBAT_fnc_spawnGroup;
        diag_log format ["DMORBAT: Task 1 - Spawning enemy defenders #%1 group %2", _i + 1, _grp];
		if (!isNull _grp) then {
			deleteWaypoint [_grp, 0];
			DMORBAT_defendGrps_task1 pushBack _grp;
            _grp setBehaviour "AWARE";
            // DMORBAT_martaHide pushBack _grp;
            // Defend the area
			[_grp, DMORBAT_task1_locPos] call BIS_fnc_taskDefend;
            // Pick infantry not in vehicle
            private _freeUnits = [];
            {
                if ([vehicle _x] call DMORBAT_fnc_isMan) then {
                    if (isNull assignedVehicle _x) then {
                        _freeUnits pushBack _x;
                    };
                };
            } forEach (units _grp);
            // Garrison nearest buildings
            _nonGarrisoned = [DMORBAT_task1_locPos, _freeUnits, 50, true, true, false, false] call DMORBAT_fnc_occupyHouse;

            // Notify of enemy deaths on global radio
            {
                _x addEventHandler ["Killed", {
                    _this spawn {
                        params ["_unit", "_killer", "_instigator", "_useEffects"];
                        private _leader = leader _unit;
                        sleep (random 5);
                        if (alive _leader) then {
                            _leader globalRadio "SentUnitKilled";
                        };
                    };
                }];
            } forEach (units _grp);

			// DISABLE AI MODS
			// LAMBS Danger
			{
				_x setVariable ["lambs_danger_disableAI", true];
			} forEach units _grp;
            _grp setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
		};

		sleep 0.001;
	}; 

	diag_log "DMORBAT: Task 1 - Preparing player group";
    _ctrl ctrlSetText format ["Preparing player group...", ""];
    DMORBAT_martaHide pushBack DMORBAT_PlayerNewGroup;
    DMORBAT_PlayerNewGroup setBehaviour "AWARE";
	for [{_i = 0}, {_i < 10}, {_i = _i + 1}] do {
        // random position
        private _angle = floor (random 360);                        // angle definition (0..360)
        private _randomSquareRoot = sqrt floor (random 1);          // random square-root to obtain a non-linear 0..1 value
        private _distance = 200 * _randomSquareRoot;    // distance from the center definition (0..radius)
        private _newSearchPos = _searchPos getPos [_distance, _angle];
		_searchWp = [DMORBAT_PlayerNewGroup, _newSearchPos, 0, -1, "", "MOVE", if (_i == 0) then { "STEALTH" } else { "" }, "", "", "", 50, "SEARCH AREA", false] call DMORBAT_fnc_GroupWp;
		_searchWp setWaypointVisible false;
		_searchWp showWaypoint "NEVER";  
	}; 
	_getCloseWp = [DMORBAT_PlayerNewGroup, [getPos leader DMORBAT_PlayerNewGroup, _searchPos] call DMORBAT_fnc_middlePoint, 0, 0, "", "MOVE", "AWARE", "NORMAL", "FILE", "GREEN", 30, "", false, true] call DMORBAT_fnc_GroupWp;
    _getCloseWp setWaypointVisible false;
    _getCloseWp showWaypoint "NEVER";  

    // Notify of enemy kills on global radio
    {
        _x addEventHandler ["Killed", {
            _this spawn {
                params ["_unit", "_killer", "_instigator", "_useEffects"];
                sleep (random 2);
                if (alive _killer) then {
                    // _killer globalRadio (selectRandom [
                    //                 "SentWitnessKilled",
                    //                 "SentCheering"
                    //                 ]);
                    _killer globalRadio "SentCheering";
                };
            };
        }];
    } forEach (units DMORBAT_PlayerNewGroup);

// Reveal units
// - BLUFOR
{
    private _unit = _x;
    p1 reveal _unit;
} forEach (allUnits select { side _x == west });
// - OPFOR
{
    private _unit = _x;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_defendGrps_task1;
    {
        (leader _x) reveal _unit;
    } forEach DMORBAT_patrolGrps_task1;
} forEach (allUnits select { side _x == east });

// Hide marta markers
p1 setVariable ["MARTA_hide", DMORBAT_martaHide];

_ctrl ctrlSetText format ["Preparing AO...", ""];

DMORBAT_Task1_done = false;
DMORBAT_Task1_1_done = false;
DMORBAT_Task1_2_done = false;
DMORBAT_Task1_End_done = false;
DMORBAT_Task1_detected = false;
DMORBAT_Task1_init = true;

sleep 5;

// Close loading screen
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
call DMORBAT_fnc_cameraIntroTerminate;
cutText ["", "BLACK IN", 2];
2 fadeSound 1;
enableRadio true;

// End music
20 fadeMusic 0;

// Start time
DMORBAT_missionStartTime = time;
diag_log "DMORBAT: Task 1 - Initialized";

// Control the flow of the task
[] execVM "tasks\Task 1\task1_flow.sqf";

sleep 2;
// Base radio
DMORBAT_officer sideRadio "SentGenCmdSeize";

sleep 3;
saveGame;

sleep 2;
// Show mission info text
private _infoTextData = [DMORBAT_task1_locPos] call DMORBAT_fnc_showInfoText;
private _location = _infoTextData select 0;
private _missionTime = _infoTextData select 1;
if (_location != "" ) then {
    _location = format ["NEAR %1", _location];
} else {
    _location = format ["SOMEWHERE IN %1", worldName];
}; 
[toUpper (_location), _missionTime] spawn BIS_fnc_infoText;