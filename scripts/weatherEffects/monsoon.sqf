// Monsoon by ALIAS
/*
================================================================================================================================
>>>>> MONSOON Parameters =======================
================================================================================================================================

null = [direction_monsoon, duration_monsoon, effect_on_objects,debris,fog_rain,rain_drops,thunder,delay_thunder] execvm "AL_monsoon\al_monsoon.sqf";

direction_monsoon   - integer, from 0 to 360, direction towards the wind blows expressed in compass degrees
duration_monsoon    - integer, life time of the monsoon expressed in seconds
effect_on_objects   - boolean, if is true occasionally a random object will be thrown in the air

// >>>>>> new parameters
debris              - boolean, make it false if you dont want branches and stuff flying around
fog_rain            - boolean, if is true fog arounf players will be generated out of particles
rain_drops          - boolean, if is false not rain drops will be generated
thunder             - boolean, if is true you will hear thunders and see lights otherwise only vanilla thunder will be present... if ever
delay_thunder       - number, based on this number a delay will be generated between thunders
*/

sleep 1;

diag_log "DMORBAT: Monsoon: Initializing";

_overcast = random [0.7, 0.9, 1];
_fog = [] call DMORBAT_fnc_setFog;
_weather = [_overcast, _fog];
[_weather, false] spawn DMORBAT_fnc_setWeather;
sleep 0.5;
 
while {DMORBAT_monsoon} do { 
    diag_log "DMORBAT: Dust Storm: Starting a new one";
    my_monsoon_duration = 240 + random 600;
    pause_between_monsoon = 240 + random 600;
    null = [100, my_monsoon_duration, true, true, true, true, true, random [0.5, 1, 5]] execvm "AL_monsoon\al_monsoon.sqf";

    sleep (my_monsoon_duration + pause_between_monsoon);
}; 


diag_log "DMORBAT: Monsoon: End";