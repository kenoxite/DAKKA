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
private _currentName = DAKKA_saveSlotName;

// Display popup
_ctrl = (_display displayCtrl IDC_GRP_DATARENAME);
_ctrl ctrlShow true;

// Fill menu elements
_ctrl = (_display displayCtrl IDC_TITLE_DATARENAME);
_ctrl ctrlSetText "Enter a new name:";
_ctrl ctrlEnable false;

_ctrl = (_display displayCtrl IDC_TXT_DATARENAME);
_ctrl ctrlSetText _currentName;
ctrlSetFocus _ctrl;

_ctrl = (_display displayCtrl IDC_BT_DATARENAME_CANCEL);
_ctrl ctrlSetText "Cancel";
_ctrl ctrlSetEventHandler ["ButtonClick", '((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_DATARENAME) ctrlShow false;'];
_ctrl ctrlSetTooltip "";

_ctrl = (_display displayCtrl IDC_BT_DATARENAME_OK);
_ctrl ctrlSetText "Accept";
_ctrl ctrlSetEventHandler ["ButtonClick", '[] call DAKKA_fnc_settingsMenuRenameSet;'];
_ctrl ctrlSetTooltip "";

true