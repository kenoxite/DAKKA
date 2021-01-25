/*
  Author: kenoxite

  Description:
  


  Parameter (s):
  _this select 0:

  Returns:


  Examples:

*/

params["_unit", "_killer", "_instigator", "_useEffects"];
cutText ["", "BLACK OUT", 5]; 
_cameraPos = getPos player; 
_group = createGroup civilian; 
_unit = _group createUnit [ "VirtualSpectator_F", [0,0,0], [], 0, "FORM"]; 
[_unit] join _group; 
_unit allowDamage false; 
_unit disableAI "ALL"; 
_unit enableSimulationGlobal false; 
sleep 5;
cutText ["", "BLACK IN", 2]; 
selectPlayer _unit; 
["Initialize", [player, [], true]] call BIS_fnc_EGSpectator; 
_camera = ["GetCamera"] call BIS_fnc_EGSpectator; 
_cameraPos set [2,10]; 
_camera setPosASL _cameraPos;