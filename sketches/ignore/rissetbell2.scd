(

var  partials, sd, note;

partials = Array.new(11);
// Amplitude, Duration, Frequency, Modifier
partials.add([1,1,0.56,0]);
partials.add([0.67,0.9,0.56,1]);
partials.add([1,0.65,0.92,0]);
partials.add([1.8,0.55,0.92,1.7]);
partials.add([2.67,0.325,1.19,0]);
partials.add([1.67,0.35,1.7,0]);
partials.add([1.46,0.25,2,0]);
partials.add([1.33,0.2,2.74,0]);
partials.add([1.33,0.15,3,0]);
partials.add([1,0.1,3.76,0]);
partials.add([1.33,0.075,4.07,0]);


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
		var fundamental, duration, amplitude;
		fundamental = 440;
		duration = 5;
		amplitude = 1;
		partials.do({arg thisData, i;
						var amp, dur, freq, offset, mulamp;
						#amp, dur, freq, offset = thisData;
						mulamp = amp*amplitude.dbamp;
						mulamp.postln;
						sd.note(0.1, duration*dur).freq_(fundamental*(freq+offset)).envDurScale_(duration*dur).ampScale_(mulamp)
						.env_(Env([-90, -12, -24, -36, -90], [0.001, 1,1, 4], \exp)).play;						});	
				})
})

)
