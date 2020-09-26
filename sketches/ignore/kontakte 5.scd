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
	blip = CtkSynthDef(\blip, {arg dur, freq, amp, numharms, env, outbus;
		var pulse;
		numharms = (SampleRate.ir * 0.4) / freq;
		pulse = Blip.ar(freq, numharms.floor, amp.dbamp);		Out.ar(outbus, pulse *env);
	});
	
	resonz =  CtkSynthDef(\resonz, {arg dur, freq, amp, outbus, inbus, env, bw;
		var  reson, bal, src;
		src = In.ar(inbus);
		
		reson = Resonz.ar(src, 
					freq, 
					(bw / freq));
		
		//reson = Balance.ar(reson, src, 20);
		Out.ar(outbus, reson * env);
	});
	
	gVerb = CtkSynthDef(\gVerb, {arg dur, amp, env, outbus, inbus, roomsize, revtime, damping, inputbw, spread, drylevel, earlylevel, taillevel;
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
			
			Out.ar(outbus, reverb * env);
	});

	
		score = CtkScore.new;
		
		length = 45.0;
		score.add(resonz.note
			(0.1, length, addAction: \tail,  target: 1)

			.inbus_(blipOut)
			.outbus_(resonzOut)

			.dur_(length)
			.amp_(0)
			.env_(CtkControl.env(Env([0, 1, 1, 0], [0.025, 0.95, 0.025], \exp), timeScale: length))

			.freq_(CtkControl.env(Env([6000, 1000 ], [1], \exp), timeScale: length))
			.bw_(CtkControl.env(Env([500, 200, 1, 1], [0.2, 0.6, 0.2]), timeScale: length))
		); 
		
		score.add(gVerb.note
			(0.1, length, addAction: \tail,  target: 1)
			.inbus_(resonzOut)
			.outbus_(0)

			.dur_(length)
			.amp_(0) 
			.env_(CtkControl.env(Env([0, 1, 1, 0], [0.025, 0.95, 0.025], \exp), timeScale: length))

			.roomsize_(80)
			.revtime_(4.85)
			.damping_(0.41)
			.inputbw_(0.19)
			.spread_(0)
			.drylevel_(-3)
			.earlylevel_(-9)
			.taillevel_(-11)
		); 
		


		score.add(blip.note
			(0.1, length, addAction: \head,  target: 1)
			.outbus_(blipOut)

			.dur_(length)
			.amp_(0) 
			.env_(CtkControl.env(Env([0, 1, 1, 0], [0.025, 0.95, 0.025], \exp), timeScale: length))

			.freq_(CtkControl.env(Env([100, 30, 6 ], [0.25, 0.75], \exp), timeScale: length)) 
			//.numharms_()
		); 


		score.play;

})
)