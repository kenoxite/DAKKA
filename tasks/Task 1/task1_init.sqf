// TASK 1
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
DAKKA_task1_locPos = [];
DAKKA_patrolGrps_task1 = [];
DAKKA_defendGrps_task1 = [];
DAKKA_Task1_detected = false;

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
DAKKA_task1_locPos = (_categoryLocations select _locationIndex) select 0;
if (count DAKKA_task1_locPos < 3) then { DAKKA_task1_locPos pushBack 0 };
diag_log format ["DAKKA: Task 1 - Initializing Location %1", _locationIndex + 1];



// COMPOSITIONS
_compositions = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_thisWorldCompositions = [_compositions, worldName] call BIS_fnc_getFromPairs;
if (isNil "_thisWorldCompositions") then { _thisWorldCompositions = [] };
_noCompData = [
                [false, true] select (count _thisWorldCompositions == 0),
                true
                ] select (isNil "_thisWorldCompositions");
if (DAKKA_automated || (!DAKKA_automated && _noCompData)) then {
    _txt = "Generating compositions...";
    _ctrl ctrlSetText _txt; 
    diag_log format ["DAKKA: Task 1 - %1", _txt];
    // Delete existing ones first
    [true] call DAKKA_fnc_compositionRemove;
    waitUntil {DAKKA_compositionsRemoved};
    // Load default compositions
    #include "..\..\compositions_default.hpp";
    #include "..\..\compositions_CUP.hpp";
    #include "..\..\compositions_steam.hpp";
    // Use CUP compositions if that mod is loaded
    _fnc_CUPcheck = {
        private _CUPtest = "FlagCarrierTakistanKingdom_EP1" createVehicle [0,0,0];
        private _CUP = if (!isNull _CUPtest) then { true } else { false };
        [_CUPtest] spawn { deleteVehicle (_this select 0) };
        _CUP
    };
    _compositionsPredefined = [];
    // _compositionsPredefined = [ +_compositions_default, +_compositions_CUP] select (call _fnc_CUPcheck);
    if (call _fnc_CUPcheck) then { _compositionsPredefined = +_compositions_CUP };
    _compositionsPredefined append _compositions_steam;

    // _compositionsPredefined = +_compositions_default;

    // #include "..\..\compositions_test.hpp";
    // _compositionsPredefined = +_compositions_test;

    _locationsPredefined = DAKKA_locations_Task1;
    // Amount of compositions should match amount of predefined locations
    _taskLocations = [_locationsPredefined, "Outposts"] call BIS_fnc_getFromPairs;
    _selectedCompositions = [];
    {
        private _coords = _x select 0;
        // if (DAKKA_debug) then { diag_log format ["_coords: %1", _coords] };
        private _dir = _x select 1;
        private _filteredComps = _compositionsPredefined select {(_x select 0) select 1 == "Guerrilla"};
        private _comp = +selectRandom _filteredComps;
        private _compName = _comp select 0;
        private _newName = format ["%1 %2", _compName, _forEachIndex + 1];
        _comp set [0, _newName];
        // if (DAKKA_debug) then { diag_log format ["_selectedComposition: %1", _compName] };
        private _compData = _comp select 1;
        private _ref = _compData select 0;
        _ref set [1, [_coords select 0, _coords select 1, 0]];
        _ref set [2, floor(random 360)];
        _selectedCompositions pushBack _comp;
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
    [1, DAKKA_task1_locPos] call DAKKA_fnc_compositionLoad;
    waitUntil {DAKKA_compositionsLoaded == 1};
    DAKKA_task1_locPos = DAKKA_compLoadedLocs select 0;

    // Enable simulation for all composition objects
/*    _nul = [] spawn {
        _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
        _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
        _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
        if (!isNil "_compositionsData") then {
            waitUntil { DAKKA_compositionsLoaded == count _compositionsData };

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
    };	*/

    if (DAKKA_debug) then {
        // call DAKKA_fnc_mapDisplayCompositions;
    };
};

// CREATE MARKERS
_ctrl ctrlSetText format ["Creating markers...", ""];
// Marker: Suggested search area for the outpost
_searchPos = [[[DAKKA_task1_locPos, 175]], []] call BIS_fnc_randomPos; 
[_searchPos, [200, 200], "ColorEAST", "empty", "FDiagonal", "ELLIPSE", 0.3, ["DAKKA_mrkr_Task1_searchArea"]] call BIS_fnc_markerCreate;

// Display suggested location on map
DAKKA_task1_location = createLocation ["o_installation", _searchPos, 30, 30];
DAKKA_task1_location setText "Enemy Outpost?";
DAKKA_task1_location setSide east;

// Find a start position
_ctrl ctrlSetText format ["Finding a start position...", ""];
_startPos_B = [DAKKA_task1_locPos, 700, 1000, 1, 0, 0.7, 0, ["DAKKA_mrkr_Task1_searchArea"]] call BIS_fnc_findSafePos;

diag_log "DAKKA: Task 1 - Spawning player group";
_ctrl ctrlSetText format ["Spawning player group...", ""];
_dir = [_startPos_B, _searchPos] call BIS_fnc_dirTo;
p1 setPos _startPos_B;
DAKKA_PlayerNewGroup = [_startPos_B] call DAKKA_fnc_spawnPlayerGroup; 
waitUntil {sleep 0.01; DAKKA_PlayerNewGroup getVariable ["DAKKA_playerGroupReady", false]};
if (isNull DAKKA_PlayerNewGroup) then { diag_log ["DAKKA: Task 1 --- ERROR --- Could not create DAKKA_PlayerNewGroup!", ""]; terminate _thisScript};
{ (vehicle _x) setDir _dir; } forEach (units DAKKA_PlayerNewGroup);
deleteWaypoint [DAKKA_PlayerNewGroup, 0];

// CREATE TASKS
diag_log "DAKKA: Task 1 - Creating tasks";
_ctrl ctrlSetText format ["Creating tasks...", ""];
// Task 1 (main)
_title = call compile format ["DAKKA_Task%1_Title", DAKKA_Task];
_description = format ["%1", call compile format ["DAKKA_Task%1_Desc_Short", DAKKA_Task]];
_marker = "";
_task1 = [DAKKA_PlayerNewGroup, "DAKKA_Task1", [_description, _title, _marker], objNull, "ASSIGNED", -1, false, "move1", false] call BIS_fnc_taskCreate;
// Task 1-1
_title = "Locate the outpost";
_description = "Search the <marker name='DAKKA_mrkr_Task1_searchArea'>suggested area</marker> and locate the outpost.";
_marker = "";
_task1_1 = [DAKKA_PlayerNewGroup, ["DAKKA_Task1_1", "DAKKA_Task1"], [_description, _title, _marker], objNull, "CREATED", -1, false, "scout", false] call BIS_fnc_taskCreate;

// SUPPORT
diag_log "DAKKA: Task 1 - Spawning support groups";
_ctrl ctrlSetText format ["Spawning support groups...", ""];
_basePos = getPos DAKKA_officer;
[[
    ["Artillery", DAKKA_task1_locPos, 300, ["DAKKA_mrkr_Task1_searchArea"]],
    ["CAS", [0,0,0]],
    ["Air Transport", DAKKA_task1_locPos, 1000, ["DAKKA_mrkr_Task1_searchArea"]]
]] spawn DAKKA_fnc_spawnSupport;

DAKKA_playerGroupReady = true;

// BRIEFING
private _playerFactionName = getText (configFile >> "CfgFactionClasses" >> (DAKKA_PlayerFactions select 0) >> "displayName");
private _enemyFactionName = getText (configFile >> "CfgFactionClasses" >> (DAKKA_EnemyFactions select 0) >> "displayName");
private _terrainName = getText (configFile >> "CfgWorlds" >> worldName >> "description");
private _infoTextData = [DAKKA_task1_locPos] call DAKKA_fnc_showInfoText;
private _locationStr = _infoTextData select 0;
private _missionTime = _infoTextData select 1;
private _location = _locationStr;
if (_locationStr != "" ) then {
    _location = format ["near %1", _locationStr];
} else {
    _location = format ["somewhere in %1", _terrainName];
}; 

_intel = format ["The information gathered by the intel guys suggests there's a <font face='RobotoCondensedBold'>%1</font> outpost <marker name='DAKKA_mrkr_Task1_searchArea'>%2</marker>, currenlty being used as a training center.<br/><br/>Intel has also managed to <font face='RobotoCondensedBold'>intercept the enemy radio channel</font>, so you will be up to date of their whereabouts.<br/><br/>No civilian presence has been detected in the area.", _enemyFactionName, if (_locationStr == "") then { "in this area" } else { _location }];
player createDiaryRecord ["Diary", ["Intel", _intel], taskNull, "", false];

_enemyForces = format ["Intel suggests that <font face='RobotoCondensedBold'>%1</font>'s forces in the area consist of several patrols equipped with <font face='RobotoCondensedBold'>small arms</font>.<br/><br/>All hints to the contingent present being mostly made up of <font face='RobotoCondensedBold'>inexperienced</font> troops. That doens't mean they can't present a challenge to your team.", _enemyFactionName];
player createDiaryRecord ["Diary", ["Enemy Forces", _enemyForces], taskNull, "", false];

_situation = format ["The presence of <font face='RobotoCondensedBold'>%1</font> forces in <font face='RobotoCondensedBold'>%2</font> is growing stronger by the day and is menacing the stability of the region. But maybe today we can do something to palliate that.<br/><br/>Our intel guys are confindent that a new training center has been established <marker name='DAKKA_mrkr_Task1_searchArea'>%3</marker>. Your team will be deployed in the AO with the task of <font face='RobotoCondensedBold'>locating that outpost and neutralizing all enemy activity</font> in the area.<br/><br/>Once the objective is accomplished, you are to <font face='RobotoCondensedBold'>exfil</font> by any means necessary.<br/><br/>If intel is correct, the AO will be patrolled, so <font face='RobotoCondensedBold'>stealth is advised</font>. In any case, you are the ones to decide the course of action once you assess the situation there.", _enemyFactionName, _terrainName, if (_locationStr == "") then { "somewhere in this area" } else { _location }];
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
// waitUntil { !(shownHUD select 0) };
showWatch false;
showCompass false;
showGPS false;
disableMapIndicators [true, true, true, true];
openMap true;
[[1500, 1500], markerPos "DAKKA_mrkr_Task1_searchArea", 0] call BIS_fnc_zoomOnArea;
hintSilent "Close the map to start the task";
// Stop time
_initdate = date;
while {visibleMap} do
{
    setdate _initdate;
    sleep 0.5;
}; 
// waitUntil { !visibleMap };
hintSilent "";
cutText ["", "BLACK IN", 5];
// Restart loading screen
_loadingScreen = createDialog "DAKKA_Loading_Screen";
waitUntil {_loadingScreen};
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);
[DAKKA_task1_locPos] call DAKKA_fnc_cameraIntro;
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
            "EventTrack03a_F_EPB",
            "Music_Probe_Discovered",
            "Music_Suspended_Loop_01",
            "LeadTrack03_F_Mark",
            "OM_Music02",
            "OM_Music03",
            "AmbientTrack03_F",
            "AmbientTrack01_F_EPB",
            "BackgroundTrack01_F_EPB",
            "EventTrack04_F_EPB",
            "BackgroundTrack01_F_EPC",
            "BackgroundTrack04_F_EPC",
            "EventTrack03_F_EPC",
            "LeadTrack03_F_EPC",
            "LeadTrack04_F_Tank",
            "BackgroundTrack01_F_Tank"
        ],
        [ // combat
            "LeadTrack03a_F_EPA",
            "Music_Battle_Human",
            "Music_Freeroam_Battle_Human",
            "Music_Tension_Loop_01",
            "LeadTrack02_F_EPC",
            "LeadTrack02_F_EPB"
        ],
        [ // safe
            "AmbientTrack01a_F",
            "Music_Freeroam_01_MissionStart",
            "Music_Roaming_Day",
            "Music_Roaming_Night",
            "Music_Roaming_Night_02",
            "Music_Roaming_Night_Fragment_01_20s",
            "AmbientTrack02_F_EXP"
        ],
        0.3, // volume
        5, // transition
        500, // radius
        5, // execution rate
        true // no repeat
    ]
] call BIS_fnc_jukebox;

