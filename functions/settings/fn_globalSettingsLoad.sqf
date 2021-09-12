/*
  Author: kenoxite

  Description:
  Loads the saved global settings 


  Parameter (s):


  Returns:


  Examples:

*/

DAKKA_settings = profileNamespace getVariable ["DAKKA_settings", DAKKA_settings];

DAKKA_Task = ([DAKKA_settings, "Selected Task"] call BIS_fnc_getFromPairs) select 0;
DAKKA_saveSlots = [DAKKA_settings, "Selected Profiles"] call BIS_fnc_getFromPairs;
DAKKA_PlayerFactions = [DAKKA_settings, "Player Factions"] call BIS_fnc_getFromPairs;
DAKKA_EnemyFactions = [DAKKA_settings, "Enemy Factions"] call BIS_fnc_getFromPairs;
DAKKA_customDate = [DAKKA_settings, "Date"] call BIS_fnc_getFromPairs;
DAKKA_customWeather = [DAKKA_settings, "Weather"] call BIS_fnc_getFromPairs;
DAKKA_weatherEffect = ([DAKKA_settings, "Weather Effect"] call BIS_fnc_getFromPairs) select 0;
DAKKA_randomTime = ([DAKKA_settings, "Random Time"] call BIS_fnc_getFromPairs) select 0;
DAKKA_randomWeather = ([DAKKA_settings, "Random Weather"] call BIS_fnc_getFromPairs) select 0;
DAKKA_noNight = ([DAKKA_settings, "No night"] call BIS_fnc_getFromPairs) select 0;
DAKKA_forceFlashlights = ([DAKKA_settings, "Forced Flashlights"] call BIS_fnc_getFromPairs) select 0;
DAKKA_flares = ([DAKKA_settings, "Flares"] call BIS_fnc_getFromPairs) select 0;


diag_log "DAKKA: --- GLOBAL SETTINGS LOADED ---";

true