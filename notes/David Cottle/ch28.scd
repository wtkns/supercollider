/*
28 - Music Driven by Extra-Musical Criteria, Data Files
Extra Musical Criteria
Text Conversion

28.1. ascii values
*/

a = "Test string";
a.at(2).ascii.postln;
a.at(2).digit.postln;_a.do({arg each; each.post; " ".post; each.ascii.postln;})

/*
Mapping

28.2. pitchMap
*/

pitchMap = IdentityDictionary[
 $H -> 6, $x -> 6, $b -> 6, $T -> 6, $W -> 6,
 $e -> 11, $o -> 11, $c -> 11, $, -> 11, $. -> 11,
 $n -> 3, $y -> 3, 
 $m -> 4, $p -> 8, $l -> 9
 ]; 

/*

28.3. mapping array
*/

var mappedValue, intervMap;

intervMap = [ 
 ["ae", 2], ["io", 4], [" pst", 5], ["Hrn", -2],
 ["xmp", -1], ["lfg", -4], ["Th", -5], [".bdvu", 1]
];

intervMap.do({arg item; 
 if(item.at(0).includes($o),
 {mappedValue = item.at(1)})
 });

/*

28.4. Extra-Musical Criteria, Pitch Only
*/

(
var noteFunc, blipInst, midiInst, channel = 0, port = 0, prog = 0,
 intervMap, count = 0, ifNilInt = 0, midin = 0, inputString; 

//The input stream. 

inputString = "Here is an example of mapping. The, them, there, these,"
 "there, then, that, should have similar musical interpretations."
 "Exact repetition; thatthatthatthatthatthat will also"
 "be similar.";

//intervMap is filled with arrays containing a collection of 
//characters and a value. In the functions below the character
//strings are associated with the numbers.

intervMap = [ 
 ["ae", 2], ["io", 4], [" pst", 5], ["Hrn", 7],
 ["xmp", 1], ["lfg", 3], ["Th", 6], [".bdvu", 11]
];


"// [Char, Interval, ifNilInt, midi interval, octave, midi]".postln;

noteFunc = Pfunc({var parseInt, octave;

 //Each array in the intervMap is checked to see if the
 //character (inputString.wrapAt(count)) is included. If
 //it is then parseInt is set to the value at item.at(1)
 
 intervMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseInt = item.at(1)})
 });

 //If parseInt is notNil, midin is set to that. 
 //ifNilInt is for storing each parseInt to be used if
 //no match is found and parseInt is nil the next time around.

 if(parseInt.notNil,
 {midin = parseInt; ifNilInt = parseInt},
 {midin = ifNilInt}
 );

 octave = 60;

 "//".post; [inputString.wrapAt(count), parseInt, 
 ifNilInt, midin, octave/12, midin + octave].postln;

 count = count + 1; 
 
 midin + octave
});

Pbind(
 \midinote, noteFunc,
 \dur, 0.125,
 \amp, 0.8,
 \instrument, "SimpleTone"
).play;

)

/*

28.5. Extra-Musical Criteria, Total Control
*/

(
var noteFunc, blipInst, midiInst, channel = 0, port = 0, prog = 0,
 intervMap, count = 0, ifNilInt = 0, midin = 0, ifNilDur = 1,
 durMap, durFunc, ifNilSus = 1, susMap, susFunc, ifNilAmp = 0.5, 
 curAmp = 0.5, ampMap, ampFunc, inputString; 

//The input stream. 

inputString = "Here is an example of mapping. The, them, there, these,"
 "there, then, that, should have similar musical interpretations."
 "Exact repetition; thatthatthatthatthatthat will also"
 "be similar.";

//intervMap is filled with arrays containing a collection of 
//characters and a value. In the functions below the character
//strings are associated with the numbers.

intervMap = [ 
 ["ae", 6], ["io", 9], [" pst", 1], ["Hrn", -3],
 ["xmp", -1], ["lfg", -4], ["Th", -5], [".bdvu", 1]
];

durMap = [ 
 ["aeiouHhrsnx", 0.125], ["mplf", 0.5], ["g.T,t", 0.25],
 ["dvc", 2], [" ", 0]
];

susMap = [ 
 ["aei ", 1.0], ["ouHh", 2.0], ["rsnx", 0.5], ["mplf", 2.0], ["g.T,t", 4.0],
 ["dvc", 1.0]
];

ampMap = [ 
 ["aeHhrsnx ", 0.8], ["ioumplfg.T,tdvc", 1.25]
];

noteFunc = Pfunc({var parseInt, octave = 48;

 //Each array in the intervMap is checked to see if the
 //character (inputString.wrapAt(count)) is included. If
 //it is then parseInt is set to the value at item.at(1)
 
 intervMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseInt = item.at(1)})
 });

 //If parseInt is notNil, midin is set to that plus previous
 //midin. ifNilInt is for storing each parseInt to be used if
 //no match is found and parseInt is nil.

 if(parseInt.notNil,
 {midin = parseInt + midin%48; ifNilInt = parseInt},
 {midin = ifNilInt + midin%48}
 );

 [inputString.wrapAt(count)].post; 
 ["pitch", parseInt, midin, octave/12, midin + octave].post;
 
 midin + octave
});

durFunc = Pfunc({var parseDur, nextDur;

 durMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseDur = item.at(1)})
 });

 if(parseDur.notNil,
 {nextDur = parseDur; ifNilDur = parseDur},
 {nextDur = ifNilDur}
 );
 ["dur", nextDur].post;
 nextDur
});

susFunc = Pfunc({var parseSus, nextSus;

 susMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseSus = item.at(1)})
 });

 if(parseSus.notNil,
 {nextSus = parseSus; ifNilSus = parseSus},
 {nextSus = ifNilSus}
 );
 ["sustain", nextSus.round(0.01)].post;
 nextSus
});

ampFunc = Pfunc({var parseAmp;

 ampMap.do({arg item; 
 if(item.at(0).includes(inputString.wrapAt(count)),
 {parseAmp = item.at(1)})
 });

 if(parseAmp.notNil,
 {curAmp = curAmp*parseAmp; ifNilAmp = parseAmp},
 {curAmp = curAmp*ifNilAmp}
 );
 
 count = count + 1;
 if(0.5.coin, {curAmp = rrand(0.2, 0.9)});
 ["amp", curAmp.round(0.01)].postln;

 curAmp.wrap(0.4, 0.9)
});


Pbind(
 \midinote, noteFunc,
 \dur, durFunc,
 \legato, susFunc,
 \amp, ampFunc,
 \instrument, "SimpleTone"
).play;
)

/*
Working With Files

28.6. reading a file
*/

(
var input, filePointer; //declare variables
filePointer = File("Test File", "r"); 
input = filePointer.readAllString;
filePointer.close;
input.postln;
)

/*

28.7. reading a file
*/

// Print any pathname for later use

File.openDialog("", { arg pathName; pathName.postln});

// Open using a dialog
(
var input, filePointer; //declare variables
File.openDialog("", {arg pathname;
 filePointer = File(pathname, "r"); 
 input = filePointer.readAllString;
 input.postln;
 // Everything has to be inside this function
},
{"File not found".postln});

)

// Or open file and store in global

(
var filePointer; //declare variables
File.openDialog("", {arg pathname;
 filePointer = File(pathname, "r"); 
 ~input = filePointer.readAllString;
},
{"File not found".postln});
)

// Then

~input.postln;

// Or include ~input in the patch.

/*

28. Exercises
*/
