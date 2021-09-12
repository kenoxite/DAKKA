#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the custom group tree list.


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath", ["_groupNumber", 1], ["_enemy", true], "_idcButtons", ["_isSupport", false]];
private ["_taskData", "_groupsData", "_thisCategoryData", "_thisCategoryGroups", "_thisGroupData", "_unitData", "_thisCategoryName", "_display", "_buttonText", "_unitClassArr", "_ranksArr", "_loadoutsArr", "_groupMods"];
disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
if (DAKKA_debug) then { diag_log format ["DAKKA: TreeCustomGroup_selChanged _selectionPath:%1", _selectionPath] };

if (count _selectionPath > 0) then {
    if ((tvCount [IDC_TREE_GRP1, []]) > 1) then {
        tvSetCurSel [IDC_TREE_FACTION_GROUPS, [-1]];
    };
      ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];

	if (_groupNumber != 1) then { tvSetCurSel [IDC_TREE_GRP1, [-1]] };
	if (_groupNumber != 2) then { tvSetCurSel [IDC_TREE_GRP2, [-1]] };
	if (_groupNumber != 3) then { tvSetCurSel [IDC_TREE_GRP3, [-1]] };

    DAKKA_customGroupsSelection = [_groupNumber, _selectionPath];
    if (DAKKA_debug) then { diag_log format ["DAKKA: TreeCustomGroup_selChanged DAKKA_customGroupsSelection:%1", DAKKA_customGroupsSelection] };

    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    if (!_isSupport) then{
        _groupsData = [_taskData, format ["%1 groups", if (_enemy) then { "Enemy" } else { "Friendly" }]] call BIS_fnc_getFromPairs; 
        _thisCategoryData = _groupsData select (_groupNumber - 1);
        _thisCategoryName = _thisCategoryData select 0; 
    } else {
        _groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;
        _supportGroup = lbCurSel IDC_COMBO_SUPPORT_TYPES; 
        _groupsCategoryData = _groupsData select _supportGroup; 
        _thisCategoryName = _groupsCategoryData select 0;
        _thisCategoryData = _groupsCategoryData select 1;
    };

    if ((_selectionPath select 0) > 0) then {
        _thisCategoryGroups = _thisCategoryData select 1;  
        _thisGroupData = _thisCategoryGroups select ((_selectionPath select 0) - 1);
        // if (DAKKA_debug) then { diag_log format ["DAKKA: TreeCustomGroup_selChanged _thisGroupData:%1", _thisGroupData] };
        _unitData = _thisGroupData select 1;
        _groupMods = _thisGroupData select 2;

        _unitClassArr = [];
        _ranksArr = [];
        _loadoutsArr = [];

        {
        	_unitClassArr pushBack (_x select 0);
        	_ranksArr pushBack (_x select 1);
        	_loadoutsArr pushBack (_x select 2);
        } forEach _unitData;
    };
};

if ((count _selectionPath) <= 1) then {
	// Group was selected
	if (DAKKA_PreviewGroupID != format ["%1%2%3%4", _groupNumber, DAKKA_PreviewGroupName, _selectionPath select 0] && (_selectionPath select 0) > 0) then {
		call DAKKA_fnc_previewGroupDelete;
		[_unitClassArr, _ranksArr, _loadoutsArr, _groupMods] call DAKKA_fnc_previewGroup;
		DAKKA_SelectedPreviewUnit = (units DAKKA_previewGroup) select 0;
        [false] call DAKKA_fnc_displayVehicleInfo;
		DAKKA_PreviewGroupName = tvData [_idc, tvCurSel _idc];
		DAKKA_PreviewGroupID = format ["%1%2%3%4", _groupNumber, DAKKA_PreviewGroupName, _selectionPath select 0];
	};
	// DAKKA_previewUnit = objNull;
	// DAKKA_SelectedPreviewUnit = objNull;
	if ((_selectionPath select 0) > 0) then {
		{
			ctrlEnable [_x, true];
		} forEach _idcButtons;
        // Only allow to add faction groups when no custom group is selected. Otherwise the previewgroup changes and breaks things
        ctrlEnable [IDC_BT_ADD_GROUP, false];
	} else {
		{
			ctrlEnable [_x, false];
		} forEach _idcButtons;

        ctrlEnable [IDC_BT_ADD_GROUP, true];
	};

    if (DAKKA_Task != 2) then {
    	_buttonText = if ((count _selectionPath) == 1 && (_selectionPath select 0) == 0) then {
    			format ["%1", _thisCategoryName];
    		} else {
    			"the selected group";
    		};
    	_ctrl = (_display displayCtrl IDC_BT_ADD_GROUP);
    	_ctrl ctrlSetText format ["Add group to %1", _thisCategoryName];

    	_ctrl = (_display displayCtrl IDC_BT_ADD_UNIT);
    	_ctrl ctrlSetText format ["Add unit to %1", _buttonText];
    };
    	
} else {
	// Unit was selected
	if ((count _selectionPath) > 1 && DAKKA_PreviewGroupName != (tvData [_idc, _selectionPath select [0, 1]])) then {
		call DAKKA_fnc_previewGroupDelete;
		DAKKA_PreviewGroupName = "";	
		DAKKA_PreviewGroupID = "";	
		[_unitClassArr, _ranksArr, _loadoutsArr, _groupMods] call DAKKA_fnc_previewGroup;
		DAKKA_PreviewGroupName = tvData [_idc, _selectionPath select [0, 1]];
		DAKKA_PreviewGroupID = format ["%1%2%3%4", _groupNumber, DAKKA_PreviewGroupName, _selectionPath select 0, _selectionPath select 1];
	};
	[_selectionPath select 1] call DAKKA_fnc_previewUnit;
	if (DAKKA_debug) then { diag_log format ["DAKKA: TreeCustomGroup_selChanged DAKKA_SelectedPreviewUnit:%1", DAKKA_SelectedPreviewUnit] };
	{
		ctrlEnable [_x, true];
	} forEach _idcButtons;
    [true] call DAKKA_fnc_displayVehicleInfo;
};