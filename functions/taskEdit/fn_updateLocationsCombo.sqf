#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available AO locations. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_taskData", "_worldLocationsData", "_locationsData", "_categoryData", "_indexCat", "_locations", "_locPrevObj"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl =  _display displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DAKKA: --- ERROR --- updateLocationsCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

_taskData = DAKKA_TaskData select (DAKKA_Task - 1);
_worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
_locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
_indexCat = lbCurSel (_display displayCtrl IDC_COMBO_AO_SELECTION_CAT);
_categoryData = _locationsData select _indexCat;
_locations = _categoryData select 1;

for [{private _i = 0}, {_i < count _locations}, {_i = _i + 1}] do 
{
    _ctrl lbAdd format ["Location %1", _i + 1]; 
    _ctrl lbSetData [_i, format ["Location %1", _i + 1]];
};

// Update preview locations array
{
  deleteVehicle _x;
} forEach DAKKA_locationPreview;

if ((count _locations) > 0) then {
  ctrlEnable [IDC_BT_AO_SEL_SET, true];
  ctrlEnable [IDC_BT_AO_SEL_REMOVE, true];
};

// First location reserved for previews on user coordinates
_locPrevObj = createVehicle ["Flag_Red_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_locPrevObj hideObject true;
DAKKA_locationPreview = [_locPrevObj];
// Then create reference objects for the actual locations
{
    _locPrevObj = createVehicle ["Flag_Red_F", (_x select 0), [], 0, "CAN_COLLIDE"];
    _locPrevObj hideObject true;
    DAKKA_locationPreview pushBack _locPrevObj;
} forEach _locations;

true