/*
27 - Total Serialization Continued, Special Considerations 
Absolute vs. Proportional Values, Rhythmic Inversion 
Pitch

27.1. Proportional MIDI inversion
*/

// If used as MIDI intervals this is unison, 4th up, M3rd up,
// 5th up, M2 down, M6th down, 2nd up, ttone down
 
o = [0, 5, 4, 7, -2, -9, 2, -6];

o.neg;
// Results in unison, 4th down, M3rd down, etc.
[ 0, -5, -4, -7, 2, 9, -2, 6 ]

/*
Duration and next event
Next Event
Non-Sequential Events
Amplitude
Rhythmic Inversion

Ex. 21.1
*/

var rhythmArray, orLength, inversion;

rhythmArray = [1, 1.5, 2, 1.25, 0.25, 0.25, 1.5, 0.333];
orLength = rhythmArray.sum;
inversion = rhythmArray.reciprocal.normalizeSum*orLength;
inversion.postln;
rhythmArray.sum.postln;
inversion.sum.postln;

/*
27. Exercises
*/
