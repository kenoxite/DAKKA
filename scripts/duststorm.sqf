// Duststorm by ALIAS

sleep 1;

diag_log "DMORBAT: Dust Storm: Initializing";
_overcast = random [0.7, 0.9, 1];
_fog = [] call DMORBAT_fnc_setFog;
_weather = [_overcast, _fog];
[_weather, false, false] spawn DMORBAT_fnc_setWeather;
 
sleep 0.5;

while {DMORBAT_duststorm} do {  
    diag_log "DMORBAT: Dust Storm: Starting a new one";
    // [_direction_duststorm, _duration_duststorm, _effect_on_objects, _dust_wall, _lethal_wall, _vizibility]    
    null = [random 360, 300 + (random 600), false, false, false, random [0.05, 0.1, 0.3] ] execvm "AL_dust_storm\al_duststorm.sqf";

    sleep 1200 + (random 1200); // delay between storms, it must be longer than storm duration
}; 


diag_log "DMORBAT: Dust Storm: End";