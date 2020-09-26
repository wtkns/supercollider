// (
// SynthDef(\crusher, {
// 	arg bitdepth = 32, gate = 1;
// 	var env, signal;
// 	env = EnvGen.ar(Env.asr(0.1, 1, 0.1), gate:gate, doneAction: 2); // So we can free it
// 	signal = SoundIn.ar(0).trunc(0.5**Lag.kr((bitdepth).linlin(0, 127, 1, 32))) * env;
// 	Out.ar([0,1], signal);
// }).store;
// )
//
// ~crusher = Synth(\crusher);
// // Try it out manually
// ~crusher.set(\bitdepth, 8);
// ~crusher.set(\bitdepth, 1);
// ~crusher.set(\bitdepth, 32);
// ~crusher.set(\gate, 0); // frees the synth
// (
// // I haven't done it here, but you could use a MIDI message to set the gate and release the synth
// var cc, crusher;
// crusher = Synth(\crusher);
// cc = CCResponder({ |src, chan, num, veloc|
// 	crusher.set(\bitdepth, veloc);
//
// },
// metadata: (\type: \sSphincter, \author: "james watkins")
//)