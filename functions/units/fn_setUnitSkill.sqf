/*
  Author: kenoxite

  Description:
  Modifies the unit's skills. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

params ["_unit", "_unitSkill"]; 

switch (_unitSkill) do {
	case 1: {
		// UNTRAINED
		_unit disableAI "FSM"; 
		_unit setskill 0.15; 
		_unit setUnitAbility 0.15; 
		_unit setskill ["aimingAccuracy", random [0.06, 0.08, 0.1]]; 
		_unit setskill ["aimingShake", random [0.6, 0.8, 1]]; 
		_unit setskill ["aimingSpeed", random [0.2, 0.5, 0.7]]; 
		_unit setskill ["spotDistance", random [0.2, 0.3, 0.5]]; 
		_unit setskill ["spotTime",random [0.6, 0.8, 1]]; 
		_unit setskill ["commanding",random [0.8, 1, 1.2]]; 
		_unit setskill ["courage",random [0.2, 0.4, 0.6]]; 
		_unit setskill ["general", random [0.1, 0.3, 0.5]]; 
		_unit setskill ["reloadSpeed",random [0.01, 0.1, 0.3]]; 
	};
	case 2: {
		// ELITE
		_unit setskill 0.8; 
		_unit setUnitAbility 0.8; 
		_unit setskill ["aimingAccuracy", random [0.5, 0.7, 0.9]]; 
		_unit setskill ["aimingShake", random [0.2, 0.3, 0.5]]; 
		_unit setskill ["aimingSpeed", random [0.5, 0.7, 0.9]]; 
		_unit setskill ["spotDistance", random [0.6, 0.8, 1]]; 
		_unit setskill ["spotTime",random [0.2, 0.4, 0.5]]; 
		_unit setskill ["commanding",random [0.2, 0.3, 0.5]]; 
		_unit setskill ["courage", 1]; 
		_unit setskill ["general", random [0.7, 0.8, 0.9]]; 
		_unit setskill ["reloadSpeed",random [0.01, 0.03, 0.05]]; 
        _unit allowFleeing 0;

        // DISABLE AI MODS
        // Vcom AI
        (group _unit) setVariable ["VCM_TOUGHSQUAD",true]; //This command will stop the AI squad from calling for backup.
	};
};

// Give super skill to drivers in the hope of making them suck less when driving (hey, it worked in OFP!)
if !([vehicle _unit] call DMORBAT_fnc_isMan) then {
	(driver vehicle _unit) setSkill 1;
	(driver vehicle _unit) setUnitAbility 1; 
};

true