(
var sd, bell, defaultPartials;

	defaultPartials = Array.new(11);
	// Amplitude, Duration, Frequency, Modifier
	defaultPartials.add([1,1,0.56,0]);
	defaultPartials.add([0.67,0.9,0.56,1]);
	defaultPartials.add([1,0.65,0.92,0]);
	defaultPartials.add([1.8,0.55,0.92,1.7]);
	defaultPartials.add([2.67,0.325,1.19,0]);
	defaultPartials.add([1.67,0.35,1.7,0]);
	defaultPartials.add([1.46,0.25,2,0]);
	defaultPartials.add([1.33,0.2,2.74,0]);
	defaultPartials.add([1.33,0.15,3,0]);
	defaultPartials.add([1,0.1,3.76,0]);
	defaultPartials.add([1.33,0.075,4.07,0]);


bell = {arg fund = 500, duration = 10, amplitude = -12, partials = defaultPartials;

	partials.do({arg thisPartial, i;
					var amp, dur, freq, offset, note, env;
					#amp, dur, freq, offset = thisPartial;
					dur = dur*duration;
					freq = (fund*freq)+offset;
					amp = (amplitude * amp);
					env = Env([-90, -12, -90], [0.002, 1], \exp);
					sd.note(0.1, dur).freq_(freq).env_(env).envDurScale_(dur).ampScale_(amp).
					play;
					});	
};
	
Server.default = s = Server.internal.boot;

s.waitForBoot({
	s.scope;

	sd = CtkSynthDef(\simpleSineWEnv, {arg freq, envDurScale = 1, ampScale;
		var osc, env, envGen;
		env = Control.names([\env]).kr(Env.newClear(8)); 
		envGen = EnvGen.kr(env, timeScale: envDurScale);
		osc = SinOsc.ar(freq, 0, envGen.dbamp * ampScale.dbamp);
		Out.ar(0, Pan2.ar(osc))
	});

	Routine.run({
		bell.value(880,5, -24, defaultPartials);
		bell.value(280,20, -12, defaultPartials);
		bell.value(660,5, -24, defaultPartials);
		bell.value(440,10, -24, defaultPartials);
		bell.value(500,5, -24, defaultPartials);
		bell.value(1280,20, -12, defaultPartials);
		bell.value(600,5, -24, defaultPartials);
		bell.value(400,10, -24, defaultPartials);
		bell.value(200,5, -24, defaultPartials);
		bell.value(100,20, -12, defaultPartials);
		bell.value(800,5, -24, defaultPartials);
		bell.value(2000,10, -24, defaultPartials);
	})	
})

)
