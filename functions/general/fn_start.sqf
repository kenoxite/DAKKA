#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0:

  Returns:


  Examples:

*/
// MUSIC
DAKKA_EH_playIntroMusic = addMusicEventHandler ["MusicStop", { [DAKKA_musicType] call DAKKA_fnc_playMusic;}];
2 fadeMusic 0.3;
playMusic "LeadTrack04_F_Tacops";
DAKKA_musicType = "intro";

// SOUND
0 fadeSound 0;

// Intro camera
[] spawn DAKKA_fnc_cameraIntro;

// Start loading screen
_loadingScreen = createDialog "DAKKA_Loading_Screen";
if (!_loadingScreen) then { systemChat "Loading screen could not be opened!" };

// EXTRACT FACTIONS DATA
private _initTime = time;
if (isNil "DAKKA_availableFactionsData") then {
    DAKKA_availableFactionsData = call DAKKA_fnc_extractFactionData;
    if (DAKKA_debug) then { systemChat format ["Faction data extracted in %1s", time - _initTime] };
};

// PLAYER SETUP
(units p1) joinSilent grpNull;
(units p1) joinSilent (createGroup [west, true]);
p1 setCaptive true;
removeAllWeapons p1;         
removeAllItems p1;             
removeUniform p1;         
removeVest p1;         
removeBackpack p1;         
removeHeadgear p1;         
removeGoggles p1; 

// Spectate EH
// p1 addEventHandler ["killed", { [_this] spawn DAKKA_fnc_spectate; } ];

DAKKA_EH_OpenMenu = player addAction ["Open Menu", { call DAKKA_fnc_openMainDialog;}];


// GLOBAL MISSION PARAMETERS
// Disable ambient fauna
// enableEnvironment [false, true];

// Close loading screen
private _display = findDisplay IDC_LOADING_SCREEN;
_display closeDisplay IDC_CANCEL;
waitUntil {isNull _display};

// MAIN MENU
// call DAKKA_fnc_createDialogs;

_display = findDisplay IDC_MENU_MISSION_EDIT;
// call DAKKA_fnc_openMainDialog;