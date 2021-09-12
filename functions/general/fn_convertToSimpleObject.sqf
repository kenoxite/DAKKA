/*
	Author: kenoxite

	Description:
	Converts an object to simple object.


	Parameter (s):
	_this select 0: _pos
	_this select 1: _dir
	_this select 2: _category
	_this select 3: _className

	Returns:


	Examples:
	[position player, getDir player, "Guerrilla", "Camps", "CampA"] call DAKKA_fnc_compositionSpawn;
*/

params ["_obj"];
private ["_objPos", "_vectorDirUp", "_simpleObj", "_model"];

_objPos = getPosWorld _obj;
_vectorDirUp = [vectorDir _obj, vectorUp _obj];
_model = getModelInfo _obj select 1;
deleteVehicle _obj;
_simpleObj = createSimpleObject [_model, _objPos];
_simpleObj setVectorDirAndUp _vectorDirUp;

_simpleObj	