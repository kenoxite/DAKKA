/*
  Author: kenoxite

  Description:
  Loads the saved settings 


  Parameter (s):


  Returns:


  Examples:

*/

// Retrieve task data
private _savedData = profileNamespace getVariable (format ["DAKKA_Task%1", DAKKA_Task]);

// No saved data
if (isNil "_savedData") exitWith {
    diag_log format ["DAKKA: settingsLoad --- WARNING --- No saved task data found. Using default task data", ""];
    // Save task settings
    call DAKKA_fnc_settingsSave;
    false
};

// Saved data found
private _slotIndex = (DAKKA_saveSlots select (DAKKA_Task - 1));
private _currentSlot = _savedData select _slotIndex;
// if (DAKKA_debug) then { diag_log format ["DAKKA: settingsLoad _currentSlot: %1", _currentSlot] };
private _slotName = _currentSlot select 0;
DAKKA_saveSlotName = _slotName;
private _slotData = _currentSlot select 1;
// if (DAKKA_debug) then { diag_log format ["DAKKA: settingsLoad _slotData: %1", _slotData] };


// Check for existing array of locations, compositions, etc for this terrain
// Check locations
private _locations = [_slotData, "Locations"] call BIS_fnc_getFromPairs;
if (DAKKA_debug) then { diag_log format ["DAKKA: settingsLoad _locations: %1", _locations] };
private _thisWorldLocations = [_locations, worldName] call BIS_fnc_getFromPairs;

if (isNil "_thisWorldLocations") then {
    diag_log format ["DAKKA: settingsLoad --- WARNING --- No locations data for %1. Creating entries in locations array...", worldName];
    private _newArr = [];
    switch (DAKKA_Task) do { 
        case 1 : 
        {
            _newArr = [worldName,
                            [
                                ["Outposts",
                                    []
                                ]
                            ]
                        ];
        }; 
        case 2 : 
        {
            _newArr =  [worldName,
                            [
                                ["Contested Areas",
                                    []
                                ]
                            ]
                        ];
        }; 
    };
    [_slotData, "Locations", [_newArr]] call BIS_fnc_addToPairs;
};
// Check compositions
private _compositions = [_slotData, "Compositions"] call BIS_fnc_getFromPairs;
private _thisWorldLocations = [_locations, worldName] call BIS_fnc_getFromPairs;
if (isNil "_thisWorldLocations") then {
    diag_log format ["DAKKA: settingsLoad --- WARNING --- No compositions data for %1. Creating entries in compositions array...", worldName];
    private _newArr = [worldName, []];
    [_slotData, "Compositions", [_newArr]] call BIS_fnc_addToPairs;
};

// Overwrite current task data with loaded one
DAKKA_TaskData set [DAKKA_Task - 1, _slotData];


if (DAKKA_debug) then { diag_log format ["DAKKA: settingsLoad DAKKA_TaskData locations: %1", [DAKKA_TaskData select (DAKKA_Task - 1), "Locations"] call BIS_fnc_getFromPairs] };
if (DAKKA_debug) then { diag_log format ["DAKKA: settingsLoad DAKKA_TaskData Compositions: %1", [DAKKA_TaskData select (DAKKA_Task - 1), "Compositions"] call BIS_fnc_getFromPairs] };

diag_log format ["DAKKA: settingsLoad --- TASK DATA LOADED FOR TASK %1 - Slot: %2 --- ", DAKKA_Task, _slotIndex];

true