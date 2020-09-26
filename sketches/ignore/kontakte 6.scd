(
var score, blip, blipOut, resonz, resonzOut, gVerb, gVerbOut, myBuses, length;

Server.default = s = Server.internal;
s.boot;
s.waitForBoot({
//	s.scope;
//	f = FreqScope.new; 


	// Buses
	blipOut = CtkAudio.new(server: s);
	resonzOut = CtkAudio.new(server: s);
	gVerbOut = CtkAudio.new(server: s);
	blipOut.bus.postln;
	myBuses = [blipOut];

	// Blip Generator		
	blip = CtkSynthDef(\blip, {arg dur, freq, amp, numharms, env = 1, outbus;
		var pulse;
		numharms = (SampleRate.ir * 0.4) / freq;
		pulse = Blip.ar(freq, numharms.floor, amp.dbamp);		Out.ar(outbus, pulse *env);
	});
	
	resonz =  CtkSynthDef(\resonz, {arg dur, freq, amp, outbus, inbus, env = 1, bw;
		var  reson, bal, src;
		src = In.ar(inbus);
		
		reson = Resonz.ar(src, 
					freq, 
					(bw / freq));
		
		Out.ar(outbus, (reson * env));
		
	});
	
	gVerb = CtkSynthDef(\gVerb, {arg dur, amp, env = 1, outbus, inbus, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel, mix = 0.5;
		var src, reverb;
		src = In.ar(inbus);

		reverb = GVerb.ar(src,
						roomsize, 
						revtime, 
						damping, 
						inputbw, 
						spread, 
						drylevel.dbamp,
						earlylevel.dbamp, 
						taillevel.dbamp
						);
			
			Out.ar(outbus, (reverb * env) * mix); // reverb out (1)
			Out.ar(outbus, (src*env) * (1 - mix)); // dry out (0)
	});

	
		score = CtkScore.new;
		
		length = 45.0;

		score.add(blip.note
			(0.1, length, addAction: \head,  target: 1)
			.outbus_(blipOut)

			.dur_(length)
			.amp_(0) 

			.freq_(CtkControl.env(Env([166, 14.5, 3.63, 0.91 ], [0.31, 0.17, 0.26, 0.26], \exp), timeScale: length)) 
		); 

		score.add(resonz.note
			(0.1, length, addAction: \tail,  target: 1)

			.inbus_(blipOut)
			.outbus_(resonzOut)

			.dur_(length)
			.amp_(0)

			.freq_(CtkControl.env(Env([400, 3000, 196, 160], [0.31, 0.17, 0.26, 0.26], \exp), timeScale: length))
			.bw_(CtkControl.env(Env([1, 3000, 100, 1], [0.31, 0.17, 0.26, 0.26], \exp), timeScale: length))
		); 
		
		score.add(gVerb.note
			(0.1, length, addAction: \tail,  target: 1)
			.inbus_(resonzOut)
			.outbus_(0)

			.dur_(length)
			.amp_(0) 
			
			.mix_(CtkControl.env(Env([0.1, 0.1, 1, 1, 0.01], [0.5, 0.05, 0.4, 0.05], \exp), timeScale: length))

			.roomsize_(80)
			.revtime_(4.85)
			.damping_(0.41)
			.inputbw_(0.19)
			.drylevel_(-3)
			.earlylevel_(-9)
			.taillevel_(-11)
		); 
		





		score.play;

})
)
