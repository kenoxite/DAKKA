#include "..\..\control_defines.hpp";
/*
  Author: kenoxite

  Description:
  Updates the combo box displaying the available AO location categories. 


  Parameter (s):
  _this select 0: _index
 

  Returns:


  Examples:

*/

params ["_idc"];
private ["_ctrl", "_indexCtrl", "_compositions", "_catArr", "_subCat", "_catClass", "_catName", "_subCatArr", "_subCatName", "_subCatClass", "_compArr", "_comp", "_compName", "_compClass", "_indexCat", "_indexSubCat", "_indexComp"];
disableSerialization;
_ctrl = (findDisplay IDC_MENU_MISSION_EDIT) displayCtrl _idc;
if (isNull _ctrl) exitWith { 
  diag_log format ["DAKKA: --- ERROR --- updateCompositionsTreeList CONTROL %1  could not be found!", _ctrl];
};
tvClear _ctrl;

_compositions = [];
{ 
  _catName = getText (_x >> "name");
  _catClass = configName _x;
  _compositions pushback [[_catName, _catClass], []];
  // _indexCat = _ctrl tvAdd [[], _catName];
  // _ctrl tvSetData [[_indexCat], _catClass];
  _catArr = (_compositions select ((count _compositions) - 1)) select 1;
  {
    _subCatName = getText (_x >> "name");
    _subCatClass = configName _x;
    _catArr pushback [[_subCatName, _subCatClass], []];
    _subCat = (_catArr select ((count _catArr) - 1)) select 1;
    // _indexSubCat = _ctrl tvAdd [[_indexCat], _subCatName];
    // _ctrl tvSetData [[_indexCat, _indexSubCat], _subCatClass];
    {
      _compName = getText (_x >> "name");
      _compClass = configName _x;
      _subCat pushback [_compName, _compClass];
      // _indexComp = _ctrl tvAdd [[_indexCat, _indexSubCat], _compName];
      // _ctrl tvSetData [[_indexCat, _indexSubCat, _indexComp], _compClass];
    } forEach ("true" configClasses _x);
  } forEach ("true" configClasses _x);
} forEach ("true" configClasses (configfile >> "CfgGroups" >> "Empty")); 
_compositions sort true;

// {
//     if (DAKKA_debug) then { diag_log format ["DAKKA: updateCompositionsTreelist _compositions %2: %1", _x, _forEachIndex] };
// } forEach _compositions;
// if (DAKKA_debug) then { diag_log format ["DAKKA: updateCompositionsTreelist _compositions (full): %1", _compositions] };

// Populate tree list
private _i1 = 0;
for [{private _i = 0}, {_i < count _compositions}, {_i = _i + 1}] do
{
  _catArr = _compositions select _i;
  _catName = (_catArr select 0) select 0;
  _catClass = (_catArr select 0) select 1;
  private _indexCat = _ctrl tvAdd [[], _catName];
  _ctrl tvSetData [[_indexCat], _catClass];

  _subCatArr = _catArr select 1;
  private _j1 = 0;
  for [{private _j = 0}, {_j < count _subCatArr}, {_j = _j + 1}] do
  {
    _subCat = _subCatArr select _j;
    _subCatName = (_subCat select 0) select 0;
    _subCatClass = (_subCat select 0) select 1;
    private _indexSubCat = _ctrl tvAdd [[_indexCat], _subCatName];
    _ctrl tvSetData [[_indexCat, _indexSubCat], _subCatClass];
    _j1 = _j1 + 1;

   _compArr = _subCat select 1;
   if ((count _compArr) > 0 && _subCatName != "") then {
      for [{private _k = 0}, {_k < count _compArr}, {_k = _k + 1}] do
      {
        _comp = _compArr select _k;
        _compName = _comp select 0;
        _compClass = _comp select 1;
        _indexComp = _ctrl tvAdd [[_indexCat, _indexSubCat], _compName];
        _ctrl tvSetData [[_indexCat, _indexSubCat, _indexComp], _compClass];
      };
      _ctrl tvExpand [_indexCat];
      // _ctrl tvExpand [_indexCat, _indexSubCat];
    } else {
      // Delete subcategory if there's no compositions
      _ctrl tvDelete [_indexCat, _indexSubCat];
    };
  };
  // Delete category if there's no compositions in any subcategory
  if ((_ctrl tvCount [_indexCat]) == 0 || _catName == "") then {
    // systemChat format ["DAKKA: updateCompositionsTreeList NO COMPOSITIONS IN %1", _catName];
    _ctrl tvDelete [_indexCat];
  };
  _i1 = _i1 + 1;
};
// tvExpandAll _ctrl;