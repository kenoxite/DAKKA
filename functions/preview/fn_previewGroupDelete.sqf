#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Deletes the preview group. 


  Parameter (s):
  _this select 0: _idcCombo
 

  Returns:


  Examples:

*/

// if (DMORBAT_debug) then { diag_log format ["DMORBAT: preview group: %1", DMORBAT_previewGroup] };
// if (!isNull DMORBAT_previewGroup) then {
	DMORBAT_PreviewGroupName = "";
	DMORBAT_PreviewGroupID = "";
	DMORBAT_previewUnit = objNull;
	DMORBAT_SelectedPreviewUnit = objNull;
	DMORBAT_previewUnitisPlayer = false;
    [DMORBAT_previewGroup] call DMORBAT_fnc_deleteGroup;
    DMORBAT_previewGroup = grpNull;
// };