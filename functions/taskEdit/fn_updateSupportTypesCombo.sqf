#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available support types. 
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_taskData", "_supportTypesData", "_supportTypeName"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DMORBAT: --- ERROR --- updateSupportTypesCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_supportTypesData = [_taskData, "Support groups"] call BIS_fnc_getFromPairs;

for [{private _i = 0}, {_i < count _supportTypesData}, {_i = _i + 1}] do 
{
    _thisSupportTypeData = _supportTypesData select _i;
    _supportTypeName = _thisSupportTypeData select 0;
    _ctrl lbAdd _supportTypeName; 
    _ctrl lbSetData [_i, _supportTypeName];
};

true