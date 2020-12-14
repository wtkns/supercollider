//jeff vactrol synth
SynthDef(\vactrol, {|
	out = 0,
	attack = 0.05,
	res = 0.8,
	strength = 0.5,
	panX = 0,
	panY = 0,
	len = 0.25,
	t_gate = 1,
	level = 0,
	in = 20,
	pulseWidth = 0.5,
	pulseFreq = 20,
	source = 1|
  var trig, sig, busInSignal, internalSignal, freq, env, laggedTrig;
  trig = Trig.ar(t_gate, 0,1);
  busInSignal = In.ar(in,1);
  internalSignal = Pulse.ar(pulseFreq, pulseWidth);
  sig = Select.ar(source, [busInSignal, internalSignal]);
  env = EnvGen.ar(Env.perc(attack, 1, curve: \wel), t_gate, timeScale: len);
  freq = env.lincurve(0, 1, 0, 1000 * strength, curve: -4);
  laggedTrig = trig.lag();
  sig = MoogFF.ar(sig, freq, res);
  Out.ar(out, Pan4.ar(sig, panX, panY, level));
}, metadata:()).add();