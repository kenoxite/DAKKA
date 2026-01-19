// TERRAIN SETTINGS

// - Weather -

// Overcast settings - should be changed based on general climate of the terrain
DAKKA_overcast = 0.5; // average overcast
DAKKA_rain = [0.9, 1.2]; // average annual precipitation [min, max] -- should be roughly based on real stats, in inches
DAKKA_rainMonths = [5, 9]; // months where precipitation is at its highest -- you can either start from the beginning of the rainy months or the end, it'll be sorted later

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
                [[4161.08,735.226,0],0],
                [[6413.73,2226.76,0],0],
                [[2522.69,9068.18,0],0],
                [[9269.57,10387.9,0],0],
                [[5111.69,7859.7,0],0],
                [[1243.31,8072.88,0],0],
                [[4224.62,4952.13,0],0],
                [[10565.3,827.565,0],0]
            ]
        ]
    ];

DAKKA_locations_Task2 = [
        ["Contested Areas",
            [
                [[7518.39,1675.53,0],325],
                [[8441.39,3733.01,0],305],
                [[6782.69,5438.47,0],325],
                [[7331.48,8145.29,0],45],
                [[3444.28,6386.1,0],330],
                [[3249.7,9320.9,0],350],
                [[10808.2,1541.11,0],305],
                [[2486.92,11372.6,0],180]
            ]
        ]
    ];
