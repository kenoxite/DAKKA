// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.6; // average overcast
DAKKA_rain = [1, 3]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [6, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 15;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[1575.26,2630.23,0],0],
                [[1640.99,1024.35,0],0],
                [[11294.2,2197.71,0],0],
                [[13036.3,13314.7,0],0],
                [[1409.5,14011.4,0],0],
                [[1776.4,7229.29,0],0],
                [[13801.4,8605.45,0],0],
                [[6064.96,13633.5,0],0],
                [[6182.23,10319.6,0],0],
                [[7566.87,6624.77,0],0],
                [[10846,12857.6,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[4844.59,5478.24,0],60],
                [[7238.8,7634.31,0],50],
                [[10663.4,10945.3,0],105],
                [[12379.3,6653.97,0],320],
                [[12702.1,1197.66,0],60],
                [[2383.19,1790.86,0],25],
                [[4934.15,14922.2,0],120],
                [[13889.7,13863,0],55],
                [[11130.5,8285.79,0],335]
            ]
        ]
    ];
