#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the tree list displaying the units of the selected faction. 


  Parameter (s):
  _this select 0: _idc
  _this select 1: _faction
 

  Returns:


  Examples:

*/

params ["_idc", "_faction", ["_filterType", "all"]];
private ["_display", "_ctrl", "_indexCtrl", "_factionInd", "_unitName", "_factionUnits", "_subcat", "_catIndex", "_catUnits", "_unitClass", "_bannedVehicles", "_filter", "_unitIcon", "_unitData"];

if (DAKKA_debug) then { diag_log format ["DAKKA: updateUnitsTreeList _filterType: %1", _filterType] };

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idc;
tvClear _ctrl;

// if (DAKKA_debug) then { diag_log format ["DAKKA: _faction:%1", _faction] };
_factionInd = [DAKKA_availableFactionsData, _faction] call DAKKA_fnc_findFirstNested;
if (_factionInd >= 0) then {
    _factionUnits = [_faction, _filterType] call DAKKA_fnc_categorizeUnits;

	// Populate tree list
	for [{private _i = 0}, {_i < count _factionUnits}, {_i = _i + 1}] do
	{
		if ((count ((_factionUnits select _i) select 1)) > 0) then {
			_catName = (_factionUnits select _i) select 0;
			_indexCat = _ctrl tvAdd [[], _catName];
			_ctrl tvSetData [[_indexCat], _catName];
			_catUnits = (_factionUnits select _i) select 1;
			for [{private _j = 0}, {_j < count _catUnits}, {_j = _j + 1}] do
			{
				_unitData = (_catUnits select _j);
                _unitClass = _unitData select 0;
				_unitName = _unitData select 1;
                // _unitIcon = _unitData select 2;
				_indexUnit = _ctrl tvAdd [[_indexCat], _unitName];
				_ctrl tvSetData [[_indexCat, _indexUnit], _unitClass];
                // _ctrl tvSetPicture [[_indexCat, _indexUnit], _unitIcon];
				_ctrl tvSetTooltip [[_indexCat, _indexUnit], format ["%1\n%2\n\nClick to preview", _unitName, _unitClass]];
			};
		};
	};
	tvExpandAll _ctrl;
};