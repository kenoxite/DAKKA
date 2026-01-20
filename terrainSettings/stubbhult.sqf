// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1.5, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.5]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 5;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]

DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[3171.76,2380.83,0],0],
                [[10304.8,10847.7,0],0],
                [[7018.11,9885.7,0],0],
                [[10024.4,3110.31,0],0],
                [[6432.67,4751.53,0],0],
                [[6687.84,8777.61,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[6948.86,6971.24,0],15],
                [[10066.4,4136.69,0],75],
                [[7466.7,4737.4,0],340],
                [[2628.33,5015.58,0],15],
                [[2731.53,8932.04,0],65],
                [[8655.27,9930.83,0],35]
            ]
        ]
    ];
