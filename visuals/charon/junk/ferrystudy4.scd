(
var count, domain, bounds, bgColor, doClear, pieceLength;
var score, graingen, warpgen, flange, pitchshift, delay, reverb, gverb, resonz, limiter, sndBuffer;
var myBuses, grainOut, warpOut, flangeOut, pitchShiftOut, delayOut, reverbOut, gverbOut, limiterOut, resonzOut;

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

s.waitForBoot({
	
	////////////   SOUND SECTION PARAMETERS AND CTK SYNTHDEFs
	s.scope;
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
	myBuses.do({arg thisbus, i; thisbus.bus.postln;});  


	// load sound file into buffer
	sndBuffer = CtkBuffer.playbuf("/Users/jameswatkins/dx461-au11-james/FerryStudy/ferry.aiff");
	sndBuffer.load;
	s.sync;


	// CtkSynthDefs with all relevant parameters
	
	// part I
	graingen = CtkSynthDef(\gliss, {arg duration, buffer, grainFreq, grainPeriod, grainAmp, env;
					var grains, freq, trigger, pan, rate, pos, out, ctrl;
					trigger = Impulse.ar(grainFreq);
					rate = LFNoise2.kr(0.1).range(0.707, 1.3);
					pos = LFNoise1.kr(2).range(0, 0.1);
					pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
					grains = GrainBuf.ar(2, trigger, grainPeriod, buffer, rate, pos, 4, pan);
					out = Limiter.ar(grains, 0.8, 0.1);
					Out.ar(grainOut, out* grainAmp*env);
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
				
	reverb = CtkSynthDef(\freeverb, {arg roomsize = 0.7, gain = 0.9, damp = 0.5, inbus = 99, gate = 1, outbus;
				var in, rev, out, env;
				env = EnvGen.kr(Env([0, 1, 1, 0.5], [0.1, 0.85, 0.5], \sin, 1), gate);
				in = In.ar(inbus, 2);
				rev = FreeVerb.ar(in, 1.0, roomsize, damp);
				Out.ar(outbus, rev * env);
				});				
	
	limiter =  CtkSynthDef(\limiter, {arg inbus = 0;
				ReplaceOut.ar(inbus, Limiter.ar(In.ar(inbus, 2), 0.9, 0.01 ));
				});
				
//	stageLimit = SynthDef(\stageLimiter, {arg bus = 2, limit = 1;
//					var input;
//					input = In.ar(bus, 5); // change nr of channels here if you need to
//					input = Select.ar(CheckBadValues.ar(input, 0, 0), [input, DC.ar(0), DC.ar(0), input]);
//					ReplaceOut.ar(bus, Limiter.ar(input, limit)) ;
//			});			
	
	/// PART II

	warpgen	 = CtkSynthDef(\warp, {arg duration, env, ampMult, buffer, start, end, curve, freqScale;
					var out, pointer, pan;
					pointer = EnvGen.kr(Env([start, end], [duration], curve)) + LFNoise2.kr(0.1).range(-0.01, 0.01);
					out = Warp1.ar(1, buffer, pointer, freqScale, 0.1, -1, 8, 0.2);
					// use a noise UGen to control the panning
					pan = Pan2.ar(out, LFNoise2.kr((duration * 0.2).reciprocal));
					Out.ar(warpOut, pan * env * ampMult);
					});		
					
	gverb = CtkSynthDef(\gverb, {arg roomsize = 120, revtime = 3, damp = 0.5, inputbw = 0.5, spread = 15, inbus = 99, gate = 1, outbus;
					var in, rev, out, env;
					env = EnvGen.kr(Env([0, 1, 0], [0.1, 1.0], \sin, 1), gate);
					in = In.ar(inbus, 2);
					// GVerb reads in mono - outputs stereo. Mix our signal before sending it in
					rev = GVerb.ar(in.sum, roomsize, revtime, damp, inputbw, spread, 
					drylevel: 0, maxroomsize: roomsize + 1);
					Out.ar(outbus, rev * env)
					});
	
	resonz = CtkSynthDef(\resonz, {arg formfreq, bandwidth, amp, inbus, outbus, env;
				var reson;
				reson = Resonz.ar(In.ar(inbus, 2), formfreq, (bandwidth / formfreq));
				Out.ar(0, (reson * env) * amp);
				});

////////// SCORE

		score.add(sndBuffer);

///// PART I  //////
		score.add(graingen.note (0.1, 66.0, addAction: \head,  target: 1)
			.duration_(60.0)
			.buffer_(sndBuffer)
			.env_(CtkControl.env(Env([0, 0.85, 0.85, 0.75, 0], [0.01, 0.80, 0.18, 0.01], -3).plot, timeScale: 60))
			.grainFreq_(CtkControl.env(Env([500, 5, 10, 4500], [0.25, 0.25, 0.5], \exp), timeScale: 60)) 
			.grainPeriod_(0.01)
			.grainAmp_(CtkControl.env(Env([0.6, 0.85, 0.85, 0.5], [0.5, 0.15, 0.35], \exp), timeScale: 60))
		); 

		score.add(flange.note (0.1, 66.0, addAction: \tail,  target: 1)
			.inbus_(grainOut)
			.outbus_(flangeOut)
			.psamount_(CtkControl.env(Env([0.1, 5], [1], \sin), timeScale: 60))
			.psfreq_(10.reciprocal)
			.duration_(60)
		); 

		score.add(delay.note (0.1, 66.0, addAction: \tail,  target: 1)
			.duration_(60.0)
			.deltime_(CtkControl.env(Env([0.01, 0.75, 0.01], [0.25, 0.75], \exp), timeScale: 60))
			.inbus_(flangeOut)
			.outbus_(delayOut)
		); 	
		
		score.add(reverb.note (0.1, 190.0, addAction: \tail,  target: 1)
			.inbus_(delayOut)
			.outbus_(0)
		); 		
		
	
		
		
///// PART II  //////

		score.add(warpgen.note (55.0, 90.0, addAction: \head,  target: 1)
			.buffer_(sndBuffer)
			.start_(0.25)
			.end_(0.7)
			.duration_(85)
			.curve_(5)
			.env_(CtkControl.env(Env([0, 0.8, 0.8, 0], [0.1, 0.8, 0.1], \sin), timeScale: 86))
			.ampMult_(0.2)
			.freqScale_(CtkControl.env(Env([0.5, 1, 1.5, 0.01], [0.1, 0.8, 0.25], \sin), timeScale: 86))
		); 

		score.add(resonz.note (55.0, 90.0, addAction: \tail,  target: 1)
			.inbus_(warpOut)
			.outbus_(resonzOut)
			.amp_(CtkControl.env(Env([0, 0.9, 0.9, 0], [0.1, 0.8, 0.1], \sin), timeScale: 86))
			.env_(CtkControl.env(Env([0, 0.9, 0.9, 0], [0.1, 0.8, 0.1], \sin), timeScale: 86))
			.formfreq_(CtkControl.env(Env([200, 100, 750], [0.3, 0.7], \sin), timeScale: 86))
			.bandwidth_(CtkControl.env(Env([20, 400, 50], [0.3, 0.7], \sin), timeScale: 86))
		); 	

		score.add(flange.note (57.0, 90.0, addAction: \tail,  target: 1)
			.inbus_(warpOut)
			.outbus_(resonzOut)
			.psamount_(CtkControl.env(Env([0.1, 5, 5], [0.8, 0.2], \sin), timeScale: 86))
			.psfreq_(10.reciprocal)
			.duration_(96)
		); 

		score.add(gverb.note (57.0, 92.0, addAction: \tail,  target: 1)
			.inbus_(resonzOut)
			.outbus_(0)
		); 	

		score.add(limiter.note (0.1, 190.0, addAction: \tail, target: 0)
			.inbus_(0)
		);
		
		score.write("/Users/jameswatkins/dx461-au11-james/FerryStudy/test.aif".standardizePath, options: 
		ServerOptions.new.numOutputBusChannels_(2));


		CmdPeriod.doOnce({
			sndBuffer.free;
			"buffer clear".postln;
			myBuses.do({arg thisbus; thisbus.free;});  

		});

	//////////// GRAPHICS ROUTINE (plays score)

	// Set up Particle routine 
	pieceLength = 3000;
	count = 200; 
	bounds = Point.new(1000, 800);
	bgColor = Color.black;
	doClear = true;
	
	

	r = Routine.new({

	// initialize window
	domain = Khora.new(count, bounds, bgColor, doClear);

	// start Audio
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
					vis: (i/count)-0.25,
					siz: Point.new(10,100),
					styl: \rectangle,
					lif: ((pieceLength/2)/count)*i,
					indx: i
				)
			);
		});	

		// start particles
		for (0, pieceLength*0.5, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.size.y = part.size.y-0.05; 
				
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});


	// part 2:
		(0.5).wait;

		for (0, count*2, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \rotate,
					par: domain,
					pos: Point.new(domain.bounds.x/2, i*(domain.bounds.y/count)),
					vel: Point.new(i%500,5),
					col: Color.new255(i%100*2.5, i%250, i%25*10, 255),
					vis: (i/count)-0.15,
					siz: Point.new(2,2),
					styl: \circle,
					lif: (pieceLength/count)*i,
					indx: i
				)
			);
		});	

		domain.userview.clearOnRefresh = false;

		for (0, pieceLength/4, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.color = (part.color).complementary; 
				part.size = part.size+Point.new(0.025,0.025);
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				// if (part.age>part.life, {domain.animae.removeAt(j)});
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});
		
		for (0, pieceLength/4, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.color = (part.color).complementary; 
				part.size = part.size+Point.new(-0.025,-0.025);
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				part.color = (part.color).darken(3); 
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});

		for (0, pieceLength/8, {|i|

			domain.animae.do({ arg part, j;
				part.move;
				part.color = Color.black; 
				part.size = part.size+Point.new(0.5,0.5);
			});

			// housekeeping
			domain.animae.do({ arg part, j;
				//part.color = (part.color).darken(3); 
			});
			
			domain.userview.refresh;
			(1/30).wait;
		});
		
	}, 2048);	

	//r.play(AppClock);

});	

)