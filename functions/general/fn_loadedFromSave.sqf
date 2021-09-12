/*
  Author: Larrow & kenoxite

  Description:
  Takes care of things that need to keep working after loading a save


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

addMissionEventHandler ["Loaded", {
    params ["_saveType"];

    //RPT save type
    diag_log format[ "DAKKA: Mission loaded from %1", _saveType ];

    //Set var as load type STRING
    DAKKA_loadedSavegame = true;

    // Things to do if user loads a saved game while editing
    if (DAKKA_editingTask) then {
        diag_log format ["DAKKA: Restoring edit menus"];
        [] execVM "scripts\menuCheck.sqf";
    };

}];

true