#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the probabilities of presence. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo"];
private ["_display", "_ctrl", "_indexCtrl"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl =  _display displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DMORBAT: --- ERROR --- updateSkillsCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

for [{private _i = 0}, {_i < count DMORBAT_skillLevels}, {_i = _i + 1}] do
{
  _indexCtrl = _ctrl lbAdd (DMORBAT_skillLevels select _i); 
  _ctrl lbSetData [_indexCtrl, (DMORBAT_skillLevels select _i)];
};

true