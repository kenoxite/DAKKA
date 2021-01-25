/*
  Author: kenoxite

  Description:
  Displays the animated text at the start of the mission. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_pos"];
private _location = "";
private _locationList = nearestLocations [_pos, ["NameLocal", "CityCenter", "NameCityCapital", "NameCity", "NameVillage", "NameMarine", "Name", "Area"] , 1000];
{
    if (_location == "" && (text _x) != "") exitWith {
        _location = text _x;
    };
} forEach _locationList;
private _hour = if ((date select 3) < 10) then {
                    format ["0%1", date select 3];
                } else { 
                    date select 3;
                };
private _minute = if ((date select 4) < 10) then {
                    format ["0%1", date select 4];
                }else{
                    date select 4;
                };
// [toUpper (format ["%1", _location]), format ["%1:%2", _hour, _minute]] spawn BIS_fnc_infoText;

[toUpper (_location), format ["%1:%2", _hour, _minute]]