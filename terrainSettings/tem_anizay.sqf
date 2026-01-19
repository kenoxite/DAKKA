// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [1, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [10, 3]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 45;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[1831.39,961.977,0],0],
                [[7484.46,8437.66,0],0],
                [[8379.65,1173.54,0],0],
                [[1478.36,9086.2,0],0],
                [[4877.5,1838.79,0],0],
                [[4512.76,8662.29,0],0],
                [[941.749,4649.27,0],0],
                [[9228.21,4512.09,0],0],
                [[2792.26,3590.47,0],0],
                [[5556.74,3241.09,0],0],
                [[6269.57,6264.17,0],0],
                [[5763.37,7792.94,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[1452.78,7258.01,0],0],
                [[2926.58,9159.87,0],75],
                [[4066.33,7990.93,0],265],
                [[5740.28,5688.63,0],155],
                [[3499.5,4551.09,0],190],
                [[1983.01,2227.02,0],340],
                [[5021.16,1386.31,0],45],
                [[6413.96,2353.96,0],315],
                [[8402.33,5164.4,0],75],
                [[6796.56,8371.79,0],320],
                [[8971.87,9401.68,0],90],
                [[757.896,5609.84,0],0]
            ]
        ]
    ];
