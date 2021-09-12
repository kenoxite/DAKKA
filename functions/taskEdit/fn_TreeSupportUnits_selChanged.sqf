#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_selectionPath"];
disableSerialization;
  ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
  
if ((count _selectionPath) > 1) then {
    if (typeOf DAKKA_SelectedPreviewUnit != tvData [IDC_TREE_SUPPORT_UNITS, tvCurSel IDC_TREE_SUPPORT_UNITS]) then {
        call DAKKA_fnc_previewGroupDelete;
        DAKKA_PreviewGroupName = "";  
        DAKKA_PreviewGroupID = "";    
        [[tvData [IDC_TREE_SUPPORT_UNITS, _selectionPath]]] call DAKKA_fnc_previewGroup;
        DAKKA_SelectedPreviewUnit = (units DAKKA_previewGroup) select 0;
        [true] call DAKKA_fnc_displayVehicleInfo;
    };
    ctrlEnable [IDC_BT_SUPPORT_UNITS_ADD, true]; 
} else {        
    ctrlEnable [IDC_BT_SUPPORT_UNITS_ADD, false]; 
    [false] call DAKKA_fnc_displayVehicleInfo;   
};