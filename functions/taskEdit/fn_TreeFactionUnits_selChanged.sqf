#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the faction units tree list.


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_selectionPath", "_idcGroups", "_idcUnits"];
disableSerialization;
if (count _selectionPath > 0) then {
	tvSetCurSel [_idcGroups, [-1]];	
	ctrlEnable [IDC_BT_ADD_GROUP, false];
	tvSetCurSel [IDC_TREE_PLAYER_GRP1, [-1]];
};

if ((count _selectionPath) > 1) then {
	if (typeOf DMORBAT_SelectedPreviewUnit != tvData [_idcUnits, tvCurSel _idcUnits]) then {
		call DMORBAT_fnc_previewGroupDelete;
		DMORBAT_PreviewGroupName = "";	
		DMORBAT_PreviewGroupID = "";	
		// if (DMORBAT_debug) then { diag_log format ["DMORBAT: TreeFactionUnits_selChanged CALLING PREVIEWGROUP", ""] };
		[[tvData [_idcUnits, _selectionPath]]] call DMORBAT_fnc_previewGroup;
		DMORBAT_SelectedPreviewUnit = (units DMORBAT_previewGroup) select 0;
        [true] call DMORBAT_fnc_displayVehicleInfo;
	};
	ctrlEnable [IDC_BT_ADD_UNIT, true];	
} else {		
	ctrlEnable [IDC_BT_ADD_UNIT, false];	
    [false] call DMORBAT_fnc_displayVehicleInfo;
};