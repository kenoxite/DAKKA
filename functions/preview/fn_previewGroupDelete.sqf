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

// if (DAKKA_debug) then { diag_log format ["DAKKA: preview group: %1", DAKKA_previewGroup] };
// if (!isNull DAKKA_previewGroup) then {
	DAKKA_PreviewGroupName = "";
	DAKKA_PreviewGroupID = "";
	DAKKA_previewUnit = objNull;
	DAKKA_SelectedPreviewUnit = objNull;
	DAKKA_previewUnitisPlayer = false;
    [DAKKA_previewGroup] call DAKKA_fnc_deleteGroup;
    DAKKA_previewGroup = grpNull;
// };