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
private ["_display"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

// Delete task markers
call DAKKA_fnc_deleteTaskMarkers;

// Delete composition markers
call DAKKA_fnc_deleteCompositionMarkers;

// Delete wheelchocks
{
  deleteVehicle _x;
} forEach DAKKA_wheelChock;
DAKKA_wheelChock = []; 

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
call DAKKA_fnc_cameraPreviewTerminate;
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

DAKKA_wheelChock = nil;
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