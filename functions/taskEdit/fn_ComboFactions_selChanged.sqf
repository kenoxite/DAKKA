#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Instructions associated with the change selection eventhandler of factions combo box


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo", "_selectionPath", ["_isPlayerFaction", true], ["_updateGroups", false], ["_updateSupportUnits", false]];
private ["_display", "_ctrl", "_side", "_faction"];
if (DMORBAT_debug) then { diag_log format ["DMORBAT: ComboFactions_selChanged _selectionPath:%1", _selectionPath] };
if (_selectionPath < 0) exitWith { false };

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idcCombo;

_side = if (_isPlayerFaction) then { "Player" } else { "Enemy" };

if (_updateGroups) then {
    call DMORBAT_fnc_previewGroupDelete;
};

_faction = _ctrl lbData (lbCurSel _ctrl);
if (DMORBAT_debug) then { diag_log format ["DMORBAT: ComboFactions_selChanged _faction: %1", _faction] };
if (isNil "_faction") exitWith { [format ["ERROR: Couldn't find the %1 faction!", _side]] spawn DMORBAT_fnc_displayMessage; false };

call compile format ["DMORBAT_%1Factions set [DMORBAT_Task - 1, _faction];", _side];
if (_isPlayerFaction) then { DMORBAT_PlayerFaction = DMORBAT_PlayerFactions select (DMORBAT_Task - 1) };
if (DMORBAT_debug) then { diag_log format ["DMORBAT: ComboFactions_selChanged DMORBAT_%1Factions: %2", _side, call compile format ["DMORBAT_%1Factions", _side]] };

[format ["%1 Factions", _side]] call DMORBAT_fnc_globalSettingsSave;

if (_updateGroups) then {
    [IDC_TREE_FACTION_GROUPS, _faction, true] call DMORBAT_fnc_updateGroupsTreeList;
    _ctrl = _display displayCtrl IDC_TREE_FACTION_GROUPS;
    _ctrl tvSetCurSel [0, 0];
    [IDC_TREE_FACTION_UNITS, _faction] call DMORBAT_fnc_updateUnitsTreeList;
};

if (_updateSupportUnits) then {
    _ctrl = _display displayCtrl IDC_COMBO_SUPPORT_TYPES;
    private _selectedSupport = _ctrl lbData (lbCurSel _ctrl);
    _ctrl = _display displayCtrl IDC_TREE_SUPPORT_UNITS;
    [IDC_TREE_SUPPORT_UNITS, _faction, _selectedSupport] call DMORBAT_fnc_updateUnitsTreeList;
    _ctrl tvSetCurSel [0, 0];
};

true