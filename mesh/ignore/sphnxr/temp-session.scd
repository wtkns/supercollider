//session file


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
("~/git/sphnxr/init.scd").loadPaths;

("~/git/sphnxr/pstreams.scd").loadPaths;

(
//5. AFTER all Peers have joined
// This should create an env variable named for each peer in the AddrBook
~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)



(
// 6.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.addEffect(\reslpf, \rlpf);
~rose.addEffect(\ringModulator, \ringMod);
)

(
// 7.  Now set the individual pdefns for one synth

Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \sin, inf);
Pdefn(\sinOutBus, \masterOut, inf);
Pdefn(\sinFreq, Prand(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\sinAmp, 0.5, inf);
Pdefn(\sinAtt, 0.01, inf);
Pdefn(\sinWait, Pseq([0.25, 0.125, 0.125], inf));
Pdefn(\sinDuration, Pseq([0.75], inf));
Pdefn(\sinPan, Pseq([-1,1], inf));
Pdefn(\sinMod1, 0, inf);
Pdefn(\sinMod2, 0, inf);
)

~sin.play;



Pdefn(\sinOutBus, \ringModulator, inf);
~rose.setEffect(\ringModulator, \freq, 1.5);
~rose.setEffect(\ringModulator, \freq, 250);
~rose.setEffect(\ringModulator, \freq, 350);



// 8. this is just to make sure the global tempo is set to something reasonable.
~clock.setGlobalTempo(1);

Pdefn(\sinAmp, 0.25, inf);
Pdefn(\sinMod1, Prand([0, 0.001,0.010,0.0125,0.025,0.05,0.1, 0.5], inf));
Pdefn(\sinMod2, Prand([0, 0.001,0.010,0.0125,0.025,0.05,0.1, 0.5], inf));
~rose.setEffect(\ringModulator, \freq, 500);


// 9.  Start the synth

~sin.stop;



// 14.  Change the outbus to an effect

Pdefn(\sinOutBus, \reverb, inf);
Pdefn(\sinOutBus, \distortion, inf);


(
// 7.  Now set the individual pdefns for one synth

Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \pulse, inf);
Pdefn(\sinOutBus, \reslpf, inf);
Pdefn(\sinFreq, Prand(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\sinAmp, 0.25, inf);
Pdefn(\sinAtt, 0.01, inf);
Pdefn(\sinWait, Pseq([0.06125], inf));
Pdefn(\sinDuration, Pseq([0.125], inf));
Pdefn(\sinPan, Pseq([-1,1], inf));
Pdefn(\sinMod1, 0.5, inf);
Pdefn(\sinMod2, 0.5, inf);
)

(
~rose.setEffect(\distortion, \postGain, 0.05);
~rose.setEffect(\distortion, \preGain, 20.0);

)


~rose.setEffect(\reslpf, \freq, 4000);
~rose.setEffect(\reslpf, \freq, 400);
~rose.setEffect(\reslpf, \rq, 0.0125);
~rose.setEffect(\reslpf, \mix, 0.25);
~rose.setEffect(\reslpf, \mix, 0.75);
~rose.setEffect(\reslpf, \mix, 0.99);

~rose.setEffect(\reslpf, \rq, 0.125);


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
("~/git/sphnxr/init.scd").loadPaths;

("~/git/sphnxr/pstreams.scd").loadPaths;

(
//5. AFTER all Peers have joined
// This should create an env variable named for each peer in the AddrBook
~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)

(
// 6.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.addEffect(\reslpf, \rlpf);
~rose.addEffect(\ringModulator, \ringMod);
~rose.addEffect(\ampModulator, \ampMod);
)


(
// 7.  Now set the individual pdefns for one synth

Pdefn(\fmTarget, \rose, inf);
Pdefn(\fmInstrument, \fm, inf);
Pdefn(\fmOutBus, \ringModulator, inf);
Pdefn(\fmFreq, Prand(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\fmCar, Pseq([1], inf));
Pdefn(\fmMod, Pseq([2.4, 2.401, 4, ], inf));
Pdefn(\fmIndex, Pseq([3, 4, 4.5], inf));
Pdefn(\fmAmp, 0.125, inf);
Pdefn(\fmAtt, 0.01, inf);
Pdefn(\fmWait, Prand([5,2,9,3,2,1], inf));
Pdefn(\fmDuration, Pseq([15], inf));
Pdefn(\fmPan, Pseq([-1,1], inf));
Pdefn(\fmMod1, 0.5, inf);
Pdefn(\fmMod2, 0.5, inf);
)

~fm.play;

Pdefn(\fmOutBus, Prand(['ringModulator','ampModulator' ], inf));

~rose.setEffect(\ringModulator, \freq, 1.5);
~rose.setEffect(\ringModulator, \freq, 15);
~rose.setEffect(\ringModulator, \freq, 250);
~rose.setEffect(\ringModulator, \freq, 350);
~rose.setEffect(\ringModulator, \freq, 1000);


~rose.setEffect(\ampModulator, \freq, 10);
~rose.setEffect(\ampModulator, \freq, 250);
~rose.setEffect(\ampModulator, \freq, 350);
~rose.setEffect(\ampModulator, \freq, 1000);

~fm.stop;

(
// 24.  Now set the individual pdefns for the granular synth
Pdefn(\granTarget, \rose, inf);
Pdefn(\granInstrument, \gran, inf);
Pdefn(\granOutBus, \reslpf, inf);
Pdefn(\granEnvBuf, -1, inf);
// this is the buffer number containing a signal to use for the grain envelope. -1 uses a built-in Hann envelope
Pdefn(\granBufOffset, Prand([0,1,2,3,4,5,6,7,8,9], inf));
// this is the buffer number to use. buffers are loaded during init from the granSamples folder in the repo
Pdefn(\granBufPos, Pbrown(0, 1, 0.0125, inf));
// this is where in the sample the grain will come from
Pdefn(\granRate, Prand([1, 2, 5, 10, 15, 20, 25, 50, 100, 500], inf));
Pdefn(\granRate, Pexprand(0.0001, 500, inf));
Pdefn(\granDurMin, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granDurMax, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granPlayRateMin, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPlayRateMax, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\granAmp, Prand([0.1, 0.15, 0.25], inf));
Pdefn(\granNoteDuration, Prand([0.5, 1.0, 1.5, 2.0, 5.0, 10.0], inf));
Pdefn(\granWait, Prand([0.5, 1.0, 1.5, 2.0, 5.0], inf));
)

// Warning: make sure the clock isnt anything crazy
~clock.setGlobalTempo(1,10);

// Note: to see the buffers you have loaded
~buffers.postln


// 25. just play a single "note"
~granular.step;


// 26. start playing
~granular.play;

// 27. Stop the granular
~granular.stop;
