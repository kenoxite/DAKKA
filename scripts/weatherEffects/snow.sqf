// Snow by tupolov

sleep 1;

diag_log "DAKKA: Snow: Initializing";
 
DAKKA_environment = environmentEnabled;
// setViewDistance 500;
_overcast = random [0.6, 0.8, 1];
_fog = [] call DAKKA_fnc_setFog;
_weather = [_overcast, _fog];
[_weather, false, false] spawn DAKKA_fnc_setWeather;
// setWind [0, -5, true];
sleep 0.5;

DAKKA_snow = true;    
DAKKA_snowIntensity = if (count _this > 0) then { (_this select 0) } else { 700 };
DAKKA_snowTempIntensity = 700;    
DAKKA_snowVelocity =  if (count _this > 1) then { (_this select 1) } else { 1.25 };    
DAKKA_snowFidelity = 5;    
DAKKA_snowMaxDistance = 35;    
DAKKA_snowTTL = 0.1;
DAKKA_TTL = 0.5;
DAKKA_snowRefresh = if (count _this > 2) then { (_this select 2) } else { 0.2 }; 

if (DAKKA_snowIntensity >= 100) then {
    enableEnvironment [true, false];
};

diag_log "DAKKA: Snow: Starting";
// if (DAKKA_debug) then { diag_log format ["DAKKA: Snow DAKKA_snowIntensity: %1 DAKKA_snowVelocity: %2 DAKKA_snowRefresh: %3", DAKKA_snowIntensity, DAKKA_snowVelocity, DAKKA_snowRefresh] };
 
0 = [] spawn {      
   
    while {DAKKA_snow} do {      
   
        private _a = 0;      
        while {_a < DAKKA_snowIntensity} do {      
   
            private _fi = DAKKA_snowFidelity;      
            private _max = DAKKA_snowMaxDistance;     
   
            if (vehicle player != player) then {    
                _max = _max * 2;   
                DAKKA_snowTempIntensity = DAKKA_snowIntensity;    
                DAKKA_snowIntensity = DAKKA_snowIntensity * 9;    
            } else {    
                DAKKA_snowIntensity = DAKKA_snowTempIntensity;   
            };      
   
            for "_d" from _fi to _max step _fi do {   
   
                private _pos = ATLtoASL positionCameraToWorld [0,0,0];   
                private _hpos = +_pos; _hpos set [2,(_pos select 2)+20]; 

                setWind [0,0,true];    
                0 setRain 0;      
                   
                private _height = (_max - _d + 2) min 12;   
                if (speed player > 30) then {_height = 8;};   
   
                private _dpos = [   
                    ((_pos select 0) + (_d - (random (2*_d))) + ((velocity vehicle player select 1)*1)),   
                    ((_pos select 1) + (_d - (random (2*_d))) + ((velocity vehicle player select 0)*1)),   
                    (_pos select 2) + _height   
                ];      
   
                private _hdpos = +_dpos; _hdpos set [2,(_dpos select 2) + 20]; 
   
                private _ldpos = +_dpos; _ldpos set [2,(_pos select 2)+0.1];       
                   
                if (!lineIntersects [_dpos, _hdpos] || {(_hpos distance2D _hdpos > 7) && (lineIntersects [_pos,_hpos])}) then {     
   
                    private _ttl = (_height*DAKKA_TTL);    
                    private _surfaces = lineIntersectsSurfaces [_dpos,_ldpos,player,player,true,1];    
                    private _size = (0.02 + (random 0.06));
                    private _vel = (_size*10)*DAKKA_snowVelocity;   
                    if (count _surfaces > 0) then {   
   
                        _surfHeight = _surfaces select 0 select 0 select 2;   
                        private _dist = (_dpos select 2) - _surfHeight;   
                        _ttl = ((_dist / _vel) * DAKKA_snowTTL) min (_height * DAKKA_snowTTL);                           
   
                    };    
  
                    private _snowDrop = selectRandom [                      
                        ["a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,(1 + ceil(random 7)),0],
                        ["a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,13,0],                     
                        ["a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,(1 + ceil(random 7)),0],  
                        ["a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,16,0],  
                        ["a3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,(1 + ceil(random 7)),0]  
                    ];  
  
                    drop [_snowDrop, "", "Billboard", 1, _ttl, ASLToATL _dpos, [0,0, 0 - _vel], 1, 0.0000001, 0.000, 0.7, [_size], [[1,1,1,0], [1,1,1,1], [1,1,1,1], [1,1,1,1]], [0,0], 0.2, (1.5 -_vel) max 0.3, "", "", ""];      
                };     
                _a = _a + 1;      
            };                 
        };    
        sleep DAKKA_snowRefresh;         
    };      
};

enableEnvironment DAKKA_environment;
diag_log "DAKKA: Snow: End";