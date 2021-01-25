#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the player's group tree list.


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_selectionPath", "_idcPlayerGrp", "_idcGroups", "_idcUnits"];
private ["_taskData", "_playerGroupData", "_unitsData"];

disableSerialization;
// diag_log format ["DMORBAT: TreePlayerGroup_selChanged _selectionPath:%1", _selectionPath];
if (count _selectionPath > 0) then {
	tvSetCurSel [_idcGroups, [-1]];	
	ctrlEnable [IDC_BT_ADD_GROUP, false];
	tvSetCurSel [_idcUnits, [-1]];	
	ctrlEnable [IDC_BT_ADD_UNIT, false];

      ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
};
if ((count _selectionPath) <= 1) then {
	if (DMORBAT_PreviewGroupID != format ["%1%2%3%4", "P", DMORBAT_PreviewGroupName, _selectionPath select 0]) then {
		call DMORBAT_fnc_previewPlayerGroup;
		DMORBAT_PreviewGroupName = tvData [_idcPlayerGrp, tvCurSel _idcPlayerGrp];
		DMORBAT_PreviewGroupID = format ["%1%2%3%4", "P", DMORBAT_PreviewGroupName, _selectionPath select 0];
	};
	DMORBAT_previewUnit = objNull;
	DMORBAT_previewUnitisPlayer = false;
	ctrlEnable [IDC_BT_1_GRP1, true];
	ctrlEnable [IDC_BT_2_GRP1, true];
	ctrlEnable [IDC_BT_3_GRP1, false];
	ctrlEnable [IDC_BT_4_GRP1, false];
    [false] call DMORBAT_fnc_displayVehicleInfo;
} else {
	if ((count _selectionPath) > 1 && DMORBAT_PreviewGroupID != format ["%1%2%3%4", "P", DMORBAT_PreviewGroupName, _selectionPath select 0]) then {
		call DMORBAT_fnc_previewPlayerGroup;
		DMORBAT_PreviewGroupName = tvData [_idcPlayerGrp, _selectionPath select [0, 1]];
		DMORBAT_PreviewGroupID = format ["%1%2%3%4", "P", DMORBAT_PreviewGroupName, _selectionPath select 0];
	};
	[_selectionPath select 1] call DMORBAT_fnc_previewUnit;
	if ([_selectionPath select 1] call DMORBAT_fnc_checkIfSelIsPlayer) then {
		DMORBAT_previewUnitisPlayer = true;
	} else {
		DMORBAT_previewUnitisPlayer = false;
	};
	ctrlEnable [IDC_BT_1_GRP1, true];
	ctrlEnable [IDC_BT_2_GRP1, true];
    ctrlEnable [IDC_BT_3_GRP1, true];

    [true] call DMORBAT_fnc_displayVehicleInfo;
    
    // _taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
    // _playerGroupData = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
    // _playerGroupData = _playerGroupData select 0;
    // _unitsData = _playerGroupData select 1;
	if ([_selectionPath select 1] call DMORBAT_fnc_checkIfSelIsPlayer && ([tvData [_idcPlayerGrp, _selectionPath]] call DMORBAT_fnc_isMan)) then {
		ctrlEnable [IDC_BT_4_GRP1, false];
	};
	if (!([_selectionPath select 1] call DMORBAT_fnc_checkIfSelIsPlayer) || !([tvData [_idcPlayerGrp, _selectionPath]] call DMORBAT_fnc_isMan)) then {
		ctrlEnable [IDC_BT_4_GRP1, true];
	};
};
DMORBAT_SelectedPreviewUnit = objNull;