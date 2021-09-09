#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Extracts data from factions

  Parameter (s):
  _this select 0: _obj

  Returns:


  Examples:

*/

// _loadingScreen = createDialog "DMORBAT_Loading_Screen";
// if (!_loadingScreen) then { systemChat "Loading screen could not be opened!" };

private _display = findDisplay IDC_LOADING_SCREEN;
private _ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

private _factionsData = [];
private _validFactions = [];

private _addFaction = {
    params ["_factionClass"];
    // Add faction name, flag and icon
    {
        private _thisFactionName = getText (_x >> "displayName"); 
        private _thisFactionFlag = getText (_x >> "flag");
        private _thisFactionIcon = getText (_x >> "icon");
        private _thisSideNum = getNumber (_x >> "side");
        private _txt = format ["Extracting faction data from ""%1""...", _thisFactionName];
        _ctrl ctrlSetText _txt; 
        if (DMORBAT_debug) then { diag_log format ["DMORBAT: %1 (%2)", _txt, _factionClass] }; 
        private ["_defFlag", "_defIcon", "_color"];
        switch (_thisSideNum) do {
            case 1: {
                _defFlag = "\a3\Data_f\flags\flag_blue_co.paa";
                _color = ["Map", "BLUFOR"] call BIS_fnc_displayColorGet;
            };
            case 0: {
                _defFlag = "\a3\Data_f\flags\flag_red_co.paa";
                _color = ["Map", "OPFOR"] call BIS_fnc_displayColorGet;
            };
            case 2: {
                _defFlag = "\a3\Data_f\flags\flag_green_co.paa";
                _color = ["Map", "Independent"] call BIS_fnc_displayColorGet;
            };
            case 3: {
                _defFlag = "\a3\Data_f\flags\flag_white_co.paa";
                _color = ["Map", "BLUFOR"] call BIS_fnc_displayColorGet;
            };                      
        };  
        _defIcon = format ["#(rgb,8,8,3)color(%1,%2,%3,1)", _color select 0, _color select 1, _color select 2];
        if (isNil "_thisFactionFlag") then { _thisFactionFlag = _defFlag };
        if (isNil "_thisFactionIcon") then { _thisFactionIcon = _defIcon };
        if (_thisFactionFlag == "") then { _thisFactionFlag = _defFlag };
        if (_thisFactionIcon == "") then { _thisFactionIcon = _defIcon };
        private _thisFactionData = [configName _x, _thisFactionName, _thisFactionFlag, _thisFactionIcon, _thisSideNum];
        // if (DMORBAT_debug) then { diag_log format ["DMORBAT: _thisFactionData = %1", _thisFactionData] };
        _factionsData pushBack _thisFactionData;
    } forEach ("((configName _x) == _factionClass)" configClasses (configFile >> "CfgFactionClasses"));
};


_txt = "Faction data extraction has started!";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: ----------------- %1 -----------------", _txt]; 

private _bannedFactions = [
    "Virtual_F"
];

// Check for factions with valid units
private _txt = "Extracting data from factions with valid units...";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: %1", _txt];
{
    private _factionClass = configName _x;
    if !(_factionClass in _bannedFactions) then {
        private _thisSideNum = getNumber (_x >> "side");
        if (_thisSideNum >= 0 && _thisSideNum <= 3) then {
            {
                if (getNumber (_x >> 'scope') == 2) then {
                    // Exit search for this faction if a valid unit has already been found
                    private _index = _validFactions find _factionClass;
                    if (_index < 0) then {
                        private _allowFaction = false;
                        private _thisClassName = configName _x;
                        if (_thisClassName isKindOf 'Man') then {
                            _allowFaction = true;
                        };
                        if (!_allowFaction) then {
                            if (_thisClassName isKindOf 'LandVehicle') then {
                                _allowFaction = true;
                            };
                        };
                        if (!_allowFaction) then {
                            if (_thisClassName isKindOf 'Air') then {
                                _allowFaction = true;
                            };
                        };
                        if (!_allowFaction) then {
                            if (_thisClassName isKindOf 'Ship') then {
                                _allowFaction = true;
                            };
                        };
                        if (_allowFaction) then {
                            _validFactions pushBack _factionClass;
                            [_factionClass] call _addFaction;
                        };
                    };
                };
            } forEach ("(getText (_x >> 'faction') == _factionClass)" configClasses (configFile >> "CfgVehicles"));
        };
    };
} forEach ("true" configClasses (configFile >> "CfgFactionClasses"));

// {
//     if (DMORBAT_debug) then { diag_log format ["DMORBAT: _validFactions %2: %1", _x, _forEachIndex] };
// } forEach _validFactions;

_txt = "Faction data extraction has finished!";
_ctrl ctrlSetText _txt; 
diag_log format ["DMORBAT: ----------------- %1 -----------------", _txt]; 

// {
//     if (DMORBAT_debug) then { diag_log format ["DMORBAT: _factionsData %2: %1", _x, _forEachIndex] };
// } forEach _factionsData;

_factionsData