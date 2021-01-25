#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Edits the currently selected composition 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idc", ["_cameraAngle", "top"], ["_end", false]];
private ["_display", "_ctrl", "_selectionPath", "_taskData", "_worldCompositionsData", "_compositionsData", "_index", "_thisCompositionData", "_compObjects", "_target", "_cameraRadius", "_cameraHeightCircle", "_circlingPos", "_dist", "_camDist", "_mrkr", "_ref"];

call DMORBAT_fnc_cameraPreviewTerminate;

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idc);
_selectionPath = tvCurSel _ctrl;
if ((count _selectionPath) < 1) exitWith { [format ["ERROR: No composition was selected!"]] spawn DMORBAT_fnc_displayMessage;; };

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
_compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
_index = _selectionPath select 0;
_thisCompositionData = _compositionsData select _index;

if (_end) then {
	// Show things
	ctrlShow [IDC_GRP_AO_MAP_CONTROLS, true];
    ctrlShow [IDC_IMG_MAPCROSSHAIR, true];
	  if (DMORBAT_mapSatellite) then {
	    ctrlShow [IDC_MAP_AO_SEL_T, false];
	    ctrlShow [IDC_MAP_AO_SEL_S, true];
	  } else {
	    ctrlShow [IDC_MAP_AO_SEL_T, true];
	    ctrlShow [IDC_MAP_AO_SEL_S, false];
	  };
	ctrlShow [IDC_GRP_TASK_GROUPS, true];
    ctrlShow [IDC_GRP_TASK_DESCRIPTION, true];
	ctrlShow [IDC_GRP_AO_SELECTION, true];
	ctrlShow [IDC_GRP_NAV_BUTTONS, true];
    ctrlShow [IDC_GRP_CURRENTSAVEDDATA, true];
    ctrlShow [IDC_TXT_TIPS, true];
    ctrlShow [IDC_GRP_LEFTBAR_BCKG, true];
    ctrlShow [IDC_GRP_BOTTOMBAR_BCKG, true];

    ctrlShow [IDC_TREE_PLAYER_GRP1, false];
    ctrlShow [IDC_GRP_TASK_GROUP2, false];
    ctrlShow [IDC_GRP_TASK_GROUP3, false];

    // Control the buttons display
    ctrlShow [IDC_BT_3_GRP1, false];
    ctrlShow [IDC_BT_4_GRP1, false];
    if (DMORBAT_Task == 1) then {
        ctrlShow [IDC_BT_AO_SEL_ROTATE_LEFT, false];
        ctrlShow [IDC_BT_AO_SEL_ROTATE_RIGHT, false];
    };

	// Enable buttons
	ctrlEnable [IDC_BT_1_GRP1, true];
	ctrlEnable [IDC_BT_2_GRP1, true];
	ctrlEnable [IDC_BT_3_GRP1, true];
	ctrlEnable [IDC_BT_AO_SEL_SET, true];
	ctrlEnable [IDC_BT_AO_SEL_REMOVE, true];
	ctrlEnable [IDC_BT_AO_SEL_ADD, true];
	ctrlEnable [IDC_BT_AO_SEL_COMP_ADD, true];
	ctrlEnable [IDC_TREE_AO_COMP_1, true];
	ctrlEnable [IDC_TREE_AO_SELECTION_COMP, true];

    // Preview control: display and resize
    _ctrl = (_display displayCtrl IDC_BT_PREVIEW);
    _ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
    _ctrly = safezoneY + (11 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
    _ctrlHeight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;

	// Set focus
	_ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
	ctrlSetFocus _ctrl;

	// Update markers
	call DMORBAT_fnc_mapDisplayCompositions;

} else {
	_compObjects =+ _thisCompositionData select 1;
	_target = (_compObjects select 0) select 0;
	DMORBAT_editReference = _target;
	_compObjects deleteAt 0;

	// Check for furthers object from center to set a camera distance
	_camDist = 0;
	_dist = 0;
	{
		_dist = (_x select 0) distance _target;
		if (_dist > _camDist) then {
			_camDist = _dist;
		};
	} forEach _compObjects;

	ctrlShow [IDC_GRP_AO_MAP_CONTROLS, false];

	ctrlShow [IDC_GRP_EDIT_CONTROLS, true];
	ctrlShow [IDC_GRP_CAM_TYPE, true];

	if (_cameraAngle == "circling") then {
	  _cameraRadius = _camDist * 2;
	  _cameraHeightCircle = _camDist;
	  _circlingPos = getPosATL _target;
	  [_circlingPos, _cameraRadius, _cameraHeightCircle, 0.2] spawn DMORBAT_fnc_cameraPreviewCircle;
	} else {
		[_target, _cameraAngle, _camDist] spawn DMORBAT_fnc_cameraEdit;
	};

	// Disable buttons
	ctrlEnable [IDC_BT_1_GRP1, false];
	ctrlEnable [IDC_BT_2_GRP1, false];
	ctrlEnable [IDC_BT_3_GRP1, false];
	ctrlEnable [IDC_BT_AO_SEL_SET, false];
	ctrlEnable [IDC_BT_AO_SEL_REMOVE, false];
	ctrlEnable [IDC_BT_AO_SEL_ADD, false];
	ctrlEnable [IDC_BT_AO_SEL_COMP_ADD, false];
	ctrlEnable [IDC_TREE_AO_COMP_1, false];
	ctrlEnable [IDC_TREE_AO_SELECTION_COMP, false];

	ctrlShow [IDC_GRP_TASK_GROUPS, false];
    ctrlShow [IDC_GRP_TASK_DESCRIPTION, false];
	ctrlShow [IDC_GRP_AO_SELECTION, false];
	ctrlShow [IDC_GRP_NAV_BUTTONS, false];
    
    ctrlShow [IDC_GRP_CURRENTSAVEDDATA, false];
    ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
    ctrlShow [IDC_TXT_TIPS, false];
    ctrlShow [IDC_GRP_LEFTBAR_BCKG, false];
    ctrlShow [IDC_GRP_BOTTOMBAR_BCKG, false];
    ctrlShow [IDC_MAP_AO_SEL_T, false];
    ctrlShow [IDC_MAP_AO_SEL_S, false];
    ctrlShow [IDC_IMG_MAPCROSSHAIR, false];

    // Preview control: display and resize
    _ctrl = (_display displayCtrl IDC_BT_PREVIEW);
    _ctrlx = SafeZoneX;
    _ctrly = SafeZoneY;
    _ctrlWidth = SafeZoneW;
    _ctrlHeight = SafeZoneH;
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlShow true;
    _ctrl ctrlCommit 0;
};

true