/*
  Author: kenoxite

  Description:
  Controls what happens when mission is ended. 


  Parameter (s):
  _this select 0: 
 

  Returns:
  

  Examples:

*/

2 fadeMusic 1;  
5 fadeSound 0;
enableRadio false;
setAccTime 1; 
{_x allowDamage false;} forEach units p1;