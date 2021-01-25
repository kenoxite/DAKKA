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
    if (typeOf DMORBAT_SelectedPreviewUnit != tvData [IDC_TREE_SUPPORT_UNITS, tvCurSel IDC_TREE_SUPPORT_UNITS]) then {
        call DMORBAT_fnc_previewGroupDelete;
        DMORBAT_PreviewGroupName = "";  
        DMORBAT_PreviewGroupID = "";    
        [[tvData [IDC_TREE_SUPPORT_UNITS, _selectionPath]]] call DMORBAT_fnc_previewGroup;
        DMORBAT_SelectedPreviewUnit = (units DMORBAT_previewGroup) select 0;
        [true] call DMORBAT_fnc_displayVehicleInfo;
    };
    ctrlEnable [IDC_BT_SUPPORT_UNITS_ADD, true]; 
} else {        
    ctrlEnable [IDC_BT_SUPPORT_UNITS_ADD, false]; 
    [false] call DMORBAT_fnc_displayVehicleInfo;   
};