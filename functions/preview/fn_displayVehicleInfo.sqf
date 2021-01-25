#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/
params [["_show", true]];
private ["_display", "_ctrl", "_unit"];

_display = findDisplay IDC_MENU_MISSION_EDIT;

_unit = if (isNull DMORBAT_SelectedPreviewUnit) then { 
            vehicle DMORBAT_previewUnit;
        } else {
            vehicle DMORBAT_SelectedPreviewUnit;
        };


private _isMan = [_unit] call DMORBAT_fnc_isMan;

if (_show && !_isMan && !isNull _unit) then {
    // Fill data
    private _unitClass = typeOf _unit;

    // Passenger seats
    _ctrl = (_display displayCtrl IDC_TITLE_VEHICLEINFO_1);
    _ctrl ctrlSetText "Passenger Seats:";
    _ctrl ctrlEnable false;
    private _passengerSeats = (fullCrew [_unit, "", true]) select {isNull (_x select 0)};
    _ctrl = (_display displayCtrl IDC_TXT_VEHICLEINFO_1);
    _ctrl ctrlSetText str (count _passengerSeats);
    _ctrl ctrlEnable false;

    // Weapons
    private _weapons = weapons _unit;
    _ctrl = (_display displayCtrl IDC_TITLE_VEHICLEINFO_2);
    _ctrl ctrlSetText "Weapons:";
    _ctrl ctrlEnable false;
    _ctrl = (_display displayCtrl IDC_TXT_VEHICLEINFO_2);
    private _weaponsTxt = "None";
    {
        private _name = getText (configfile >> "CfgWeapons" >> _x >> "displayName");
        _weaponsTxt = format ["%1%2%3", if (_forEachIndex == 0) then {""} else {_weaponsTxt}, if (_forEachIndex > 0) then {", "} else {""}, _name];
    } forEach _weapons;
    _ctrl ctrlSetText _weaponsTxt;
    _ctrl ctrlEnable false;

    // Show
    _ctrl = (_display displayCtrl IDC_GRP_VEHICLEINFO);
    _ctrl ctrlShow true;

} else {
    // Hide
    _ctrl = (_display displayCtrl IDC_GRP_VEHICLEINFO);
    _ctrl ctrlShow false;
};

true