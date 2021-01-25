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
if (_month <= _rainMonths_Beg || _month >= _rainMonths_End) then {
    // Rainy months
    _overcastMin = 0;
    _overcastMed = ((DMORBAT_overcast / 2) + ((DMORBAT_rain select 1) / 2) + (random ((DMORBAT_rain select 1) / 2))) min 0.9;
    _overcastMax = 1;
} else {
    // Dry months
    _overcastMin = 0;
    _overcastMed = ((DMORBAT_overcast / 2) + (DMORBAT_rain select 0) + (random 0.1)) min 0.9;
    _overcastMax = (DMORBAT_overcast + (DMORBAT_rain select 0) + (random 0.7)) min 1;
};

_overcast = random [_overcastMin, _overcastMed, _overcastMax];

diag_log format ["DMORBAT: setOvercast _overcast: %1 [%2, %3, %4]", _overcast, _overcastMin, _overcastMed, _overcastMax];

_overcast