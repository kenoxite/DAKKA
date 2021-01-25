#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

params [["_action", ["all"]]];
private _currentDate = DMORBAT_customDate;
private _currentDay = _currentDate select 2;
private _currentMonth = _currentDate select 1;
private _currentYear = _currentDate select 0;
private _currentHour = _currentDate select 3;
private _currentMinutes = _currentDate select 4;

if ("all" in _action || "year" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_YEAR);
    lbClear _ctrl;
    for [{private _i = 1982}, {_i <= 2050}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd str _i; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentYear == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "month" in _action) then {
    private _monthNames = [
        "Jan.",
        "Feb.",
        "Mar.",
        "Apr.",
        "May",
        "Jun.",
        "Jul.",
        "Aug.",
        "Sep.",
        "Oct.",
        "Nov.",
        "Dec."
    ];
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MONTH);
    lbClear _ctrl;
    for [{private _i = 1}, {_i <= 12}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd (_monthNames select (_i - 1));
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentMonth == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "day" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_DAY);
    lbClear _ctrl;
    private _maxDays = 30;
    // Check for odd months
    if ((_currentMonth % 2) != 0) then { _maxDays = 31 };
    // Check for february
    if (_currentMonth == 2) then { 
        _maxDays = 28;
        // Check for leap-year
        if (_currentYear call BIS_fnc_isLeapYear) then {
            _maxDays = 29;
        };
    };

    for [{private _i = 1}, {_i <= _maxDays}, {_i = _i + 1}] do 
    {
        private _ctrlIndex = _ctrl lbAdd str _i; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentDay == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "hour" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_HOUR);
    lbClear _ctrl;
    for [{private _i = 0}, {_i <= 23}, {_i = _i + 1}] do 
    {
        // Format time display
        private _fHour = if (_i < 10) then {
            format ["0%1", _i];
        } else { 
            str _i;
        };
        private _ctrlIndex = _ctrl lbAdd _fHour; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentHour == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};

if ("all" in _action || "minutes" in _action) then {
    _ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_MINUTES);
    lbClear _ctrl;
    for [{private _i = 0}, {_i <= 59}, {_i = _i + 1}] do 
    {
        private _fMinutes = if (_i < 10) then {
            format ["0%1", _i];
        }else{
            str _i;
        };
        private _ctrlIndex = _ctrl lbAdd _fMinutes; 
        _ctrl lbSetValue [_ctrlIndex, _i];
        if (_currentMinutes == _i) then {
            _ctrl lbSetCurSel _ctrlIndex;
        };
    };
};