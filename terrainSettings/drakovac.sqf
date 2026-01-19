// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [1.8, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [5, 8]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.4]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
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
                [[7332.97,2484.26,0],0],
                [[407.612,10457,0],0],
                [[4809.42,11264.7,0],0],
                [[7557.84,7064.32,0],0],
                [[3857.49,5878.64,0],0],
                [[5422.27,9781.75,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[2191.84,2241.76,0],325],
                [[7268.96,5361.16,0],325],
                [[2146.65,10581.7,0],100],
                [[5994.21,9652.14,0],40],
                [[6869.76,3189.66,0],320]
            ]
        ]
    ];
