
(
Server.default = s = Server.internal.boot;
Routine.run({
	var note, sndBuffer, thisnote;
	s.waitForBoot({
		sndBuffer = CtkBuffer.playbuf("/Users/joshp/SND/ferry.aiff");
		sndBuffer.load;
		
		s.sync;
		note = CtkSynthDef(\periodic, {arg duration, grainFreq, grainPeriod, grainAmp, 
				sndBuffer;
			var grains, env, freq, trigger, pan, rate, pos, out, ctrl;
			env = EnvGen.kr(Env([0, 1, 1, 0], [0.3, 0.4, 0.3], \sin), timeScale: duration);
			// create overlaps
			trigger = Impulse.ar(grainFreq);
			rate = LFNoise2.kr(0.1).range(0.707, 1.3);
			pos = LFNoise1.kr(2).range(0, 1);
			pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
			grains = GrainBuf.ar(2, trigger, grainPeriod, sndBuffer, rate, pos, 4, pan);
			out = grains;
//			//	0.2 ! 8 creates an array of 8 instances of 0.2 ... in this case
//			// 8 different LFNoise2s!
//			out = Resonz.ar(out, [1400, 1600, 1900, 2200] * LFNoise2.kr(0.2 ! 8).range(0.7, 1.2), 0.01);
//			out = Splay.ar(out); // spreads the output above across the stereo field
//			out = CombC.ar(out, 0.1, [54, 56, 89, 122].reciprocal, 3) * LFNoise2.kr(0.2 ! 8).max(0);
//			out = Splay.ar(out);
//			ctrl = LFNoise2.kr(0.2 ! 8).max(0);
//			out = CombC.ar(out, 0.1, [54, 56, 89, 122].reciprocal, 3) * ctrl;
//			out = RLPF.ar(out, 100 + (ctrl * 3000), 0.2) + out;
//			out = Splay.ar(out); 
			Out.ar(0, out * env);
			});
			
		thisnote = note.note(1.0, 20.0).duration_(20.0).grainFreq_(50).grainPeriod_(0.01).grainAmp_(-12.dbamp)
			.sndBuffer_(sndBuffer).play;
		
		CmdPeriod.doOnce({sndBuffer.free});
		})
	})
)
