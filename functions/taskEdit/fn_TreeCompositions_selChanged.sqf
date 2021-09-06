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
private ["_mrkr", "_display", "_ctrl"];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: TreeCompositions_selChanged _selectionPath:%1", _selectionPath] };
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl _idc);
  ctrlShow [IDC_GRP_SAVEDDATAPROFILES, false];
if ((count _selectionPath) > 2) then {
	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_COMP_ADD);
	_ctrl ctrlEnable true;
} else {
	_ctrl = (_display displayCtrl IDC_BT_AO_SEL_COMP_ADD);
	_ctrl ctrlEnable false;
};
true