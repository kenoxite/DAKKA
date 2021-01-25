/*
  Author: kenoxite

  Description:
  Deletes the saved variables. 


  Parameter (s):
 

  Returns:


  Examples:

*/

// Global settings
profileNamespace setVariable ["DMORBAT_settings", nil];

// Task settings
{
	profileNamespace setVariable [format ["DMORBAT_Task%1", _forEachIndex + 1], nil];
} forEach DMORBAT_TasksArr;

true