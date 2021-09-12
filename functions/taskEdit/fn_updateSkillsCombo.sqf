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
  diag_log format ["DAKKA: --- ERROR --- updateSkillsCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

for [{private _i = 0}, {_i < count DAKKA_skillLevels}, {_i = _i + 1}] do
{
  _indexCtrl = _ctrl lbAdd (DAKKA_skillLevels select _i); 
  _ctrl lbSetData [_indexCtrl, (DAKKA_skillLevels select _i)];
};

true