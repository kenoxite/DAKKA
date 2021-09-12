/*
  Author: kenoxite

  Description:
  Deletes the saved variables. 


  Parameter (s):
 

  Returns:


  Examples:

*/

// Global settings
profileNamespace setVariable ["DAKKA_settings", nil];

// Task settings
{
	profileNamespace setVariable [format ["DAKKA_Task%1", _forEachIndex + 1], nil];
} forEach DAKKA_TasksArr;

true