#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
   


  Parameter (s):
 

  Returns:


  Examples:

*/

disableSerialization;
private _display = findDisplay IDC_MENU_MISSION_EDIT;
private _currentName = DMORBAT_saveSlotName;

// Display popup
_ctrl = (_display displayCtrl IDC_GRP_DATARENAME);
_ctrl ctrlShow true;

// Fill menu elements
_ctrl = (_display displayCtrl IDC_TITLE_DATARENAME);
_ctrl ctrlSetText "Give the profile a name:";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TXT_DATARENAME);
private _suggestedName = "New Profile";
// private _playerFaction = DMORBAT_PlayerFactions select (DMORBAT_Task - 1);
// private _enemyFaction = DMORBAT_EnemyFactions select (DMORBAT_Task - 1);
// private _suggestedName = format ["%1 vs %2", _playerFaction, _enemyFaction];
_ctrl ctrlSetText _suggestedName;
ctrlSetFocus _ctrl;

_ctrl = (_display displayCtrl IDC_BT_DATARENAME_CANCEL);
_ctrl ctrlSetText "Cancel";
_ctrl ctrlSetEventHandler ["ButtonClick", '((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_DATARENAME) ctrlShow false;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_DATARENAME_OK);
_ctrl ctrlSetText "Accept";
_ctrl ctrlSetEventHandler ["ButtonClick", '[] call DMORBAT_fnc_settingsMenuNewSet;'];
_ctrl ctrlSetTooltip "";

true