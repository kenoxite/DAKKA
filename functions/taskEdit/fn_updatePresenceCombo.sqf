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
private ["_display", "_ctrl", "_indexCtrl", "_probabilities"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl =  _display displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DAKKA: --- ERROR --- updatePresenceCombo CONTROL %1  could not be found!", _ctrl];
};
lbClear _ctrl;

_probabilities = ["0%", "25%", "50%", "75%", "100%"];

for [{private _i = 0}, {_i < count _probabilities}, {_i = _i + 1}] do
{
  _indexCtrl = _ctrl lbAdd (_probabilities select _i); 
  _ctrl lbSetData [_indexCtrl, (_probabilities select _i)];
};

true