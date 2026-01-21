// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.3; // average overcast
DAKKA_rain = [0, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [2, 4]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 2;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2880.27,4855.75,0],0],
                [[5582.44,8982.64,0],0],
                [[8460.02,9004.52,0],0],
                [[1570.71,2920.35,0],0],
                [[7862.91,3801.96,0],0],
                [[8201.39,2042.87,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2332.34,1487.32,0],65],
                [[4254.93,4610.26,0],0],
                [[8929.53,6464.7,0],330],
                [[9000.2,3416.91,0],345],
                [[8404.92,2703.07,0],25],
                [[6618.17,5397.81,0],140],
                [[7702.47,7974.34,0],90],
                [[3600.47,7787.7,0],250]
            ]
        ]
    ];
