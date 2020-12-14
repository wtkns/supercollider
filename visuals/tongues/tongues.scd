(
var count, bounds, pieceLength;  // Piece parameters
var domain, ctl; // containers and controls
var bgColor, doClear, fullScreen; // Display Parameters
var graingen, flange, delay, freeverb, gverb, resonz, limiter;  // Synths
var myBuses, grainOut, flangeOut, delayOut, reverbOut, gverbOut, limiterOut, resonzOut;  // Buses
var myBuffers, sndBuffer, sharpEnv; // Buffers
var notes, dur; // notes

// SET PIECE PARAMETERS
dur = 260;
pieceLength = 6400;  // up to 10800 @ 30fps
count = 40;
bounds = Point.new(800, 800);

// MANAGE CTK CONTROLS
ctl = Dictionary.new;
ctl.add(\grainRate ->CtkControl.play(initVal: 1.0));
ctl.add(\cleanRevRoom ->CtkControl.play(initVal: 0.1));
ctl.add(\cleanRevMix ->CtkControl.play(initVal: 0.1));
ctl.add(\partPan ->CtkControl.play(initVal: 0));

// MANAGE AND BOOT SERVER
thisThread.randSeed_(140);
Server.default = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.boot;
// s.scope;

s.waitForBoot({

	// MANAGE BUSES
	grainOut = CtkAudio.new(2);
	flangeOut = CtkAudio.new(2);
	delayOut = CtkAudio.new(2);
	reverbOut = CtkAudio.new(2);
	gverbOut  = CtkAudio.new(2);
	resonzOut = CtkAudio.new(2);
	limiterOut = CtkAudio.new(2);
	myBuses = [grainOut, flangeOut, delayOut, reverbOut, gverbOut, resonzOut, limiterOut];
	// myBuses.do({arg thisBus; thisBus.bus.postln;});  // debugging

	// MANAGE BUFFERS
	sndBuffer = CtkBuffer.playbuf("~/git/wtkns/supercollider/visuals/tongues/jon.aiff".standardizePath, channels: 0); // load the sample
	sharpEnv = CtkBuffer.new(size: 1024); // envelope for grain window
	sharpEnv.fillWithEnv(0.1, env: Env([0, 1, 1, 0], [0.01, 0.98, 0.1], \sin));
	myBuffers = [sndBuffer, sharpEnv];
	myBuffers.do({arg thisBuffer; thisBuffer.load;});
	"buffers added".postln;
	s.sync;  // wait until buffers are loaded

	// MANAGE SYNTHS
	graingen = CtkSynthDef(\grain, {arg outBus, buffer, envBuf, pos, grainPeriod, rate, pan, amp;
		var grains, trigger;
		trigger = Impulse.ar(0.01);
		grains = GrainBuf.ar(2, trigger, grainPeriod, buffer, rate, pos, 4, pan, envBuf);
		Out.ar(outBus, grains * amp);
	});

	flange	= CtkSynthDef(\flange, {arg duration, inBus, outBus, psamount, psfreq, mix, amp = 1;
		var src, out, env, delay, deltime;
		src = In.ar(inBus, 2);
		env = EnvGen.kr(Env([0.001, 1.0, 1.0, 0.001], [0.001, 0.998, 0.001], \sin), timeScale: duration);
		deltime = SinOsc.ar(psfreq, 0).range(0, psamount);
		delay = DelayC.ar(src, psamount, deltime);
		//Out.ar(outBus, [src, delay] );
		Out.ar(outBus,  (delay * mix * amp)); // flange out (1)
		Out.ar(outBus, (src * (1 - mix))); // dry out (0)
	});

	delay 		= CtkSynthDef(\delay, {arg inBus, outBus, deltime;
		var src, out, delay;
		src = In.ar(inBus, 2);
		// DelayC- delay with cubic interpolation
		// DelayC.ar(arg in = 0.0, maxdelaytime = 0.2, delaytime = 0.2, mul = 1.0, add = 0.0);
		// the max delay time tells SC how much memory to allocate
		delay = DelayC.ar(src, 1.0, deltime + LFNoise2.kr(1).range(0, deltime));
		Out.ar(outBus, (delay));
	});

	freeverb = CtkSynthDef(\freeverb, {arg duration, inBus, outBus, room, mix, damp = 0, gate = 1, amp;
		var src, out, env, rev;
		src = In.ar(inBus, 2);
		env = EnvGen.kr(Env([0.001, 1.0, 1.0, 0.001], [0.001, 0.998, 0.001], \sin), timeScale: duration);
		rev = FreeVerb.ar(src, mix, room, damp);
		Out.ar(outBus, (rev * env) * amp);
	});

	gverb = 	CtkSynthDef(\gverb, {arg duration, inBus, outBus, roomsize = 220, revtime = 20, damp = 0.25, inputbw = 0.75, spread = 15, env, mix;
		var src, out, rev;
		src = In.ar(inBus, 2);
		// GVerb reads in mono - outputs stereo. Mix our signal before sending it in
		rev = GVerb.ar(src.sum, roomsize, revtime, damp, inputbw, spread,
			drylevel: 0, maxroomsize: roomsize + 1);
		Out.ar(outBus, rev * env);
		Out.ar(0,  rev * mix); // direct out (1)
	});

	resonz = CtkSynthDef(\resonz, {arg inBus, outBus, formfreq, bandwidth, amp;
		var src, reson, rq, freqs, ampScale;
		src = In.ar(inBus, 2);
		freqs = formfreq * [1, 2.1, 3.9, 4.1, 7, 8];
		rq = bandwidth / formfreq;
		ampScale = 1/rq;
		reson = Resonz.ar(src, freqs, 1 / freqs, ampScale);
		Out.ar(outBus, (reson.sum)!2 * amp);
	});

	limiter = 	CtkSynthDef(\limiter, {arg inBus = 0, level = 0.9;
		ReplaceOut.ar(inBus, Limiter.ar(In.ar(inBus, 2), level, 0.01 ));
	});

	r = Routine.new({

		// VISUAL PARAMETERS AND WINDOW
		bgColor = Color.black;
		doClear = false;
		fullScreen = false; //true; // or windowed
		domain = Khora.new(count, bounds, bgColor, doClear, fullScreen);

		// 	// INITIALIZE PARTICLES
		for (0, count, {|i|
			domain.animae = domain.animae.add(
				Anima.new(
					strat: \bounce,
					par: domain,
					pos: Point.new((domain.bounds.x/(count+1))*(i), 0),
					vel: Point.new(0, 6+(0.25*i)),
					col: Color.red,
					vis: 0.5,
					siz: Point.new(40,40),
					styl: \box,
					lif: 6400,
					indx: i,

					// Set each particle's grain position and length with a note
					not: graingen.note(0.1, 0.5)
					.buffer_(sndBuffer)
					.envBuf_(sharpEnv)
					.pos_(sndBuffer.duration - (1/count *i))
					.grainPeriod_(sndBuffer.duration/count)
					.rate_(ctl[\grainRate])
					.pan_(ctl[\partPan])
					.amp_(0.15)
					.outBus_(grainOut);
				);
			);
		});

		// 	// START FILTER NOTES
		notes = List.new(1);

		notes.add(freeverb.note (addAction: \tail,  target: 1)
			.duration_(dur)
			.inBus_(grainOut)
			.outBus_(0)
			.room_(CtkControl.env(Env([0.1, 0.5, 0.15, 0.15], [0.125, 0.125, 0.75], \sin), timeScale: dur))
			.mix_(CtkControl.env(Env([0.1, 0.45, 0.6], [0.125, 0.875], \sin), timeScale: dur))
			.damp_(0.5)
			.amp_(CtkControl.env(Env([0.15, 0.25, 0, 0], [0.25, 0.125, 0.625], \sin), timeScale: dur))
			.play;
		);

		notes.add(delay.note (addAction: \tail,  target: 1)
			.inBus_(flangeOut)
			.outBus_(0)
			.deltime_(CtkControl.env(Env([0, 0, 0.5, 0.75, 0, 0.5, 0], [0.125, 0.125, 0.125, 0.125, 0.4, 0.1], \sin), timeScale: dur))
			.play
		);

		notes.add(flange.note (addAction: \tail,  target: 1)
			.duration_(dur)
			.inBus_(grainOut)
			.outBus_(flangeOut)
			.amp_(0.5)
			.psamount_(CtkControl.env(Env([0, 0, 2.5, 0.01, 10], [0.125, 0.125, 0.125, 0.625], \sin), timeScale: dur))
			.psfreq_(CtkControl.env(Env([0, 0, 0.25, 0.01, 10 ], [0.125, 0.125, 0.125, 0.625], \sin), timeScale: dur))
			.mix_(CtkControl.env(Env([0, 0, 1, 1, 0], [0.25, 0.125, 0.125, 0.5], \sin), timeScale: dur))
			.play
		);

		// filters for part II

		notes.add(gverb.note (addAction: \tail,  target: 1)
			.inBus_(grainOut)
			.outBus_(gverbOut)
			.env_(CtkControl.env(Env([0, 0, 0.5, 0, 0.5], [0.475, 0.015, 0.49, 0.01], \sin), timeScale: dur)) // wet out to resonz
			.mix_(CtkControl.env(Env([0, 0, 0.3, 0, 0.5], [0.475, 0.015, 0.49, 0.01], \sin), timeScale: dur)) // direct out
			.play
		);

		notes.add(resonz.note (addAction: \tail,  target: 1)
			.inBus_(grainOut)
			.outBus_(0)
			.amp_(CtkControl.env(Env([0, 0, 1, 2, 0], [0.5, 0.125, 0.37, 0.0055], \sin), timeScale: dur))
			.formfreq_(CtkControl.env(Env([200, 200, 800, 100, 40], [0.5, 0.125, 0.125, 0.25], \exp), timeScale: dur))
			.bandwidth_(CtkControl.env(Env([100, 10, 20, 10, 15], [0.5, 0.125, 0.125, 0.25], \sin), timeScale: dur))
			.play
		);

		notes.add(resonz.note (addAction: \tail,  target: 1)
			.inBus_(grainOut)
			.outBus_(0)
			.amp_(CtkControl.env(Env([0, 0, 1, 2, 0], [0.5, 0.125, 0.37, 0.005], \sin), timeScale: dur))
			.formfreq_(CtkControl.env(Env([800, 800, 100, 100, 40], [0.5, 0.125, 0.25, 0.125], \exp), timeScale: dur))
			.bandwidth_(CtkControl.env(Env([10, 10, 20, 5, 15], [0.5, 0.125, 0.125, 0.25], \sin), timeScale: dur))
			.play
		);

		notes.add(resonz.note (addAction: \tail,  target: 1)
			.inBus_(grainOut)
			.outBus_(0)
			.amp_(CtkControl.env(Env([0, 0, 1, 2, 0], [0.5, 0.125, 0.37, 0.005], \sin), timeScale: dur))
			.formfreq_(CtkControl.env(Env([400, 400, 40, 180, 40], [0.5, 0.25, 0.125, 0.125], \exp), timeScale: dur))
			.bandwidth_(CtkControl.env(Env([50, 50, 5, 25, 15], [0.5, 0.125, 0.125, 0.25], \sin), timeScale: dur))
			.play
		);

		notes.add(limiter.note (addAction: \tail, target: 0)
			.inBus_(0)
			.level_(0.95)
			.play;
		);

		//
		// START PIECE
		// AUDIO AND ANIMATION

		// PART I
		// "part I".postln;
		for (0, 800, {|i|
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
				part.size = part.size * 1.0002;
				part.visible = (part.visible * 0.999).max(0.25);
			});

			domain.userview.refresh;
			(1/30).wait;

		});

		//PART II
		// "part II".postln;
		for (0, 800, {|i|
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
				part.size = part.size * 1.0002;
				part.visible = (part.visible * 0.999).max(0.25);
				ctl[\grainRate].set(rrand(0.75, 1));
				ctl[\partPan].set(rrand(-0.5, 0.5));
			});

			domain.userview.refresh;
			(1/30).wait;

		});
		//
		// 	//PART III
		// 	// "part III".postln;
		for (0, 800, {|i|
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
				part.size = part.size * 1.0002;
				part.visible = (part.visible * 0.999).max(0.25);
				ctl[\grainRate].get({arg bus, val; ctl[\grainRate].set(val * 0.998)});				ctl[\partPan].set(rrand(-0.75, 0.75));
			});

			domain.userview.refresh;
			(1/30).wait;

		});

		//PART IV
		// "part IV".postln;
		for (0, 800, {|i|
			//i.postln;  // to find timing
			domain.animae.do({ arg part, j;
				part.move;
				part.size = part.size * 1.0002;
				part.visible = (part.visible * 0.999).max(0.25);
				ctl[\grainRate].set(rrand(0.75, 1.25));
				ctl[\partPan].set(rrand(-1, 1));
			});

			domain.userview.refresh;
			(1/30).wait;

		});

			// HALFWAY

			//PART V
			// "part V".postln;
			for (0, 800, {|i|
				//i.postln;  // to find timing
				domain.animae.do({ arg part, j;
					part.move;
					ctl[\grainRate].set(1.0);
					part.size = part.size * 0.9998;

				});

				domain.userview.refresh;
				(1/30).wait;

			});

			//PART VI
			// "part VI".postln;
			for (0, 800, {|i|
				//i.postln;  // to find timing
				domain.animae.do({ arg part, j;
					part.move;
					ctl[\grainRate].set(rrand(0.75, 1.25));
					ctl[\partPan].set(rrand(-0.75, 0.75));
					part.size = part.size * 0.9998;
				});

				domain.userview.refresh;
				(1/30).wait;

			});

			//PART VII
			// "part VII".postln;
			for (0, 800, {|i|
				//i.postln;  // to find timing
				domain.animae.do({ arg part, j;
					part.move;
					ctl[\grainRate].set(rrand(0.75, 1.25));
					ctl[\partPan].set(rrand(-0.75, 0.75));
					part.size = part.size * 0.9998;
				});

				domain.userview.refresh;
				(1/30).wait;

			});

			//PART VIII
			// "part VIII".postln;
			for (0, 800, {|i|
				//i.postln;  // to find timing
				if (domain.animae.size > 0, {
					domain.animae.do({ arg part, j;
						part.move;
						part.size = part.size * 0.9998;
						ctl[\grainRate].get({arg bus, val; ctl[\grainRate].set(val * 0.998)});					ctl[\partPan].set(rrand(-0.75, 0.75));
						if ((part.life>0) && (part.age>part.life), {
						domain.animae.removeAt(j)});
					});
				},{"Quit!".postln; });
		//
				if (domain.animae.size > 0, {
					domain.userview.refresh;
					(1/30).wait;
				},{"Quit!".postln; });

			});
		//
		//
	}, 2048);

	r.play(AppClock);

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
