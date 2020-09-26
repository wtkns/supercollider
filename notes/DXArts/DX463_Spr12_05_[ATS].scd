/*
ATS - Analysis - Transformation - Synthesis
	developed by Juan Pampin for his dissertation at Stanford University
	originally created in Common LISP for CLM
	atsa / atsh
	SC Plugins
*/

/* 
 ATSH.app will run on OS X IF you have it in the /Applications folder AND
 Must have X11 installed
 */
 
"open /Applications/ATSH.app".unixCmd;

s.boot;

// Load our ATS file into SC:

a = AtsFile("/Users/joshp/SND/FluteMono.ats");

// using the data

a.sndDur;
a.numPartials;
a.numFrames;
a.getParFreq(0);

a.numPartials.do({arg i;
	a.getParFreq(i).at(0).postln;
});

a.loadToBuffer;
a.freeBuffer;

a.saveForSC("/Users/joshp/SND/FluteMono.scats");

b = CtkBuffer.playbuf("/Users/joshp/SND/FluteMono.scats").load;

n = CtkSynthDef(\atsTest1, {arg buffer, atsSndDur, nPars;
	var ats, pointer;
	pointer = LFSaw.kr(atsSndDur.reciprocal, 1).range(0, 1);
	ats = AtsSynth.ar(buffer, nPars, 0, 1, pointer);
	Out.ar(0, ats.dup);
});

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(a.numPartials).play;

z.free;

n = CtkSynthDef(\atsTest2, {arg buffer, atsSndDur, nPars, parStart = 0,
		parSkip = 1, freqMul = 1, freqAdd = 0, stretch = 1;
	var ats, pointer;
	pointer = LFSaw.kr(atsSndDur.reciprocal * stretch, 1).range(0, 1);
	ats = AtsSynth.ar(buffer, nPars, parStart, parSkip, pointer, freqMul, freqAdd);
	Out.ar(0, ats.dup);
});

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(3).parStart_(3).parSkip_(2).play;
z.free;

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(1).parStart_(3).parSkip_(1).play;
z.free;

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(a.numPartials).stretch_(0.1).play;
z.free;

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(a.numPartials).stretch_(0.1)
	.freqMul_(1.1).freqAdd_(40).play;
z.free;

z = a.numPartials.asInt.collect({arg i;
	n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(1).stretch_(0.1.rrand(0.2))
		.parStart_(i).freqMul_(1.1.rrand(0.9)).freqAdd_(40.rrand(-20)).play;
});

z.do({arg thisNote; thisNote.free;});

n = CtkSynthDef(\atsTest2, {arg buffer, atsSndDur, nPars, parStart = 0,
		parSkip = 1, freqMul = 1, freqAdd = 0, stretch = 1,
		sinePct = 1, noisePct = 1, numBands = 25, bandStart = 0,
		bandSkip = 1;
	var ats, pointer;
	pointer = LFSaw.kr(atsSndDur.reciprocal * stretch, 1).range(0, 1);
	ats = AtsNoiSynth.ar(buffer, nPars, parStart, parSkip, pointer, 
		sinePct: sinePct,
		noisePct: noisePct,
		freqMul: freqMul, 
		freqAdd: freqAdd,
		numBands: numBands,
		bandStart: bandStart,
		bandSkip: bandSkip
		);
	Out.ar(0, ats.dup);
});

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(a.numPartials).play;
z.free;

z = n.note.buffer_(b).atsSndDur_(a.sndDur).nPars_(a.numPartials)
	.sinePct_(0).play;

z.sinePct_(0.6);
z.sinePct_(2.0);
z.sinePct_(0);

z.free;


/*
See also:
	AtsFile
	AtsSynth
	AtsNoiSynth
	AtsPartial
	AtsBand
	AtsFreq
	AtsAmp
	AtsNoise
	AtsParInfo
*/