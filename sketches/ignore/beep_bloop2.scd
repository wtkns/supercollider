// sample modal drone
// james watkins
// 29.12.2015

/*



*/

(
s = Server.default;
ServerOptions.devices;
s.options.device_("JackRouter");
s.boot;
 )


(
var sd, root, scale, partials, tonic, times, beatLength, phraseLength,  sectionLength, prob;
thisThread.randSeed = 200;


// section
root = 200.0;
beatLength = 50.0;
sectionLength = 10.0;

partials = [[1.0, 1.0],  [1.25, 0.75], [1.5, 0.5]];
scale = [1/1,5/4,3/2,7/4,11/8,13/8,17/16,19/16];
prob = 0.15;

sd = CtkSynthDef(\myNote, {arg freq, dur, amp, pan;
	var sin, env, envGen;
	env = Env([0.001, 0.99, 0.001], [0.75, 0.25], [\sin, \sin]);
	env.plot;
	envGen = EnvGen.kr(env, doneAction: 0, timeScale: dur);
	sin = SinOsc.ar(freq, 0, amp);
	Out.ar(0, Pan2.ar(sin * envGen, pan));
}).send(s);

sectionLength.do({arg o;
	scale.do({arg thisNote, i;
		if (prob.coin, {
			partials.do({arg thisPart, u;
				var aNote, randPan, randAmp;
				randPan = rrand(-1.0, 1.0);
				randAmp = rrand(0.0, 0.125);
				aNote = sd.note((o*beatLength/2.0), beatLength).freq_(root*thisNote*thisPart[0]).dur_(thisPart[1]*beatLength).amp_(randAmp).pan_(randPan);
				aNote.play;
			});
		});
	});
});

)
s.quit;