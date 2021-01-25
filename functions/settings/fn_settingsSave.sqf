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

if (DMORBAT_automated) exitWith { false };

_savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);

_currentTaskData =+ DMORBAT_TaskData select (DMORBAT_Task - 1);
_defaultTaskData =+ DMORBAT_TaskData_default select (DMORBAT_Task - 1);
_slotIndex = (DMORBAT_saveSlots select (DMORBAT_Task - 1));
if (isNil "_savedData") then {
    // No saved data found. Create new data
    diag_log format ["DMORBAT: settingsSave --- WARNING --- No saved task data found. Creating a new save using default task data", ""];
    _savedData = [[DMORBAT_saveSlotName, _defaultTaskData]];
/*    {
        diag_log format ["DMORBAT: settingsSave _savedData (new) %1: %2", _forEachIndex, _x];
    } forEach _savedData;*/
} else {
    // Saved data found
/*    {
        diag_log format ["DMORBAT: settingsSave _savedData %1: %2", _forEachIndex, _x];
    } forEach _savedData;*/
    if (_slotIndex < 0) then {
        // No existing saves for this terrain. Create a new one
        diag_log format ["DMORBAT: settingsSave --- WARNING --- No saved task data found for this task. Creating a new save using default task data", ""];
        _savedData pushBack [[DMORBAT_saveSlotName, _defaultTaskData]];
        // diag_log format ["DMORBAT: settingsSave _savedData (new): %1", _savedData];
    } else {
        // Existing saves. Overwrite current slot settings
        _savedData set [_slotIndex, [DMORBAT_saveSlotName, _currentTaskData]];
    };
};
// diag_log format ["DMORBAT: settingsSave _dataToSave: %1", _savedData];

profileNamespace setVariable [format ["DMORBAT_Task%1", DMORBAT_Task], _savedData];

diag_log format ["DMORBAT: settingsSave --- TASK DATA SAVED FOR TASK %1 - Slot: %2 --- ", DMORBAT_Task, _slotIndex];

true