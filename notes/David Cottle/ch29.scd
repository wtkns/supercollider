/*
29 - Markov Chains, Numerical Data Files


29.1. transTable
*/

//A collection of the pitches used

legalPitches = [60, 62, 64, 65, 67, 69];

//An array of arrays, representing every possible previous pair.

transTable = [
 [0, 0], //C, C
 [0, 1], //C, D
 [0, 2], //C, E
 [0, 4], //C, G
 [1, 2], //D, E
 [2, 0], //E, C
 [2, 3], //E, F
 [3, 2], //F, E
 [3, 4], //F, G
 [4, 0], //G, C
 [4, 2], //G, E
 [4, 3], //G, F
 [4, 4], //G, G
 [4, 5], //G, A
 [5, 4] //A, G 
]; 

/*

29.2. Parsing the transTable
*/

transTable.do({arg index, i; if(index == currentPair, 
 {nextIndex = i; true;}, {false})});

/*

29.3. Probability chart
*/

nPitchProb = 
[
 //C D E F G A
 [0.00, 0.33, 0.00, 0.00, 0.66, 0.00], //C, C
 [0.00, 0.00, 1.00, 0.00, 0.00, 0.00], //C, D
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00], //C, E
 [0.66, 0.00, 0.00, 0.00, 0.00, 0.33], //C, G
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //D, E
 [0.50, 0.00, 0.25, 0.00, 0.25, 0.00], //E, C
 [0.00, 0.00, 0.00, 0.00, 1.00, 0.00], //E, F
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //F, E
 [0.00, 0.00, 0.50, 0.00, 0.50, 0.00], //F, G
 [1.00, 0.00, 0.00, 0.00, 0.00, 0.00], //G, C
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00], //G, E
 [0.00, 0.00, 1.00, 0.00, 0.00, 0.00], //G, F
 [0.00, 0.00, 0.00, 0.00, 0.00, 1.00], //G, G
 [0.00, 0.00, 0.00, 0.00, 1.00, 0.00], //G, A
 [0.00, 0.00, 0.00, 1.00, 0.00, 0.00] //A, G
 
];

/*
currentPair.put(0, currentPair.at(1));_currentPair.put(1, nextPitch);

29.4. Foster Markov
*/

(
 
var wchoose, legalPitches, previousIndex, prevPitch, 
currentPitch, nextIndex, nextPitch, nPitchProb, 
pchoose, blipInst, envelope, pClass, count, resopluck; 

prevPitch = 3;
currentPitch = 1;
count = 1;
pClass = #["A3", "B3", "C4", "D4", "E4", "F4", "F#4", 
 "G4", "A4", "B4", "C5", "D5"];

//pchoose is the mechanism for picking the next value. 

