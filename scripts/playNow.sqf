// PLAY NOW

#include "..\control_defines.hpp";

cutText ["", "BLACK IN", 999];
enableRadio false;

// Start loading screen
_loadingScreen = createDialog "DAKKA_Loading_Screen";
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

// Flag this process as automated
DAKKA_automated = true;

// Reset tasks data to default
DAKKA_TaskData = +DAKKA_TaskData_default;

// Retrieve data for this task
_task = DAKKA_Task;
_taskData = DAKKA_TaskData select (_task - 1);

// FRIENDLY GROUPS
_playerFaction = DAKKA_PlayerFactions select (_task - 1);
if (DAKKA_debug) then { diag_log format ["DAKKA: _playerFaction: %1", _playerFaction] };
_factionGroupsFriendly = [_playerFaction] call DAKKA_fnc_categorizeFactionGroups;

// ENEMY GROUPS
_enemyFaction = DAKKA_EnemyFactions select (_task - 1);
if (DAKKA_debug) then { diag_log format ["DAKKA: _enemyFaction: %1", _enemyFaction] };
_factionGroupsEnemy = [_enemyFaction] call DAKKA_fnc_categorizeFactionGroups;


[_playerFaction, _enemyFaction, _factionGroupsFriendly, _factionGroupsEnemy, _display, _ctrl] execVM format ["scripts\playNow\playNow_task%1.sqf", DAKKA_Task];
