#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the faction selection combo boxes. 


  Parameter (s):
  _this select 0: _idcCombo
  _this select 1: _isPlayerFaction
  _this select 2: _idcFactioGroups
  _this select 3: _idcFactioUnits
  _this select 4: _idcFactionGroupUnits
 

  Returns:


  Examples:

*/

params ["_idcCombo", ["_isPlayerFaction", true]];
private ["_display", "_ctrl", "_indexCtrl", "_thisFaction", "_thisFactionName", "_thisFactionIcon", "_thisSideNum", "_color", "_side", "_selChangedAction", "_faction", "_fIndex"];
disableSerialization;

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idcCombo;
lbClear _ctrl;

// Remove EH to avoid overwriting values when changing pages
// _ctrl ctrlSetEventHandler ["LBSelChanged", ''];

{	
	_thisFaction = (_x select 0);
	_thisFactionName = (_x select 1);
	_thisFactionIcon = (_x select 3);
	_thisSideNum = (_x select 4);
	// Add factions to combo boxes
	_color = "";
	switch (_thisSideNum) do {
		case 0: {
			_color = [0.827, 0.369, 0.369, 1];
		};
		case 1: {
			_color = [0.482, 0.667, 0.851, 1];
		};
		case 2: {
			_color = [0.6, 0.827, 0.369, 1];
		};
		case 3: {
			_color = [0.882, 0.553, 0.882, 1];
		};						
	};				
	_indexCtrl = _ctrl lbAdd _thisFactionName;					
	_ctrl lbSetData [_indexCtrl, _thisFaction];
	_ctrl lbSetColor [_indexCtrl, _color];
	_ctrl lbSetPicture [_indexCtrl, _thisFactionIcon];
	_ctrl lbSetPictureColor [_indexCtrl, [1, 1, 1, 1]];
	_ctrl lbSetPictureColorSelected [_indexCtrl, [1, 1, 1, 1]];
} forEach DAKKA_availableFactionsData;

lbSort _ctrl;

_side = if (_isPlayerFaction) then { "Player" } else { "Enemy" };

_faction = call compile format ["DAKKA_%1Factions select (DAKKA_Task - 1)", _side];
if (isNil "_faction") then { 
    private _error = format ["WARNING: Couldn't find the saved %1 faction!", _side];
    [_error] spawn DAKKA_fnc_displayMessage;
    diag_log format ["DAKKA: --- %1", _error];
};

if (DAKKA_debug) then { diag_log format ["DAKKA: updateFactionCombo _faction: %1", _faction] };
if (_faction == "") then {
    private _error = format ["WARNING: Couldn't find the saved %1 faction!", _side];
    [_error] spawn DAKKA_fnc_displayMessage;
    diag_log format ["DAKKA: --- %1", _error];
};

_fIndex = -1;
{
    if ((_ctrl lbData _forEachIndex) == _faction) exitWith {
        _fIndex = _forEachIndex;
    };
} forEach DAKKA_availableFactionsData;
_ctrl lbSetCurSel (_fIndex max 0);

if (DAKKA_debug) then { diag_log format ["DAKKA: updateFactionCombo _faction: %1", _faction] };
if (_fIndex < 0) then {
    private _error = format ["WARNING: Couldn't find the saved %1 faction!", _side];
    [_error] spawn DAKKA_fnc_displayMessage;
    diag_log format ["DAKKA: --- %1", _error];

    call compile format ["DAKKA_%1Factions set [(DAKKA_Task - 1), _ctrl lbData %2]", _side, if (_isPlayerFaction) then { 0 } else { 2 }];
};


if (DAKKA_debug) then { diag_log format ["DAKKA: updateFactionCombo _faction: %1 DAKKA_PlayerFactions: %2 DAKKA_EnemyFactions: %3", _faction, DAKKA_PlayerFactions, DAKKA_EnemyFactions] };

true