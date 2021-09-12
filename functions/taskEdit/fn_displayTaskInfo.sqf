#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Controls the display of the information related to a task in the task selection menu. 


  Parameter (s):
 
 

  Returns:


  Examples:

*/
private ["_display", "_ctrl", "_img", "_txt"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

_ctrl = (_display displayCtrl IDC_MM_TASK_IMG);
_img = call compile format ["DAKKA_Task%1_Image", DAKKA_Task];
_ctrl ctrlSetText _img;

_ctrl = (_display displayCtrl IDC_MM_TASK_DESC);
_txt = call compile format ["DAKKA_Task%1_Desc_Short", DAKKA_Task];
_ctrl ctrlSetText _txt;
// _ctrl ctrlSetStructuredText (parseText format ["<t size='0.45' align='center' valign='middle'>%1</t>", _txt]);