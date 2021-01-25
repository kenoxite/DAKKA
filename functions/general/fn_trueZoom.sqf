/*
  Author: Killzone Kid

  Description:
  Returns the current zoom level based on screen resolution. 


  Parameter (s):
  

  Returns:


  Examples:

*/
(
    [0.5, 0.5] 
    distance2D  
    worldToScreen 
    positionCameraToWorld 
    [0, 3, 4]
) * (
    getResolution 
    select 5
) / 2
