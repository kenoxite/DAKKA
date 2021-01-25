// TASK START


0 fadeSound 0;
cutText ["", "BLACK IN"];

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

// Enable simulation for all composition objects
_nul = [] spawn {
    _taskData = DMORBAT_TaskData select (DMORBAT_Task - 1);
    _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
    _compositionsData = [_worldCompositionsData, worldName] call BIS_fnc_getFromPairs;
    if (!isNil "_compositionsData") then {
        waitUntil { DMORBAT_compositionsLoaded == count _compositionsData };

        {
        	_compObjects =+ _x select 1;
        	_compObjects deleteAt 0;
        	{
        		_obj = _x select 0;
        		_obj enableSimulation true;
                // _obj setVelocity [0, 0, 0];
        		_obj allowDamage true;
        	} forEach _compObjects;
        } forEach _compositionsData;
    };
};

// Create marta module
_supportLogicGroup = createGroup sideLogic;
_marta = _supportLogicGroup createUnit ["MartaManager", _basepos, [], 50, "CAN_COLLIDE"];
setGroupIconsVisible [false, false];

call DMORBAT_fnc_resetWeatherEffects;
_null = [] spawn {
    sleep 1;
    // Weather effect
    if (DMORBAT_weatherEffect != "None") then {
        call compile format ["DMORBAT_%1 = true", DMORBAT_weatherEffect];
        call DMORBAT_fnc_startWeatherEffect;
    };
    // Random time and weather
    if (DMORBAT_randomTime || DMORBAT_automated) then {
       [] spawn DMORBAT_fnc_randomTime;
    };
    if ((DMORBAT_randomWeather || DMORBAT_automated) && (DMORBAT_weatherEffect == "None" || DMORBAT_weatherEffect == "earthquake")) then {
       [] spawn DMORBAT_fnc_randomWeather;
    };
};

// Things to do if using Play Now option
if (DMORBAT_automated) then {
    DMORBAT_automated = false;
};

// Init the task
[] execVM format ["tasks\Task %1\task%1_init.sqf", DMORBAT_Task];