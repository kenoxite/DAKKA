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
    _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2", DMORBAT_Task, _i];
    deleteMarker _mrkr;

    // Delete aditional markers
    if (DMORBAT_Task == 2) then {
        // Contested area
        _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area", DMORBAT_Task, _i];
        deleteMarker _mrkr;
        // Friendly spawn
        _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly", DMORBAT_Task, _i];
        deleteMarker _mrkr;
        // Friendly spawn Text
        _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_friendly_txt", DMORBAT_Task, _i];
        deleteMarker _mrkr;
        // Enemy spawn
        _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy", DMORBAT_Task, _i];
        deleteMarker _mrkr;
        // Enemy spawn Text
        _mrkr = format ["DMORBAT_mrkr_Task%1_location_%2_area_enemy_txt", DMORBAT_Task, _i];
        deleteMarker _mrkr;
    };
};

true