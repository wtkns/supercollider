(
Server.default = s = Server.internal.boot;
s.waitForBoot({
	s.scope;
	f = FreqScope.new(400, 200, 0);
	})
)

(
var score;
score = CtkScore.new;

a = CtkSynthDef(\sinTone, {arg freq, gate = 1, amp = 1, dur;
	var sig, env;
	env = EnvGen.kr(Env.new([0, 1, 1, 0], [0.1, 0.8, 0.1], \sin), timeScale: dur, doneAction: 0); 
	sig = SinOsc.ar(freq, 0, 1);
	Out.ar(0, sig * env * amp);
	});

score.add(
	// unison	
	a.note(1.0, 10).freq_(500).amp_(-12.dbamp).dur_(10),
	a.note(1.0, 10).freq_(500).amp_(-12.dbamp).dur_(10),
	// beating
	a.note(12.0, 10).freq_(500).amp_(-12.dbamp).dur_(10),
	a.note(12.0, 10).freq_(505).amp_(-12.dbamp).dur_(10),
	// roughness
	a.note(23.0, 10).freq_(500).amp_(-12.dbamp).dur_(10),
	a.note(23.0, 10).freq_(520).amp_(-12.dbamp).dur_(10),
	// interval
	a.note(34.0, 10).freq_(500).amp_(-12.dbamp).dur_(10),
	a.note(34.0, 10).freq_(555).amp_(-12.dbamp).dur_(10)
);

score.play;
)