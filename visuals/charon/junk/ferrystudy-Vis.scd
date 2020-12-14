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
	
	glissound = 	CtkSynthDef(\gliss, {arg duration, grainFreq, grainPeriod, grainAmp, sndBuffer;
					var grains, env, freq, trigger, pan, rate, pos, out, ctrl;
						env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
					// create overlaps
						trigger = Impulse.ar(grainFreq);
						rate = LFNoise2.kr(0.1).range(0.707, 1.3);
						pos = LFNoise1.kr(2).range(0, 1);
						pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
						grains = GrainBuf.ar(2, trigger, grainPeriod, sndBuffer, rate, pos, 4, pan);
						out = grains;
					Out.ar(0, out);
					});
	
	ferryGrain = CtkSynthDef(\periodic, {arg duration, grainFreq, grainPeriod, grainAmp, sndBuffer;
			var grains, env, freq, trigger, pan, rate, pos, out, ctrl;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
			// create overlaps
			trigger = Impulse.ar(grainFreq);
			rate = LFNoise2.kr(0.1).range(0.707, 1.3);
			pos = LFNoise1.kr(2).range(0, 1);
			pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
			grains = GrainBuf.ar(2, trigger, grainPeriod, sndBuffer, rate, pos, 4, pan);
			out = grains;
		Out.ar(0, out);
			});

////////// SCORE


//////////// GRAPHICS ROUTINE (plays score)

	// Set up Particle routine 
	pieceLength = 3600;
	count = 200; 
	bounds = Point.new(1000, 800);
	bgColor = Color.black;
	doClear = true;
	
	// initialize window
	domain = Khora.new(count, bounds, bgColor, doClear);
	
	// start particles
	r = Routine.new({

	score.play;
	
	// part 1:
		// initialize particles
		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: i/count,
					siz: Point.new(10,100),
					styl: \rectangle,
					lif: (pieceLength/count)*i,
					indx: i
				)
			);
		});	

		for (0, pieceLength, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.size.y = part.size.y-0.025; 
				
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});


	// part 2:
		(2).wait;

		for (0, count/2, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: i/count,
					siz: Point.new(100,100),
					styl: \circle,
					lif: (pieceLength/count)*i,
					indx: i
				)
			);
		});	

		domain.userview.clearOnRefresh = false;

		for (0, pieceLength/2, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.color = (part.color).complementary; 
				part.size = part.size+Point.new(-0.055,-0.055);
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				// if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});

		
	}, 2048);	
		r.play(AppClock);
});		
)