#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the faction groups tree list.


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_selectionPath", ["_enemy", true]];
private ["_faction"];

if (count _selectionPath > 0) then {
	tvSetCurSel [IDC_TREE_FACTION_UNITS, [-1]];		
	ctrlEnable [IDC_BT_ADD_UNIT, false];
	tvSetCurSel [IDC_TREE_PLAYER_GRP1, [-1]];

    _faction = call compile format ["DAKKA_%1Factions select (DAKKA_Task - 1)", if (_enemy) then { "Enemy" } else { "Player" }];
      ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
};
if ((count _selectionPath) <= 2) then {
	if (DAKKA_debug) then { diag_log format ["DAKKA: selected: %1", _selectionPath] };
	if ((count _selectionPath) <= 1) then {
		ctrlEnable [IDC_BT_ADD_GROUP, false];
	} else {
		if (DAKKA_PreviewGroupID != format ["%1%2%3%4", "F", DAKKA_PreviewGroupName, _selectionPath select 0, _selectionPath select 1]) then {
			if (DAKKA_debug) then { diag_log format ["DAKKA: TreeFactionGroups_selChanged CALLING UPDATEUNITSLIST", ""] };
			_prepareForPreview = [_selectionPath, _faction] call DAKKA_fnc_prepareGroupPreview;
			DAKKA_PreviewGroupName = tvData [IDC_TREE_FACTION_GROUPS, tvCurSel IDC_TREE_FACTION_GROUPS];
			DAKKA_PreviewGroupID = format ["%1%2%3%4", "F", DAKKA_PreviewGroupName, _selectionPath select 0, _selectionPath select 1];
		};
		ctrlEnable [IDC_BT_ADD_GROUP, true];
	};
	DAKKA_previewUnit = objNull;	
	DAKKA_previewUnitisPlayer = false;
    [false] call DAKKA_fnc_displayVehicleInfo;
} else {
	if (DAKKA_debug) then { diag_log format ["DAKKA: selected: %1", (_selectionPath)] };
	if ((count _selectionPath) > 2 && DAKKA_PreviewGroupID != format ["%1%2%3%4", "F", DAKKA_PreviewGroupName, _selectionPath select 0, _selectionPath select 1]) then {
		if (DAKKA_debug) then { diag_log format ["DAKKA: TreeFactionGroups_selChanged CALLING UPDATEUNITSLIST", ""] };
		[_selectionPath, _faction] call DAKKA_fnc_prepareGroupPreview;
		DAKKA_PreviewGroupName = tvData [IDC_TREE_FACTION_GROUPS, _selectionPath select [0, 2]];
		DAKKA_PreviewGroupID = format ["%1%2%3%4", "F", DAKKA_PreviewGroupName, _selectionPath select 0, _selectionPath select 1];
	};
	[_selectionPath select 2] call DAKKA_fnc_previewUnit;
	ctrlEnable [IDC_BT_ADD_GROUP, true];
    [true] call DAKKA_fnc_displayVehicleInfo;
};
DAKKA_SelectedPreviewUnit = objNull;