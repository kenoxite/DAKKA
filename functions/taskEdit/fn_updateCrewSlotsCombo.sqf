#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available crew slots for the selected vehicle. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idcCombo", "_veh"];
private ["_display", "_ctrl", "_indexCtrl", "_crewSlots", "_effectiveCommander", "_fullcrew", "_commander", "_role"];
disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = _display displayCtrl _idcCombo;
if (isNull _ctrl) exitWith { 
  diag_log format ["DAKKA: --- ERROR --- updateCrewSlotsCombo CONTROL %1  could not be found!", _ctrl];
};
// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo idc: %3 veh: %1 (%2) _ctrl:%4", _veh, typeOf _veh, _idcCombo, _ctrl] };
lbClear _ctrl;
_crewSlots = [_veh] call DAKKA_fnc_getCrewSlots;
_effectiveCommander= assignedVehicleRole (effectiveCommander _veh);
_commander = _effectiveCommander select 0;
_fullcrew = fullCrew _veh;
// if ("Turret" in _effectiveCommander) then { _effectiveCommander set [0, "Commander"];};
{
  if ((_x select 3) isEqualTo (_effectiveCommander select 1)) then {
    _commander = (_x select 1);
  };
} forEach _fullcrew;

// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo (lbSize _idcCombo): %1 _effectiveCommander:%2 fullcrew: %3 _commander: %4", (lbSize _idcCombo), _effectiveCommander, _fullCrew, _commander] };
// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo _crewSlots: %1 _commander: %2", _crewSlots, _commander] };
for "_i" from 0 to ((count _crewSlots) - 1) do 
{
  if ((_crewSlots select _i) == 1) then {
    _role = DAKKA_crewSlotRoles select _i;
    _indexCtrl = _ctrl lbAdd _role;       
    _ctrl lbSetData [_indexCtrl, _role];
    if (_role == _commander) then {
      _ctrl lbSetText [_indexCtrl, format ["*%1", _role]];
    };
    // if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo _indexCtrl:%2 _role: %1", _role, _indexCtrl] }; 
  };
};

for "_i" from 0 to ((lbSize _idcCombo) - 1) do 
{
  if ((lbData [_idcCombo, _i]) == _commander) then {
    _ctrl lbSetCurSel _i;
  };
};

// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo _indexCtrl: %1 size: %2", _indexCtrl, lbSize _idcCombo] };
if (_indexCtrl > 0) then {
  _ctrl = (_display displayCtrl IDC_GRP_VEH_CREW_SEL);
  _ctrl ctrlShow true;
  // if (DAKKA_debug) then { diag_log format ["DAKKA: updateCrewSlotsCombo SHOWING crew popup: %1", IDC_GRP_VEH_CREW_SEL] };
} else {
  [_idcCombo] call DAKKA_fnc_setCrewSlot;
};