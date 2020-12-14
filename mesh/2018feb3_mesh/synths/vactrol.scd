//jeff vactrol synth
SynthDef(\vactrol, {|out = 0, attack = 0.05, density = 5, bwr = 0.8, pos = 0, len = 0.25, strength = 0.5, t_gate = 1, in = 20|
  var trig, sig, freq, env, laggedTrig;
  trig = Trig.ar(t_gate, 0,1);
    sig = In.ar(in,1);
  env = EnvGen.ar(Env.perc(attack, 1, curve: \wel), t_gate, timeScale: len);
  freq = env.lincurve(0, 1, 0, 1000 * strength, curve: -4);
  laggedTrig = trig.lag();
  sig = MoogFF.ar(sig, freq, bwr);
  Out.ar(out, Pan2.ar(sig, pos));
}, metadata:()).add();