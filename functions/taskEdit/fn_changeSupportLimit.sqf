#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
 
 

  Returns:


  Examples:

*/

private ["_display", "_ctrl", "_taskData", "_groupsData", "_catIndex", "_groupsCategoryData", "_thisCategoryData", "_supportLimitData", "_supportLimit", "_supportType"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

_ctrl = _display displayCtrl IDC_COMBO_SUPPORT_TYPES;
_supportType = _ctrl lbData (lbCurSel _ctrl);

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_groupsData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;
_catIndex = [_groupsData, _supportType] call BIS_fnc_findInPairs;
if (_catIndex < 0) exitWith { diag_log format ["DMORBAT: changeSupportLimit Suppport type ""%1"" not found!", _supportType]; false };
_groupsCategoryData = _groupsData select _catIndex; 
_thisCategoryData = _groupsCategoryData select 1;
_supportLimitData = _thisCategoryData select 0;

_ctrl = _display displayCtrl IDC_EDIT_SUPPORT_LIMIT;
_supportLimit = floor (parseNumber (ctrlText _ctrl));
if (_supportLimit < -1) then { _supportLimit = -1; };
_supportLimitData set [0, _supportLimit];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: changeSupportLimit _supportLimit: %1", _supportLimit] };

call DMORBAT_fnc_settingsSave;

true