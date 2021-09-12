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
        [DAKKA_settings, _var, DAKKA_saveSlots] call BIS_fnc_setToPairs;
    };

    case "Selected Task":
    {
        [DAKKA_settings, _var, [DAKKA_Task]] call BIS_fnc_setToPairs;
    };

    case "Player Factions":
    {
        [DAKKA_settings, _var, DAKKA_PlayerFactions] call BIS_fnc_setToPairs;
    };

    case "Enemy Factions":
    {
        [DAKKA_settings, _var, DAKKA_EnemyFactions] call BIS_fnc_setToPairs;
    };

    case "Known mods":
    {
        
    };

    case "Date":
    {
        [DAKKA_settings, _var, DAKKA_customDate] call BIS_fnc_setToPairs;
    };

    case "Random Time":
    {
        [DAKKA_settings, _var, [DAKKA_randomTime]] call BIS_fnc_setToPairs;
    };

    case "No night":
    {
        [DAKKA_settings, _var, [DAKKA_noNight]] call BIS_fnc_setToPairs;
    };

    case "Weather":
    {
        [DAKKA_settings, _var, DAKKA_customWeather] call BIS_fnc_setToPairs;
    };

    case "Random Weather":
    {
        [DAKKA_settings, _var, [DAKKA_randomWeather]] call BIS_fnc_setToPairs;
    };

    case "Weather Effect":
    {
        [DAKKA_settings, _var, [DAKKA_weatherEffect]] call BIS_fnc_setToPairs;
    };

    case "Forced Flashlights":
    {
        [DAKKA_settings, _var, [DAKKA_forceFlashlights]] call BIS_fnc_setToPairs;
    };

    case "Flares":
    {
        [DAKKA_settings, _var, [DAKKA_flares]] call BIS_fnc_setToPairs;
    };
};

// if (DAKKA_debug) then { diag_log format ["DAKKA: globalSettingsSave DAKKA_settings: %1", DAKKA_settings] };

// Save the updated data
profileNamespace setVariable ["DAKKA_settings", DAKKA_settings];
diag_log "DAKKA: --- GLOBAL SETTINGS SAVED ---";

true