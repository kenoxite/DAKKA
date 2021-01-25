#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Deletes the composition markers. 


  Parameter (s):
  _this select 0: 


  Returns:


  Examples:

*/

private ["_mrkr"];

for [{private _i = 1}, {_i < 99}, {_i = _i + 1}] do
{
  _mrkr = format ["DMORBAT_mrkr_Task%1_comp_%2", DMORBAT_Task, _i];
  deleteMarker _mrkr;
};

true