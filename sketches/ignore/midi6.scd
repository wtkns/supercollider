(

// initialize and connect MIDI

var resp, ctl, synth, freqEnv;
var sample, pevents;
var recipr = 127.reciprocal;
var drone1, drone2, drone3, drone4, drone5, drone6, playBuffer;
var notes, myBuffers, myBuses;

freqEnv = Env([100, 500], [1], \exp);

// an array of ctk controls:
ctl = 9.collect({CtkControl.play(initVal: 0.01)}); // initval prevents divide by zero

Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.boot;
s.waitForBoot({
	s.scope;
	s.freqscope;

	drone1 = CtkBuffer.playbuf("~/samp/drone_1.aiff".standardizePath);
	drone2 = CtkBuffer.playbuf("~/samp/drone_2.aiff".standardizePath);
	drone3 = CtkBuffer.playbuf("~/samp/drone_3.aiff".standardizePath);
	drone4 = CtkBuffer.playbuf("~/samp/drone_4.aiff".standardizePath);
	drone5 = CtkBuffer.playbuf("~/samp/drone_5.aiff".standardizePath);
	drone6 = CtkBuffer.playbuf("~/samp/drone_6.aiff".standardizePath);
	myBuffers = [drone1, drone2, drone3, drone4, drone5, drone6];
	myBuffers.do({arg thisBuffer; thisBuffer.load;});
 	"buffers added".postln;
	s.sync;		 // and pause execution until the buffer is loaded
	
	MIDIClient.init;
	MIDIIn.connectAll; 
	
	// start the responders 
	resp = Array.fill(17, {arg i; 
					CCResponder({ |src,chan,num,value|
					    //value.postln;
					    ctl[i].set(value * recipr); // 0-1
					    },
					    nil, // any source
					    nil, // any channel
					    i+1, // cc start with #1
					    nil // any value
					);
	});
	
	playBuffer = CtkSynthDef(\monoPlayback, {arg buffer, startPos, rate = 1, mul, pan;
		var src, env;
		env = EnvGen.kr(Env([0, 1, 1, 0], [0.1, BufDur.kr(buffer) - 0.2, 0.1], \sin));
		// PlayBuf expects the number of channels to match those in the buffer
		// this will ONLY play mono files!
		src = PlayBuf.ar(1, // mono
			buffer, // the buffer you created above
			rate * BufRateScale.kr(buffer), // the rate adjust for SR of file
			1, // a trigger... ignore for now
			startPos * BufSampleRate.kr(buffer), // adjust startPos in sec to samples
			1 // loop, 0 is no, 1 is yes
			);
		Out.ar(0, Pan2.ar((src * env)*mul, pan));
	});
	
	sample = {arg id, amp, env, rate, pan, buffer, mul;
		var proc;
		proc = ProcModR.new(env, amp, 2, 0, id: id);
		proc.function_({arg group, routebus, server;
			Task({
				playBuffer.note(target: group)
					.buffer_(buffer)
					.startPos_(0)
					.rate_(rate)
					.pan_(pan)
					.mul_(mul)
				.play;
			});
		});
	};
	
	
	pevents = ProcEvents.new([
		/* Samples */		
			[   // Start all samples, release nothing
					[
					sample.value(\evSa, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: 0,
						buffer: drone1,
						mul:ctl[0]
					),

					sample.value(\evSb, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: 0,
						buffer: drone2,
						mul:ctl[1]
					),
					
					sample.value(\evSc, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: 0,
						buffer: drone3,
						mul:ctl[2]
					),
					
					sample.value(\evSd, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: -0.9,
						buffer: drone4,
						mul:ctl[3]
					),

					sample.value(\evSe, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: 0.9,
						buffer: drone5,
						mul:ctl[4]
					)						
					],	
					nil
			], 
				
		/* 1 */	
			
			[   // create \ev1, release ev0
					[
					sample.value(\ev1, 0.5, Env([0, 1, 0], [2, 0.1], \sin, 1),
						rate: 1,
						pan: 0,
						buffer: drone6
					)				
					],	
					[\evSa, \evSb, \evSc, \evSd]
			]	
	], 0.dbamp, id: "test");
	
	pevents.showPMGUIs = true; 
	pevents.perfGUI;			

	// CLEAN UP BUFFERS AND BUSES
	CmdPeriod.doOnce({
		myBuffers.do({arg thisBuffer; thisBuffer.free;});
		"buffer clear".postln;
		myBuses.do({arg thisBus; thisBus.free;});		"buses clear".postln;
		notes.do({arg thisNote; thisNote.free;});
		"notes clear".postln;
	});
});
)