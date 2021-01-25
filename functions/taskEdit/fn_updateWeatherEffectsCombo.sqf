#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the weather effects. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params [];
private ["_display", "_ctrl", "_effectsData", "_thisEffect", "_effectType", "_effectTypeData", "_effectName", "_effectDescription"];

_display = findDisplay IDC_MENU_MISSION_EDIT;
_ctrl = (_display displayCtrl IDC_COMBO_ENVSETTINGS_WEATHEREFFECTS);
lbClear _ctrl;
_effectsData = DMORBAT_weatherEffectsList;

for [{private _i = 0}, {_i < count _effectsData}, {_i = _i + 1}] do 
{
    _thisEffect = _effectsData select _i;
    _effectType = _thisEffect select 0;
    _effectTypeData = _thisEffect select 1;
    _effectName = _effectTypeData select 0;
    _effectDescription= _effectTypeData select 1;
    _ctrl lbAdd _effectName; 
    _ctrl lbSetData [_i, _effectType];
    _ctrl lbSetTooltip [_i, _effectDescription];
};

true