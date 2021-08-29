/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private ["_overcast", "_overcastMin", "_overcastMed", "_overcastMax", "_month", "_rainMonths_Beg", "_rainMonths_End"];

// Base overcast on average precipitation of current month
if ((DMORBAT_rainMonths select 0) > (DMORBAT_rainMonths select 1)) then {
    _rainMonths_Beg = DMORBAT_rainMonths select 1;
    _rainMonths_End = DMORBAT_rainMonths select 0;
} else {
    _rainMonths_Beg = DMORBAT_rainMonths select 0;
    _rainMonths_End = DMORBAT_rainMonths select 1;
};
_month = date select 1;
if (_month >= _rainMonths_Beg && _month <= _rainMonths_End) then {
    // Rainy months
    _overcastMin = 0;
    _overcastMed = ((DMORBAT_overcast / 3) + (((DMORBAT_rain select 1) / 6) min 0.5) + (random ((DMORBAT_rain select 1) / 6))) min 0.9;
    _overcastMax = 1;
} else {
    // Dry months
    _overcastMin = 0;
    _overcastMed = ((DMORBAT_overcast / 4) + (((DMORBAT_rain select 0) / 4) min 0.5) + (random 0.5)) min 0.7;
    _overcastMax = ((DMORBAT_overcast / 4) + ((DMORBAT_rain select 0) / 2) + (random 0.5)) min 0.9;
};

_overcast = random [_overcastMin, _overcastMed, _overcastMax];

diag_log format ["DMORBAT: setOvercast _overcast: %1 [%2, %3, %4]", _overcast, _overcastMin, _overcastMed, _overcastMax];

_overcast