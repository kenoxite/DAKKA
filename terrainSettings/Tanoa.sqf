// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.3; // average overcast
DAKKA_rain = [4.5, 12]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [7, 10]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.03; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 50;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[10280.8,3753.79,0],0],
                [[11159.4,2623.62,0],0],
                [[13009.4,4169.1,0],0],
                [[12702,4410.03,0],0],
                [[12268.1,4885.37,0],0],
                [[11623.5,4431.71,0],0],
                [[10752.3,4734.44,0],0],
                [[11113,7754.39,0],0],
                [[9962.1,7896.15,0],0],
                [[10320.1,7874.57,0],0],
                [[9071.6,7500.4,0],0],
                [[8774.27,8709.89,0],0],
                [[7169.71,9663.32,0],0],
                [[7719.3,11707.2,0],0],
                [[7366.29,12649.8,0],0],
                [[13254.4,10654.3,0],0],
                [[14233,9671.07,0],0],
                [[13171.6,9403.83,0],0],
                [[11789.2,9468.96,0],0],
                [[11857.9,9543.75,0],0],
                [[11376.5,9201.05,0],0],
                [[10745.5,9257.03,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2601.19,6551.31,0],325],
                [[8889.11,10236.2,0],35],
                [[7311.6,8572.7,0],40],
                [[13260.6,11757.3,0],295]
            ]
        ]
    ];