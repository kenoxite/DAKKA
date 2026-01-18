// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [6, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 3;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[3676.56,2145.93,0],0],
                [[5670.07,2509.47,0],0],
                [[6142.59,1078.49,0],0],
                [[7885.5,2037.12,0],0],
                [[11389.4,5481.01,0],0],
                [[7760.11,8585.74,0],0],
                [[2948.97,7808.68,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[3889.42,2878.35,0],30],
                [[9324.64,2663.05,0],110],
                [[6379.74,7328.7,0],0],
                [[5656.22,10641.6,0],75],
                [[10110.2,9608.81,0],25],
                [[3324.36,7057.74,0],50],
                [[6502.14,3462.56,0],80]
            ]
        ]
    ];
