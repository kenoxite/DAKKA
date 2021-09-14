#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Preview the currently selected location. 


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params [["_index", -1], ["_end", false]];
private ["_pos", "_display", "_ctrl", "_cameraPos", "_cameraDir", "_cameraFOV", "_cameraRelX", "_cameraRelY", "_cameraRelZ", "_cameraHeight", "_cameraTarget" , "_circlingPos", "_circlingDistance", "_cameraRadius", "_cameraHeightCircle", "_indexCat", "_locPrevObj", "_taskData", "_worldLocationsData", "_locationsData"];
// systemChat format ["DMBORBAT: locationPreview _index: %1", _index];

if (typeName _index != "NUMBER") exitWith { false };

_display = findDisplay IDC_MENU_MISSION_EDIT;

call DAKKA_fnc_cameraPreviewTerminate;
waitUntil {DAKKA_cameraPreviewTerminateDone};

if (_end) then {

  // Update buttons
  _ctrl = (_display displayCtrl IDC_BT_AO_SEL_PREVIEW_COORDS);
  _ctrl ctrlSetText "PREVIEW COORDS";
  _ctrl ctrlSetEventHandler ["ButtonClick", '[] call DAKKA_fnc_locationPreview;'];
  _ctrl ctrlSetTooltip "Preview the area at the current coordinates";

  // Show things
  ctrlShow [IDC_GRP_TASK_DESCRIPTION, true];
  ctrlShow [IDC_GRP_AO_SELECTION, true];
  ctrlShow [IDC_GRP_NAV_BUTTONS, true];
  ctrlShow [IDC_GRP_CURRENTSAVEDDATA, true];
  ctrlShow [IDC_TXT_TIPS, true];
  ctrlShow [IDC_GRP_LEFTBAR_BCKG, true];
  ctrlShow [IDC_GRP_BOTTOMBAR_BCKG, true];
  ctrlShow [IDC_GRP_TASK_GROUPS, true];

    ctrlShow [IDC_TREE_PLAYER_GRP1, false];
    ctrlShow [IDC_GRP_TASK_GROUP2, false];
    ctrlShow [IDC_GRP_TASK_GROUP3, false];

    // Control the buttons display
    ctrlShow [IDC_BT_3_GRP1, false];
    ctrlShow [IDC_BT_4_GRP1, false];
    if (DAKKA_Task == 1) then {
        ctrlShow [IDC_BT_AO_SEL_ROTATE_LEFT, false];
        ctrlShow [IDC_BT_AO_SEL_ROTATE_RIGHT, false];
    };

  ctrlShow [IDC_IMG_MAPCROSSHAIR, true];
  ctrlShow [IDC_GRP_AO_MAP_CONTROLS, true];
  ctrlShow [IDC_BT_AO_SEL_SWITCHMAP, true];
  if (DAKKA_mapSatellite) then {
    ctrlShow [IDC_MAP_AO_SEL_T, false];
    ctrlShow [IDC_MAP_AO_SEL_S, true];
  } else {
    ctrlShow [IDC_MAP_AO_SEL_T, true];
    ctrlShow [IDC_MAP_AO_SEL_S, false];
  };

    // Preview control: display and resize
    _ctrl = (_display displayCtrl IDC_BT_PREVIEW);
    _ctrlx = safezoneX + (20 * pixelGridNoUIScale * pixelW);
    _ctrly = safezoneY + (11 * pixelGridNoUIScale * pixelH);
    _ctrlWidth = (safezoneW - (20 * pixelGridNoUIScale * pixelW));
    _ctrlHeight = (SafeZoneH - (27 * pixelGridNoUIScale * pixelH));
    _ctrl ctrlSetPosition [ _ctrlx, _ctrly, _ctrlWidth, _ctrlHeight];
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;

  // Reset preview location reference
  //(DAKKA_locationPreview select (count DAKKA_locationPreview) - 1) setPos [0 ,0 ,0];

  // Set focus
  _ctrl = (_display displayCtrl IDC_COMBO_AO_SELECTION_LOC);
  ctrlSetFocus _ctrl;

} else {
  
  // Update buttons
  if (_index >= 0) then {
    _taskData = DAKKA_TaskData select (DAKKA_Task - 1);
    _worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
    _locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
    _indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
    _pos = ((_locationsData select _indexCat) select (_index + 1)) select 0;
  } else {
    _ctrl = (_display displayCtrl IDC_BT_AO_SEL_PREVIEW_COORDS);
    _ctrl ctrlSetText "END PREVIEW";
    _ctrl ctrlSetEventHandler ["ButtonClick", '[-1, true] call DAKKA_fnc_locationPreview;'];
    _ctrl ctrlSetTooltip "End the current location preview";
    ctrlSetFocus _ctrl;
    _pos = getMarkerPos "DAKKA_mrkr_MapCenter";
  };

  // Hide things
  ctrlShow [IDC_GRP_TASK_DESCRIPTION, false];
  ctrlShow [IDC_GRP_AO_SELECTION, false];
  ctrlShow [IDC_GRP_AO_COMPOSITIONS, false];
  ctrlShow [IDC_GRP_NAV_BUTTONS, false];
  ctrlShow [IDC_BT_AO_SEL_SWITCHMAP, false];
  ctrlShow [IDC_GRP_CURRENTSAVEDDATA, false];
  ctrlShow [IDC_TXT_TIPS, false];
  ctrlShow [IDC_GRP_LEFTBAR_BCKG, false];
  ctrlShow [IDC_GRP_BOTTOMBAR_BCKG, false];
  ctrlShow [IDC_MAP_AO_SEL_T, false];
  ctrlShow [IDC_MAP_AO_SEL_S, false];
  ctrlShow [IDC_GRP_TASK_GROUPS, false];
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


  // systemChat format ["DAKKA: locationPreview _pos: %1", _pos];
  _cameraPos = _pos getPos [100, 180];
  _cameraDir = 180;
  _cameraFOV = 0.7;
  _cameraRelX = 0;
  _cameraRelY = 0;
  _cameraRelZ = 20;
  _cameraHeight = 5;
  _cameraTarget = objNull;

  _cameraRadius = 75;
  _cameraHeightCircle = 25;
  _circlingPos = _pos;

    if (_index >= 0) then {
      // Preview at listed location
      (DAKKA_locationPreview select (_index + 1)) setPos _pos;
    } else {
      // Preview at coordinates
      (DAKKA_locationPreview select 0) setPos _pos;
    };
  // [_cameraPos, _cameraDir, _cameraFOV, _cameraRelX, _cameraRelY, _cameraRelZ, _cameraHeight] spawn DAKKA_fnc_cameraPreviewStatic;
  [_circlingPos, _cameraRadius, _cameraHeightCircle, 0.2] spawn DAKKA_fnc_cameraPreviewCircle;
};
