(
var count, domain, bounds, bgColor, doClear, fullScreen, pieceLength;
var graingen, warpgen, flange, pitchshift, delay, reverb, gverb, resonz, limiter;
var grainOut, warpOut, flangeOut, pitchShiftOut, delayOut, reverbOut, gverbOut, limiterOut, resonzOut;
var fireSinging, thisNote, sharpEnv;
var score, myBuses, myBuffers;
var reverbNote;

// set up ctk score
score = CtkScore.new;

// set up server variables
thisThread.randSeed_(120);
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
//ServerOptions.outDevices; 
//Server.default.options.outDevice_("Soundflower (2ch)"); 
s.boot;
s.scope;

s.waitForBoot({
	////////////   SOUND SECTION PARAMETERS AND CTK SYNTHDEFs
	
	grainOut = CtkAudio.new(server: s);
	warpOut = CtkAudio.new(server: s);
	flangeOut = CtkAudio.new(server: s);
	pitchShiftOut = CtkAudio.new(server: s);
	delayOut = CtkAudio.new(server: s);
	reverbOut = CtkAudio.new(server: s);
	gverbOut  = CtkAudio.new(server: s);
	resonzOut = CtkAudio.new(server: s);
	limiterOut = CtkAudio.new(server: s);
	myBuses = [	grainOut, warpOut, flangeOut, pitchShiftOut, delayOut, reverbOut, gverbOut, resonzOut, limiterOut];
	myBuses.do({arg thisBus; thisBus.bus.postln;});

	// load sound file into buffer
	fireSinging = CtkBuffer.playbuf("~/samp/jon.aiff".standardizePath, channels: 0);

	// fill buffer with envelope for grain window
	sharpEnv = CtkBuffer.new(size: 1024);
	sharpEnv.fillWithEnv(0.1, env: Env([0, 1, 1, 0], [0.001, 0.98, 0.01], \sin));
	myBuffers = [fireSinging, sharpEnv];
	myBuffers.do({arg thisBuffer; thisBuffer.load;});
       
	"buffers added".postln;
	s.sync;
	
	
	// CtkSynthDefs with all relevant parameters

	// part I
	graingen = CtkSynthDef(\grain, {arg buffer, envBuf, pos, grainPeriod, rate, pan, outBus;
					var grains, trigger, out, amp;
					trigger = Impulse.ar(0.01);
					rate = LFNoise2.kr(0.1).range(0.9, 1.2);
					amp = LFNoise2.kr(0.1).range(0.85, 0.95);
					grains = GrainBuf.ar(2, trigger, grainPeriod, buffer, rate, pos, 4, pan, envBuf);
					out = grains;
					Out.ar(outBus, out* amp);
					});

	flange  =   CtkSynthDef(\flange, {arg duration, freq = 110, psamount, psfreq, inbus, outbus;
				var env, src, delay, deltime;
				env = EnvGen.kr(Env([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: duration); 
				// a sound to flange
				src = In.ar(inbus, 2);
				// here, the delay is controlled by a SinOsc.  Remap the output
				// to 0 and psamount (avoiding negative delay times)
				deltime = SinOsc.ar(psfreq, 0).range(0, psamount);
				delay = DelayC.ar(src, psamount, deltime);
				Out.ar(outbus, [src, delay] * env);
				});	
		
	delay 		= CtkSynthDef(\delay, {arg duration, deltime, inbus, outbus;
				var env, src, delay;
				env = EnvGen.kr(
				Env([0.0, 1.0, 1.0, 0.0], [0.001, 0.998, 0.001]), timeScale: duration); 
				src = In.ar(inbus, 2);
				// DelayC- delay with cubic interpolation
				// DelayC.ar(arg in = 0.0, maxdelaytime = 0.2, delaytime = 0.2, mul = 1.0, add = 0.0);
				// the max delay time tells SC how much memory to allocate
				delay = DelayC.ar(src, 1.0, deltime + LFNoise2.kr(1).range(0, deltime));
				Out.ar(0, [src, delay] * env);
				});		
				
	reverb = CtkSynthDef(\freeverb, {arg roomsize = 0.7, gain = 0.9, damp = 0.5, gate = 1, mix = 0.5, inbus, outbus, feedback;
				var in, rev, out, env;
				env = EnvGen.kr(Env([0, 1, 1, 0.5], [0.1, 0.85, 0.5], \sin, 1), gate);
				in = In.ar(inbus, 2);
				rev = FreeVerb.ar(in, mix, roomsize, damp);
				Out.ar(grainOut, rev * feedback);
				Out.ar(outbus, rev * env);
				});				
	
	limiter =  CtkSynthDef(\limiter, {arg inbus = 0;
				ReplaceOut.ar(inbus, Limiter.ar(In.ar(inbus, 2), 0.9, 0.01 ));
				});

		
	// thisNote = graingen.note(0.25, 0.5).buffer_(sndBuffer).envBuf_(sharpEnv);
	// thisNote.play;
	
	// Set up Particle routine 
	pieceLength = 7200;  // up to 10800 @ 30fps
	count = 200; 
	bounds = Point.new(800, 800);
	bgColor = Color.black;
	doClear = false;
	fullScreen = true; // or windowed

	r = Routine.new({

		// initialize window
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);
		
		// start Audio
		// score.play;

		// part 1:
		// initialize particles
		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \bounce,
					par: domain,
					pos: Point.new((domain.bounds.x/(count+1))*(i), 0),
					vel: Point.new(0, 3+((fireSinging.duration/count)*i)),
					col: Color.red,
					vis: 0.5,
					siz: Point.new(250,250),
					styl: \box,
					lif: 0,
					indx: i,
					not: graingen.note(0.1, 0.5)
						.buffer_(fireSinging)
						.envBuf_(sharpEnv)
						.pos_(fireSinging.duration - (1/count *i))
						.grainPeriod_(fireSinging.duration/count)
						.rate_(rrand(0.85, 1.15))
						.pan_(rrand(-1*(i/count), i/count))
						.outBus_(grainOut);
				)
			);
		});	
		
		// start reverb
		
		reverbNote = reverb.note (0.1, 90.0, addAction: \tail,  target: 1)
			.inbus_(grainOut)
			.outbus_(0)
			.roomsize_(CtkControl.env(Env([0.25, 0.75, 1.0], [0.1, 0.9], \sin), timeScale: 90))
			.mix_(CtkControl.env(Env([0.25, 0.75, 1.0], [0.2, 0.9], \sin), timeScale: 90))
			.gain_(CtkControl.env(Env([0.8, 0.95, 1.25], [0.2, 0.9], \sin), timeScale: 90))
			.feedback_(CtkControl.env(Env([0.01, 0.1, 0.5], [0.8, 0.2], \sin), timeScale: 90))
			.play;

		// start particles
		for (0, pieceLength/8, {|i|

			domain.animae.do({ arg part, j;
				part.move;
			});
			
			// housekeeping
			domain.animae.do({ arg part, j;
				if (part.life != 0, {
					if (part.age>part.life, {domain.animae.removeAt(j)});
				});			
				part.velocity.y = part.velocity.y*1.00075; 
				part.size = part.size * 0.995;
				part.color = (part.color).complementary; 			});
			
			domain.userview.refresh;
			(1/30).wait;
		});
		
		
		// part 2

		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: (i/count)-0.25,
					siz: Point.new(10,100),
					styl: \rectangle,
					lif: ((pieceLength/2)/count)*i,
					indx: i
				)
			);
		});	
		
//		domain.animae.do({ arg part, j;
//			part.strategy =  \spiral;
//			part.style = \circle;
//			part.size = Point.new(j/2,j/2);
//			part.color = Color.new255(j%100*2.5, j%250, j%25*10, 255);
//			part.velocity  =  Point.new(10,10);
//		});
		
		for (0, pieceLength, {|i|

			domain.animae.do({ arg part, j;
				part.move;
			});
			
			// housekeeping
			domain.animae.do({ arg part, j;
				if (part.life != 0, {
					if (part.age>part.life, {domain.animae.removeAt(j)});
				});	
				part.color = (part.color).complementary; 
					
			});
			
						domain.userview.refresh;
			(1/30).wait;
		});

		
	}, 2048);	

	r.play(AppClock);

	CmdPeriod.doOnce({
		myBuffers.do({arg thisBuffer; thisBuffer.free;});
		"buffer clear".postln;
		myBuses.do({arg thisBus; thisBus.free;});		"buses clear".postln;

	});
	
});	

)
