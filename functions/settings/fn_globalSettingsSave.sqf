/*
  Author: kenoxite

  Description:
  Saves the global settings 


  Parameter (s):


  Returns:


  Examples:

*/

params [["_var", ""]];

switch (_var) do
{
    case "Selected Profiles":
    {
        [DMORBAT_settings, _var, DMORBAT_saveSlots] call BIS_fnc_setToPairs;
    };

    case "Selected Task":
    {
        [DMORBAT_settings, _var, [DMORBAT_Task]] call BIS_fnc_setToPairs;
    };

    case "Player Factions":
    {
        [DMORBAT_settings, _var, DMORBAT_PlayerFactions] call BIS_fnc_setToPairs;
    };

    case "Enemy Factions":
    {
        [DMORBAT_settings, _var, DMORBAT_EnemyFactions] call BIS_fnc_setToPairs;
    };

    case "Known mods":
    {
        
    };

    case "Date":
    {
        [DMORBAT_settings, _var, DMORBAT_customDate] call BIS_fnc_setToPairs;
    };

    case "Random Time":
    {
        [DMORBAT_settings, _var, [DMORBAT_randomTime]] call BIS_fnc_setToPairs;
    };

    case "No night":
    {
        [DMORBAT_settings, _var, [DMORBAT_noNight]] call BIS_fnc_setToPairs;
    };

    case "Weather":
    {
        [DMORBAT_settings, _var, DMORBAT_customWeather] call BIS_fnc_setToPairs;
    };

    case "Random Weather":
    {
        [DMORBAT_settings, _var, [DMORBAT_randomWeather]] call BIS_fnc_setToPairs;
    };

    case "Weather Effect":
    {
        [DMORBAT_settings, _var, [DMORBAT_weatherEffect]] call BIS_fnc_setToPairs;
    };

    case "Forced Flashlights":
    {
        [DMORBAT_settings, _var, [DMORBAT_forceFlashlights]] call BIS_fnc_setToPairs;
    };

    case "Flares":
    {
        [DMORBAT_settings, _var, [DMORBAT_flares]] call BIS_fnc_setToPairs;
    };
};

// if (DMORBAT_debug) then { diag_log format ["DMORBAT: globalSettingsSave DMORBAT_settings: %1", DMORBAT_settings] };

// Save the updated data
profileNamespace setVariable ["DMORBAT_settings", DMORBAT_settings];
diag_log "DMORBAT: --- GLOBAL SETTINGS SAVED ---";

true