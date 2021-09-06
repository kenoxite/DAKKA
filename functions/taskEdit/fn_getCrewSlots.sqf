#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Returns the crew slots of a vehicle. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_veh"];
private ["_arr", "_slots"];
_arr = [];
{
	_slots = fullCrew [_veh, _x, true];
	// if (DMORBAT_debug) then { diag_log format ["DMORBAT: _slots: %1", _slots] };
	if (count _slots > 0) then { _arr pushBack 1 } else { _arr pushBack 0 };
} forEach DMORBAT_crewSlotRoles;
_arr