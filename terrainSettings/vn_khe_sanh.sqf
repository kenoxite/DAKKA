// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.7; // average overcast
DAKKA_rain = [0.5, 12]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 12]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 10;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2709.98,2709.45,0],0],
                [[12377.3,11655.2,0],0],
                [[6730.58,12986.4,0],0],
                [[1929.71,12084.8,0],0],
                [[12151,1365.64,0],0],
                [[7344.61,2221.81,0],0],
                [[1951,6051.52,0],0],
                [[4079.98,9119.89,0],0],
                [[11208.3,8426.03,0],0],
                [[6096.07,5165.3,0],0],
                [[7742.77,10243,0],0],
                [[1643.35,13113.7,0],0],
                [[5534.6,6539.89,0],0],
                [[4793.37,4862.97,0],0],
                [[4409.48,2378.92,0],0],
                [[1582.76,8454.79,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[10778.7,3920.32,0],0],
                [[9695.08,6580.13,0],275],
                [[7574.34,7985.96,0],340],
                [[2641.78,9977.59,0],330],
                [[5485.2,8278.68,0],0],
                [[3575.46,4322.1,0],290],
                [[7712.14,1417.05,0],275],
                [[6744.88,5908.94,0],330],
                [[7898.1,3826.43,0],320]
            ]
        ]
    ];
