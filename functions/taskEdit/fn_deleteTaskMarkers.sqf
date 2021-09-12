#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Deletes the task markers. 


  Parameter (s):
  _this select 0: 


  Returns:


  Examples:

*/

// Reset markers
for [{private _i = 1}, {_i < 99}, {_i = _i + 1}] do
{
    _mrkr = format ["DAKKA_mrkr_Task%1_location_%2", DAKKA_Task, _i];
    deleteMarker _mrkr;

    // Delete aditional markers
    if (DAKKA_Task == 2) then {
        // Contested area
        _mrkr = format ["DAKKA_mrkr_Task%1_location_%2_area", DAKKA_Task, _i];
        deleteMarker _mrkr;
        // Friendly spawn
        _mrkr = format ["DAKKA_mrkr_Task%1_location_%2_area_friendly", DAKKA_Task, _i];
        deleteMarker _mrkr;
        // Friendly spawn Text
        _mrkr = format ["DAKKA_mrkr_Task%1_location_%2_area_friendly_txt", DAKKA_Task, _i];
        deleteMarker _mrkr;
        // Enemy spawn
        _mrkr = format ["DAKKA_mrkr_Task%1_location_%2_area_enemy", DAKKA_Task, _i];
        deleteMarker _mrkr;
        // Enemy spawn Text
        _mrkr = format ["DAKKA_mrkr_Task%1_location_%2_area_enemy_txt", DAKKA_Task, _i];
        deleteMarker _mrkr;
    };
};

true