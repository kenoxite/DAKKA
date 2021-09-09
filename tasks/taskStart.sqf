// TASK START


0 fadeSound 0;
cutText ["", "BLACK IN"];

// RANDOM DATE, TIME & WEATHER
call DMORBAT_fnc_resetWeatherEffects;
_null = [] spawn {
        if (DMORBAT_automated) then {
            // Random date
            _newDate = DMORBAT_customDate;
            _newDate set [0, 1985];
            _newDate set [1, [1, 12] call BIS_fnc_randomInt];
            _newDate set [2, [1, 28] call BIS_fnc_randomInt];
            setDate _newDate;
            DMORBAT_noNight = DMORBAT_noNightAuto;
            [] spawn DMORBAT_fnc_randomTime;
            DMORBAT_customDate = date;
            DMORBAT_weatherEffect = "None";
            [] spawn DMORBAT_fnc_randomWeather;
        } else {
            sleep 1;
            // Weather effect
            if (DMORBAT_weatherEffect != "None") then {
                call compile format ["DMORBAT_%1 = true", DMORBAT_weatherEffect];
                call DMORBAT_fnc_startWeatherEffect;
            };
            // Random time and weather
            if (DMORBAT_randomTime) then {
               [] spawn DMORBAT_fnc_randomTime;
            };
            if (DMORBAT_randomWeather && (DMORBAT_weatherEffect == "None" || DMORBAT_weatherEffect == "earthquake")) then {
               [] spawn DMORBAT_fnc_randomWeather;
            };
        };
};

[] spawn DMORBAT_fnc_cameraIntro;

// LOCATIONS
// Set random location if none was specified in a custom game
if (!DMORBAT_automated) then {
    // Retrieve data for this task
    _task = DMORBAT_Task;
    _taskData = DMORBAT_TaskData select (_task - 1);
    _worldLocationsData = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
    _locationsData = [_worldLocationsData, worldName] call BIS_fnc_getFromPairs;
    _categoryData = _locationsData select 0;
    _categoryLocations = _categoryData select 1;
    if (count _categoryLocations == 0) then {
        _locationsPredefined = call compile format ["DMORBAT_locations_Task%1", _task];
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
if (!DMORBAT_automated) then {
    _loadingScreen = createDialog "DMORBAT_Loading_Screen";
};

// SPAWN ANNOUNCER UNIT
_faction = DMORBAT_PlayerFactions select (DMORBAT_Task - 1); 
_officerClass = "";
// Return the first "man" class
{
	if (_officerClass == "") exitWith { _officerClass = (configName _x); };
} forEach (("getText (_x >> 'faction') == _faction && (getNumber (_x >> 'scope') == 2) && (configName _x) isKindOf 'Man'") configClasses (configfile >> "CfgVehicles")); 
if (_officerClass == "") then { _officerClass = typeOf player };
DMORBAT_officer = [_officerClass, position player] call DMORBAT_fnc_spawnMan;
removeAllWeapons DMORBAT_officer;        
removeVest DMORBAT_officer;         
removeBackpack DMORBAT_officer;
DMORBAT_officer setUnitRank "COLONEL";
DMORBAT_officer disableAI "PATH";
DMORBAT_officer setCaptive true;
DMORBAT_officer allowDamage false;
(group DMORBAT_officer) setGroupId ["Base"];
DMORBAT_martaHide pushBack (group DMORBAT_officer);
_basepos = getPos DMORBAT_officer;

// Create marta module
_supportLogicGroup = createGroup sideLogic;
_marta = _supportLogicGroup createUnit ["MartaManager", _basepos, [], 50, "CAN_COLLIDE"];
setGroupIconsVisible [false, false];

// Init the task
[] execVM format ["tasks\Task %1\task%1_init.sqf", DMORBAT_Task];