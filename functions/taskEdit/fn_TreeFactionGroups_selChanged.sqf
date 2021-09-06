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

    _faction = call compile format ["DMORBAT_%1Factions select (DMORBAT_Task - 1)", if (_enemy) then { "Enemy" } else { "Player" }];
      ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
};
if ((count _selectionPath) <= 2) then {
	if (DMORBAT_debug) then { diag_log format ["DMORBAT: selected: %1", _selectionPath] };
	if ((count _selectionPath) <= 1) then {
		ctrlEnable [IDC_BT_ADD_GROUP, false];
	} else {
		if (DMORBAT_PreviewGroupID != format ["%1%2%3%4", "F", DMORBAT_PreviewGroupName, _selectionPath select 0, _selectionPath select 1]) then {
			if (DMORBAT_debug) then { diag_log format ["DMORBAT: TreeFactionGroups_selChanged CALLING UPDATEUNITSLIST", ""] };
			_prepareForPreview = [_selectionPath, _faction] call DMORBAT_fnc_prepareGroupPreview;
			DMORBAT_PreviewGroupName = tvData [IDC_TREE_FACTION_GROUPS, tvCurSel IDC_TREE_FACTION_GROUPS];
			DMORBAT_PreviewGroupID = format ["%1%2%3%4", "F", DMORBAT_PreviewGroupName, _selectionPath select 0, _selectionPath select 1];
		};
		ctrlEnable [IDC_BT_ADD_GROUP, true];
	};
	DMORBAT_previewUnit = objNull;	
	DMORBAT_previewUnitisPlayer = false;
    [false] call DMORBAT_fnc_displayVehicleInfo;
} else {
	if (DMORBAT_debug) then { diag_log format ["DMORBAT: selected: %1", (_selectionPath)] };
	if ((count _selectionPath) > 2 && DMORBAT_PreviewGroupID != format ["%1%2%3%4", "F", DMORBAT_PreviewGroupName, _selectionPath select 0, _selectionPath select 1]) then {
		if (DMORBAT_debug) then { diag_log format ["DMORBAT: TreeFactionGroups_selChanged CALLING UPDATEUNITSLIST", ""] };
		[_selectionPath, _faction] call DMORBAT_fnc_prepareGroupPreview;
		DMORBAT_PreviewGroupName = tvData [IDC_TREE_FACTION_GROUPS, _selectionPath select [0, 2]];
		DMORBAT_PreviewGroupID = format ["%1%2%3%4", "F", DMORBAT_PreviewGroupName, _selectionPath select 0, _selectionPath select 1];
	};
	[_selectionPath select 2] call DMORBAT_fnc_previewUnit;
	ctrlEnable [IDC_BT_ADD_GROUP, true];
    [true] call DMORBAT_fnc_displayVehicleInfo;
};
DMORBAT_SelectedPreviewUnit = objNull;