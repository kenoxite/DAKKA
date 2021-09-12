#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the selected crew slot as a player slot. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_taskData", "_playerData", "_playerIndex", "_role", "_index"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idcCombo;

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
_playerIndex = _playerData select 0;

_playerIndex = _playerData select 0;
_role = _ctrl lbData (lbCurSel _ctrl);
_index = DAKKA_crewSlotRoles find _role;
if (_index >= 0) then {
  _playerData set [1, _index];
};
// if (DAKKA_debug) then { diag_log format ["DAKKA: setCrewSlot _role: %1 index: %2", _role, lbCurSel _ctrl] };

[IDC_TREE_PLAYER_GRP1] call DAKKA_fnc_updatePlayerGroupTreeList;
DAKKA_previewUnitisPlayer = true;
_ctrl tvSetCurSel [0, _playerIndex];

((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_VEH_CREW_SEL) ctrlShow false;
// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo HIDING crew popup: %1", IDC_GRP_VEH_CREW_SEL] };

// Save task settings
call DAKKA_fnc_settingsSave;