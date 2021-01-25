#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Displays a message in the message area. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params ["_txt"];
private ["_display", "_ctrl", "_currentText"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_TXT_MESSAGEBOX);
_ctrl ctrlSetText _txt;

sleep 30;

_currentText = ctrlText _ctrl;
if (_currentText == _txt) then {
    _ctrl ctrlSetText "";
};
