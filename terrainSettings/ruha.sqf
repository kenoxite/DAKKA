// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
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
                [[1594.27,1451.93,0],0],
                [[1961.55,6393.63,0],0],
                [[6043.2,2333.13,0],0],
                [[4802.6,6616.82,0],0],
                [[2966.71,5070.48,0],0],
                [[1981.58,3753.1,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2225.81,1534,0],10],
                [[4285.08,4340.66,0],315],
                [[5657.37,3286.43,0],350],
                [[6127.03,6892.76,0],100],
                [[2810.94,6127.11,0],320],
                [[1793.04,4501.73,0],295],
                [[4603.38,1554.69,0],320]
            ]
        ]
    ];
