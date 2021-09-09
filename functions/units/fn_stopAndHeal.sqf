/*
  Author: kenoxite

  Description:
  Adds EH that forces the AI unit to stop until it is healed by the player 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_unit"];

private _healEH = _unit addEventHandler ["HandleHeal", {
    _this spawn {
        params ["_injured", "_healer"];
        private _damage = damage _injured;
        private _startTime = time;
        if (_healer == p1) then {
            _injured disableAI "MOVE";
            waitUntil {damage _injured != _damage || !alive _injured || !alive _healer || (time - _startTime) > 30};
            _injured enableAI "MOVE";
            if (damage _injured != _damage) then {
                _healer addRating (round (200 * _damage));
            };
        };
    };
}];

