#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
    


  Parameter (s):
  _this select 0: _idc
 

  Returns:


  Examples:

*/

params ["_idcCombo"];

disableSerialization;
private _display = findDisplay IDC_MENU_MISSION_EDIT;
private _ctrl =  _display displayCtrl _idcCombo;

lbClear _ctrl;

private _savedData = profileNamespace getVariable (format ["DMORBAT_Task%1", DMORBAT_Task]);

for [{private _i = 0}, {_i < count _savedData}, {_i = _i + 1}] do
{
    private _slotData = _savedData select _i;
    private _slotName = _slotData select 0;
    private _indexCtrl = _ctrl lbAdd _slotName; 
    _ctrl lbSetData [_indexCtrl, _slotName]; 
};