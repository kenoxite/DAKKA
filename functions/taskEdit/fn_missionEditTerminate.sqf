#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Terminates mission editing and prepares the task to be played. 


  Parameter (s):
  _this select 0: 


  Returns:


  Examples:

*/
private ["_display", "_enemyGrpCount", "_playerGroupCount", "_friendlyGroupCount", "_taskData", "_playerGroupData", "_friendlyGroupsData", "_enemyGroupsData", "_friendlyInfGroupsData", "_friendlyLandGroupData", "_friendlyAirGroupsData", "_friendlyInfGroupCount", "_friendlyLandGroupCount", "_friendlyAirGroupCount", "_enemyInfGroupCount", "_enemyLandGroupCount", "_enemyAirGroupCount", "_enemyPatrolsData", "_enemyDefendersData", "_enemyPatrolsCount", "_enemyDefendersCount", "_enemyInfGroupsData", "_enemyLandGroupsData", "_enemyAirGroupsData", "_enemyInfGroupCount", "_enemyLandGroupCount", "_enemyAirGroupCount"];

if (!DAKKA_automated) then {
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);

    _playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
    _playerGroupCount = count _playerGroupData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _playerGroupCount: %1, _playerGroupData: %2", _playerGroupCount, _playerGroupData]; };

    _friendlyGroupsData = [_taskData, "Friendly groups"] call BIS_fnc_getFromPairs;
    _friendlyInfGroupsData = [_friendlyGroupsData, "Infantry"] call BIS_fnc_getFromPairs;
    _friendlyInfGroupCount = count _friendlyInfGroupsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _friendlyInfGroupCount: %1, _friendlyInfGroupsData: %2", _friendlyInfGroupCount, _friendlyInfGroupsData]; };
    _friendlyLandGroupData = [_friendlyGroupsData, "Land Vehicles"] call BIS_fnc_getFromPairs;
    _friendlyLandGroupCount = count _friendlyLandGroupData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _friendlyLandGroupCount: %1, _friendlyLandGroupData: %2", _friendlyLandGroupCount, _friendlyLandGroupData]; };
    _friendlyAirGroupsData = [_friendlyGroupsData, "Air Vehicles"] call BIS_fnc_getFromPairs;
    _friendlyAirGroupCount = count _friendlyAirGroupsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _friendlyAirGroupCount: %1, _friendlyAirGroupsData: %2", _friendlyAirGroupCount, _friendlyAirGroupsData]; };
    _friendlyGroupCount = _friendlyInfGroupCount + _friendlyLandGroupCount + _friendlyAirGroupCount;

    _enemyGroupsData = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;
    _enemyPatrolsData = [_enemyGroupsData, "Patrols"] call BIS_fnc_getFromPairs;
    _enemyPatrolsCount = count _enemyPatrolsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _enemyPatrolsCount: %1, _enemyPatrolsData: %2", _enemyPatrolsCount, _enemyPatrolsData]; };
    _enemyDefendersData = [_enemyGroupsData, "Defenders"] call BIS_fnc_getFromPairs;
    _enemyDefendersCount = count _enemyDefendersData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _enemyDefendersCount: %1, _enemyDefendersData: %2", _enemyDefendersCount, _enemyDefendersData]; };
    _enemyInfGroupsData = [_enemyGroupsData, "Infantry"] call BIS_fnc_getFromPairs;
    _enemyInfGroupCount = count _enemyInfGroupsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _enemyInfGroupCount: %1, _enemyInfGroupsData: %2", _enemyInfGroupCount, _enemyInfGroupsData]; };
    _enemyLandGroupsData = [_enemyGroupsData, "Land Vehicles"] call BIS_fnc_getFromPairs;
    _enemyLandGroupCount = count _enemyLandGroupsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _enemyLandGroupCount: %1, _enemyLandGroupsData: %2", _enemyLandGroupCount, _enemyLandGroupsData]; };
    _enemyAirGroupsData = [_enemyGroupsData, "Air Vehicles"] call BIS_fnc_getFromPairs;
    _enemyAirGroupCount = count _enemyAirGroupsData;
    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _enemyAirGroupCount: %1, _enemyAirGroupsData: %2", _enemyAirGroupCount, _enemyAirGroupsData]; };
    _enemyGrpCount = if (DAKKA_Task == 1) then {
            _enemyPatrolsCount + _enemyDefendersCount
        } else {
            _enemyInfGroupCount + _enemyLandGroupCount + _enemyAirGroupCount;
        };

    if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - _playerGroupCount: %1, _enemyGrpCount: %2", _playerGroupCount, _enemyGrpCount]; };

    if (_playerGroupCount == 0 || _enemyGrpCount == 0) exitWith {
        diag_log format ["DAKKA: missionEditTerminate --- ERROR --- CAN'T START. NO CUSTOM GROUPS CREATED!"];
        ["ERROR: You need to create at least a player group and an enemy group to start the task!"] spawn DAKKA_fnc_displayMessage
    };
};

