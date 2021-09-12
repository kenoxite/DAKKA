#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  EH for moving map


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params [["_idcCurrent", -1], ["_idcOther", -1]];
private ["_display", "_ctrlCurrent", "_ctrlOther", "_ctrlPos", "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH", "_mapCenter", "_finalPos"];

disableSerialization;
_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrlCurrent = (_display displayCtrl _idcCurrent);
_ctrlOther = (_display displayCtrl _idcOther);

_ctrlPos = ctrlPosition _ctrlCurrent;
_ctrlX =  (_ctrlPos select 0);
_ctrlY =  (_ctrlPos select 1);
_ctrlW =  ((_ctrlPos select 2) / 2);
_ctrlH =  ((_ctrlPos select 3) / 2);

_mapCenter = [(_ctrlW + _ctrlX), (_ctrlH + _ctrlY)];
_finalPos = _ctrlCurrent ctrlMapScreenToWorld _mapCenter;
"DAKKA_mrkr_MapCenter" setMarkerPos _finalPos;

_ctrlOther ctrlMapAnimAdd [0, ctrlMapScale _ctrlCurrent, _finalPos];
ctrlMapAnimCommit _ctrlOther;

true