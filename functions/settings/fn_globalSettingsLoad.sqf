/*
  Author: kenoxite

  Description:
  Loads the saved global settings 


  Parameter (s):


  Returns:


  Examples:

*/

DMORBAT_settings = profileNamespace getVariable ["DMORBAT_settings", DMORBAT_settings];

DMORBAT_Task = ([DMORBAT_settings, "Selected Task"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_saveSlots = [DMORBAT_settings, "Selected Profiles"] call BIS_fnc_getFromPairs;
DMORBAT_PlayerFactions = [DMORBAT_settings, "Player Factions"] call BIS_fnc_getFromPairs;
DMORBAT_EnemyFactions = [DMORBAT_settings, "Enemy Factions"] call BIS_fnc_getFromPairs;
DMORBAT_customDate = [DMORBAT_settings, "Date"] call BIS_fnc_getFromPairs;
DMORBAT_customWeather = [DMORBAT_settings, "Weather"] call BIS_fnc_getFromPairs;
DMORBAT_weatherEffect = ([DMORBAT_settings, "Weather Effect"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_randomTime = ([DMORBAT_settings, "Random Time"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_randomWeather = ([DMORBAT_settings, "Random Weather"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_noNight = ([DMORBAT_settings, "No night"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_forceFlashlights = ([DMORBAT_settings, "Forced Flashlights"] call BIS_fnc_getFromPairs) select 0;
DMORBAT_flares = ([DMORBAT_settings, "Flares"] call BIS_fnc_getFromPairs) select 0;


diag_log "DMORBAT: --- GLOBAL SETTINGS LOADED ---";

true