#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Export settings 


  Parameter (s):


  Returns:


  Examples:

*/

private _display = findDisplay IDC_MENU_MISSION_EDIT;

private _savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);
private _slotIndex = (DMORBAT_saveSlots select (DMORBAT_Task - 1));
private _exportedData = +_savedData select _slotIndex;
private _profileName = _exportedData select 0;
private _taskData = _exportedData select 1;

// Apply author to exported profile
// private _author = profileName;
// private _newName = format ["%1 (by %2)", _profileName, _author];

// Expunge " [Imported]" tag
private _profileNameCount = count _profileName;
private _importedCount = count " [Imported]";
if (_profileNameCount > _importedCount) then {
    private _importedText = _profileName select [_profileNameCount - _importedCount, _profileNameCount - 1];
    if (_importedText == " [Imported]") then {
        private _newName = _profileName select [0, _profileNameCount - _importedCount];
        _exportedData set [0, _newName];
    };
};

// Remove reference to specific objects
private _worldCompositionsData = [_taskData, "Compositions"] call BIS_fnc_getFromPairs;
{
    _compositionsData = _x select 1;
    {
        _compObjects = _x select 1;
        {
            _x set [0, ""];
        } forEach _compObjects;
        // Reset hidden objects
        _x set [2, []];
    } forEach _compositionsData;
} forEach _worldCompositionsData;

// private _exportedDataInfo = format ["/* Task data for '%1' by %2 */", call compile format ["DMORBAT_Task%1_Title", DMORBAT_Task], profileName];
copyToClipboard (str _exportedData);

["Task data exported to clipboard."] spawn DMORBAT_fnc_displayMessage;

true