_display = findDisplay IDC_MENU_MISSION_EDIT;

// Delete task markers
call DAKKA_fnc_deleteTaskMarkers;

// Delete composition markers
call DAKKA_fnc_deleteCompositionMarkers;

// Delete map center marker
deleteMarker "DAKKA_mrkr_MapCenter";

// Delete preview position marker
deleteMarker "DAKKA_groupPreviewPos";

// Delete open menu action
player removeAction DAKKA_EH_OpenMenu;

// Delete mission EH
removeMissionEventHandler ["Draw3D", DAKKA_draw3D_EH_previewUnit];
removeMissionEventHandler ["Draw3D", DAKKA_draw3D_EH_previewLocation];

// Delete music EH
removeMusicEventHandler ["MusicStop", DAKKA_EH_playIntroMusic];

// Destroy cameras
if (DAKKA_debug) then { diag_log format ["DAKKA: missionEditTerminate - Terminating preview camera..."] };
call DAKKA_fnc_cameraPreviewTerminate;
waitUntil {DAKKA_cameraPreviewTerminateDone};
call DAKKA_fnc_cameraIntroTerminate;
call DAKKA_fnc_previewGroupDelete;

// Termiante scripts
terminate DAKKA_mainMenu_loop;
DAKKA_editingTask = false;

// Delete global variables
DAKKA_availableFactionsData = nil;
DAKKA_availableFactionsDataNoInf = nil;
DAKKA_availableFactionsDataGroups = nil;

DAKKA_mainMenu_loop = nil;
DAKKA_EH_OpenMenu = nil;
DAKKA_draw3D_EH_previewUnit = nil;
DAKKA_draw3D_EH_previewLocation = nil;
DAKKA_EH_playIntroMusic = nil;

// DAKKA_faction = nil;
// DAKKA_factionInd = nil;

// DAKKA_PlayerFaction = nil;
// DAKKA_PlayerFactions = nil;
// DAKKA_EnemyFactions = nil;

DAKKA_previewGroup = nil;
DAKKA_PreviewGroupName = nil;
DAKKA_PreviewGroupID = nil;
DAKKA_previewUnit = nil;
DAKKA_SelectedPreviewUnit = nil;
DAKKA_previewUnitisPlayer = nil;
DAKKA_locationPreview = nil;

// DAKKA_cameraIntro = nil;
// DAKKA_cameraIntroPlaying = nil;
// DAKKA_previewCamera = nil;
// DAKKA_previewCameraPlaying = nil;
DAKKA_cameraZoom = nil;
DAKKA_cameraX = nil;
DAKKA_cameraY = nil;
DAKKA_editReference = nil;

DAKKA_lastPage = nil;
// DAKKA_crewSlotRoles = nil; // Still needed when setting player group
DAKKA_customGroupsSelection = nil;

DAKKA_wheelChockArr = nil;
DAKKA_mainDialogOpened = nil;
DAKKA_selectedLocMrkr = nil;
DAKKA_mapCoords = nil;
DAKKA_mapSatellite = nil;

DAKKA_musicType = nil;
DAKKA_tips = nil;

// Save mission settings
call DAKKA_fnc_settingsSave;

// Close main menu
// closeDialog IDC_OK;
_display closeDisplay IDC_CANCEL;

// Initiate task
[] execVM "tasks\taskStart.sqf";