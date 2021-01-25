#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Changes the current menu page shown and controls the display of elements its elements. 


  Parameter (s):
  _this select 0: _currentPage
  _this select 1: _next
 

  Returns:


  Examples:

*/

params ["_currentPage", "_next"];
private ["_ctrl", "_ctrlWidth", "_ctrlHeight", "_ctrlx", "_ctrly", "_arr", "_index", "_display", "_hide", "_show", "_move", "_display"];
disableSerialization;
cutText ["Preparing menus...", "BLACK IN", 999];
_display = findDisplay IDC_MENU_MISSION_EDIT;

diag_log format ["DMORBAT: --- buttonChangePage page:%1 changing to %2 page", _currentPage, if (_next) then { "NEXT" } else { "PREVIOUS" }];

if (_currentPage > 1) then {
  call DMORBAT_fnc_previewGroupDelete;
  call DMORBAT_fnc_cameraPreviewTerminate;
  // Remove EH to avoid carrying wrong data to next page
  _ctrl = _display displayCtrl IDC_TREE_FACTION_UNITS;
  _ctrl ctrlSetEventHandler ["TreeSelChanged", ''];
  _ctrl = _display displayCtrl IDC_COMBO_FACTIONS;
  _ctrl ctrlSetEventHandler ["LBSelChanged", ''];

    // Save task settings
    call DMORBAT_fnc_settingsSave;

  if (_currentPage == 2 && !_next) then {
    [] spawn DMORBAT_fnc_cameraIntro;
    call DMORBAT_fnc_deleteTaskMarkers;
  };

  if (_currentPage == 7 && !_next) then {
    // Update date
    setDate DMORBAT_missionStart;
    0 fadeSound 0;
    2 fadeMusic 0.3;
    // Update weather
    [DMORBAT_missionWeather, false] spawn DMORBAT_fnc_setWeather;
    call DMORBAT_fnc_resetWeatherEffects;
  };

  if (_currentPage == 7 && _next) then {
    0 fadeSound 0;
    2 fadeMusic 0.3;
  };
};

_display = findDisplay IDC_MENU_MISSION_EDIT;
_arr = [
    [ // Page 1 - Main menu
      [], //move
      [IDC_GRP_MAINMENU, IDC_BACKG_TASK, IDC_GRP_BACKG_MAIN], // hide (next)/ show (back)
      [IDC_BT_PREVIEW, IDC_GRP_LEFTBAR_BCKG, IDC_GRP_BOTTOMBAR_BCKG, IDC_GRP_FACTION_GROUPS, IDC_GRP_TASK_GROUPS, IDC_GRP_TASK_DESCRIPTION, IDC_GRP_NAV_BUTTONS, IDC_GRP_CAMERA_PREVIEW] // show (next) / hide (back)
    ],

    [ // Page 2 - Player group
      [],
      [IDC_BT_PREVIEW, IDC_GRP_LEFTBAR_BCKG, IDC_GRP_BOTTOMBAR_BCKG, IDC_GRP_FACTION_GROUPS, IDC_GRP_TASK_GROUPS, IDC_GRP_TASK_DESCRIPTION, IDC_GRP_NAV_BUTTONS, IDC_GRP_CAMERA_PREVIEW],
      [IDC_GRP_MAINMENU, IDC_BACKG_TASK, IDC_GRP_BACKG_MAIN]
    ],

    [ // Page 3 - Friendly groups
      [],
      [],
      []
    ],

    [ // Page 4 - Enemy groups
      [],
      [],
      []
    ],

    [ // Page 5 - AO locations
      [],
      [IDC_GRP_AO_SELECTION, IDC_GRP_AO_MAP_CONTROLS, IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, IDC_IMG_MAPCROSSHAIR],
      [IDC_BT_PREVIEW, IDC_GRP_FACTION_GROUPS]
    ],

    [ // Page 6 - Support
      [],
      [IDC_BT_PREVIEW, IDC_GRP_SUPPORT],
      [IDC_GRP_AO_SELECTION, IDC_GRP_AO_MAP_CONTROLS, IDC_MAP_AO_SEL_T, IDC_MAP_AO_SEL_S, IDC_IMG_MAPCROSSHAIR]
    ],

    [ // Page 7 - Global Settings
      [],
      [IDC_GRP_ENVSETTINGS],
      [IDC_BT_PREVIEW, IDC_GRP_BOTTOMBAR_BCKG, IDC_GRP_TASK_GROUPS, IDC_GRP_SUPPORT]
    ],

    [ // Page 8 - Summary
      [],
      [],
      [IDC_GRP_ENVSETTINGS]
    ],

    [ // Page 9 - 
      [],
      [],
      []
    ]
  ];

_move = if (_next) then {
    ((_arr select (_currentPage)) select 0);  
  } else {
    ((_arr select (_currentPage - 1)) select 0);
  };
_hide = if (_next) then {
    ((_arr select (_currentPage)) select 2);  
  } else {
    ((_arr select (_currentPage - 1)) select 1);  
  };
_show = if (_next) then {
    ((_arr select (_currentPage)) select 1);  
  } else {
    ((_arr select (_currentPage - 1)) select 2);
  };

{ (_display displayCtrl _x) ctrlShow false } forEach _hide;

// Move main menu back to the side
{
  _ctrlWidth = safezoneW - (94.5 * pixelGridNoUIScale * pixelW);
  _ctrlHeight = safezoneH;
  _ctrl = (_display displayCtrl _x);  
  _ctrl ctrlSetPosition [safezoneX, safezoneY];
  _ctrl ctrlCommit 0.1;
} forEach _move;

{ (_display displayCtrl _x) ctrlShow true } forEach _show;

[] execVM format ["menuPages\page%1.sqf", if (_next) then { _currentPage + 1 } else { _currentPage - 1 }];
