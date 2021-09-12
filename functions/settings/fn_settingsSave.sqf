/*
  Author: kenoxite

  Description:
  Saves the settings 
    
    Save format:
    [
        [
        
            [
                <slot1 name>,
                [<slot1 data>]
            ],
            [
                <slot2 name>,
                [<slot2 data>]
            ],
            [...]
        ]
    ]

  Parameter (s):


  Returns:


  Examples:

*/

private ["_savedData", "_currentTaskData", "_defaultTaskData", "_currentWorldDataIndex", "_currentWorldData", "_saveSlots", "_slotIndex"];

if (DAKKA_automated) exitWith { false };

_savedData = profileNamespace getVariable (format ["DAKKA_Task%1", DAKKA_Task]);

_currentTaskData = +DAKKA_TaskData select (DAKKA_Task - 1);
_defaultTaskData = +DAKKA_TaskData_default select (DAKKA_Task - 1);
_slotIndex = (DAKKA_saveSlots select (DAKKA_Task - 1));
if (isNil "_savedData") then {
    // No saved data found. Create new data
    diag_log format ["DAKKA: settingsSave --- WARNING --- No saved task data found. Creating a new save using default task data", ""];
    _savedData = [[DAKKA_saveSlotName, _defaultTaskData]];
/*    {
        if (DAKKA_debug) then { diag_log format ["DAKKA: settingsSave _savedData (new) %1: %2", _forEachIndex, _x] };
    } forEach _savedData;*/
} else {
    // Saved data found
/*    {
        if (DAKKA_debug) then { diag_log format ["DAKKA: settingsSave _savedData %1: %2", _forEachIndex, _x] };
    } forEach _savedData;*/
    if (_slotIndex < 0) then {
        // No existing saves for this terrain. Create a new one
        diag_log format ["DAKKA: settingsSave --- WARNING --- No saved task data found for this task. Creating a new save using default task data", ""];
        _savedData pushBack [[DAKKA_saveSlotName, _defaultTaskData]];
        // if (DAKKA_debug) then { diag_log format ["DAKKA: settingsSave _savedData (new): %1", _savedData] };
    } else {
        // Existing saves. Overwrite current slot settings
        _savedData set [_slotIndex, [DAKKA_saveSlotName, _currentTaskData]];
    };
};
// if (DAKKA_debug) then { diag_log format ["DAKKA: settingsSave _dataToSave: %1", _savedData] };

profileNamespace setVariable [format ["DAKKA_Task%1", DAKKA_Task], _savedData];

diag_log format ["DAKKA: settingsSave --- TASK DATA SAVED FOR TASK %1 - Slot: %2 --- ", DAKKA_Task, _slotIndex];

true