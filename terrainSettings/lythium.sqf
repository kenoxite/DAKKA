// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [1, 4]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [10, 3]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

// Fog settings - should be changed based on general climate of the terrain and their average elevation
DAKKA_fogValue = [0, 0.3]; // normal fog value that represents fog density at fogBase level. Range 0..1 - [min, max] -- min is used for dry season, max for wet
DAKKA_fogDecay = 0.01; // decay of fog density with altitude. Range -1..1 --- the lower the more hazy and spread, the higher the more condensed at lower altitudes and thick --- values closer to 0 are preferable for more realistic results
DAKKA_fogBase = 7;  // base altitude (ASL) of fog (in meters). Range -5000..5000 -- this value should be based on the lowest elevation of the terrain


// - Locations -
// Predefined locations for this terrain for all the tasks
// You can add as many locations as you want, but there must be at least one location for each location category for each task
// To easily get coordinates you can add some locations in Editing Mode. Every time you add a location the coordinates are copied to the clipboard
// Format is: [<coordinates>, <direction>]
DAKKA_locations_Task1 = [
        ["Outposts",
            [
                [[17408.1,4542.92,0],0],
                [[3622.84,16703,0],0],
                [[18456.7,15429.5,0],0],
                [[4514.19,8090.66,0],0],
                [[5119.5,13561.7,0],0],
                [[11829.4,11782.5,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[14067.1,4046.46,0],300],
                [[16578.6,6814,0],70],
                [[19081.9,3465.89,0],45],
                [[16253.6,10367,0],95],
                [[10885.7,7621.94,0],355],
                [[3744.52,12854.7,0],325],
                [[13486.5,17586.8,0],60],
                [[12768.3,15386.3,0],100],
                [[2675.26,16152.5,0],10],
                [[965.775,9369.45,0],350],
                [[11523.4,2929.71,0],30],
                [[9874.47,11341.6,0],300]
            ]
        ]
    ];
