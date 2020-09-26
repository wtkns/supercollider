(
var sd, note, clar;
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale;
		var osc, env, envGen;
		// Control.names([\argName]).kr( ... a default ... )
		// space for an 8 breakpoint Env
		env = Control.names([\env]).kr(Env([-90, -12, -90], [0.02, 0.98], \exp));Ê
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc));
	});
	
	// pass in values for freq, amp (in db) and duration:
	clar = {arg freq, amp, duration;Ê
		var partialAmps, freqScale, durScale, env;
		partialAmps = [0, -30, -6, -36, -9, -44, -18, -76, -24, -66, -36];
		freqScale = [1, 2.1, 3.001, 3.9, 5.0, 5.85, 7.01, 8.1, 8.99, 9.9, 11.02];
		durScale = [1, 1, 1, 0.9, 1, 0.8, 0.9, 0.5, 0.7, 0.3, 0.1];
		
		partialAmps.size.do({arg i; // simply a counter passed in
			var thisAmp, thisFreq, thisDur;
			thisAmp = partialAmps[i] + amp;Ê
			thisFreq = freqScale[i] * freq;
			thisDur = durScale[i] * duration;
			sd.note(0.1, thisDur).freq_(thisFreq).envDurScale_(thisDur)
				.ampScale_(thisAmp).play;
		})
	};
	 Ê
	Routine.run({
		clar.value(220, -18, 4).play;		
	});
})
)
