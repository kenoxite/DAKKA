#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of the AO location categories combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc", "_selectionPath"];
private ["_mrkr"];
if (DAKKA_debug) then { diag_log format ["DAKKA: TreePlacedCompositions_selChanged _selectionPath:%1", _selectionPath] };

if ((_selectionPath select 0) >= 0) then {
	ctrlEnable [IDC_BT_1_GRP1, true];
	ctrlEnable [IDC_BT_2_GRP1, true];
	ctrlEnable [IDC_BT_3_GRP1, true];

      ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
} else {
	ctrlEnable [IDC_BT_1_GRP1, false];
	ctrlEnable [IDC_BT_2_GRP1, false];
	ctrlEnable [IDC_BT_3_GRP1, false];
};

true