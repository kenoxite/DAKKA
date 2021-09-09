/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0: 
 

  Returns:


  Examples:

*/

private _editing = false;
if !(isNil "DMORBAT_mainDialogOpened") then {
    _editing = DMORBAT_mainDialogOpened;
};

enableEnvironment DMORBAT_environment;

switch (DMORBAT_weatherEffect) do
{
    case "snow":
    {  

        [700, 1.25, 0.2] execVM "scripts\weatherEffects\snow.sqf";
    };
    case "snow_light":
    {  
        [10, 0.1, 0.9] execVM "scripts\weatherEffects\snow.sqf";
    };
    case "earthquake":
    {  
        private _damageBuildings = if (_editing) then { false } else { true };
        [_damageBuildings] execVM "scripts\weatherEffects\earthquake.sqf";
    };
    case "duststorm":
    {  
        [] execVM "scripts\weatherEffects\duststorm.sqf";
    };
    case "monsoon":
    {  
        [] execVM "scripts\weatherEffects\monsoon.sqf";
    };
    case "postapocalyptic":
    {  
        private _damageBuildings = if (_editing) then { false } else { true };
        [_damageBuildings] execVM "scripts\weatherEffects\postapocalyptic.sqf";
    };
};

true