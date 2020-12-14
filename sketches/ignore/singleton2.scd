(
var count, domain, bounds, bgColor, doClear, fullScreen, pieceLength;
var graingen, sndBuffer, thisNote, sharpEnv;
var score, myBuses, myBuffers;
var grainOut;

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
	myBuses = [grainOut];
	myBuses.do({arg thisBus; thisBus.bus.postln;});
	
	sndBuffer = CtkBuffer.playbuf("~/samp/jon.aiff".standardizePath, channels: 0);
	sharpEnv = CtkBuffer.new(size: 1024);
	sharpEnv.fillWithEnv(0.1, env: Env([0, 1, 1, 0], [0.001, 0.98, 0.01], \sin));
	myBuffers = [sndBuffer, sharpEnv];
	myBuffers.do({arg thisBuffer; thisBuffer.load;});
       
	"buffers added".postln;
	s.sync;

	graingen = CtkSynthDef(\grain, {arg buffer, envBuf, pos, grainPeriod, rate, pan;
					var grains, trigger, out, amp;
					trigger = Impulse.ar(0.01);
					rate = LFNoise2.kr(0.1).range(0.9, 1.2);
					amp = LFNoise2.kr(0.1).range(0.85, 0.95);
					grains = GrainBuf.ar(2, trigger, grainPeriod, buffer, rate, pos, 4, pan, envBuf);
					out = grains;
					Out.ar(grainOut, out* amp);
					});


		
	// thisNote = graingen.note(0.25, 0.5).buffer_(sndBuffer).envBuf_(sharpEnv);
	// thisNote.play;
	
	// Set up Particle routine 
	pieceLength = 3000;
	count = 200; 
	bounds = Point.new(800, 800);
	bgColor = Color.red;
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
					vel: Point.new(0, 3+((sndBuffer.duration/count)*i)),
					col: Color.yellow,
					vis: 0.25,
					siz: Point.new(250,250),
					styl: \box,
					lif: 0,
					indx: i,
					not: graingen.note(0.1, 0.5)
						.buffer_(sndBuffer)
						.envBuf_(sharpEnv)
						.pos_(sndBuffer.duration - (1/count *i))
						.grainPeriod_(sndBuffer.duration/count)
						.rate_(rrand(0.85, 1.15))
						.pan_(rrand(-1*(i/count), i/count));
				)
			);
		});	

		// start particles
		for (0, pieceLength, {|i|

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
		
		domain.animae.do({ arg part, j;
			part.strategy =  \rotate;
			part.velocity  =  Point.new(10,10);
		});
		
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
