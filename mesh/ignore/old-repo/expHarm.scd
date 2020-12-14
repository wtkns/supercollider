// SynthDef(\sinCluster, {
// 	| harmonics = 10, cps = 200, cpsPower = 1.1 |
//
//

Server.default = Server.local;

s.boot;

(
SynthDef(\expHarm, {
	|cps = 200, cpsPow = 0.78, cpsLag = 0.1, powLag = 0.1, leftAdd = 0.5, rightAdd = -0.5, panVal = 0, panLag = 0.25 |

	var harms = 32;
	var signal = Mix.fill(harms, {|i|
		FSinOsc.ar((cps + (cps * i).pow(cpsPow) + [leftAdd, rightAdd]).lag(cpsLag))
	}) / (2 * harms);

	var panSignal = Pan2.ar(signal, panVal.lag(panLag));

	Out.ar(0, panSignal)

}).add;
)


x = Synth(\expHarm, [\cps, 200]);

x.set(\cpsLag, 10);

x.set(\cps, 100);


x.set(\panVal, 0);
x.set(\panLag, 25);
x.set(\panVal, 1);


x.set(\leftAdd, 0);
x.set(\rightAdd, 0);

x.set(\cps, 600);

x.set(\cpsPow, 1.25);
x.set(\cpsPow, 0.8);
x.set(\cpsPow, 0.15);

x.free














(
SynthDef(\expHarm, {
	|cps = 300, cpsPower = 1.06 |
	var harmonics = 10;
	var cpsArray = Array.fill(harmonics, {|i| cps + (cps * i).pow(cpsPower)});
	var signal = SinOsc.ar(cpsArray);
	Out.ar(0, signal)
}).add;
)


(




)


Array.fill(harmonics, {|i| (cps*(i+1.pow(cpsPower)))});


(var a = 1, z;
z = if (a < 5, { 100 },{ 200 });
z.postln;
)