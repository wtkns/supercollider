(
var count, domain, bounds, bgColor, doClear, pieceLength;
var score, ferryGrain, glissound, sndBuffer;

// declare mapping envelopes
var grainFreqEnv, grainPeriodEnv;
grainFreqEnv = Env.new([1, 20, 100],[0.5, 0.5], \exp);
grainPeriodEnv = Env.new([0.01, 10],[1], \exp);

// set up ctk score
score = CtkScore.new;

// set up server variables
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;

s.waitForBoot({

////////////   SOUND SECTION PARAMETERS AND CTK SYNTHDEFs

	// load sound file into buffer
	sndBuffer = CtkBuffer.playbuf("/Users/jameswatkins/dx461-au11-james/FerryStudy/ferry.aiff");
	sndBuffer.load;
	s.sync;


	
	// CtkSynthDef with all relevant parameters
	
	glissound = 	CtkSynthDef(\gliss, {arg duration, grainFreq, grainPeriod, grainAmp, sndBuffer, outbus;
					var grains, env, freq, trigger, pan, rate, pos, out, ctrl;
						env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
					// create overlaps
						trigger = Impulse.ar(grainFreq);
						rate = LFNoise2.kr(0.1).range(0.707, 1.3);
						pos = LFNoise1.kr(2).range(0, 1);
						pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
						grains = GrainBuf.ar(2, trigger, grainPeriod, sndBuffer, rate, pos, 4, pan);
						out = grains;
					Out.ar(outbus, out);
					});
	
	

////////// SCORE

score.add(glissound.note
			(0.1, 66.0, addAction: \head,  target: 1)
			.grainFreq_(CtkControl.env(Env([0, 50 ], [1.0], \exp), timeScale: 66)) 
			.grainPeriod_(CtkControl.env(Env([0.01, 1], [1.0], \exp), timeScale: 66))
			.grainAmp_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.95, 0.05], \lin), timeScale: 66))
			.duration_(60)
			.outbus_(0)
			.sndBuffer_(sndBuffer)
		); 
//
//	10.do({arg i;		
//		score.add(moogy.note
//			(0.1, 22, addAction: \tail, target: 1) 
//			.inbus_(blipOut)
//			.pan_(CtkControl.env(Env([-0.8, 0.8, 0], [0.2, 0.8], \lin), timeScale: 22))
//			.env_(CtkControl.env(Env([0.01, 1, 1, 0.01], [0.05, 0.9, 0.05], \lin), timeScale: 22))
//			.dur_(22)
//			.amp_(0.8)
//			.outbus_(o)
//		);
//	});









score.play;

CmdPeriod.doOnce({sndBuffer.free});
		})
});		
)