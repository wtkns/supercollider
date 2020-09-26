	warpgen	 = CtkSynthDef(\warp, {arg duration, buffer, start, end, dur, curve;
					var out, pointer, pan, env;
					env = EnvGen.kr(Env([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), timeScale: dur);
					pointer = EnvGen.kr(Env([start, end], [dur], curve)) + LFNoise2.kr(0.1).range(-0.01, 0.01);
					out = Warp1.ar(1, buffer, pointer, 0.5, 0.1, -1, 8, 0.2);
					// use a noise UGen to control the panning
					pan = Pan2.ar(out, LFNoise2.kr((dur * 0.2).reciprocal));
					Out.ar(0, pan * env * 0.2);
					});		

	pitchshift =CtkSynthDef(\pshiftpdev, {arg dur, semis, windowsize = 0.1, buffer, clean = 1, pitchdev = 0, inbus, outbus;
				var in, env, out;
				env = EnvGen.kr(
				Env([0.0001, 1, 1, 0.0001], [0.1, dur - 0.02, 0.1], \sin));
					in = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer));
				// add in a little timeDispersion to avoid "combing" effect
				out = (in * clean) + PitchShift.ar(in, windowsize, semis.midiratio, pitchdev, windowsize * 0.1);
				Out.ar(0, out * env);
				});	
				
				
				
				
				
				
				
				
				///// PART II  //////

		score.add(warpgen.note (58.0, 66.0, addAction: \head,  target: 1)
			.buffer_(sndBuffer)
			.start_(0.1)
			.end_(0.9)
			.dur_(60)
			.curve_(5)
		); 

		score.add(pitchshift.note (58.0, 66.0, addAction: \tail,  target: 1)
			.dur_(60.0)
			.inbus_(flangeOut)
			.outbus_(pitchShiftOut)
			.semis_(0)
			.clean_(0)
			.pitchdev_(0)
		); 

		score.add(flange.note (58.0, 66.0, addAction: \tail,  target: 1)
			.inbus_(warpOut)
			.outbus_(flangeOut)
			.psamount_(0.01)
			.psfreq_(1.reciprocal)
			.duration_(60)
		); 

		score.add(reverb.note (0.1, 66.0, addAction: \tail,  target: 1)
			.inbus_(delayOut)
			.outbus_(0)
			.roomsize_(1.0)
			.gain_(1.0)
			.damp_(1.0)
		); 		
		
