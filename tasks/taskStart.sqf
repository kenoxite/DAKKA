// TASK START


0 fadeSound 0;
cutText ["", "BLACK IN"];

// RANDOM DATE, TIME & WEATHER
call DAKKA_fnc_resetWeatherEffects;
_null = [] spawn {
        if (DAKKA_automated) then {
            // Random date
            _newDate = DAKKA_customDate;
            _newDate set [0, 1985];
            _newDate set [1, [1, 12] call BIS_fnc_randomInt];
            _newDate set [2, [1, 28] call BIS_fnc_randomInt];
            setDate _newDate;
            DAKKA_noNight = DAKKA_noNightAuto;
            [] spawn DAKKA_fnc_randomTime;
            DAKKA_customDate = date;
            DAKKA_weatherEffect = "None";
            [] spawn DAKKA_fnc_randomWeather;
        } else {
            sleep 1;
            // Weather effect
            if (DAKKA_weatherEffect != "None") then {
                call compile format ["DAKKA_%1 = true", DAKKA_weatherEffect];
                call DAKKA_fnc_startWeatherEffect;
            };
            // Random time and weather
            if (DAKKA_randomTime) then {
               [] spawn DAKKA_fnc_randomTime;
            };
            if (DAKKA_randomWeather && (DAKKA_weatherEffect == "None" || DAKKA_weatherEffect == "earthquake")) then {
               [] spawn DAKKA_fnc_randomWeather;
            };
        };
};

[] spawn DAKKA_fnc_cameraIntro;

// LOCATIONS
// Set random location if none was specified in a custom game
if (!DAKKA_automated) then {
    // Retrieve data for this task
    _task = DAKKA_Task;
    _taskData = DAKKA_TaskData select (_task - 1);
    _worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
    _locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
    _categoryData = _locationsData select 0;
    _categoryLocations = _categoryData select 1;
    if (count _categoryLocations == 0) then {
        _locationsPredefined = call compile format ["DAKKA_locations_Task%1", _task];
        // Add locations data to tasks array
        _locations = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
        _thisWorldLocations = [_locations, worldName] call BIS_fnc_getFromPairs;
        if (isNil "_thisWorldLocations") then {
            // Add terrain data and include the predefined locations
            _newArr = [worldName, _locationsPredefined];
            [_taskData, "Locations", [_newArr]] call BIS_fnc_addToPairs;
        } else {
            // Add predefined locations to current terrain
            [_locations, worldName, _locationsPredefined] call BIS_fnc_setToPairs
        };
    };
};

// Start loading screen
if (!DAKKA_automated) then {
    _loadingScreen = createDialog "DAKKA_Loading_Screen";
};

// SPAWN ANNOUNCER UNIT
_faction = DAKKA_PlayerFactions select (DAKKA_Task - 1); 
_officerClass = "";
// Return the first "man" class
{
	if (_officerClass == "") exitWith { _officerClass = (configName _x); };
} forEach (("getText (_x >> 'faction') == _faction && (getNumber (_x >> 'scope') == 2) && (configName _x) isKindOf 'Man'") configClasses (configfile >> "CfgVehicles")); 
if (_officerClass == "") then { _officerClass = typeOf player };
DAKKA_officer = [_officerClass, position player] call DAKKA_fnc_spawnMan;
removeAllWeapons DAKKA_officer;        
removeVest DAKKA_officer;         
removeBackpack DAKKA_officer;
DAKKA_officer setUnitRank "COLONEL";
DAKKA_officer disableAI "PATH";
DAKKA_officer setCaptive true;
DAKKA_officer allowDamage false;
(group DAKKA_officer) setGroupId ["Base"];
DAKKA_martaHide pushBack (group DAKKA_officer);
_basepos = getPos DAKKA_officer;

// Create marta module
_supportLogicGroup = createGroup sideLogic;
_marta = _supportLogicGroup createUnit ["MartaManager", _basepos, [], 50, "CAN_COLLIDE"];
setGroupIconsVisible [false, false];

// Init the task
[] execVM format ["tasks\Task %1\task%1_init.sqf", DAKKA_Task];