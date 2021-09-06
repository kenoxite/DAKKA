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

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_playerData = [_taskData, "Player data"] call BIS_fnc_getFromPairs;
_playerIndex = _playerData select 0;

_playerIndex = _playerData select 0;
_role = _ctrl lbData (lbCurSel _ctrl);
_index = DMORBAT_crewSlotRoles find _role;
if (_index >= 0) then {
  _playerData set [1, _index];
};
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: setCrewSlot _role: %1 index: %2", _role, lbCurSel _ctrl] };

[IDC_TREE_PLAYER_GRP1] call DMORBAT_fnc_updatePlayerGroupTreeList;
DMORBAT_previewUnitisPlayer = true;
_ctrl tvSetCurSel [0, _playerIndex];

((findDisplay IDC_MENU_MISSION_EDIT) displayCtrl IDC_GRP_VEH_CREW_SEL) ctrlShow false;
// if (DMORBAT_debug) then { diag_log format ["DMORBAT: updateCrewSlotsCombo HIDING crew popup: %1", IDC_GRP_VEH_CREW_SEL] };

// Save task settings
call DMORBAT_fnc_settingsSave;