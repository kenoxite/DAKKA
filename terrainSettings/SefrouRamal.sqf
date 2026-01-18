// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.2; // average overcast
DAKKA_rain = [0, 0.5]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [10, 3]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 25;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[2931.99,8195.54,0],0],
                [[2140.21,5834.45,0],0],
                [[1228.29,4556.62,0],0],
                [[7755.22,3812.87,0],0],
                [[7716.91,6825.37,0],0],
                [[7517.08,1905.6,0],0],
                [[1681.92,2142.8,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2317.37,3415.62,0],330],
                [[4429.36,5034.2,0],210],
                [[6687.19,8739.32,0],0],
                [[7256.82,4627.02,0],90],
                [[7960.42,2866.26,0],15],
                [[4633.2,2821.99,0],5],
                [[6263.02,6583.69,0],95],
                [[4244.28,8738.87,0],350],
                [[2056.88,5774.98,0],315]
            ]
        ]
    ];
