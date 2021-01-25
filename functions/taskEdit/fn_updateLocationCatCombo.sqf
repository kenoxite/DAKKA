#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available AO location categories. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_ctrl", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_thisCategoryName"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DMORBAT: --- ERROR --- updateLocationCatCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

_taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;

for [{private _i = 0}, {_i < count _locationsData}, {_i = _i + 1}] do 
{
    _categoryData = _locationsData select _i;
    _thisCategoryName = _categoryData select 0;
    _ctrl lbAdd _thisCategoryName; 
    _ctrl lbSetData [_i, _thisCategoryName];
};

true