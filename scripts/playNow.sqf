// PLAY NOW

#include "..\control_defines.hpp";

cutText ["", "BLACK IN", 999];
enableRadio false;

// Start loading screen
_loadingScreen = createDialog "DMORBAT_Loading_Screen";
_display = findDisplay IDC_LOADING_SCREEN;
_ctrl = (_display displayCtrl IDC_TXT_LOADINGSCREEN);

// Flag this process as automated
DMORBAT_automated = true;

// Reset tasks data to default
DMORBAT_TaskData = +DMORBAT_TaskData_default;

// Retrieve data for this task
_task = DMORBAT_Task;
_taskData = DMORBAT_TaskData select (_task - 1);

// FRIENDLY GROUPS
_playerFaction = DMORBAT_PlayerFactions select (_task - 1);
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _playerFaction: %1", _playerFaction] };
_factionGroupsFriendly = [_playerFaction] call DMORBAT_fnc_categorizeGroups;

// ENEMY GROUPS
_enemyFaction = DMORBAT_EnemyFactions select (_task - 1);
if (DMORBAT_debug) then { diag_log format ["DMORBAT: _enemyFaction: %1", _enemyFaction] };
_factionGroupsEnemy = [_enemyFaction] call DMORBAT_fnc_categorizeGroups;


[_playerFaction, _enemyFaction, _factionGroupsFriendly, _factionGroupsEnemy, _display, _ctrl] execVM format ["scripts\playNow\playNow_task%1.sqf", DMORBAT_Task];