_startingMusic = selectRandom [
    "LeadTrack06_F_EPC",
    "EventTrack03_F_EPB",
    "EventTrack03a_F_EPB"
    ];
// ["playMusic", [_startingMusic]] call BIS_fnc_jukebox;
playMusic _startingMusic;

// Prepare safe empty positions array
// diag_log "DAKKA: Task 1 - Preparing safe empty positions";
// _ctrl ctrlSetText format ["Looking for safe positions...", ""];
// _ready = DAKKA_task1_locPos findEmptyPositionReady [0, 1000];
// waitUntil { _ready };

	diag_log "DAKKA: Task 1 - Spawning enemies";
	_ctrl ctrlSetText format ["Spawning enemy groups...", ""];
	_enemyGroups = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;

    // PATROLS
	_patrolGroups = +(_enemyGroups select 0) select 1;
	for [{private _i = 0}, {_i < count _patrolGroups}, {_i = _i + 1}] do {
		_grp = [(_patrolGroups select _i) select 1, DAKKA_task1_locPos, east, 100] call DAKKA_fnc_spawnGroup;
        waitUntil {sleep 0.01; _grp getVariable ["DAKKA_groupReady", false]};
        diag_log format ["DAKKA: Task 1 - Spawning enemy patrol #%1 group %2", _i + 1, _grp];
		if (!isNull _grp) then {
			deleteWaypoint [_grp, 0];
			DAKKA_patrolGrps_task1 pushBack _grp;
            _grp setBehaviour "AWARE";
            // DAKKA_martaHide pushBack _grp;
            // Patrol the area
            sleep 0.1;
			[_grp, DAKKA_task1_locPos, if ((count ([_grp, true] call BIS_fnc_groupVehicles)) > 0) then { 500 } else { 300 }, ["true", "if (behaviour this != ""COMBAT"") then { if (random 1 > 0.9) then { this globalRadio ""SentClear""; }; };"], [[DAKKA_task1_locPos, 50]], true] call DAKKA_fnc_patrolArea;

            // Notify of enemy deaths on global radio
            {
                _x addEventHandler ["Killed", {
                    _this spawn {
                        params ["_unit", "_killer", "_instigator", "_useEffects"];
                        private _leader = leader _unit;
                        sleep (random 5);
                        if (alive _leader) then {
                            _leader globalRadio "SentUnitKilled";
                            playSound "radioStatic1";
                        };
                    };
                }];
            } forEach (units _grp);
		};
		sleep 0.001;
	}; 

    // DEFENDERS
    _garrisonRadius = 50;
	_defendGroups = +(_enemyGroups select 1) select 1;
	for [{private _i = 0}, {_i < count _defendGroups}, {_i = _i + 1}] do {
		_grp = [(_defendGroups select _i) select 1, DAKKA_task1_locPos, east, 10, true, "", false] call DAKKA_fnc_spawnGroup;
        waitUntil {sleep 0.01; _grp getVariable ["DAKKA_groupReady", false]};
        diag_log format ["DAKKA: Task 1 - Spawning enemy defenders #%1 group %2", _i + 1, _grp];
		if (!isNull _grp) then {
			deleteWaypoint [_grp, 0];
			DAKKA_defendGrps_task1 pushBack _grp;
            _grp setBehaviour "AWARE";
            // DAKKA_martaHide pushBack _grp;
            // Defend the area
			[_grp, DAKKA_task1_locPos] call BIS_fnc_taskDefend;
            // Pick infantry not in vehicle
            private _freeUnits = [];
            {
                if ([vehicle _x] call DAKKA_fnc_isMan) then {
                    if (isNull assignedVehicle _x) then {
                        _freeUnits pushBack _x;
                    };
                };
            } forEach (units _grp);
            // Garrison nearest buildings
            if (_i > 0) then { _garrisonRadius = _garrisonRadius * 2; };
            _nonGarrisoned = [DAKKA_task1_locPos, _freeUnits, _garrisonRadius, true, true, false, false] call DAKKA_fnc_occupyHouse;

            // Notify of enemy deaths on global radio
            {
                _x addEventHandler ["Killed", {
                    _this spawn {
                        params ["_unit", "_killer", "_instigator", "_useEffects"];
                        private _leader = leader _unit;
                        sleep (random 5);
                        if (alive _leader) then {
                            _leader globalRadio "SentUnitKilled";
                            playSound "radioStatic1";
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

	diag_log "DAKKA: Task 1 - Preparing player group";
    _ctrl ctrlSetText format ["Preparing player group...", ""];
    DAKKA_martaHide pushBack DAKKA_PlayerNewGroup;
    DAKKA_PlayerNewGroup setBehaviour "AWARE";
	for [{_i = 0}, {_i < 10}, {_i = _i + 1}] do {
        // random position
        private _angle = floor (random 360);                        // angle definition (0..360)
        private _randomSquareRoot = sqrt floor (random 1);          // random square-root to obtain a non-linear 0..1 value
        private _distance = 200 * _randomSquareRoot;    // distance from the center definition (0..radius)
        private _newSearchPos = _searchPos getPos [_distance, _angle];
		_searchWp = [DAKKA_PlayerNewGroup, _newSearchPos, 0, -1, "", "MOVE", if (_i == 0) then { "STEALTH" } else { "" }, "", "", "", 50, "SEARCH AREA", false] call DAKKA_fnc_GroupWp;
		_searchWp setWaypointVisible false;
		_searchWp showWaypoint "NEVER";  
	}; 
	_getCloseWp = [DAKKA_PlayerNewGroup, [getPos leader DAKKA_PlayerNewGroup, _searchPos] call DAKKA_fnc_middlePoint, 0, 0, "", "MOVE", "AWARE", "NORMAL", "FILE", "GREEN", 30, "", false, true] call DAKKA_fnc_GroupWp;
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
                    playSound "radioStatic1";
                };
            };
        }];
    } forEach (units DAKKA_PlayerNewGroup);


// Hide marta markers
p1 setVariable ["MARTA_hide", DAKKA_martaHide];

_ctrl ctrlSetText format ["Preparing AO...", ""];

DAKKA_Task1_done = false;
DAKKA_Task1_1_done = false;
DAKKA_Task1_2_done = false;
DAKKA_Task1_End_done = false;
DAKKA_Task1_detected = false;
DAKKA_Task1_init = true;

sleep 5;

// Close loading screen
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};
call DAKKA_fnc_cameraIntroTerminate;
cutText ["", "BLACK IN", 2];
2 fadeSound 1;
enableRadio true;

// Fog blur
[] execVM "scripts\weatherEffects\fogBlur.sqf";

// End music
// 20 fadeMusic 0;

// Start time
DAKKA_missionStartTime = time;
diag_log "DAKKA: Task 1 - Initialized";

// Equip NVG to player if night
if ([DAKKA_customDate] call DAKKA_fnc_isNight && hmd p1 != "") then { player action ["nvGoggles", player]; };

// Control the flow of the task
[] execVM "tasks\Task 1\task1_flow.sqf";

sleep 2;
// Base radio
DAKKA_officer sideRadio "SentGenCmdSeize";

sleep 3;
if (!is3DENPreview) then { saveGame };

sleep 2;
// Show mission info text
[toUpper (_location), _missionTime] spawn BIS_fnc_infoText;
// [[toUpper (_location), 0.5, 2], [_missionTime, 0.5, 4, 0.5]] spawn BIS_fnc_EXP_camp_SITREP;