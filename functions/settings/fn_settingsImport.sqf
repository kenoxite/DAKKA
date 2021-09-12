#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Import settings 


  Parameter (s):


  Returns:


  Examples:

*/

private _display = findDisplay IDC_MENU_MISSION_EDIT;

private _importedData = call compile copyFromClipboard;

// Make sure the imported data is correct
if (typeName _importedData != "ARRAY") exitWith { ["ERROR: Incorrect data format (_importedData). Data not imported."] spawn DAKKA_fnc_displayMessage; };
if (count _importedData < 2) exitWith { ["ERROR: Incorrect data format (_importedData). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _profileName = _importedData select 0;
if (typeName _profileName != "STRING") exitWith { ["ERROR: Incorrect data format (_profileName). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _taskData = _importedData select 1;
if (typeName _taskData != "ARRAY") exitWith { ["ERROR: Incorrect data format (_taskData). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _locations = [_taskData, "Locations"] call BIS_fnc_getFromPairs;
if (isNil "_locations") exitWith { ["ERROR: Incorrect data format (_locations). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _thisWorldLocations = [_locations, worldName] call BIS_fnc_getFromPairs;
if (isNil "_thisWorldLocations") exitWith { ["ERROR: Incorrect data format (_thisWorldLocations). Data not imported."] spawn DAKKA_fnc_displayMessage; };
    
// Determine the task the imported data belongs to
private _importedDataTask = 1;
private _task2Locations = [_thisWorldLocations, "Contested Areas"] call BIS_fnc_getFromPairs;
if !(isNil "_task2Locations") then { _importedDataTask = 2 };
private _task = DAKKA_Task;
if (_task != _importedDataTask) exitWith { [format ["ERROR: Data is from task ""%1"". Data not imported.", call compile format ["DAKKA_Task%1_Title", _importedDataTask]]] spawn DAKKA_fnc_displayMessage; };

private _playerGroup = [_taskData, "Player group"] call BIS_fnc_getFromPairs;
if (isNil "_playerGroup") exitWith { ["ERROR: Incorrect data format (_playerGroup). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _friendlyGroups = [_taskData, "Friendly groups"] call BIS_fnc_getFromPairs;
if (isNil "_friendlyGroups") exitWith { ["ERROR: Incorrect data format (_friendlyGroups). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _enemyGroups = [_taskData, "Enemy groups"] call BIS_fnc_getFromPairs;
if (isNil "_enemyGroups") exitWith { ["ERROR: Incorrect data format (_enemyGroups). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _playerData = [_taskData, "Player Data"] call BIS_fnc_getFromPairs;
if (isNil "_playerData") exitWith { ["ERROR: Incorrect data format (_playerData). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _compositions = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
if (isNil "_compositions") exitWith { ["ERROR: Incorrect data format (_compositions). Data not imported."] spawn DAKKA_fnc_displayMessage; };

private _supportGroups = [_taskData, "Support Groups"] call BIS_fnc_getFromPairs;
if (isNil "_supportGroups") exitWith { ["ERROR: Incorrect data format (_supportGroups). Data not imported."] spawn DAKKA_fnc_displayMessage; };


// Apply tag to imported profile
private _newName = format ["%1 [Imported]", _profileName];
_importedData set [0, _newName];

// Import
private _savedData = profileNamespace getVariable (format ["DAKKA_Task%1", _task]);
_savedData pushBack _importedData;

private _slotIndex = count _savedData;
DAKKA_saveSlots set [DAKKA_Task - 1, _slotIndex];
DAKKA_saveSlotName = _newName;

// Update profiles combo
_ctrl = (_display displayCtrl IDC_COMBO_SAVEDDATAPROFILES);
[IDC_COMBO_SAVEDDATAPROFILES] call DAKKA_fnc_updateSavedDataCombo;
_ctrl lbSetCurSel _slotIndex;

// Update profile display
_ctrl = (_display displayCtrl IDC_TXT_CURRENTSAVEDDATA);
_ctrl ctrlSetText format ["Profile: %1", DAKKA_saveSlotName];

// Close profiles menu
_ctrl = (_display displayCtrl IDC_GRP_SAVEDDATAPROFILES);
_ctrl ctrlShow false;


["Task data imported from clipboard."] spawn DAKKA_fnc_displayMessage;

true