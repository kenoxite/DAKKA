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
call DMORBAT_fnc_deleteTaskMarkers;

// Delete composition markers
call DMORBAT_fnc_deleteCompositionMarkers;

// Delete wheelchocks
{
  deleteVehicle _x;
} forEach DMORBAT_wheelChock;
DMORBAT_wheelChock = []; 

// Delete map center marker
deleteMarker "DMORBAT_mrkr_MapCenter";

// Delete preview position marker
deleteMarker "DMORBAT_groupPreviewPos";

// Delete open menu action
player removeAction DMORBAT_EH_OpenMenu;

// Delete mission EH
removeMissionEventHandler ["Draw3D", DMORBAT_draw3D_EH_previewUnit];
removeMissionEventHandler ["Draw3D", DMORBAT_draw3D_EH_previewLocation];

// Delete music EH
removeMusicEventHandler ["MusicStop", DMORBAT_EH_playIntroMusic];

// Destroy cameras
call DMORBAT_fnc_cameraPreviewTerminate;
call DMORBAT_fnc_cameraIntroTerminate;
call DMORBAT_fnc_previewGroupDelete;

// Termiante scripts
terminate DMORBAT_mainMenu_loop;
DMORBAT_editingTask = false;

// Delete global variables
DMORBAT_availableFactionsData = nil;
DMORBAT_availableFactionsDataNoInf = nil;
DMORBAT_availableFactionsDataGroups = nil;

DMORBAT_mainMenu_loop = nil;
DMORBAT_EH_OpenMenu = nil;
DMORBAT_draw3D_EH_previewUnit = nil;
DMORBAT_draw3D_EH_previewLocation = nil;
DMORBAT_EH_playIntroMusic = nil;

// DMORBAT_faction = nil;
// DMORBAT_factionInd = nil;

// DMORBAT_PlayerFaction = nil;
// DMORBAT_PlayerFactions = nil;
// DMORBAT_EnemyFactions = nil;

DMORBAT_previewGroup = nil;
DMORBAT_PreviewGroupName = nil;
DMORBAT_PreviewGroupID = nil;
DMORBAT_previewUnit = nil;
DMORBAT_SelectedPreviewUnit = nil;
DMORBAT_previewUnitisPlayer = nil;
DMORBAT_locationPreview = nil;

// DMORBAT_cameraIntro = nil;
// DMORBAT_cameraIntroPlaying = nil;
// DMORBAT_previewCamera = nil;
// DMORBAT_previewCameraPlaying = nil;
DMORBAT_cameraZoom = nil;
DMORBAT_cameraX = nil;
DMORBAT_cameraY = nil;
DMORBAT_editReference = nil;

DMORBAT_lastPage = nil;
// DMORBAT_crewSlotRoles = nil; // Still needed when setting player group
DMORBAT_customGroupsSelection = nil;

DMORBAT_wheelChock = nil;
DMORBAT_mainDialogOpened = nil;
DMORBAT_selectedLocMrkr = nil;
DMORBAT_mapCoords = nil;
DMORBAT_mapSatellite = nil;

DMORBAT_musicType = nil;
DMORBAT_tips = nil;

// Save mission settings
call DMORBAT_fnc_settingsSave;

// Close main menu
// closeDialog IDC_OK;
_display closeDisplay IDC_CANCEL;

// Initiate task
[] execVM "tasks\taskStart.sqf";