pchoose = 
{
legalPitches = [57, 59, 60, 62, 64, 65, 66, 67, 69, 71, 72, 74];

//Both prevPitch and nextPitch are not pitches, but array positions.

previousIndex = [
 [2], //previous is 0 or A3
 [2], //1 or B3
 [0, 1, 2, 3, 4, 5, 7, 9, 10], //2: C4
 [1, 2, 3, 4, 7, 10], //3: D4
 [2, 3, 4, 5, 7, 8], //4: E4
 [4, 5, 7, 8], //5: F4
 [7], //6: F#4
 [2, 4, 5, 6, 7, 8, 10], //7: G4
 [2, 4, 5, 6, 7, 8, 10], //8: A4
 [8, 10], //9: B5
 [7, 8, 9, 10, 11], //10: C5
 [7, 9] //11: D5
];

previousIndex.at(prevPitch).do({arg index, i; if(index == currentPitch, 
 {nextIndex = i; true;}, {false})});

nPitchProb = 
[
// [00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11] array position
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for A3
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00] // one array: C4
],
[ //arrays for B3
 [00, 00, 05, 06, 00, 00, 00, 05, 00, 00, 00, 00] // C4 only
],
[ //arrays for C4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // A3
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // B3
// [00, 02, 02, 09, 02, 10, 00, 00, 00, 00, 00, 00], original C4
 [00, 06, 02, 09, 02, 06, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 03, 04, 08, 00, 00, 01, 00, 00, 00, 00], // D4
 [00, 00, 00, 07, 03, 02, 00, 04, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 11, 00, 00, 00, 05, 00, 00, 00], // F4
 [00, 00, 00, 00, 04, 00, 00, 12, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 02, 11, 03, 00, 00] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for D4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // B4
// [01, 00, 01, 04, 05, 00, 00, 01, 00, 01, 03, 00], original C4
 [05, 00, 01, 04, 01, 00, 00, 01, 00, 01, 03, 00], // C4
// [00, 01, 12, 01, 02, 00, 00, 00, 00, 00, 00, 00], original D4
 [00, 06, 07, 01, 02, 00, 00, 00, 00, 00, 00, 00], // D4
 [00, 00, 01, 03, 06, 04, 00, 01, 01, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 00, 05, 08, 03, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00] // C5
],
[ //arrays for E4
 [00, 00, 00, 12, 03, 01, 00, 00, 00, 00, 00, 00], // C4
// [00, 02, 07, 03, 02, 00, 00, 01, 00, 01, 00, 00], original D4
 [00, 05, 04, 03, 02, 00, 00, 01, 00, 01, 00, 00], // D4
 [00, 00, 03, 04, 06, 02, 00, 01, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 04, 03, 00, 06, 03, 00, 00, 00], // F4
 [00, 00, 00, 00, 02, 00, 00, 10, 03, 00, 01, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00] // A4,
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for F4
 [00, 00, 00, 08, 00, 08, 00, 00, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 08, 00, 08, 00, 00, 00, 00], // F4
 [00, 00, 02, 00, 00, 00, 00, 10, 00, 00, 04, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00] // A4, 
],
[ //arrays for F#4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00] // G4,
],
[ //arrays for G4
 [00, 00, 00, 11, 05, 00, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 05, 04, 03, 01, 00, 02, 01, 00, 00, 00], // E4
 [00, 00, 00, 00, 16, 00, 00, 00, 00, 00, 00, 00], // F4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // F#4
 [00, 00, 00, 00, 04, 01, 04, 04, 03, 00, 00, 00], // G4
 [00, 00, 01, 00, 01, 00, 05, 07, 01, 00, 01, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 06, 05, 03, 02, 00] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for A4
 [00, 00, 16, 00, 00, 00, 00, 00, 00, 00, 00, 00], // C4
 [00, 00, 00, 11, 05, 00, 00, 00, 00, 00, 00, 00], // E4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00], // F4
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // F#4
 [00, 00, 01, 00, 09, 01, 00, 02, 01, 00, 02, 00], // G4
 [00, 00, 00, 00, 02, 00, 00, 12, 00, 00, 02, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 09, 02, 05, 00, 00] // C5
],
[ //arrays for B5
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 00, 06, 00, 00, 10] // C5
],
// A, B, C, D, E, F, F#, G, A, B, C, D
[ //arrays for C5
 [00, 00, 00, 00, 14, 00, 00, 02, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 01, 00, 05, 06, 00, 04, 00], // A4
 [00, 00, 00, 00, 00, 00, 00, 00, 12, 00, 04, 00], // B4
 [00, 00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00], // C5
 [00, 00, 00, 00, 00, 00, 00, 05, 00, 11, 00, 00] //D5
],
[ //arrays for D5
 [00, 00, 00, 00, 00, 00, 00, 16, 00, 00, 00, 00], // G4
 [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 16, 00] // B4
]
];

nextPitch = (nPitchProb.at(prevPitch).at(nextIndex).normalizeSum).windex;

//current is set to previous, next is current for next run. The actual pitch 
//is returned from legal pitch at nextPitch.

[pClass.at(nextPitch), legalPitches.at(nextPitch)].post; 
// if((count%10) == 0, {"".postln};);
count = count + 1;
prevPitch = currentPitch;
currentPitch = nextPitch;
legalPitches.at(nextPitch)
};

Pbind(

 \dur, 0.125,
 \dur, Prand([
 Pseq(#[1]),
 Pseq(#[0.5, 0.5]),
 Pseq(#[0.5, 0.5]),
 Pseq(#[0.25, 0.25, 0.25, 0.25]),
 Pseq(#[0.5, 0.25, 0.25]),
 Pseq(#[0.25, 0.25, 0.5]),
 Pseq(#[0.25, 0.5, 0.25])
 ], inf),
 \midinote, Pfunc(pchoose),
 \db, -10,
// \instrument, "SimpleTone",
 \pan, 0.5
).play

)


/*
Data Files, Data Types

29.5. test ascii
*/

var fp;
fp = File("Testascii.rtf", "r"); //open a text file
fp.length.do({a = fp.getInt8; [a, a.ascii.postln}); //read file as integers

/*

29.6. data files
*/

var fp, data;
fp = File("TestInt", "w"); //open a file
data = [65, 66, 67, 68, 69, 70, 71];
data.do({arg eachInt; fp.putInt16(eachInt)}); //place each int in file
fp.close;

var fp, data;
fp = File("TestInt", "r"); //open a file
data = fp.readAllInt16; //read all as Int array
data.postln;
fp.close;

var fp, data;
fp = File("TestFloat", "w"); //open a file
data = [6.5, 6.6, 6.7, 6.8, 6.9, 7.0, 7.1];
data.do({arg eachFloat; fp.putFloat(eachFloat)}); 
fp.close;

var fp, data;
fp = File("TestFloat", "r"); //open a file
data = fp.readAllFloat; //read all as array
data.postln;
fp.close;

/*
Interpreting Strings

29.7. interpreting a string
*/

var fp, array;
fp = File("arrayfile", "r");
array = fp.readAllString; //read the file into a string 
array.postln; //print to confirm it is a string
array = array.interpret; //interpret it and store it again
array.at(0).postln; //confirm it is code not a string
array.at(1).sum.postln;
array.at(2).at(0).postln;
array.at(3).postln;

/*
29. Exercises
*/
