#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Sets the time and date. 


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params [["_dateType", ""], ["_initTime", time]];
private ["_display", "_ctrl", "_newDate", "_value", "_action"];
_display = findDisplay IDC_MENU_MISSION_EDIT;
_newDate = DAKKA_customDate;
_action = [];
switch (_dateType) do {
    case "year":
    {
        _ctrl = _display displayCtrl IDC_COMBO_ENVSETTINGS_YEAR;
        _value = _ctrl lbValue (lbCurSel _ctrl);
        _newDate set [0, _value];
        _action pushBack "day";
    };
    case "month":
    {
        _ctrl = _display displayCtrl IDC_COMBO_ENVSETTINGS_MONTH;
        _value = _ctrl lbValue (lbCurSel _ctrl);
        _newDate set [1, _value];
        _action pushBack "day";
    };
    case "day":
    {
        _ctrl = _display displayCtrl IDC_COMBO_ENVSETTINGS_DAY;
        _value = _ctrl lbValue (lbCurSel _ctrl);
        _newDate set [2, _value];
    };
    case "hour":
    {
        _ctrl = _display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR;
        _value = _ctrl lbValue (lbCurSel _ctrl);
        _newDate set [3, _value];
    };
    case "minutes":
    {
        _ctrl = _display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES;
        _value = _ctrl lbValue (lbCurSel _ctrl);
        _newDate set [4, _value];
    };
};
setDate _newDate;
DAKKA_customDate = _newDate;
if (count _action > 0) then {
    [_action] call DAKKA_fnc_fillDate;
};

if (DAKKA_debug) then { diag_log format ["time: %1", time - _initTime] };
// Don't update time and weather when just loading the page to avoid spamming the change X functions
if (((time - _initTime) > 1) || _dateType == "minutes") then {
    // Update weather (only when changing month)
    if (_dateType == "month") then {
        if (DAKKA_randomWeather) then {
            [] spawn DAKKA_fnc_randomWeather;
        } else {
            [DAKKA_customWeather] spawn DAKKA_fnc_setWeather;
        };
    };

    // Save settings
    if (!DAKKA_randomTime) then {
        ["Date"] call DAKKA_fnc_globalSettingsSave;
    } else {
        diag_log "DAKKA: --- TIME SET ---";
    };

    if (DAKKA_cameraIntroPlaying) then {
        [] spawn DAKKA_fnc_cameraIntro;
    };
};