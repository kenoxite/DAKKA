/*
  Author: kenoxite

  Description:
  Displays the animated text at the start of the mission. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params [["_pos", position player], ["_format", "mil"]];

private _location = "";
private _locationList = nearestLocations [_pos, ["NameLocal", "CityCenter", "NameCityCapital", "NameCity", "NameVillage", "NameMarine", "Name", "Area"] , 1000];

private _fnc_BRPVP_getWeekDay = {
    private _date = [_this select 0,_this select 1,_this select 2,0,0];
    private _yearBefore = ((_date select 0)-1) max 0;
    private _qttLeapYears = floor (_yearBefore/4);
    private _qttNormalYears = _yearBefore-_qttLeapYears;
    private _days = _qttNormalYears+_qttLeapYears*(366/365);
    _days = _days+dateToNumber _date;
    (round (_days/(1/365))) mod 7
};

{
    if (_location == "" && (text _x) != "") exitWith {
        _location = text _x;
    };
} forEach _locationList;

private _date = date;
private _dateMonth = _date select 1;

private _monthZeros = str _dateMonth;
while { count _monthZeros < 2 } do {_monthZeros = format["0%1",_monthZeros] };

private _monthTextArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
private _monthText = _monthTextArr select (_dateMonth - 1);

private _dateDay = _date select 2;
private _dayZeros = str _dateDay;
while { count _dayZeros < 2 } do {_dayZeros = format["0%1",_dayZeros] };

private _dateHour = _date select 3;
private _hoursZeros = str _dateHour;
while { count _hoursZeros < 2 } do {_hoursZeros = format["0%1",_hoursZeros] };

private _dateMinutes = _date select 4;
private _minutesZeros = str _dateMinutes;
while { count _minutesZeros < 2 } do {_minutesZeros = format["0%1",_minutesZeros] };

private _weekdaysArr = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
private _weekday = _weekdaysArr select (_date call _fnc_BRPVP_getWeekDay);

private _date_n_time = if (_format == "mil") then {
    // J - Local Time Zone
    // Military format: 10 1300 J JUL
    toUpper (format ["%1 %2%3 J %4", _dayZeros, _hoursZeros, _minutesZeros, _monthText]);
} else {
    // Civilian format: Sun, Jul 10, 13:00
    format ["%1, %2 %3, %4:%5", _weekday, _monthText, _dateDay, _hoursZeros, _minutesZeros];
};
[_location, _date_n_time]