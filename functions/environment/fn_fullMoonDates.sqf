/*
  Author: kenoxite

  Description:
  Returns array of dates for given year when moon is at its fullest


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

  Set random full moon date in year 1970:
  setDate selectRandom (1970 call DMORBAT_fnc_fullMoonDates);

*/

private _year = param [0, 2035];
private ["_date", "_phase", "_fullMoonDate"];
private _fullMoonPhase = 1;
private _waxing = false;
private _fullMoonDates = [];
for "_i" from dateToNumber [_year, 1, 1, 0, 0] to dateToNumber [_year, 12, 31, 23, 59] step 1 / 365 do
{
    _date = numberToDate [_year, _i];
    _phase = moonPhase _date;
    call
    {
        if (_phase > _fullMoonPhase) exitWith
        {
            _waxing = true;
            _fullMoonDate = _date;
        };
        if (_waxing) exitWith 
        {
            _waxing = false;
            _fullMoonDates pushBack _fullMoonDate;
        };
    };
    _fullMoonPhase = _phase;
};
_fullMoonDates